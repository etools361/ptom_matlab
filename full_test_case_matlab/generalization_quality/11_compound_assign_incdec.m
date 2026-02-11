% Generalization test 11: compound assignment and ++/--

function out = genq_compound_assign_incdec()
    a = [];
    b = [];
    a = 1;
    b = 2;
    a = a + b;
    a = a - 1;
    a = a * 3;
    a = a / 2;
    a = mod(a, 2);
    a = a + 1;
    b = b - 1;
    out = a + b;
    return;
end
