function result = Srunlength(arr)
    result = [];
    start = [];
    zero_count = 0;
    for idx = 1:numel(arr)
        num = arr(idx);
        if num ~= 0
            if isempty(start)
                result = [result, [zero_count, num]];
                zero_count = 0;
                start = [];
            end
        else
            if isempty(start)
                zero_count = zero_count + 1;
            end
        end
    end
    %i forget most important thing DEEE:
    result = result(2:end);
end

