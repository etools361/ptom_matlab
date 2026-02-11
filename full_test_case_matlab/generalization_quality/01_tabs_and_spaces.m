% Generalization test 01: mixed tabs/spaces (position tracking)

function out = genq_tabs_spaces()
    x = [];
    y = [];
    x = 10;
    y = 20;
    if x < y
        x = x + 1;
    end
    out = x;
    return;
end
