function s = interpolate(X, Z, E)

rf = RBFtype('wen_c2');
e = 1e-1;

A = rf(e, pdist2(X, X));

tic;
a = A\Z;
toc;

EM = rf(e, pdist2(E, X));

s = EM*a;

end

