function out = nest_if_2()
    sum = 0;
    if sum == 0
        if sum == 1
            sum = sum + 1;
        else
            sum = sum + 2;
        end
    else
        sum = sum + 2;
    end
    out = sum;
    return;
end
