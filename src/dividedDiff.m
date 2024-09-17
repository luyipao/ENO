% This function expands an existing divided difference table by adding new interpolation points (x) and their corresponding values (y).
% The function will automatically convert both to column vectors.

% Inputs:
% x: Vector of new interpolation points
% y: Vector of corresponding function values at the new points
% table: Existing divided difference table

% Output:
% result: New divided difference table including the new interpolation points and their corresponding values

function result = dividedDiff(x, y, table)

% Obtain the number of new points
n = length(x);

% If the existing table is not provided, initialize it to an empty array.
if nargin == 2
    table = [];
end

% Convert x and y to column vectors if they are not already in that format
x = x(:);
y = y(:);

% Copy the existing divided differences to the appropriate location in B
[m,~] = size(table);
B = zeros(n+m,n+m+1);
B(1:m, 1:m+1) = table;

% Copy the new points and their function values into B
B(m+1:m+n,1:2) = [x y];

% Calculate the new divided differences and store them in B
for j = 3:m+n+1
    ii = max(j-1,m+1):m+n;
    B(ii,j) = (B(ii,j-1)-B(ii-1,j-1)) ./ (B(ii,1)-B(ii-j+2,1));
end

% Return the new divided difference table
result = B;

end