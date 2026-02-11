function out = u_mix_for_x_while_3()
    out = 0;
    o = 0;
    o = 0;
    while o < 2
        sum = 0;
        w0 = 0;
        w1 = 0;
        w2 = 0;
        w0 = 0;
        while w0 < 2
            w1 = 0;
            while w1 < 2
                w2 = 0;
                while w2 < 2
                    sum = sum + 1;
                    w2 = w2 + 1;
                end
                w1 = w1 + 1;
            end
            w0 = w0 + 1;
        end
        o = o + 1;
    end
    out = out;
    return;
end
