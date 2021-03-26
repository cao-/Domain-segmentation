function ST =  patch_from(it, X, Z, T, C, NT, tol, iXC, dXC, b, rf)

% Status of the triangles, identified with colours.  Initially all
% triangles are white
ST = char('w'*ones(NT, 1));


% Indices of the vertices of the triangle
t = T(it, :);

% Variable where to store the patches 
PC = [];
PC.inside = cell(0); % triangles fully inside the patch
PCnum = 0;  % Number of the current patch



%%
% Labels for the triangles.  On row t they store the list of 
% indices of patches that have the t-th triangle in the inside (GREEN) and
% those that have the t-th triangle on the border and not bad (YELLOW); and
% those that have the t-th triangle on the border and bad (RED)
YL = zeros(NT, 1);


%% First patch
%
% The indices in X of the set Xk of k nearest neighbours to c
iXk = iXC(it, 1:end-1);
% Their distances from the centre c
dk = dXC(it, 1:end-1);
% The first three points must be the vertices of the triangle.  We ensure
% that it is the case.
if not(ismember(iXk(3), t))
    % swap the third and fourth elements
    iXk([3 4]) = iXk([4 3]);
    dk([3 4]) = dk([4 3]);
end

% The coordinates of the k nearest neighbours
Xk = X(iXk, :);

% Local distance matrix
Dk = pdist2(Xk, Xk);
% Mean distance of the local points
%mk = mean_dist(Dk);
mk = dk(end);
%Appropriate scaling parameter to be used in this local context
bk = b/mk;
% Local interpolation matrix
Ak = rf(bk, Dk);
% Values in the data sites Xk
Zk = Z(iXk);
h = mean(Zk);
Zk = Zk - h;
% LOOCV vectors, native norm and coefficients of the local interpolant
[~, ~, ~, Qk, ~] = loocv_vector(Ak, Zk);

% Badness of the patch
bdn = norm(Qk, 1);

% if the patch is bad, we mark the triangle as red
if bdn > tol
    ST(it) = 'r';
    return;
end
    
% Find out which triangles are in the inside and which are on the border of
% the patch
[inside, border] = triangleLocations(T, iXk);

% Update the patch number
PCnum = PCnum + 1;

% Take note of the first patch
PC.inside(PCnum) = {inside};

% Update the global status of the triangles
ST(inside) = 'g';
ST(border) = 'y';

% Update YL
YL(border) = PCnum;

% Update BD
BD = border;


