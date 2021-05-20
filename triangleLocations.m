function [inside, border] = triangleLocations(T, VT, iXk)

% This code is very slow!  It requires quadratic time on the size of T,
% because it inspects all the triangles.  It can be performed in linear
% time by inspecting only the local triangles.
% 

candidates = [VT{iXk}]';

inside = candidates(all(ismember(T(candidates, :), iXk), 2));
border = setdiff(candidates, inside);

% candidates = find(any(ismember(T, iXk), 2));
% 
% inside = candidates(all(ismember(T(candidates, :), iXk), 2));
% border = setdiff(candidates, inside);

end

