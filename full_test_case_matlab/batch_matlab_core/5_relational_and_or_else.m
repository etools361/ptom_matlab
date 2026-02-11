function out = core_relational_and_or_else(a, b, c, d)
% MATLAB core: eq/le, &/|, if/else vs no-else
    x = (a == b);
    y = (c <= d);
    z = (a & b);
    w = (c | d);

    out = 0;
    if x
        out = out + 1;
    else
        out = out + 10;
    end

    if y
        out = out + 2;
    end

    if z
        out = out + 3;
    end

    if w
        out = out + 4;
    end
end
