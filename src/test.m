% Example usage of dividedDiff function to add a new point to the divided difference table

% Existing points and their function values
x = [1; 2; 3];
y = [2; 3; 5];

% Existing divided difference table
table = dividedDiff(x, y);
disp('Divided Difference Table:');
disp(table);
% New point to be added
x_new = 4;
y_new = 7;

% Add the new point to the existing x and y vectors
x = [x; x_new];
y = [y; y_new];

% Update the divided difference table with the new point
new_table = dividedDiff(x, y, table);

% Display the updated divided difference table
disp('Updated Divided Difference Table:');
disp(new_table);

% Function definition for dividedDiff
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
    B = zeros(n, n);
    B(1:m, 1:m+1) = table;

    % Copy the new points and their function values into B
    B(m+1:n, 1:2) = [x(m+1:n) y(m+1:n)];

    % Calculate the new divided differences and store them in B
    for j = 3:n+1
        ii = max(j-1, m+1):n;
        B(ii, j) = (B(ii, j-1) - B(ii-1, j-1)) ./ (B(ii, 1) - B(ii-j+2, 1));
    end

    % Return the new divided difference table
    result = B;
end
