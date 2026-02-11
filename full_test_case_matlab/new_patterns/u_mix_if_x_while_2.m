function out = u_mix_if_x_while_2()
    out = 0;
    if 1
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
    else
        o = 0;
    end
    out = out;
    return;
end
