function output = Szigzag(in)
    % Input Matrix
    matrix = in;
    % Get the dimensions of the matrix
    [m, n] = size(matrix);
    
    % Initialize the output array
    output = zeros(1, m*n);
    idx = 1;
    
    for s = 1:m+n-1
        if mod(s, 2) == 1
            for i = 1:min(s-1, m)
                j = s - i;
                if j >= 1 && j <= n
                    output(idx) = matrix(i, j);
                    idx = idx + 1;
                end
            end
        else
            for j = 1:min(s-1, n)
                i = s - j;
                if i >= 1 && i <= m
                    output(idx) = matrix(i, j);
                    idx = idx + 1;
                end
            end
        end
    end
    output(idx) = matrix(m, n);
end