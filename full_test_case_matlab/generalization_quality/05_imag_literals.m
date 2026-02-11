% Generalization test 05: imaginary literals (e.g. 2i, 2.5i)

function out = genq_imag_literals()
    a = [];
    b = [];
    c = [];
    a = 2 * i;
    b = 2.5 * i;
    c = a + b;
    out = c;
    return;
end
