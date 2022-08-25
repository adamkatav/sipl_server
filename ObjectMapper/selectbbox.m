function [chosenBboxes, chosenLabels] = selectbbox(im, bboxes, labels, precision)
    %% Parameters
    initPreciosion = 0.95;
    sliderMinAndMax = [0.9 1];
    figurePos = [0.25 0.3 0.5 0.5];
    sliderPos = [0.25 0.11 0.5 0.04];
    %% Create Figure
    fig = figure('Name', 'Detection Precision', ... 
                 'Units', 'Normalized', 'NumberTitle', 'Off', ...
                 'Menu', 'None');
    ax = gca;
    imshow(im); hold on;
    set(fig, 'Position', figurePos);
    
    dummyStruct.Value = 0;
    updatebboxPlot(dummyStruct, dummyStruct, ax, bboxes, precision);
    %% Create Slider
    slider = uicontrol('Parent', fig, 'Style', 'Slider', ...
                       'Units', 'Normalized', ...
                       'Position', sliderPos, ...
                       'Value', initPreciosion, ...
                       'Min', sliderMinAndMax(1), 'Max', sliderMinAndMax(2));
                   
    slider.Callback = {@updatebboxPlot, ax, bboxes, precision};
    
    bgcolor = fig.Color;
    uicontrol('Parent', fig, 'Style', 'text', ...
                    'Units', 'Normalized', ...
                    'Position', [sliderPos(1)-0.09 sliderPos(2)-0.005 0.08 0.05], ...
                    'String', [num2str(sliderMinAndMax(1)*100) '%'], ...
                    'BackgroundColor', bgcolor);
	uicontrol('Parent', fig, 'Style', 'text', ...
                    'Units', 'Normalized', ...
                    'Position', [sliderPos(1)+sliderPos(3)+0.008 ...
                                 sliderPos(2)-0.005 0.08 0.05], ...
                    'String', [num2str(sliderMinAndMax(2)*100) '%'], ...
                    'BackgroundColor', bgcolor);
                
    uicontrol('Parent', fig, 'Style', 'pushbutton', ...
                      'Units', 'Normalized', ...
                      'Position', [sliderPos(1)+sliderPos(3)/2-0.015 ...
                                   sliderPos(2)-0.07 0.05 0.05], ...
                      'String', 'Ok', ...
                      'BackgroundColor', bgcolor, ...
                      'Callback','uiresume(gcf)');
    %% Wait for button push and choose value
    uiwait(gcf);
    chosenIndexes = precision/100 >= slider.Value;
    
    while ~chosenIndexes
        noBboxWarn = warndlg('Please select at least one bounding box','Warning');
        uiwait(gcf);
        chosenIndexes = precision/100 >= slider.Value;
        if ishandle(noBboxWarn)
            close(noBboxWarn);
        end
    end
    
    chosenBboxes = bboxes(chosenIndexes, :);
    chosenLabels = labels(chosenIndexes, :);
    
    close(gcf);
end

function updatebboxPlot(es, ~, ax, bboxes, precision)
    precision = precision / 100;
    delete(ax.Children(1:end-1));
    for ii = 1:length(precision)
        if precision(ii) >= es.Value
            rectangle('Parent', ax, 'Position', bboxes(ii, :), ...
                      'Linewidth', 1.5, 'EdgeColor', 'y');
%             insertObjectAnnonation(picture, 'Rectangle', bboxes(1,:), labels(1));
        end
    end
end