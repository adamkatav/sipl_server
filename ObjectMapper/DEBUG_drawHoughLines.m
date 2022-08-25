function DEBUG_drawHoughLines(im, lines, groupIndex)

    ColOrd = get(gca,'ColorOrder');
    colorsNum = size(ColOrd, 1);

    figureTitle = 'Draw Hough Lines';
    drawHoughLinesFigure = findobj('type', 'figure', 'name', figureTitle);
    if ~isempty(drawHoughLinesFigure)
        clf(drawHoughLinesFigure);
    else
%         drawHoughLinesFigure = figure('Name', figureTitle, ...
%             'Units','Normalized', ...
%             'Position', [0 0 1 1]);
    end
    imshow(im), hold on;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        if isequal(groupIndex, 'none')
            plot(xy(:,1),xy(:,2),'LineWidth',2);
        else
            plot(xy(:,1),xy(:,2),'LineWidth',2, ...
                'color', ColOrd(mod(groupIndex(k), colorsNum), :));
        end

        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    end
    imdistline;
    impixelinfo;
end