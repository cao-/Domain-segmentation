function [inside, border] = triangleLocations(T, VT, iXk)
 

candidates = [VT{iXk}]';

inside = candidates(all(ismember(T(candidates, :), iXk), 2));
border = setdiff(candidates, inside);


end

