% cal ENO yRight obtain the better values while yLeft perform bad.


% Define the integration range and parameters
xa = 0;
xb = 2*pi;
k = 3;
numSegments = [40, 80, 160, 320];

% Loop over different segment counts
for N = numSegments
    yCal = ENOReconstrucation(xa, xb, k, N, @f);
    yRight = yCal(:,2);
    yRight = [yRight(end); yRight];
    yLeft = yCal(:,1);
    yLeft = [yLeft; yLeft(1)];
    % Calculate the exact values and error
    X = linspace(xa, xb, N+1);
    
    %% choose value yLeft or yRight
    yCalculated = yLeft;

end

%% draw
hold on;
plot(linspace(xa,xb,1000), f(linspace(xa,xb,1000)), 'DisplayName', 'True Solution');
plot(X, yCalculated, '--', 'DisplayName', 'Numerical Solution');
legend;
xlabel('x');
ylabel('y');
hold off;
%% save
filename = sprintf('ENODiscontinue.pdf');
filename = fullfile('..\docs\images',filename);
exportgraphics(gcf, filename, 'ContentType', 'vector');



%% target function
function y = f(x)
    y = double(x >= 2 & x <= 4);
end

