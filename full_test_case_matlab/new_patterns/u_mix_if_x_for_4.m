function out = u_mix_if_x_for_4()
    out = 0;
    if 1
        sum = 0;
        i0 = 0;
        i1 = 0;
        i2 = 0;
        i3 = 0;
        i0 = 0;
        while i0 < 2
            i1 = 0;
            while i1 < 2
                i2 = 0;
                while i2 < 2
                    i3 = 0;
                    while i3 < 2
                        sum = sum + 1;
                        i3 = i3 + 1;
                    end
                    i2 = i2 + 1;
                end
                i1 = i1 + 1;
            end
            i0 = i0 + 1;
        end
    else
        o = 0;
    end
    out = out;
    return;
end
