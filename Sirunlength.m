function arr = Sirunlength(result)
    try
        arr = [];
        firstNum = result(1);
        result= result(2:end);
        for idx = 1:2:numel(result)
            zero_count = result(idx);
            num = result(idx + 1);
            if zero_count > 0
                arr = [arr, zeros(1, zero_count)];
            end
            arr = [arr, num];
        end
        arr = [firstNum, arr];
    catch ME
        % disp(ME.message);
        arr= zeros(1,64);
    end
end