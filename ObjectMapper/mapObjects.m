function [JSON_dir, results] = mapObjects(im, bbox, label)
    % MAPOBJECTS function implements the mapping algorithm. It accepts the
    % output of the deep learning part of the project and creates a JSON
    % formatted string with specific parameters of each of the object
    % detected and labled, as they appear in labeledStruct
    %
    %   Arguments:
    %
    %       im      :   NxMx3 array, the image.
    %       bbox    :   Kx4 array, the MATLAB formatted bounding box of each of
    %                   the K objects detected in the image
    %       label   :   1xK cell with strings labels of each of the K detected
    %                   objects. Can be one of the following: 'cart', 'ball',
    %                   'static_ball', 'rectangle', 'static_rectangle',
    %                   'triangle', 'static_triangle', 'spring', 'wall',
    %                   'line'
    %
    %   Returns:
    %
    %       dir      :   Directory of the JSON formatted output file
    
    %% Parameters and settings
    disp("Mapping ...");
    
    objectsNum = size(bbox, 1);
    
    % Define results struct
    results = struct('Carts', [], 'Balls', [], 'Walls', [], 'Blocks', [], ...
        'Springs', [], 'Triangles', [], 'Lines', []);

    results.Carts = struct('A', [], 'B', [], 'C', [], 'D', [], ...
                          'wheel1', [], 'wheel2', [], 'radius', []);
    results.Balls = struct('Center', [], 'Radius', [],  'IsStatic', []);
    results.Walls = struct('A', [], 'B', []);
    results.Blocks = struct('A', [], 'B', [], 'C', [], 'D', [], 'IsStatic', []);
    results.Springs = struct('A', [], 'B', [], ...
                             'connectionA', [], 'connectionB', []);
    results.Triangles = struct('A', [], 'B', [], 'C', [], 'IsStatic', []);
    results.Lines = struct('A', [], 'B', [], ...
                           'connectionA', [], 'connectionB', []);

    possibleObjectTypes = {'cart', 'ball', 'static_ball', 'wall', 'rectangle', ...
                           'static_rectangle', 'line', 'spring', 'triangle', ...
                           'static_triangle','floor','ceiling','pendulum'};
    %% Loop over all detected objects
    for ii = 1:objectsNum
        if ismember(label{ii}, possibleObjectTypes)
            try
                mappedObj = mapSpecifiedObject(im, bbox(ii, :), label{ii});
            catch ME
                warning("Failed mapping object number " +  num2str(ii) + ...
                        " which is a " +  label{ii}  + "." + ...
                        newline + newline + ...
                        getReport(ME, 'extended', 'hyperlinks', 'on' ));
                continue
            end
            switch label{ii}
                case 'cart'
                    if isempty([results.Carts.A])
                        results.Carts(end) = mappedObj;
                    else
                        results.Carts(end+1) = mappedObj;
                    end
                case {'ball', 'static_ball'}
                    if isempty([results.Balls.Center])
                        results.Balls(end) = mappedObj;
                    else
                        results.Balls(end+1) = mappedObj;
                    end
                case {'rectangle', 'static_rectangle'}
                    if isempty([results.Blocks.A])
                        results.Blocks(end) = mappedObj;
                    else
                        results.Blocks(end+1) = mappedObj;
                    end
                case {'triangle', 'static_triangle'}
                    if isempty([results.Triangles.A])
                        results.Triangles(end) = mappedObj;
                    else
                        results.Triangles(end+1) = mappedObj;
                    end
                case 'spring'
                    if isempty([results.Springs.A])
                        results.Springs(end) = mappedObj;
                    else
                        results.Springs(end+1) = mappedObj;
                    end
                case {'wall','floor','ceiling'}
                    if isempty([results.Walls.A])
                        results.Walls(end) = mappedObj;
                    else
                        results.Walls(end+1) = mappedObj;
                    end
                case {'line','pendulum'}
                    if isempty([results.Lines.A])
                        results.Lines(end) = mappedObj;
                    else
                        results.Lines(end+1) = mappedObj;
                    end
                otherwise
                    error('Error in substituting into results struct.');
            end
        else
%             warning(['''' label{ii} ''' at label{' num2str(ii) '} is not '...
%                    'recognized objectType. Specify one of the objectTypes: ' ...
%                    'cart', 'ball', 'static_ball', 'rectangle', ...
%                    'static_rectangle', 'triangle', 'static_triangle', ...
%                    'spring', 'wall', 'line']);
        end
    end
    %% Connect lines and springs to objets
    results = connectLines(results);
    %% Create JSON file
    disp("Mapping Completed");
    JSON_dir = makeJSON(results);
end
