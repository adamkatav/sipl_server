function [bboxes, labels, scores] = removeSpareBboxes(bboxes, labels, scores, itersectionPercent)
    %% Parameters and settings
    possibleObjectTypes = {'cart', 'ball', 'static_ball', 'wall', 'rectangle', ...
                           'static_rectangle', 'line', 'spring', 'triangle', ...
                           'static_triangle'};
    %% Loop over all detected objects
    for ii = 1:length(possibleObjectTypes)
        corrType = possibleObjectTypes(ii);
        if ~any(labels == corrType)
            continue;
        end
        
        corrInd = find(labels == corrType);
        corrBBox = bboxes(labels == corrType, :);
        
        rectIntersect = rectint(corrBBox, corrBBox);
        rectAreas = diag(rectIntersect);
        rectIntersect = rectIntersect ./ repmat(rectAreas, 1, length(rectAreas));
        
        bbox2Delete = [];
        for jj = 1:size(rectIntersect, 1)
            for kk = 1:size(rectIntersect, 2)
                if (jj~= kk) && (rectIntersect(jj, kk) > itersectionPercent)
                    bbox2Delete = [bbox2Delete max(jj,kk)]; %#ok<AGROW>
                end
            end
        end
        
        bboxes(corrInd(unique(bbox2Delete)), :) = [];
        labels(corrInd(unique(bbox2Delete))) = [];
        scores(corrInd(unique(bbox2Delete))) = [];
    end
end