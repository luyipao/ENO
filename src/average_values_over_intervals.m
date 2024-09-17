function averageValues = average_values_over_intervals(f, intervals)
    % average_values_over_intervals computes the average values of function f over multiple intervals
    % Inputs:
    %   f - function handle, e.g., @sin
    %   intervals - a 2D array where each row represents an interval [a, b]
    % Output:
    %   averageValues - an array of average values for each interval

    % Initialize the array to store average values
    averageValues = zeros(size(intervals, 1), 1);

    % Compute the average value for each interval
    for i = 1:size(intervals, 1)
        a = intervals(i, 1);
        b = intervals(i, 2);

        % Compute the integral of f over [a, b]
        integralValue = integral(f, a, b);

        % Compute the average value of f over [a, b]
        averageValue = integralValue / (b - a);

        % Store the average value
        averageValues(i) = averageValue;
    end
end

% % Example usage
% f = @sin; % Define the function handle
% intervals = [0, pi; pi, 2*pi; 0, 2*pi]; % Define the intervals array
% averageValues = average_values_over_intervals(f, intervals);
% 
% % Display the results
% disp('The average values of f(x) on the given intervals are:');
% disp(averageValues);
