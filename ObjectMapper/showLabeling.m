function [] = showLabeling(picture, bboxes, labels, scores)

	labelScore = {};
    numberObjects = size(bboxes,1);
	for i = 1:numberObjects
		labelScore{i} = [char(labels(i)) ',' num2str(scores(i))] ;
    end
    
    % Annotate detections in the image.
	if(numberObjects ~= 0)
		picture = insertObjectAnnotation(picture,'Rectangle', bboxes, labelScore);
    end

    fig = figure('Units', 'Normalized');
    imshow(picture);     
    set(fig, 'Position', [0 0 1 1]);
end

