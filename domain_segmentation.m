function [STG, STs, T] = domain_segmentation(X, Z, rf, b, k, tol)


% Delaunay triangulation structure
TR = delaunayTriangulation(X);
% Triangles of the delaunay triangulation: each row contains the indices in
% X of the vertices of a triangle
T = TR.ConnectivityList;


% Remove elongated triangles at the border
removed = true;
ratio = 1/30;
while removed
    removed = false;
    ibd = TR.edgeAttachments(TR.freeBoundary);
    ir = [];
    for j = 1:length(ibd)
        V = X(T(ibd{j}, :), :);
        e1 = V(2, :) - V(1, :);
        e2 = V(3, :) - V(2, :);
        e3 = V(1, :) - V(3, :);
        Area = det([e1; e2]);
        Perimeter = norm(e1) + norm(e2) + norm(e3);
        if Area/Perimeter^2 < ratio
            ir(end + 1) = ibd{j};
            removed = true;
        end
    end
    T(ir,:) = [];
    TR = triangulation(T,X);
end



% Circumcentres of the triangles
C = TR.circumcenter;

VT = vertices2triangles(T, size(X, 1));


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
    ST = patch_from(it, X, Z, T, VT, C, NT, tol, iXC, b, rf);
    if not(sum(ST == 'g') == 0)
        STs(end + 1) = {ST};
    end
    STG(ST == 'g') = 'g';
    STG(ST == 'r') = 'r';
    it = find(STG == 'w', 1, 'first');
end


end

