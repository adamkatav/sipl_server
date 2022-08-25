function output = mapCart(im, scaleRatio, boundingBox)
    % MAPCART function is used to find the dimensions, center and oriantation
    % of a cart body and centers and dimensions
    %
    %   Arguments:
    %
    %       im          :   Binary image after pre-proccessing (cut and scaled)
    %       scaleRatio  :   Ratio used to scale the image before proccessing
    %       boundingBox :   Standart four element vector bounding box of the
    %                       cart (in the original uncut and unscaled image)
    %
    %   Returns:
    %
    %       output  :   A struct ready to be formatted as JSON file using with
    %                   the corresponding 'Cart' field

    % Parameters
    wheelRadiiRange = [30 55]; % [Pixels] 
    % Circular Hoguh transform parameters:
    wheelsSensitivity = 0.95;
    wheelsEdgeThreshold = 0;
    wheelMaskMargin = 20;
    skeletPixels = inf;
    imSize = size(im);
    
    % Get skeleton image
    thinIm = bwmorph(im, 'skelet', skeletPixels);
    thinIm = bwmorph(thinIm, 'spur', inf);

    % Get centers and radii of wheels
    [wheelsCenters, wheelsRadii, ~] = ...
                  imfindcircles(thinIm, wheelRadiiRange, ...
                                'Sensitivity', wheelsSensitivity, ...
                                'EdgeThreshold', wheelsEdgeThreshold, ...
                                'Method', 'TwoStage');

    % Check if two first found circles are closer than the diameter of
    % the bigger one. If yes, take next detected circle until the
    % wheels are far enough
    for ii = 2:length(wheelsRadii)
        if norm(wheelsCenters(1, :) - wheelsCenters(ii, :)) > wheelsRadii(1)
            % Leave only two wheels
            wheelsCenters_final = wheelsCenters([1 ii], :);
            wheelsRadii_final = wheelsRadii([1 ii]);
            break;
        end
    end
    
    % Get the mean radius of the two wheels
    wheelMeanRadius = mean(wheelsRadii_final);

    % Create a mask that hides all image beneath the line connecting the wheels
    % centers 
    wheelsSlope = (wheelsCenters_final(2,2) - wheelsCenters_final(1,2)) / ...
                  (wheelsCenters_final(2,1) - wheelsCenters_final(1,1));
    wheelsAngle = atan(wheelsSlope);
    [columnsInImage, rowsInImage] = meshgrid(1:imSize(2), 1:imSize(1));
    maskPixels = rowsInImage <= wheelsSlope * ...
                                (columnsInImage - wheelsCenters_final(1,1))+...
                                wheelsCenters_final(1,2) - ...
                                wheelMeanRadius / cos(wheelsAngle) + ...
                                wheelMaskMargin;
    
    % Map cart rectangle
    [rectProps, width, rectHeight, angle] = mapRectangle(im & maskPixels, scaleRatio, boundingBox);
    
    
    % Create symmetric wheels
    rectA = rectProps.A * scaleRatio - boundingBox(1:2);
    rectB = rectProps.B * scaleRatio - boundingBox(1:2);
    rectC = rectProps.C * scaleRatio - boundingBox(1:2);
    rectD = rectProps.D * scaleRatio - boundingBox(1:2);
    
    rectCenter = mean([rectA; rectB; rectC; rectD]);
    wheelsDist = norm(wheelsCenters_final(1,:) - wheelsCenters_final(2, :));
    
    wheel1Pos_cartSys = (0.5 * [wheelsDist 0] ...
                        +0.5 * [0 rectHeight] ...
                        +[0 wheelMeanRadius]);
                    
    wheel2Pos_cartSys = (-0.5 * [wheelsDist 0] ...
                        +0.5 * [0 rectHeight] ...
                        +[0 wheelMeanRadius]);
                    
    wheelsCenters_final(1, :) = [cos(angle) -sin(angle); sin(angle)  cos(angle)] * ...
                               wheel1Pos_cartSys' + rectCenter';
            
    wheelsCenters_final(2, :) = [cos(angle) -sin(angle); sin(angle)  cos(angle)] * ...
                                wheel2Pos_cartSys' + rectCenter';
    
    % ----------------------------------------------------------------
    
    % Export results struct
    output.A = rectProps.A;
    output.B = rectProps.B;
    output.C = rectProps.C;
    output.D = rectProps.D;
    output.wheel1 = round((wheelsCenters_final(1,:) + boundingBox(1:2))/scaleRatio);
    output.wheel2 = round((wheelsCenters_final(2,:) + boundingBox(1:2))/scaleRatio);
    output.radius = round(wheelMeanRadius/scaleRatio);
end