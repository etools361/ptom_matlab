% Generalization test 07: trailing comma in call args should add an implicit NULL

function out = genq_trailing_comma_call()
    x = [];
    x = dummy_func(1, 2, []);
    out = x;
    return;
end

function out = dummy_func(a, b, c)
    out = a;
    return;
end
