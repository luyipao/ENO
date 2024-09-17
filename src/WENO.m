clf;
xa = 0;
xb = 2*pi;
k = 3;
NValues = [40, 80 160 320];
f = @func;
for N = NValues
    yExact = f(X);
    y = WENOreconstrucation(xa, xb, k, N, @func);
    yCalculated = y(:,2);
end
yCalculated = [yCalculated(end); yCalculated];
%draw
hold on;
plot(X, yExact, 'DisplayName', 'True Solution');
plot(X, yCalculated, '--', 'DisplayName', 'Numerical Solution');
legend;
xlabel('x');
ylabel('y');
hold off;

filename = sprintf('WENODiscontinue.pdf');
filename = fullfile('..\docs\images',filename);
exportgraphics(gcf, filename, 'ContentType', 'vector');

close;


function y = func(x)
    % Example function: indicator function over [2, 4]
    y = double(x >= 2 & x <= 4);  % Convert logical to double
end