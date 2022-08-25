function vertices = getEdgesFromImage(im, verticesNum)
    % GETEDGESFROMIMAGE detects verticesNum of geometrical shape edges in
    % the im image (triange or rectangle)
    %
    %   Arguments:
    %
    %       im          :   Cropped binary image
    %       verticesNum :   Number of vertices to find
    %                       (Triangle - 3, Rectangle - 4)
    %
    %   Returns:
    %
    %       vertices    :   An array containing coordinates of found points
    %                       (First dimension is points and second is x y)]
    
    %% Detect Lines
    lines = detetRelevantLines(im);
    %% Create rho and theta vectors
    theta = [lines.theta];
    rho = abs([lines.rho]);
    
    % Find biggest gap in theta and define the modulu there (if, say, the
    % biggest gap is around 45deg then theta(theta<45)=theta(theta<45)+180
    sortedTheta = sort(theta);
    [biggestThetaGap, biggestThetaGapIndex] = max(diff(sortedTheta));
    thetaMod = sortedTheta(biggestThetaGapIndex) + biggestThetaGap/2;
    theta(theta < thetaMod) = theta(theta < thetaMod) + 180;
    %% Find verticesNum amount of lines using KMeans (K = verticesNum)
    linesInd = kmeans([theta' rho'], verticesNum);
    
    % Calculate mean line of each of the lines (the means of the k means
    % are not good because of the shifting of the angle
    vertices = zeros(2*verticesNum, 2);
    for ii=1:verticesNum
        % Extract distance matrix, theta differences matrix and array of
        % all points
        [distMat, ~, corrVertices] = distMatFromLines(lines(linesInd==ii));
        
        maxDistVerices = overallExtremaIndex(distMat, 'max');
        vertices([2*ii-1 2*ii], :) = corrVertices(maxDistVerices, :);
    end
    %% Find verticesNum Amount of Vertices
    % Extract distance matrix, theta differences matrix and array of
    % all points again
    distMat = distMatFromLines(vertices);
    
    % Find verticesNum points that are closest to other points and delete them
    for ii = 1:verticesNum
        % Get two closest points
        chosenPoints = overallExtremaIndex(distMat, 'min');
        
        % Delete the point of the chosen two above that leaves the biggest
        % diatance sum between remaining points
        allPoints = 1:length(vertices);
        remeaningPoints1 = setdiff(allPoints, chosenPoints(1));
        remeaningPoints2 = setdiff(allPoints, chosenPoints(2));
        if sum(nansum(distMat(remeaningPoints1, remeaningPoints1))) > ...
           sum(nansum(distMat(remeaningPoints2, remeaningPoints2)))
            pointToDelete = chosenPoints(1);
        else
            pointToDelete = chosenPoints(2);
        end
        
        % Delete point
        distMat(:, pointToDelete) = [];
        distMat(pointToDelete, :) = [];
        vertices(pointToDelete,:) = [];
    end
end











