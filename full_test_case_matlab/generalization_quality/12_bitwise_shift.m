% Generalization test 12: bitwise and shifts

function out = genq_bitwise_shift(x, y)
    a = [];
    a = bitor(bitand(x, y), bitxor(x, y));
    a = bitshift(bitshift(a, 2), -(1));
    out = a;
    return;
end
