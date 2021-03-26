function [E, U, NN, Q, a] = loocv_vector(A, f)

I = eye(size(A));
Y = A\[I, f];
X = Y(:, 1:(end - 1));
a = Y(:, end);

E = a./diag(X);
U = E.*a;
NN = a'*f;

if NN == 0
    Q = 0*U;
else
    Q = U/NN;
end

end