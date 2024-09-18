%% f must have a priori bound condition
% Calculate ENO reconstruction in [xa, xb], with the accuracy k and grid cell number N.
% y is a N*2 matrix where the first column represents the target function's value at the left boundary of cell $I_j$
% and the second column represents the right boundary.

% Example usage:
% xa = 0;
% xb = 2*pi;
% k = 3;
% N = 320;
% y = ENOReconstrucation(xa, xb, k, N, f);
% yRight = y(:,2);
% yRight = [yRight(end); yRight]; % Extend right boundary for plotting
% yLeft = y(:,1);
% yLeft = [yLeft; yLeft(1)]; % Extend left boundary for plotting
% plot(linspace(xa,xb,1000), f(linspace(xa,xb,1000)), 'DisplayName', 'True Solution');
% plot(X, yRight, '--', 'DisplayName', 'Numerical Solution');

% Function definition for f
% function y = f(x)
%     y = double(x >= 2 & x <= 4);
% end

function y = ENOReconstrucation(xa, xb, k, N, f)
    if (k~=3)
        error("k must be 3");
    end
    
    X = linspace(xa, xb, N + 1);  

    intervals = [X(1:end-1)', X(2:end)'];
    Y = averageValuesOverIntervals(f, intervals);
    Y = Y';
    YL = circshift(Y, 1);
    YLL = circshift(Y, 2);
    YR = circshift(Y, -1);
    YRR = circshift(Y, -2);
    YRRR = circshift(Y, -3);
    
    % yRight(i) I_i point i + 1/2
    % yLeft(i) I_i point i - 1/2
    yRight = zeros(1, N);
    yLeft = zeros(1,N);
    for i = 1:N
        % i, i + 1
        if (abs(Y(i) - YL(i)) >= abs(Y(i) - YR(i)))
            % i, i + 1, i + 2
            if (abs(YRR(i) + Y(i) - 2 * YR(i)) <= abs(YR(i) + YL(i) - 2 * Y(i)))
                yRight(i) = 1/3 * Y(i) + 5/6 * YR(i) - 1/6 * YRR(i);
                yLeft(i) = 11/6 * YR(i) - 7/6 * YRR(i) + (1/3) * YRRR(i);
            else
                % i - 1, i, i + 1
                yRight(i) = -1/6 * YL(i) + 5/6 * Y(i) + 1/3 * YR(i);
                yLeft(i) = 1/3 * Y(i) + 5/6 * YR(i) - 1/6 * YRR(i); % Corrected index
            end
        else
            % i - 2, i - 1, i
            if abs(Y(i) - 2 * YL(i) + YLL(i)) < abs(YR(i) - 2 * Y(i) + YL(i))
                yRight(i) = (1/3) * YLL(i) - (7/6) * YL(i) + (11/6) * Y(i);
                yLeft(i) = -(1/6) * YL(i) + (5/6) * Y(i) + (1/3) * YR(i); % Corrected index
            else
                % i - 1, i, i + 1
                yRight(i) = -(1/6) * YL(i) + (5/6) * Y(i) + (1/3) * YR(i);
                yLeft(i) = 1/3 * Y(i) + 5/6 * YR(i) - 1/6 * YRR(i); % Corrected index
            end
        end
    end
    y = [yLeft(:) yRight(:)];
end