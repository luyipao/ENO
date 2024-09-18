function y = WENOreconstrucation(xa, xb, k, N, f)
    % Check if k is 3
    if k ~= 3
        error("Right now, k must be 3");
    end
    
    % Step size
    h = (xb - xa) / N;
    
    % Generate grid points
    X = linspace(xa, xb, N+1);
    
    % Define intervals
    intervals = [X(1:end-1)', X(2:end)'];
    
    % Compute average values over intervals
    Y = averageValuesOverIntervals(f, intervals);
    Y = Y';
    
    % Shifted values for WENO stencils
    YL = circshift(Y, 1);
    YLL = circshift(Y, 2);
    YR = circshift(Y, -1);
    YRR = circshift(Y, -2);
    
    % VR(r,:) = vr
    VR = [1/3*YL + 5/6*YR - 1/6*YRR; -1/6*YL + 5/6*Y + 1/3*YR; 1/3*YLL - 7/6*YL + 11/6*Y];
    
    % Compute smoothness indicators β_0, β_1, β_2
    beta = [(13/12) * (Y - 2*YR + YRR).^2 + (1/4) * (3*Y - 4*YR + YRR).^2;
            (13/12) * (YL - 2*Y + YR).^2 + (1/4) * (YL - YR).^2;
            (13/12) * (YLL - 2*YL + Y).^2 + (1/4) * (YLL - 4*YL + 3*Y).^2];
    
    % Small constant to avoid division by zero
    epsilon = 1e-6;
    
    %  Compute yPos
    d = [3/10, 3/5, 1/10];
    alpha = d' ./ (epsilon + beta).^2;
    alpha_sum = sum(alpha, 1);
    weights = alpha ./ alpha_sum;
    yPos = sum(weights .* VR, 1);
    
    % Reverse the linear weights for yNeg calculation
    d = d(end:-1:1);
    
    % Compute yNeg
    alpha = d' ./ (epsilon + beta).^2;
    alpha_sum = sum(alpha, 1);
    weights = alpha ./ alpha_sum;
    yNeg = sum(weights .* VR, 1);
    
    y = [yPos(:) yNeg(:)];
end