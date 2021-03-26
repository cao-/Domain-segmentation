function [P, iP, TRG] = STborder(ST, X, T)

% Green triangles
GT = T(ST == 'g', :);

% Triangulation made of the green triangles only (a connected region)
TRG = triangulation(GT, X);

% Border of the green region as a poligonal
GB = TRG.freeBoundary();

% Indices of points at the border of the green region
iP = GB(:, 1);

% The actual points
P = X(iP, :);

end

