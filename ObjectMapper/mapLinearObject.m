function output = mapLinearObject(im, scaleRatio, boundingBox, isWall)
    % MAPLINEAROBJECT function is used to find both ends of a spring, a
    % wall or a line
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
    
    % Try to find line edges using getEdgesFromImage, otherwise find it
    % using regionprops
    try
        edges = getEdgesFromImage(im, 2);
    catch
        convexIm = bwconvhull(im);
        % Get oriantation and extrema points of the convex hull of the spring
        prop = regionprops(convexIm, 'Orientation', 'Extrema');
        
        % If the spring is directed left-right (absolute value of the
        % oriantation is less than 45 degrees), use [top-right left-top] ([3 8])
        % extrema points and if its directed up-down, use [top-right bottom-right]
        % ([2 5]) extrema points
        if abs(prop.Orientation) < 45
            edges(:,1) = prop.Extrema([3 8],1);
            edges(:,2) = prop.Extrema([3 8],2);
        else
            edges(:,1) = prop.Extrema([2 5],1);
            edges(:,2) = prop.Extrema([2 5],2);
        end
    end
    
    % Export results struct
    output.A = round((edges(1,:) + boundingBox(1:2))/scaleRatio);
    output.B = round((edges(2,:) + boundingBox(1:2))/scaleRatio);
    if ~isWall
        output.connectionA = [];
        output.connectionB = [];
    end
end



