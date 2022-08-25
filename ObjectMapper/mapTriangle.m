function output = mapTriangle(im, scaleRatio, boundingBox)
    % MAPTRIANGLE function is used to find the three vertices of a triangle
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
    %                   the corresponding 'Triangle' field
    
    pointsArray = getEdgesFromImage(im, 3);
    
    % Export results struct
    output.A = round((pointsArray(1,:) + boundingBox(1:2))/scaleRatio);
    output.B = round((pointsArray(2,:) + boundingBox(1:2))/scaleRatio);
    output.C = round((pointsArray(3,:) + boundingBox(1:2))/scaleRatio);
    output.IsStatic = 'false';
end



