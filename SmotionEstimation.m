function motion_info = SmotionEstimation(curr_frame, ref_frame, block_size, search_range)
    [height, width] = size(curr_frame);
    
    motion_info = struct('motion_vectors', zeros(ceil(height/block_size) * ceil(width/block_size), 2), ...
                         'block_indices', zeros(ceil(height/block_size) * ceil(width/block_size), 2));
    idx = 1;
    
    for i = 1:block_size:height-block_size+1
        for j = 1:block_size:width-block_size+1
            block_curr = curr_frame(i:i+block_size-1, j:j+block_size-1);
            min_error = inf;
            best_match = [0, 0];
            
            for m = 0:search_range
                for n = 0:search_range
                    if i + m < 1 || i + m + block_size - 1 > height || j + n < 1 || j + n + block_size - 1 > width
                        continue;
                    end
                    
                    block_ref = ref_frame(i+m:i+m+block_size-1, j+n:j+n+block_size-1);
                    currentMSE = immse(block_ref, block_curr);
                    if currentMSE < min_error
                        min_error = currentMSE;
                        best_match = [m, n];
                    end
                end
            end
            for m = -search_range:-1
                for n = -search_range:-1
                    if i + m < 1 || i + m + block_size - 1 > height || j + n < 1 || j + n + block_size - 1 > width
                        continue;
                    end
                    
                    block_ref = ref_frame(i+m:i+m+block_size-1, j+n:j+n+block_size-1);
                    currentMSE = immse(block_ref, block_curr);
                    if currentMSE < min_error
                        min_error = currentMSE;
                        best_match = [m, n];
                    end
                end
            end
            motion_info.motion_vectors(idx, :) = best_match;
            motion_info.block_indices(idx, :) = [i, j]; % ذخیره کردن شماره بلاک
            idx = idx + 1;
        end
    end
end
