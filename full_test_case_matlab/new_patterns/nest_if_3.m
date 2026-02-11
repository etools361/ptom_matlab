function out = nest_if_3()
    sum = 0;
    if sum == 0
        if sum == 1
            if sum == 2
                sum = sum + 1;
            else
                sum = sum + 2;
            end
        else
            sum = sum + 2;
        end
    else
        sum = sum + 2;
    end
    out = sum;
    return;
end
