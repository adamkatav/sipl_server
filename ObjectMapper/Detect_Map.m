function JSON_dir = Detect_Map(imagePath, th, showLabel, showMap)
        
    [picture, bboxes, labels, scores] = ...
                        detectImage(imagePath, th);

    if(showLabel)
        showLabeling(picture, bboxes, labels, scores);
    end
% manuallySelectBbox = 0;
%     if(manuallySelectBbox)
%         [bboxes, labels] = selectbbox(im, bboxes, labels, scores);
%     end
        
    [JSON_dir, results] = mapObjects(picture, bboxes, labels);
    
    if(showMap)
        showMapping(picture, results);
    end
    
%     results = load("results.mat");
% 
%     results = results.results;

end

