function y = ENOReconstrucation(xa, xb, k, N, f)
    X = linspace(xa, xb, N + 1);  

    intervals = [X(1:end-1)', X(2:end)'];
    Y = averageValuesOverIntervals(f, intervals);
    Y = Y';
    YL = circshift(Y, 1);
    YLL = circshift(Y, 2);
    YR = circshift(Y, -1);
    YRR = circshift(Y, -2);
    YRR = circshift(Y, -3);
    
    % yRight(i) I_i point i + 1/2
    % yLeft(i) I_i point i - 1/2
    yRight = zeros(1, N);
    yLeft = zeros(1,N);
    for i = 1:N
        % i, i + 1
        if (abs(Y(i) - YLeft(i)) >= abs(Y(i) - YR(i)))
            % i, i + 1, i + 2
            if (abs(YRR(i) + Y(i) - 2 * YR(i)) <= abs(YR(i) + YLeft(i) - 2 * Y(i)))
                yRight(i) = 1/3 * Y(i) + 5/6 * YR(i) - 1/6 * YRR(i);
                yLeft(i) = 11/6*YR(i) - 7/6 * YRR(i) + 1 / 3* YRRR(i); 
            % i - 1, i, i + 1
            else
                yRight(i) = -1/6 * YLeft(i) + 5/6 * Y(i) + 1/3 * YR(i);
                yLeft(i) = 1/3 * Y(i) + 5/6 * YR(i) - 1/6 * YRR(i);
            end
        else
            % i - 2, i - 1, i
            if abs(Y(i) - 2 * YLeft(i) + YLeftLeft(i)) < abs(YR(i) - 2 * Y(i) + YLeft(i))
                yRight(i + 1) = (1/3) * YLeftLeft(i) - (7/6) * YLeft(i) + (11/6) * Y(i);
                yLeft = -(1/6) * YLeft(i) + (5/6) * Y(i) + (1/3) * YR(i);
            else
                % i - 1, i, i + 1
                yRight(i + 1) = -(1/6) * YLeft(i) + (5/6) * Y(i) + (1/3) * YR(i);
                yLeft(i) = 1/3 * Y(i) + 5/6 * YR(i) - 1/6 * YRR(i);
            end
        end
    end
    y = [yLeft(:) yRight(:)];
end