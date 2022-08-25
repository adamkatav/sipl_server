function [picture, bboxes, labels, scores] = detectImage(imagePath, th)

    global Detector;
    
    detector = Detector.detector;
    
    picture = imread(imagePath);
    picture = imresize(picture, [300,300]);  % Resize the picture
            
    disp("Detecting ...");
    [bboxes, scores, labels] = detect(detector, picture, ...
                                      'Threshold', th, ...
                                      'ExecutionEnvironment', 'cpu');
    
    overlappingArea = 0.3;
    [bboxes, labels] = removeSpareBboxes(bboxes, labels, scores, overlappingArea);
                                  
    numberObjects = size(bboxes,1);

    if(numberObjects == 0)
		disp('Detection Completed - No objects detected');
	else
		disp(['Detection Completed - ' num2str(numberObjects) ' objects detected']);
    end
    
    labels = string(deblank(string(labels)));

end