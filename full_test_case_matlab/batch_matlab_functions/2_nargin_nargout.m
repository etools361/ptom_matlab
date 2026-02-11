% MATLAB functions: nargin/nargout
out = demo_nargout(3);

function [a, b] = demo_nargout(x)
    if nargout > 1
        a = x;
        b = x + 1;
    else
        a = x;
        b = [];
    end
end
