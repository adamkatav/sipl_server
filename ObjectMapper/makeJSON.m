function JSON_dir = makeJSON(results)

global json_name;

    % makeJSON writes a proper Json file for the java program
    %
    %   Arguments:
    %
    %       results     :   Struct of mapping results
	%
    %   Returns:
    %
    %       JSON_dir    :   Path for the new Json file
    
    if contains(json_name,"jpg")
        new_name = strrep(json_name,'.jpg','.json');
    else  %if contains "jpeg
        new_name = strrep(json_name,'.jpeg','.json');
    end
    
    JSON_dir = strcat('./jsons/',new_name);
    fid = fopen(JSON_dir, 'wt');
   
    
    fprintf(fid, '%s\n', "{");
    disp(pwd)
    resultsCell = struct2cell(results);
    
    Carts = resultsCell{1};
    Balls = resultsCell{2};
    Walls = resultsCell{3};
    Blocks = resultsCell{4};
    Springs = resultsCell{5};
    Triangles = resultsCell{6};
    Lines = resultsCell{7};
    
    Carts_Text(Carts, fid);
    Balls_Text(Balls, fid);
    ABs_Text(Walls, fid, 'w');
    Blocks_Text(Blocks, fid);
    ABs_Text(Lines, fid, 'l');
    ABs_Text(Springs, fid, 's');
    Triangles_Text(Triangles, fid);
    
    fprintf(fid, '%s', "}");
    fclose(fid);
end

function Triangles_Text(Triangles, fid)
    
    fprintf(fid, '  %s', """Triangles"": [");
    
    if(isempty(Triangles(1).A))
        fprintf(fid, '%s\n', "]");
    else
        fprintf(fid, '\n');
        for i=1:length(Triangles)
            if(i>1)                
                fprintf(fid, '%s', ",");
            end
            TriangleText(fid, Triangles(i));
        end
    
        fprintf(fid, '  %s\n', "]");
    end

end

function TriangleText(fid, Triangle)
    fprintf(fid, '    %s\n', "{");
    fprintf(fid, '      %s\n', strjoin("""A"": " + vec2Str(Triangle.A) + ","));
    fprintf(fid, '      %s\n', strjoin("""B"": " + vec2Str(Triangle.B) + ","));
    fprintf(fid, '      %s\n', strjoin("""C"": " + vec2Str(Triangle.C)));
    fprintf(fid, '    %s\n', "}");
end

function Blocks_Text(Blocks, fid)
    
    fprintf(fid, '  %s', """Blocks"": [");
    
    if(isempty(Blocks(1).A))
        fprintf(fid, '%s\n', "],");
    else
        fprintf(fid, '\n');
        for i=1:length(Blocks)
            if(i>1)                
                fprintf(fid, '%s', ",");
            end
            BlockText(fid, Blocks(i));
        end
    
        fprintf(fid, '  %s\n', "],");
    end

end

function BlockText(fid, Block)
    fprintf(fid, '    %s\n', "{");
    fprintf(fid, '      %s\n', strjoin("""A"": " + vec2Str(Block.A) + ","));
    fprintf(fid, '      %s\n', strjoin("""B"": " + vec2Str(Block.B) + ","));
    fprintf(fid, '      %s\n', strjoin("""C"": " + vec2Str(Block.C) + ","));
    fprintf(fid, '      %s\n', strjoin("""D"": " + vec2Str(Block.D) + ","));
    fprintf(fid, '      %s\n', strjoin("""IsStatic"": " + Block.IsStatic));
    fprintf(fid, '    %s\n', "}");
end

function ABs_Text(objects, fid, character)
    
    switch character
        case 'w'
            fprintf(fid, '  %s', """Walls"": [");
        case 'l'
            fprintf(fid, '  %s', """Lines"": [");
        case 's'
            fprintf(fid, '  %s', """Springs"": [");
    end
    
    if(isempty(objects(1).A))
        fprintf(fid, '%s\n', "],");
    else
        fprintf(fid, '\n');
        for i=1:length(objects)
            if(i>1)                
                fprintf(fid, '%s', ",");
            end
            ABText(fid, objects(i), character);
        end
    
        fprintf(fid, '  %s\n', "],");
    end
end

function ABText(fid, object, character)
    fprintf(fid, '    %s\n', "{");
    fprintf(fid, '      %s\n', strjoin("""A"": " + vec2Str(object.A) + ","));
    
    if(character == 'w')
        fprintf(fid, '      %s\n', strjoin("""B"": " + vec2Str(object.B))); 
    else
        fprintf(fid, '      %s\n', strjoin("""B"": " + vec2Str(object.B) + ","));
        fprintf(fid, '      %s\n', strjoin("""connectionA"": " + ...
            object.connectionA + ","));
        fprintf(fid, '      %s\n', strjoin("""connectionB"": " + ...
            object.connectionB + ","));
        fprintf(fid, '      %s\n', strjoin("""indexA"": " + ...
            object.indexA + ","));
        fprintf(fid, '      %s\n', strjoin("""indexB"": " + ...
            object.indexB));
    end
    
    fprintf(fid, '    %s\n', "}");
end

function Balls_Text(Balls, fid)
    
    fprintf(fid, '  %s', """Balls"": [");
    
    if(isempty(Balls(1).Center))
        fprintf(fid, '%s\n', "],");
    else
        fprintf(fid, '\n');
        for i=1:length(Balls)
            if(i>1)                
                fprintf(fid, '%s', ",");
            end
            BallText(fid, Balls(i));
        end
    
        fprintf(fid, '  %s\n', "],");
    end

end

function BallText(fid, Ball)
    fprintf(fid, '    %s\n', "{");
    fprintf(fid, '      %s\n', strjoin("""Center"": " + vec2Str(Ball.Center) + ","));
    fprintf(fid, '      %s\n', strjoin("""Radius"": " + Ball.Radius + ","));
    fprintf(fid, '      %s\n', strjoin("""IsStatic"": " + Ball.IsStatic));
    fprintf(fid, '    %s\n', "}");
end

function Carts_Text(Carts, fid)
    
    fprintf(fid, '  %s', """Carts"": [");
    
    if(isempty(Carts(1).A))
        fprintf(fid, '%s\n', "],");
    else
        fprintf(fid, '\n');
        for i=1:length(Carts)
            if(i>1)                
                fprintf(fid, '%s', ",");
            end
            CartText(fid, Carts(i));
        end
    
        fprintf(fid, '  %s\n', "],");
    end

end

function CartText(fid, Cart)
    fprintf(fid, '    %s\n', "{");
    fprintf(fid, '      %s\n', strjoin("""A"": " + vec2Str(Cart.A) + ","));
    fprintf(fid, '      %s\n', strjoin("""B"": " + vec2Str(Cart.B) + ","));
    fprintf(fid, '      %s\n', strjoin("""C"": " + vec2Str(Cart.C) + ","));
    fprintf(fid, '      %s\n', strjoin("""D"": " + vec2Str(Cart.D) + ","));
    fprintf(fid, '      %s\n', strjoin("""wheel1"": " + vec2Str(Cart.wheel1) + ","));
    fprintf(fid, '      %s\n', strjoin("""wheel2"": " + vec2Str(Cart.wheel2) + ","));
    fprintf(fid, '      %s\n', strjoin(["""radius"": " Cart.radius]));
    fprintf(fid, '    %s\n', "}");
end

function str = vec2Str(Vec)
    if(isempty(Vec))
        str = [];
    else
        x = Vec(1);
        y = Vec(2);
        str = """" + int2str(x) +", " + int2str(y) +"""";
    end
end