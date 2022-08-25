function indexVector = overallExtremaIndex(mat, minOrMax)
    % OVERALLEXTREMAINDEX finds the index vector of minimum or maximum of a 
    % given matrix
    %
    %   Arguments:
    %
    %       mat         :   Matrix of which to find the extrema
    %       minOrMax    :   'min' for minimum and 'max' for maximum
    %
    %   Returns:
    %
    %       indexVector :   The index of the extrema (x and y)
    

    if isequal(minOrMax, 'min')
        % Find extemum of each column and get extremas indexes
        [vec, indVec] = min(mat);
        % Find total extemum and get its index in the columns extremas vector
        [~, ind] = min(vec);
    elseif isequal(minOrMax, 'max')
        % Find extemum of each column and get extremas indexes
        [vec, indVec] = max(mat);
        % Find total extemum and get its index in the columns extremas vector
        [~, ind] = max(vec);
    else
        error(['minOrMax should be only one of the strings ''min'' or ' ...
               '''max'' but was ''' minOrMax '''']);
    end
    % Create vector of indexes of the extremas
    indexVector = [indVec(ind), ind];
end