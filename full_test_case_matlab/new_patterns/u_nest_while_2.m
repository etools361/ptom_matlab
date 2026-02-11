function out = u_nest_while_2()
    sum = 0;
    w0 = 0;
    w1 = 0;
    w0 = 0;
    while w0 < 2
        w1 = 0;
        while w1 < 2
            sum = sum + 1;
            w1 = w1 + 1;
        end
        w0 = w0 + 1;
    end
    out = sum;
    return;
end
