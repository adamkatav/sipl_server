function [centralLines, marginLines] = detetRelevantLines(im)
    % DETECTRELEVANTLINES detects all lines in the imge using hough and
    % finds all lines within a preset margin of the bounding box
    %
    %   Arguments:
    %
    %       im  :   Cropped binary image
    %
    %   Returns:
    %
    %       centralLines    :   A struct array of lines as returned from
    %                           houghlines. The lines are only those which
    %                           do not touch the bounding box margin
    %       marginLines     :   Like centralLines, but the lines that do
    %                           touch the bounding box margin

    %% Parameters
    fillGap = 5;
    minLength = 60;
    houghPeaksNum = 35;
    % Delete bbox-intersecting lines
    lineRemoveMargin = 5;
    imSize = size(im);
    %% Detect Lines
    % Find lines using hough
    [houghOut, thetaHough, rHough] = hough(im);
    % Get peaks of hough
    pHough = houghpeaks(houghOut, houghPeaksNum, 'threshold', 0);
    % Find lines
    lines = houghlines(im, thetaHough, rHough, pHough, ...
                       'FillGap', fillGap, ...
                       'MinLength', minLength);
    %% Remove Lines Intersecting the Edges of the Bounding Box
    touchMargin = false(1, length(lines));
    for ii = 1:length(lines)
        for jj = 1:2
            if jj == 1
                point = lines(ii).point1;
            else
                point = lines(ii).point2;
            end
            if point(1) <= lineRemoveMargin || ...
               point(1) >= imSize(2) - lineRemoveMargin || ...
               point(2) <= lineRemoveMargin || ...
               point(2) >= imSize(1) - lineRemoveMargin
                touchMargin(ii) = true;
                break;
            end
        end
    end
    centralLines = lines(~touchMargin);
    marginLines = lines(touchMargin);
end