% Generalization test 03: integer overflow handling (token treated as REAL)

function out = genq_big_int_overflow()
    big = [];
    r = [];
    % Larger than 32-bit, should become REAL token in the minimal lexer
    big = 99999999999999999999;
    r = big + 1;
    out = r;
    return;
end
