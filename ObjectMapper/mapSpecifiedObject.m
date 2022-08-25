function output = mapSpecifiedObject(im, boundingBox, objectType)
    % MAPSPECIFIEDOBJECT function is used to detect specific dimentions of one
    % of the objects existing in the project, given the whole image, bounding
    % box and the type of the object described in the bounding box
    %
    %   Arguments:
    %
    %       image       :   Directory of the whole image file
    %       boundingBox :   Matlab formatted bounding box
    %       objectType  :   A string specifying which object is described.
    %                       Can be one of the following: 'cart', 'ball',
    %                       'static_ball', 'rectangle', 'static_rectangle', 
    %                       'triangle', 'static_triangle', 'spring',
    %                       'wall', 'line'
    %
    %   Returns:
    %
    %       output      :   A struct with the properties of the mapped object

    %% Parameters
    warning('off', 'images:imfindcircles:warnForLargeRadiusRange');
    
    % ----------- Parameters -----------
    objectImageWidth = 300; % The width to whitch the image will be scaled before
    histThresh = [8e-3 0.1]; % Number of pixels to consider as an existing bin
    objectSizeTreshhold = 200; % Threshold used to remove objects smaller
    % than it after treshholding the image
    bboxMargin = 20; % Enlargment margin of the bounding box, in pixels
    IS_WALL = true;
    %% Pre-Processing
    scaleRatio = objectImageWidth/boundingBox(3);
    
    % Scale the image so that the bounding box width without margin
    % addition will be objectImageWidth
    scaledIm = imresize(im, scaleRatio);
    boundingBox = boundingBox * scaleRatio;
    
    % Enlarge the bounding box by bboxMargin
    % Move the origin left and up bboxMargin pixels (or to the image origin)
    for ii = 1:2
        if boundingBox(ii) - bboxMargin >= 0
            boundingBox(ii) = boundingBox(ii) - bboxMargin;
            boundingBox(ii+2) = boundingBox(ii+2) + 2*bboxMargin;
        else
            boundingBox(ii+2) = boundingBox(ii+2) + 2*boundingBox(ii);
            boundingBox(ii) = 0;
        end
    end
    
    % Crop image using bounding box, resize and get HSV values
    croppedIm = imcrop(scaledIm, boundingBox);
    % Get Lab, HSV and greyscale color dimentions
    imLab = rgb2lab(croppedIm);
    imHSV = rgb2hsv(croppedIm);
    
    % Get mean of saturation and value image
    meanSV = mean(cat(3, imHSV(:,:,2), imHSV(:,:,3)), 3);
    
    % Images list from which to chose for thresholding
    preThreshList = cat(3, imHSV(:,:,2), imHSV(:,:,3), meanSV, imLab(:,:,3));
	% Find effective bin num to decide if an image is good enough for
	% thresholding
    effBinNum = zeros(1, size(preThreshList, 3));
    for ii = 1:size(preThreshList, 3)
        histVals = imhist(preThreshList(:, :, ii));
        normHist = histVals/max(max(histVals));
        effBinNum(ii) = length(find(histThresh(1) < normHist & ...
                                    normHist < histThresh(2)));
    end
    
    % Sort images by histogram bin amp
    
    [~, imageToUse] = max(effBinNum);
    imForThresh = preThreshList(:, :, imageToUse);
    
    threshIm1 = imbinarize(imForThresh);
    threshIm2 = ~imbinarize(imForThresh);
    
    if sum(sum(threshIm2)) > sum(sum(threshIm1))
        threshIm = threshIm1;
    else
        threshIm = threshIm2;
    end
     
    % remove all objects touching the image border (assuming the drawing
    % does not)
    % NOTE: This operation is removed because usually the object is
    % connected to another one (like a spring to a cart) and thus it will
    % always touch the bounding box edges.
%     noBordesIm = imclearborder(threshIm, 4);
    noBordesIm = threshIm;

    % Get area of all different objects in the image
    treshStats = regionprops(noBordesIm, 'Area');
    regionAreas = [treshStats.Area];
    % Label all objects
    labeledIm = bwlabel(noBordesIm);
    % Remove all objects smaller that the trshhold and get final image
    % ready for processing
    areaTreshholdedRegions = find(regionAreas > objectSizeTreshhold);
    cleanIm = ismember(labeledIm, areaTreshholdedRegions);
    %% Processing
    % Assuming the only object in the bounding-box-cropped image is the
    % specified objectType
    switch objectType
        case 'cart'
            output = mapCart(cleanIm, scaleRatio, boundingBox);
        case {'ball', 'static_ball'}
            output = mapBall(cleanIm, scaleRatio, boundingBox);
        case {'rectangle', 'static_rectangle'}
            output = mapRectangle(cleanIm, scaleRatio, boundingBox);
        case {'triangle', 'static_triangle'}
            output = mapTriangle(cleanIm, scaleRatio, boundingBox);
        case 'spring'
            output = mapLinearObject(cleanIm, scaleRatio, boundingBox, ~IS_WALL);
        case {'wall','floor','ceiling'}
            output = mapLinearObject(cleanIm, scaleRatio, boundingBox, IS_WALL);
        case {'line','pendulum'}
            output = mapLinearObject(cleanIm, scaleRatio, boundingBox, ~IS_WALL);
        otherwise
            error(['''' objectType ''' at is not a '...
                   'recognized objectType. Specify one of the objectTypes: ' ...
                   'cart', 'ball', 'static_ball', 'rectangle', ...
                   'static_rectangle', 'triangle', 'static_triangle', ...
                   'spring', 'wall', 'line']);
    end
    
    if ismember(objectType, {'static_ball', 'static_rectangle', 'static_triangle'}) && ...
       ~isempty(output)
        output.IsStatic = 'true';
    end
    
end