function output = mapBall(im, scaleRatio, boundingBox)
    % MAPBALL function is used to find the center and radius of a ball
    %
    %   Arguments:
    %
    %       im          :   Binary image after pre-proccessing (cut and scaled)
    %       scaleRatio  :   Ratio used to scale the image before proccessing
    %       boundingBox :   Standart four element vector bounding box of the
    %                       cart (in the original uncut and unscaled image)
    %       imageSize   :   Size of original uncut image (used to define
    %                       wheel radius boundaries).
    %
    %   Returns:
    %
    %       output  :   A struct ready to be formatted as JSON file using
    %                   with the corresponding 'Ball' field

    % Parameters
    ballSensitivity = 1;
    ballEdgeThreshold = 0;
    skeletPixels = 5;
    minRadius = 100;
    maxRadius = 150;
    
    % Get skeleton image
    thinIm = bwmorph(im, 'skelet', skeletPixels);
    thinIm = bwmorph(thinIm, 'spur', inf);
    
    % Get center and radius
    warning('off', 'images:imfindcircles:warnForLargeRadiusRange');
    [ballCenter, ballRadius] = imfindcircles(thinIm, ...
                           [minRadius maxRadius], ...
                           'Sensitivity', ballSensitivity, ...
                           'EdgeThreshold', ballEdgeThreshold);

    % Export results
    output.Center = round((ballCenter(1, :) + boundingBox(1:2))/scaleRatio);
    output.Radius = round(ballRadius(1)/scaleRatio);
    output.IsStatic = 'false';
end