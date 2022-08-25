function results = connectLines(results)
    % CONNECTLINE find which object is connected to each of the edges of a
    % line or a spring object.
    %
    %   Arguments:
    %
    %       mappedStruct    :   The output struct of the mapObjects function
    %
    %   Returns:
    %
    %       results     :   The same result struct with lines and springs
    %                       connetion field filled in with rellevant data
    
    objKindList = {'Carts', 'Balls', 'Walls', 'Blocks', 'Triangles'};
    lineKindList = {'Lines', 'Springs'};
    linePtNames = {'A', 'B'};
    lineConnctNames = {'connectionA', 'connectionB'};
    lineIndexName = {'indexA', 'indexB'};
    
    % Iterate over Lines and Springs
    for lineKindInd = 1:length(lineKindList)
        lineKind = lineKindList{lineKindInd};
        if isempty([results.(lineKind).A])
            continue;
        end
        % Iterate over all lines
        for lineInd = 1:length(results.(lineKind))
            % Iterate over two ends of line
            for pointInd = 1:2
                objectDistInd = 0;
                % Choose relevant line and point ('A' or 'B')
                lineVert = results.(lineKind)(lineInd).(linePtNames{pointInd});
                % Create a struct which will contain all distances of the
                % corrent point from all connectable object
                distances = struct('Object', [], 'Index', [], 'Distance', []);
                % Iterate over all connectable objects (all but lines and sprins)
                for objKindInd = 1:length(objKindList)
                    if isequal(objKindList{objKindInd}, 'Balls')
                        if isempty([results.Balls.Center])
                            objNum = 0;
                        else
                            objNum = length([results.Balls.Center])/2;
                        end
                    else
                        if isempty([results.(objKindList{objKindInd}).A])
                            objNum = 0;
                        else
                            objNum = length([results.(objKindList{objKindInd}).A])/2;
                        end
                    end
                    % Iterate over all objects of the current kind
                    for objInd = 1:objNum
                        objectDistInd = objectDistInd + 1;
                        distances(objectDistInd).Object = objKindList{objKindInd};
                        distances(objectDistInd).Index = objInd;
                        switch objKindList{objKindInd}
                            case {'Carts', 'Blocks', 'Triangles'}
                                % Iterate over all pairs of vertices and find
                                % distance of the point of the line to each
                                % side of the rectangle (or cart  body rectangle)
                                if isequal(objKindList{objKindInd}, 'Triangles')
                                    vertices = [results.Triangles(objInd).A; ...
                                                results.Triangles(objInd).B; ...
                                                results.Triangles(objInd).C];
                                else
                                    vertices = [results.(objKindList{objKindInd})(objInd).A; ...
                                                results.(objKindList{objKindInd})(objInd).B; ...
                                                results.(objKindList{objKindInd})(objInd).C; ...
                                                results.(objKindList{objKindInd})(objInd).D];
                                end
                                vertNum = size(vertices, 1);
                                disFromSides = zeros(1, vertNum);
                                for vertInd = 1:vertNum
                                    p1 = vertices(vertInd, :);
                                    p2 = vertices(mod(vertInd, vertNum)+1, :);

                                    disFromSides(vertInd) = point2seg([lineVert 0], [p1 0], [p2 0]);
                                end

                                distances(objectDistInd).Distance = min(disFromSides);
                            case 'Balls'
                                ptDiff = lineVert - results.Balls(objInd).Center;
                                distances(objectDistInd).Distance = norm(ptDiff) - results.Balls(objInd).Radius;
                            case 'Walls'
                                p1 = results.Walls(objInd).A;
                                p2 = results.Walls(objInd).B;
                                distances(objectDistInd).Distance = point2seg([lineVert 0], [p1 0], [p2 0]);
                            otherwise
                                warning('Did not manage to connect line/spring');
                                return;
                        end
                    end
                end
                % Find closest object
                [~, closeObjInd] = min([distances.Distance]);
                closestObjectKind = distances(closeObjInd).Object;
                closestObjectInd = distances(closeObjInd).Index - 1;
                results.(lineKind)(lineInd).(lineConnctNames{pointInd}) = closestObjectKind;
                results.(lineKind)(lineInd).(lineIndexName{pointInd}) = closestObjectInd;
            end
        end
    end
end





