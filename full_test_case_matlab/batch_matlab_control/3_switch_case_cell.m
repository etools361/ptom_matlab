% MATLAB control flow: switch with cell array cases
x = 2;
out = 0;
switch x
    case {1, 3}
        out = 10;
    case {2, 4}
        out = 20;
    otherwise
        out = -1;
end
