% Create a sample matrix

original_matrix = magic(4); % using a 4x4 magic square as an example

disp('Original Matrix:');

disp(original_matrix);


% Perform zigzag scanning on the original matrix

zigzag_output = Szigzag(original_matrix);

disp('Zigzag Scanned Output:');

disp(zigzag_output);

% Reconstruct the original matrix using the zigzag output

reconstructed_matrix = Sizigzag(zigzag_output, size(original_matrix, 1), size(original_matrix, 2));

disp('Reconstructed Matrix:');

disp(reconstructed_matrix);


% Check if the original matrix and the reconstructed matrix are the same

if isequal(original_matrix, reconstructed_matrix)

    disp('Reconstruction successful. The original matrix is equal to the reconstructed matrix.');

else

    disp('Reconstruction failed. The original matrix is not equal to the reconstructed matrix.');

end