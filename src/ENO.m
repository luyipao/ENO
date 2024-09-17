% Define the integration range and parameters
xa = 0;
xb = 2 * pi;

% Set the number of points for approximation
k = 3;
numSegments = [40, 80, 160, 320];
errorList = [];

% Loop over different segment counts
for N = numSegments
    h = (xb - xa) / N;  % Calculate the width of each segment
    X = linspace(xa, xb, N + 1);  % Create an array of points for the range

    % Initialize intervals based on midpoints
    intervals = [X(1:end-1)', X(2:end)'];
    for i = 0:k-2
        intervals = [X(1) - (i + 1) * h, X(1) - i * h; intervals; 
                     X(end) + i * h, X(end) + (i + 1) * h];
    end

    % Calculate average values over intervals
    avgValues = averageValuesOverIntervals(@f, intervals);

    % Shift averages for calculations
    Y = avgValues(3:end - 2);
    YLeft = avgValues(2:end - 3);
    YLeftLeft = avgValues(1:end - 4);
    YRight = avgValues(4:end - 1);
    YRightRight = avgValues(5:end);
    
    % Initialize the result array
    result = zeros(1, N + 1);
    for i = 1:N
        % Check conditions to determine the appropriate stencil
        if (abs(Y(i) - YLeft(i)) >= abs(Y(i) - YRight(i)))
            % Use the stencil involving Y and its right neighbors
            if (abs(YRightRight(i) + Y(i) - 2 * YRight(i)) <= abs(YRight(i) + YLeft(i) - 2 * Y(i)))
                result(i + 1) = 1/3 * Y(i) + 5/6 * YRight(i) - 1/6 * YRightRight(i);
            else
                result(i + 1) = -1/6 * YLeft(i) + 5/6 * Y(i) + 1/3 * YRight(i);
            end
        else
            % Use the stencil involving Y and its left neighbors
            if abs(Y(i) - 2 * YLeft(i) + YLeftLeft(i)) < abs(YRight(i) - 2 * Y(i) + YLeft(i))
                result(i + 1) = (1/3) * YLeftLeft(i) - (7/6) * YLeft(i) + (11/6) * Y(i);
            else
                result(i + 1) = -(1/6) * YLeft(i) + (5/6) * Y(i) + (1/3) * YRight(i);
            end
        end
    end

    % Calculate the exact values and error
    yExact = f(X);
    yCalculated = result;
    E = yCalculated - yExact;
    % Compute the error norm
    errorNorm = h * sum(abs(yCalculated - yExact));
    errorList = [errorList, errorNorm];  % Store the error norm
end

% Compute the error ratio for convergence analysis
errorRatio = log(errorList(1:end - 1) ./ errorList(2:end)) / log(2);
disp('1-norm Error ratio:');
disp(errorRatio);

%draw
hold on;
plot(X, yExact, 'DisplayName', 'True Solution');
plot(X, yCalculated, '--', 'DisplayName', 'Numerical Solution');
legend;
xlabel('x');
ylabel('y');
hold off;

% 设置图形大小和分辨率

filename = sprintf('ENODiscontinue.pdf');
filename = fullfile('..\docs\images',filename);
exportgraphics(gcf, filename, 'ContentType', 'vector');
% 导出为 EPS 格式（矢量图）

% 关闭图形窗口
close;

% Function to define the target function
function y = f(x)
    % Example function: indicator function over [2, 4]
    y = double(x >= 2 & x <= 4);  % Convert logical to double
end

% Function to compute average values over given intervals
function avgVals = averageValuesOverIntervals(func, intervals)
    avgVals = zeros(size(intervals, 1), 1);
    for i = 1:size(intervals, 1)
        % Calculate the integral and average over the interval
        avgVals(i) = integral(func, intervals(i, 1), intervals(i, 2)) / (intervals(i, 2) - intervals(i, 1));
    end
end