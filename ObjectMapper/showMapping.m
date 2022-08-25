function [fig] = showMapping(picture, results)
    % This TEST script is used to run the mapObject syspem on a provided output
    % of the deep learning part of the project, saved in  a .mat file named
    % 'TEST_mapObjects.mat' and display all the mapping parameters on the image
    % itself. When running the function, select a .mat file containing the following
    % variables:
    %   - label :   Kx1 categorical array, specifying the object type of
    %               each of the K detected objects in the image
    %   - im    :   NxMx3, the image array, as used by the deep learning part
    %   - bbox  :   Kx4, MATLAB formatted bounding box of each of the K objects

    %% Prepeare Workspace
    % Load deep learning part output
%     [file,path] = uigetfile('*.mat');
%     if isequal(file,0)
%        return;
%     else
%        load(fullfile(path,file));
%     end

    % Map the image and obtain the results struct
%     jsonfile = mapObjects(picture, bboxes, string(labels(:)));

%     jsondata = importdata(jsonfile);
%     results = jsondecode(jsondata{:});
    % Display image
    fig = figure('Units', 'Normalized');
    imshow(picture); hold on;
    set(fig, 'Position', [0 0 1 1]);
    % MATLAB color order
    ColOrd = get(gca,'ColorOrder');
    colorsNum = size(ColOrd, 1);
    colorI = 0;
    %% Display mapped objects
    % Iterate over all object types
    objectTypes = fieldnames(results);
    for ii = 1:length(objectTypes)
        corrObjectStruct = results.(objectTypes{ii});
        corrFields = fieldnames(corrObjectStruct);

        % If an object of this type was detected, iterate over all detected objects
        % of this type
        if length(corrObjectStruct)==1 && isempty(corrObjectStruct.(corrFields{1}))
            continue;
        end

        for jj = 1:length(corrObjectStruct)
            switch objectTypes{ii}
                case 'Carts'
                    % Display cart rectangle
                    BodyX = [corrObjectStruct(jj).A(1) ...
                             corrObjectStruct(jj).B(1) ...
                             corrObjectStruct(jj).C(1) ...
                             corrObjectStruct(jj).D(1)];
                    BodyY = [corrObjectStruct(jj).A(2) ...
                             corrObjectStruct(jj).B(2) ...
                             corrObjectStruct(jj).C(2) ...
                             corrObjectStruct(jj).D(2)];
                    plot(BodyX, BodyY, 'd', ...
                         'linewidth', 3, 'markersize', 8, ...
                         'color',  ColOrd(mod(colorI, colorsNum)+1, :), ...
                         'DisplayName', 'Cart Body');
                    colorI = colorI + 1;

                    % Display wheels
                    wheelsCenters = [corrObjectStruct(jj).wheel1; ...
                                     corrObjectStruct(jj).wheel2];
                    viscircles(wheelsCenters, ...
                               corrObjectStruct(jj).radius*ones(1,2), ...
                               'EdgeColor', ColOrd(mod(colorI, colorsNum)+1, :),...
                               'LineStyle', ':');

                    % Display wheels centers
                    hWheelsCenter = plot(wheelsCenters(:,1), wheelsCenters(:,2), ...
                                         '+', 'markersize', 15, ...
                                         'Color', ColOrd(mod(colorI, colorsNum)+1, :),...
                                         'DisplayName', 'Cart Wheels');
                    colorI = colorI + 1;
                case {'Balls'}
                    % Display Ball
                    viscircles(corrObjectStruct(jj).Center, ...
                               corrObjectStruct(jj).Radius, ...
                               'EdgeColor', ColOrd(mod(colorI, colorsNum)+1, :), ...
                               'LineStyle', ':');

                    % Display ball center
                    h = plot(corrObjectStruct(jj).Center(1), ...
                         corrObjectStruct(jj).Center(2), '.', ...
                         'MarkerSize', 12, 'linewidth', 2, ...
                         'color', ColOrd(mod(colorI, colorsNum)+1, :));
                    colorI = colorI + 1;

                    if isequal(corrObjectStruct(jj).IsStatic, 'false')
                        set(h, 'DisplayName', 'Ball', 'Marker', '+');
                    else
                        set(h, 'DisplayName', 'Static Ball', 'Marker', 'x');
                    end
                case {'Blocks', 'Triangles', 'Springs', 'Walls', 'Lines'}
                    % Display Edges
                    switch objectTypes{ii}
                        case 'Blocks'
                            BodyX = [corrObjectStruct(jj).A(1) ...
                                     corrObjectStruct(jj).B(1) ...
                                     corrObjectStruct(jj).C(1) ...
                                     corrObjectStruct(jj).D(1)];
                            BodyY = [corrObjectStruct(jj).A(2) ...
                                     corrObjectStruct(jj).B(2) ...
                                     corrObjectStruct(jj).C(2) ...
                                     corrObjectStruct(jj).D(2)];
                            h = plot(BodyX, BodyY, '.', ...
                                     'linewidth', 2, 'markersize', 10, ...
                                     'color', ColOrd(mod(colorI, colorsNum)+1, :));
                            if isequal(corrObjectStruct(jj).IsStatic, 'false')
                                set(h, 'DisplayName', 'Rectangle', 'Marker', 's');
                            else
                                set(h, 'DisplayName', 'Static Rectangle', 'Marker', 'd');
                            end
                        case 'Triangles'
                            BodyX = [corrObjectStruct(jj).A(1) ...
                                     corrObjectStruct(jj).B(1) ...
                                     corrObjectStruct(jj).C(1)];
                            BodyY = [corrObjectStruct(jj).A(2) ...
                                     corrObjectStruct(jj).B(2) ...
                                     corrObjectStruct(jj).C(2)];
                            h = plot(BodyX, BodyY, '.', ...
                                     'linewidth', 2, 'markersize', 10, ...
                                     'color', ColOrd(mod(colorI, colorsNum)+1, :));
                            if isequal(corrObjectStruct(jj).IsStatic, 'false')
                                set(h, 'DisplayName', 'Triangle', 'Marker', '^');
                            else
                                set(h, 'DisplayName', 'Static Triangle', 'Marker', 'v');
                            end
                        case {'Springs', 'Walls', 'Lines'}
                            BodyX = [corrObjectStruct(jj).A(1) ...
                                     corrObjectStruct(jj).B(1)];
                            BodyY = [corrObjectStruct(jj).A(2) ...
                                     corrObjectStruct(jj).B(2)];
                            h = plot(BodyX, BodyY, '.', ...
                                     'linewidth', 2, 'markersize', 10, ...
                                     'color', ColOrd(mod(colorI, colorsNum)+1, :));
                            switch objectTypes{ii}
                                case 'Springs'
                                    set(h, 'DisplayName', 'Spring', 'Marker', '*');
                                case 'Walls'
                                    set(h, 'DisplayName', 'Wall', 'Marker', 'p');
                                case 'Lines'
                                    set(h, 'DisplayName', 'Line', 'Marker', 'h');
                            end
                    end
                    colorI = colorI + 1;
            end
        end

        legend('Show', 'Location', 'NorthEastOutside', 'Fontsize', 16, ...
               'Interpreter', 'LaTex');
    end

end