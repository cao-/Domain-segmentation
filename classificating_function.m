function F = classificating_function(P, Q)

% Preprare data for classification, set labels
xtrain = [P; Q];
ytrain = [ones(size(P, 1),1); -ones(size(Q, 1),1)];
SVMmodel = fitcsvm(xtrain,ytrain,'KernelFunction','gaussian', ...
            'kernelscale',0.5, 'ClassNames', [-1, 1], 'BoxConstraint', Inf);
%SVMmodel = fitcsvm(xtrain,ytrain,'KernelFunction','polynomial','PolynomialOrder',2, 'BoxConstraint',500);

% E evaluation points.  F gives the labels -1, 1 for each of them        
F = @(E) predict(SVMmodel, E);        

end

