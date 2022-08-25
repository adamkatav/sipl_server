function d = point2seg(pt, v1, v2)
    % POINT2SEG calculates the distanse of a point from a segment of a line
    % between two given points
    %
    %   Arguments:
    %
    %       pt  :   The point of which to calculate the distance from the
    %               segment (three dimentional)
    %       v1  :   Start point of the segment
    %       v2  :   End point of the segment
    %
    %   Returns:
    %
    %       d   :   Distanse of the point pt from the segment
    
    v1_v2 = v1 - v2;
    pt_v1 = pt - v1;
    pt_v2 = pt - v2;
    
    d_v1_v2 = norm(v1_v2);
    d_pt_v1 = norm(pt_v1);
    d_pt_v2 = norm(pt_v2);
    
    if d_v1_v2^2 + d_pt_v2^2 <= d_pt_v1^2
        d = d_pt_v2;
    elseif d_v1_v2^2 + d_pt_v1^2 <= d_pt_v2^2
        d = d_pt_v1;
    else
        d = norm(cross(v1_v2,pt_v2)) / d_v1_v2;
    end
end