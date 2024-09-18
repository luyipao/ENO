xa = 0;
xb = 2 * pi;
errorList = [];
nValues = [40, 80, 160, 320];

for n = nValues
    x = linspace(xa, xb, n + 1);
    h = (xb - xa) / n;
    
    xc = x(1:end-1) + x(2:end);
    xc = xc / 2;
    
    % Exact values
    yExact = df(xc);
    
    xc = [xc(1) - 2 * h, xc(1) - h, xc, xc(end) + h];
    yc = f(xc);
    
    % Numerical solution
    yCal = -1/6 * yc(1:end - 2) + 5/6 * yc(2:end - 1) + 1/3 * yc(3:end);
    yCal = yCal(2:end) - yCal(1:end -1 );
    yCal = yCal / h;
    
    % Compute 1-norm of the error
    errorNorm = h * sum(abs(yCal - yExact));
    % Append to error list
    errorList = [errorList, errorNorm];
end

% Compute error ratio
errorRatio = log(errorList(1:end - 1) ./ errorList(2:end)) / log(2);
disp('1-norm Error ratio:');
disp(errorRatio);


% Function f
function y = f(x)
    y = sin(x);
end
function y = df(x)
    y = cos(x);
end
