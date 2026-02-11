% MATLAB functions: persistent variable
out1 = counter();
out2 = counter();

function v = counter()
    persistent n
    if isempty(n)
        n = 0;
    end
    n = n + 1;
    v = n;
end
