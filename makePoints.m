function [points, N] = makePoints(domain, N, gridtype)
    
    d = size(domain, 2);
    
    % points in [0,1]^d
    [P, N] = createPoints(N, d, gridtype);
    
    A = domain(1, :);
    B = domain(2, :);
    
    points = A + P.*repmat((B - A), N, 1);
    
end