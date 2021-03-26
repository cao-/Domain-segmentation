function idx = close_semiplane(Y, P, X)

% Given two points Y and P and a set of points X, S is the set of points in
% X which is contained in the semiplane containing Y and delimited by the
% line passing through P and perpendicular to P - Y

w = X - P;

n = Y - P;

scalprod = sum(w.*n, 2);

idx = scalprod >= 0;

end

