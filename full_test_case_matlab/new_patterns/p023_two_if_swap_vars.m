% p023: sequential ifs with multi-statement bodies (swap pattern).

function out = p023_two_if_swap_vars(x1, x2, y1, y2)
    swap = [];
    if x1 > x2
        swap = x1;
        x1 = x2;
        x2 = swap;
    end
    if y1 > y2
        swap = y1;
        y1 = y2;
        y2 = swap;
    end
    out = {x1, x2, y1, y2};
    return;
end
