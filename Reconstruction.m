
% E evaluation points
neval = 150;
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

% Use the full data for training
Ps = XPs;  % Comment out this line to use only the border points

figure
axis([0 1 0 1])
hold on
% Number of classes
Nclass = length(XPs);
if Nclass == 1
    s = interpolate(X, Z, E);
else
    for j = 1:Nclass-1
        P = Ps{j};
        % The other class is the union of the remaining classes
        Q = [];
        for i = j+1:Nclass
            Q = [Q; Ps{i}];
        end        
        
        % Function such that F(P) = 1, F(Q) = -1, and that can make a prediction
        % for other points.
        F = classificating_function(P, Q);
        [CE, yScore] = F(E);
        
        [cont, h] = contour(Exd,Eyd,reshape(yScore(:,2),size(Exd)),[0 0],'-g','LineWidth',1.2);
        
        % Evaluation points in the same domain of the points P
        iEP = and(CE == 1, isnan(s));
        EP = E(iEP, :);
        sP = interpolate(XPs{j}, ZPs{j}, EP);
        s(iEP) = sP;
    end
    
    % Evaluation points in the same domain of the points Q
     iEQ = and(CE == -1, isnan(s));
     EQ = E(iEQ, :);
     XQ = XPs{end};
     ZQ = ZPs{end};
     sQ = interpolate(XQ, ZQ, EQ);
     s(iEQ) = sQ;
end

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


