% Many locals across nested blocks to stress scope handling
g = 0;
nested_locals(3, 4);

function out = nested_locals(a, b)
    x = a + b;
    ;
    out = g;
    return;
end
