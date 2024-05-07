function matrix = Sizigzag(in, m, n)
    len= m*n;
    output = zeros(1, len);
    output (1:numel(in)) = in(1:end);
    % Initialize the matrix to store the reconstructed matrix
    matrix = zeros(m, n);
    
    idx = 1;
    
    for s = 1:m+n-1
        if mod(s, 2) == 1
            for i = 1:min(s-1, m)
                j = s - i;
                if j >= 1 && j <= n
                    matrix(i, j) = output(idx);
                    idx = idx + 1;
                end
            end
        else
            for j = 1:min(s-1, n)
                i = s - j;
                if i >= 1 && i <= m
                    matrix(i, j) = output(idx);
                    idx = idx + 1;
                end
            end
        end
    end
    matrix(m, n) = output(idx);
end