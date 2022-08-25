function [output, width, height, angle] = mapRectangle(im, scaleRatio, boundingBox)
    % MAPRECTANGLE function is used to find the dimensions, center and
    % oriantation of a cart body and centers and dimensions
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
    %       output  :   A struct ready to be formatted as JSON file using
    %                   with the corresponding 'Rectangle' field
    %
    %       width   :   Width of the rectangle (in corrent object's
    %                   coordinates)
    %
    %       height  :   Height of th rectangle (in corrent object's
    %                   coordinates)
    %
    %       angle   :   Orientation of the rectangle in radians (in corrent
    %                   object's coordinates)
    
    % Get four rectangle vertices
    exactVertices = getEdgesFromImage(im, 4);
    
    % ----- Create exact rectangle from the vertices found above -----
    
    % Find rectangle center
    centroid = [mean(exactVertices(:, 1)) mean(exactVertices(:, 2))];
    
    % Get angle and distance of each vertex from the centroid
    verticesAngle = zeros(1, 4);
    distances = zeros(1, 4);
    for ii = 1:4
        verticesAngle(ii) = atan((exactVertices(ii,2) - centroid(2)) / ...
                                 (exactVertices(ii,1) - centroid(1))) * 180/pi;
        distances(ii) = norm(exactVertices(ii,:) - centroid);
    end
    
    % Sort the vertices by angles
    sortedAngles = sort(verticesAngle);
    
    % Get two mean angles in radians
    meanAngles(1) = mean(sortedAngles(1:2)) * pi / 180;
    meanAngles(2) = mean(sortedAngles(3:4)) * pi / 180;
    
    % Get mean distance
    meanDist = mean(distances);
    
    % Create new vertices base on mean angles
    % X
    rectVertices(1, 1) = centroid(1) + meanDist * cos(meanAngles(1));
    rectVertices(2, 1) = centroid(1) + meanDist * cos(meanAngles(2));
    rectVertices(3, 1) = centroid(1) - meanDist * cos(meanAngles(1));
    rectVertices(4, 1) = centroid(1) - meanDist * cos(meanAngles(2));
    % Y
    rectVertices(1, 2) = centroid(2) + meanDist * sin(meanAngles(1));
    rectVertices(2, 2) = centroid(2) + meanDist * sin(meanAngles(2));
    rectVertices(3, 2) = centroid(2) - meanDist * sin(meanAngles(1));
    rectVertices(4, 2) = centroid(2) - meanDist * sin(meanAngles(2));
    
    % Angle, and dimensions of the rectangle
    angle = atan((rectVertices(1, 2) - rectVertices(4, 2))/ ...
                  (rectVertices(1, 1) - rectVertices(4, 1)));
             
    width = norm(rectVertices(1, :) - rectVertices(4, :));
    height = norm(rectVertices(1, :) - rectVertices(2, :));

    % ----------------------------------------------------------------
    
    % Export results struct
    output.A = round((rectVertices(1,:) + boundingBox(1:2))/scaleRatio);
    output.B = round((rectVertices(2,:) + boundingBox(1:2))/scaleRatio);
    output.C = round((rectVertices(3,:) + boundingBox(1:2))/scaleRatio);
    output.D = round((rectVertices(4,:) + boundingBox(1:2))/scaleRatio);
    output.IsStatic = 'false';
end