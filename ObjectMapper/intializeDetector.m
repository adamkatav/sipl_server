function [] = intializeDetector()

    disp("Initializing Detector ...");

    % first detector
    %detectorPath = "C:\Users\Danielle\Technion\Yair Moshe - project - Deep Learning for Classroom Augmented Reality Android App\For_SIPL_Backup\results\FasterRCNN\detector - 18-Dec-2018 - 11_44.mat";
	% second detector
    detectorPath = "D:\detector - 26-Nov-2018 - 11_24.mat";
	% third detector
    %detectorPath = "C:\Users\Danielle\Technion\Yair Moshe - project - Deep Learning for Classroom Augmented Reality Android App\For_SIPL_Backup\results\FasterRCNN\detector - 29-Nov-2018 - 01_13.mat";
    global Detector;
    Detector = load(detectorPath);
    
    disp("Initialization Completed");

end

