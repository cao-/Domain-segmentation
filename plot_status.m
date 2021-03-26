function plot_status(X, T, ST)

clf;
hold on;
legend('off')
axis('equal')
axis([-0.05 1.05 -0.05 1.05])
%trimesh(T, X(:, 1), X(:, 2), zeros(size(X, 1), 1), zeros(size(X, 1), 1));

iwhite = ST == 'w';
igreen = ST == 'g';
iyellow = ST == 'y';
ired = ST == 'r';


patch('Faces', T(iwhite, :), 'Vertices', X, 'FaceColor', 'white')
patch('Faces', T(igreen, :), 'Vertices', X, 'FaceColor', 'green')
patch('Faces', T(iyellow, :), 'Vertices', X, 'FaceColor', 'yellow')
patch('Faces', T(ired, :), 'Vertices', X, 'FaceColor', 'red')

end