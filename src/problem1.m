% Interval boundaries
xa = 0;
xb = 2 * pi;

% Initialize error list
errorList = [];
% Range of N values
nValues = [40, 80, 160, 320];

% Loop over each N value
for n = nValues
    % Generate points and step size
    x = linspace(xa, xb, n + 1);
    h = (xb - xa) / n;

    % Exact values
    yExact = f(x);
    
    % Define intervals for averaging
    intervals = [xa - 2*h, xa - h; xa - h, xa; x(1:end - 1)' x(2:end)'; xb xb + h];
    % Average values over intervals
    avgVals = averageValuesOverIntervals(@f, intervals);
    % Numerical solution
    yCal = -1/6 * avgVals(1:end - 2) + 5/6 * avgVals(2:end - 1) + 1/3 * avgVals(3:end);
    yCal = yCal';
    
    % Compute 1-norm of the error
    errorNorm = h * sum(abs(yCal - yExact));
    % Append to error list
    errorList = [errorList, errorNorm];
end

% Compute error ratio
errorRatio = log(errorList(1:end - 1) ./ errorList(2:end)) / log(2);
disp('1-norm Error ratio:');
disp(errorRatio);

% Plot results

hold on;
plot(x, yExact, 'DisplayName', 'True Solution');
plot(x, yCal, '--', 'DisplayName', 'Numerical Solution');
legend;
xlabel('x');
ylabel('y');
hold off;

% 设置图形大小和分辨率

filename = sprintf('cellAveragecontinue.pdf');
filename = fullfile('..\docs\images',filename);
exportgraphics(gcf, filename, 'ContentType', 'vector');
close;

% Function f
function y = f(x)
    % Example function: indicator function over [2, 4]
     y = sin(x);
    %y = double(x >= 2 & x <= 4);  % Convert logical to double
end

