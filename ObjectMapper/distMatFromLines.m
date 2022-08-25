function [distMat, thetaMat, pointsArray] = distMatFromLines(linesIn)
    % DISTMAT creates a matrix of distances of each point in an
    % output of houghlines struct from each one and a matrix of angle
    % differences between all lines in the linesStruct.
    % Alternatively the function finds only the dist mat if the input
    % linesIn is and array of vertices.
    %
    %   Arguments:
    %
    %       linesIn :   Output struct of houghlines() or an n-by-2 array of
    %                   vertices.
    %
    %   Returns:
    %
    %       distMat     :   Distance matrix of all start and end points in
    %                       the linesStruct struct (upper triangulat
    %                       matrix. The low triangular values are NaN)
    %       thetaMat    :   Same as distMat but for angle differences
    %                       between separate lines
    
    % Create vectors of x and y values of all 6 vertices found (2 for each
    % line)
    if isstruct(linesIn)
        % Find angle "distances" between all lines
        theta = [linesIn.theta];
        [thetaMesh1, thetaMesh2] = meshgrid(theta, theta');
        thetaMat = abs(thetaMesh1 - thetaMesh2);
        thetaMat = triu(thetaMat) + tril(NaN*ones(size(thetaMat)));
    
        triagEdges = [linesIn.point1 linesIn.point2]';
        edgX = triagEdges(1:2:end);
        edgY = triagEdges(2:2:end);

        pointsArray = [edgX edgY];
    else
        pointsArray = linesIn;
        edgX = linesIn(:, 1);
        edgY = linesIn(:, 2);
        thetaMat = NaN;
    end
    
    % Create matrix of distances of each point from all the others
    [edgX_mesh1, edgX_mesh2] = meshgrid(edgX, edgX');
    [edgY_mesh1, edgY_mesh2] = meshgrid(edgY, edgY');
    distMat = sqrt((edgX_mesh1-edgX_mesh2).^2 + (edgY_mesh1-edgY_mesh2).^2);
    % Nake the matrix upper triangular
    distMat = triu(distMat) + tril(NaN*ones(size(distMat)));
end