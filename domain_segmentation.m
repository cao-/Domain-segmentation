function [STG, STs, T] = domain_segmentation(X, Z, rf, b, k, tol)


% Delaunay triangulation structure
TR = delaunayTriangulation(X);
% Triangles of the delaunay triangulation: each row contains the indices in
% X of the vertices of a triangle
T = TR.ConnectivityList;
% Circumcentres of the triangles
C = TR.circumcenter;

% Number of triangles NT
NT = size(T, 1);

[iXC, ~] = knnsearch(X, C, 'k', k);



% Starting triangle
%rng(12);
%it = randi(NT)
it = 1;
STs = cell(0);

% Global status of the triangles, identified with colours.  Initially all
% triangles are white
STG = char('w'*ones(NT, 1));


while not(isempty(it)) 
    ST = patch_from(it, X, Z, T, C, NT, tol, iXC, b, rf);
    if not(sum(ST == 'g') == 0)
        STs(end + 1) = {ST};
    end
    STG(ST == 'g') = 'g';
    STG(ST == 'r') = 'r';
    it = find(STG == 'w', 1, 'first');
end


end

