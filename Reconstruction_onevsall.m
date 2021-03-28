
% E evaluation points
neval = 200;
M = neval^2;
[E, M] = makePoints(domain, M, 'u');

Exd = reshape(E(:, 1), neval, neval);
Eyd = reshape(E(:, 2), neval, neval);   

warning('off')
[Ps, iPs, TRGs] = cellfun(@(ST) STborder(ST, X, T), STs, 'UniformOutput', false);
warning('on')


iXPs = cellfun(@(TRG) unique(TRG.ConnectivityList), TRGs, 'UniformOutput', false);
XPs = cellfun(@(iXP) X(iXP, :), iXPs, 'UniformOutput', false);
ZPs = cellfun(@(iXP) Z(iXP), iXPs, 'UniformOutput', false);


% Global interpolant
s = NaN(size(E, 1), 1);

Nclass = length(XPs);
F = cell(Nclass, 1);
Gscore = zeros(M, Nclass);

for i = 1:Nclass
    % Train XPs{i} against all the others
    % C1 and C2 are the two classes
    C1 = XPs{i};
    C2 = [];
        for j = [1:i-1, i+1:Nclass]
            C2 = [C2; XPs{j}];
        end
    F(i) = {classificating_function(C1, C2)};
    [label, score] = F{i}(E);
    Gscore(:, i) = score(:, 2);
end

% imx is the class label for each evaluation point of E
[mx, imx] = max(Gscore, [], 2);




% Interpolation on each subdomain
for i = 1:Nclass
    iEi = imx == i;
    Ei = E(iEi, :);
    % Interpolant for the class Ci evaluated at Ei
    sCi = interpolate(XPs{i}, ZPs{i}, Ei);
    s(iEi) = sCi;
end



figure
axis([0 1 0 1])
hold on

x = 0:0.01:1;
switch fname
    case 'h1'
        plot(x, 1/2-1/5*sin(5*x), 'b--')
    case 'h2'
        plot(0.5 + 0.2*sin(2*pi*x), 0.5 + 0.2*cos(2*pi*x), 'b--')
    case 'h3'
        plot(x, 1/2-1/5*sin(5*x), 'b--')
        plot(x, 1/2-1/5*sin(5*x)+1/3, 'b--')
    case 'h4'
        plot(x, 1/2-1/5*sin(5*x), 'b--')
        plot(1/2-1/5*sin(5*x), x, 'b--')
    case 'h5'
        x1 = 0.5:0.01:1;
        plot(x1, 0.5./x1, 'b--')
end


for i = 1: length(XPs)
    XP = XPs{i};
    plot(XP(:, 1), XP(:, 2), '.', 'LineWidth', 1.5, 'color',[mod(abs(0.3*i+.5),1) mod(abs(0.5*i+.6),1) mod(abs(0.2*i+.1),1)])
    [cont, h] = contour(Exd,Eyd,reshape(imx,size(Exd)),[i+.5 i+.5],'-g','LineWidth',1.2);
end


set(gca, 'visible', 'off')
axis equal
hold off

axs = [0 1 0 1];
az=70; el = 70;
figure
fd = real(reshape(f(E), neval, neval));
surf(Exd,Eyd,fd);
shading flat
camlight(az+90,el+90)
view(az,el)
set(gca, 'visible', 'off')
axis(axs)



figure
sd = real(reshape(s, neval, neval));
surf(Exd,Eyd,sd);
shading flat
camlight(az+90,el+90)
view(az,el)
set(gca, 'visible', 'off')
axis(axs)


