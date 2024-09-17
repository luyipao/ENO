% Compute average values over intervals
function avgVals = averageValuesOverIntervals(func, intervals)
    avgVals = zeros(size(intervals, 1), 1);
    for i = 1:size(intervals, 1)
        avgVals(i) = integral(func, intervals(i, 1), intervals(i, 2)) / (intervals(i, 2) - intervals(i, 1));
    end
end