% MATLAB functions: nested functions
out = outer(5);

function y = outer(x)
    y = inner(x) + 1;
    function z = inner(t)
        z = t * 2;
    end
end