%%  Go on until there's no more border
while not(isempty(BD))

    % Take one triangle from the border list
    it = BD(1); %randsample(BD, 1); % 
        
    % Indices of the vertices of the triangle
    t = T(it, :);
    % Circumcentre of the triangle
    c = C(it, :);
    
    % The indices in X of the set Xk of k nearest neighbours to c
    iXk = iXC(it, 1:end-1);
    % Their distances from the centre c
    % The first three points must be the vertices of the triangle.  We ensure
    % that it is the case.
    iwrong = find(not(ismember(iXk(1:4), t)));
    % Swap the wrong index with the fourth elements
    iXk([iwrong 4]) = iXk([4 iwrong]);
    
    % The coordinates of the k nearest neighbours
    Xk = X(iXk, :);
    % Find the patch which have this triangle in the border
    iEX = YL(it);  % Indices of those patches
    
    % Take the one with more points (there is at least one, otherwise the triangle that
    % we are considering doesn't belong to the border)
    
    ipc = iEX(1);
    
    
    % Take the indices of the points Yk in the inside of the patch that we
    % are trying to extend
    iYk = T(PC.inside{ipc}, :);  % There are repetitions, but we don't care
                                 % because we are going to take an
                                 % intersection
    
    % Local distance matrix
    Dk = pdist2(Xk, Xk);
    likeep = true(1, length(Xk));
    
    mk = max(max(Dk));
    % Appropriate scaling parameter to be used in this local context
    bk = b/mk;
    % Local evaluation matrix
    Ak = rf(bk, Dk);
    
    bdn = inf;
    while bdn > tol
        Xk = X(iXk, :);
        % Local evaluation matrix
        Ak = Ak(likeep, likeep);
        % Values in the data sites Xk
        Zk = Z(iXk);
        %h = sum(Zk(1:3))/3;
        h = mean(Zk);
        Zk = Zk - h;
        % LOOCV vectors, native norm and coefficients of the local interpolant
        [~, ~, ~, Qk, ak] = loocv_vector(Ak, Zk);
        
        bdn = norm(Qk, 1);
        
        % First trial: the patch is good everywhere
        succeed = bdn < tol;
        
        if succeed
            break;
        end
    
        
        % If first trial failed, then try the second one
    
        
        % The set of fixed points FP is the intersection between Xk and Yk,
        % plus the vertices of the central triangle
        % Logical indices in Xk of the fixed points
        liFP = ismember(iXk, iYk); liFP(1:3) = true; 
        
        % Indices in Xk of the points that can be removed (complementary of iFP)
        iRM = find(not(liFP));
        
        
        % If there is no point that we can remove, then this triangle can't
        % be an extention of the considered patch
        if isempty(iRM)
            succeed = false;
            break;
        end
        
        % Find the index of the worst point p among the points that can be
        % removed
        [~, ipRM] = max(Qk(iRM));
        % Index in Xk of p
        ip = iRM(ipRM);
        % The actual coordinates of the bad point
        p = Xk(ip, :);
        % Find the logical indices in Xk of the closed semiplane centred
        % in c and delimited by p
        lisemiplane = close_semiplane(c, p, Xk)';
        % The points to keep are the union of the semiplane and the fixed
        % points
        % Logical indices of the points to keep
        likeep = lisemiplane | liFP;
        
        % If I removed at least one point, then I can update Xk and try
        % again to interpolate on Xk
        if sum(likeep) < length(iXk)
            iXk = iXk(likeep);
        else  % We remove only the point p
            likeep = true(1, length(iXk));  likeep(ip) = false;    
            iXk = iXk(likeep);
        end
    end
    
    % If we succeded in extending the considered patch on the considered
    % triangle
    if succeed
        % Find out which triangles are in the inside and which are on the border of
        % the patch
        [inside, border] = triangleLocations(T, iXk);
        
        % Update the patch number
        PCnum = PCnum + 1;
        
        % Take note of the patch
        %PC.j(PCnum) = {iXk};
        % PC.Q(PCnum) = {Qk};
        %PC.a(PCnum) = {ak};
        PC.inside(PCnum) = {inside};
        %PC.border(PCnum) = {border};
        %PC.c(PCnum) = {c};
        %PC.r(PCnum) = {r};
        %PC.h(PCnum) = {h};
        %PC.phi(PCnum) = {@(r) rf(bk, r)};
        
        % Update the global status of the triangles
        ST(inside) = 'g';
        STborder = ST(border); 
        logic = and(STborder ~= 'g', STborder ~= 'r');
        ST(border(logic)) = 'y'; 
        %ST(border) = mixcolours(ST(border), 'y'*ones(size(border, 1), 1));
        
        % Update GL and YL
        %GL(inside) = cellfun(@(l) [l, PCnum], GL(inside), 'UniformOutput', false);
        %YL(border) = cellfun(@(l) [l, PCnum], YL(border), 'UniformOutput', false);
        % I update YL either in the indices i subset of border where it is 0, or in the
        % index i subset of border where length(PC.inside{YL(i)})<length(inside)
        %update_indices = false(NT, 1);
        %logical_border = flase(NT, 1);
        %logical_border(border) = true;
        %logical_nonzero_border = and(YL~=0, logical_border);
        %update_indices1 = and(YL == 0, logical_border);
        %update_indices2 = and(
        %YL(update_indices) = PCnum;
        
        %update_border = border(YL(border) == 0);
        %YL(update_border) = PCnum;
        YL(border) = PCnum;
        
        
        % Update BD
        % The new border triangles are the triangles in the border of the
        % patch that haven't already been coloured GREEN
        newborder = border(ST(border) ~= 'g');
        % Update the list of border triangles BD by removing the new green
        % triangles and adding the new yellow triangles
        BD = [setdiff(BD, inside); newborder];
    else
        % If we didn't succed in extending the patch on the triangle
        
        % If there were only one possible patch that could be extended up
        % to the triangle t, then we remove the triangle t from the global
        % list of borders
        %if length(iEX) == 1
            BD = setdiff(BD, it);
            % Update the global status of the triangle
            ST(it) = 'r';
        %end        
    end
%plot_status(X, T, ST);    
end

end
