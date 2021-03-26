function DM = pdist2(dsites, ctrs)
    
    [M,~] = size(dsites); [N,s] = size(ctrs);
    DM = zeros(M, N);
    
    for d = 1:s
        DM = DM + (dsites(:, d) - ctrs(:, d)').^2;
    end
    
    DM = sqrt(DM);
    
end