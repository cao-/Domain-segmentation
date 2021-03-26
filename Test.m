%clear all
rng(42)
warning('on')
N = 2^10;

domain = [0 0;
          1 1];
dim = size(domain, 2);

fname = 'h1';
f = @(x) feval(fname, x(:, 1), x(:, 2));

datatype = 'h';
[X, N] = makePoints(domain, N, datatype);


Z = f(X);


rf = RBFtype('wen_c0');
% Global shape parameter 
b = 5e-2;  
% Number of points to consider for the local interpolation
k = 8^2;
% Tolerance on the "cross-validation" vector Q
tol = .2;

tic;
[STG, STs, T] = domain_segmentation(X, Z, rf, b, k, tol);
toc;


plot_status(X, T, STG);


x = 0:0.01:1;
switch fname
    case 'h1'
        plot(x, 1/2-1/5*sin(5*x), 'LineWidth', 1.2, 'Color', 'b')
    case 'h2'
        plot(0.5 + 0.2*sin(2*pi*x), 0.5 + 0.2*cos(2*pi*x), 'LineWidth', 1.2, 'Color', 'b')
    case 'h3'
        plot(x, 1/2-1/5*sin(5*x), 'LineWidth', 1.2, 'Color', 'b')
        plot(x, 1/2-1/5*sin(5*x)+1/3, 'LineWidth', 1.2, 'Color', 'b')
    case 'h4'
        plot(x, 1/2-1/5*sin(5*x), 'LineWidth', 1.2, 'Color', 'b')
        plot(1/2-1/5*sin(5*x), x, 'LineWidth', 1.2, 'Color', 'b')
    case 'h5'
        x1 = 0.5:0.01:1;
        plot(x1, 0.5./x1, 'LineWidth', 1.2, 'Color', 'b')
    
end

set(gca, 'visible', 'off')
axis([0 1 0 1])
axis equal


