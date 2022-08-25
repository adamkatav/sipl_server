% This TEST file runs the mapSpecifiedObject function over a folder of
% separate images. When ran, a directory selection dialog is opened, use it
% to select a folder with only images of the same object type, e.g. 'Cart',
% 'Wall'.. and same file format. Then, an object type selection dialog is
% opened, select the object type and press OK.
% After all images are proccessed, you will be asked whether to create a
% video of the results.

% TODO: Not updated to new, JAVA compatible syntax

%% Prepeare Workspace
% Clear
clear variables; close all; clc;
warning('off', 'images:initSize:adjustingMag');

% Parameters
folder = uigetdir;
if ~folder
    return;
end
if ~exist(folder, 'dir')
    error(['Folder ''' folder ''' does not exist'])
end
objectToDetectList = {'Cart','Ball','Rectangle','Triangle','Spring','Wall'};
%
objInd = listdlg('PromptString', 'Choose which object to map', ...
                 'ListString',objectToDetectList, ...
                 'SelectionMode', 'single', ...
                 'Name', 'Object to Map');
%}
if isempty(objInd) 
    return;
end

boundingBoxesFile = [];%'data.txt';

imFileList = dir(folder);
fileNames = TEST_AUX_natsort({imFileList.name});

% Remove system files ('.DS_Store' is for MAC)
fileNames(ismember(fileNames, '.')) = [];
fileNames(ismember(fileNames, '..')) = [];
fileNames(ismember(fileNames, '.DS_Store')) = [];

imgIndex = 10;%:length(fileNames);

if ~isempty(boundingBoxesFile)
    % Get bounding boxes
    dataFileID = fopen(fullfile(folder, boundingBoxesFile));
    data = textscan(dataFileID,['%s %s %d %d %d %d %s %d %d %d %d ' ...
                                '%s %d %d %d %d %s %d %d %d %d'], ...
                    'Delimiter', ',', 'CollectOutput', true);

    % Organize in a struct
    boundingBoxes.filename = data{1,1}(:,1);
    % Sort boundingBoxes by filenames
    [sortedBoundingBoxes, boundingBoxesSortI]=sort(boundingBoxes.filename);
    boundingBoxes.carts = data{1,2};
    boundingBoxes.springs = data{1,4};
    boundingBoxes.balls = data{1,6};
    boundingBoxes.rectangle = data{1,8};
end
%% Run mapping function
results = struct('ImageFilePath', [], 'Carts', [], 'Balls', [], ...
                 'Walls', [], 'Blocks', [], 'Lines', [], 'Springs', [], ...
                 'Triangles', []);
fig = figure('Units', 'Normalized', 'Position', [0.1 0.1 0.5 0.5], ...
             'Menu', 'figure', 'NumberTitle', 'off');
prevImageSize = [0 0];
for k = 1:length(imgIndex)
    fig.Name = ['imgIndex = ' num2str(imgIndex(1) + k - 1)];
    filename = fileNames{imgIndex(k)};
    fileDir = fullfile(folder, filename);
    
    if isempty(boundingBoxesFile)
        imagesize = size(imread(fileDir));
        boundingBoxes.carts = [0 0 imagesize(2) imagesize(1)];
        boundingBoxes.balls = [0 0 imagesize(2) imagesize(1)];
        boundingBoxes.rectangle = [0 0 imagesize(2) imagesize(1)];
        boundingBoxes.spring = [0 0 imagesize(2) imagesize(1)];
        boundingBoxes.wall = [0 0 imagesize(2) imagesize(1)];
        boundingBoxIndex = 1;
    else
        boundingBoxIndex = find(strcmp(boundingBoxes.filename, filename));
    end
    
    results(k).ImageFilePath = filename;
    title(fileDir, 'Interpreter', 'None');

    % Prepare figure for display
    im = imread(fileDir);
    clf, imshow(im), truesize([500 800]), hold on;
    
    switch objectToDetectList{objInd}
        case 'Cart'
            % ---------- Detect ----------
            results(k).Carts = mapSpecifiedObject(im, ...
                              boundingBoxes.carts(boundingBoxIndex, :), 'Cart');

            % Display cart rectangle
            plot(results(k).Carts.BodyX, results(k).Carts.BodyY, 'x', ...
                 'linewidth', 5, 'markersize', 10, 'color', 'red');

            % Display wheels
            for i=1:2
                hWheels = viscircles(results(k).Carts.WheelsCenters, ...
                                     results(k).Carts.WheelsRadius*ones(1,2), ...
                                     'EdgeColor', 'b', 'LineStyle', ':');
            end

            % Display wheels centers
            hWheelsCenter = plot(results(k).Carts.WheelsCenters(:,1), ...
                                 results(k).Carts.WheelsCenters(:,2), 'b+', ...
                                 'markersize', 10);
        case 'Ball'
            % ---------- Detect ----------

            results(k).Balls = mapSpecifiedObject(im, ...
                              boundingBoxes.balls(boundingBoxIndex, :), 'Ball');

            % ----------- Draw -----------

            % Display Ball
            hBall = viscircles(results(k).Balls.Center, ...
                               results(k).Balls.Radius, 'EdgeColor','m', ...
                               'LineStyle', ':');

            % Display ball center
            rBallCenter = plot(results(k).Balls.Center(1), ...
                               results(k).Balls.Center(2), '+', ...
                               'MarkerSize', 10, 'color', 'g');
        case 'Rectangle'
            % ---------- Detect ----------

            results(k).Blocks = mapSpecifiedObject(im, ...
                     boundingBoxes.rectangle(boundingBoxIndex, :), 'Rectangle');

            % ---------- Draw ----------

            % Display Edges
            plot(results(k).Blocks.x, results(k).Blocks.y, 'x', ...
                 'linewidth', 5, 'markersize', 10, 'color', 'red');
        case 'Triangle'
            % ---------- Detect ----------

            results(k).Triangles = mapSpecifiedObject(im, ...
                      boundingBoxes.rectangle(boundingBoxIndex, :), 'Triangle');

            % ---------- Draw ----------

            % Display Edges
            plot(results(k).Triangles.x, results(k).Triangles.y, 'x', ...
                 'linewidth', 5, 'markersize', 10, 'color', 'red');
        case 'Spring'
            % ---------- Detect ----------

            results(k).Springs = mapSpecifiedObject(im, ...
                           boundingBoxes.spring(boundingBoxIndex, :), 'Spring');

            % ---------- Draw ----------

            % Display Edges
            plot(results(k).Springs.x, results(k).Springs.y, 'x', ...
                 'linewidth', 5, 'markersize', 10, 'color', 'red');
        case 'Wall'
            % ---------- Detect ----------

            results(k).Walls = mapSpecifiedObject(im, ...
                           boundingBoxes.wall(boundingBoxIndex, :), 'Wall');

            % ---------- Draw ----------

            % Display Edges
            plot(results(k).Walls.x, results(k).Walls.y, 'x', ...
                 'linewidth', 5, 'markersize', 10, 'color', 'red');
        otherwise
            error(['Unknown object ' objectToDetectList{objInd}]);
    end
    pause(0.5);
    frames(5*(k-1)+1:5*k) = getframe(gcf);
end

close(fig);

if length(imgIndex) > 1
    answer = questdlg('Create a video of the results?', 'Results Video', ...
                  'Yes', 'No', 'No');

    if isequal(answer, 'Yes')
        videoMessage = msgbox('Creating video of the results', ...
                              'Results Recording');
        videoFile = VideoWriter('ResultsVideo', 'MPEG-4');
        open(videoFile);
        writeVideo(videoFile, frames);
        close(videoFile);
        if isvalid(videoMessage)
            close(videoMessage);
        end
        msgbox(['Saved video of the results to: ' videoFile.Filename]);
    end
end

fileID = fopen('results.json', 'wt');
jsonText = jsonencode(results);
fprintf(fileID, jsonText(2:end-1));
fclose(fileID);







