% 6_return_if_else.ael - 函数内多分支 return
% 目的：if / else if / else 中的多返回路径
r = 0;
r = select_sign(1);

function out = select_sign(x)
    if x > 0
        out = 1;
        return;
    elseif x < 0
        out = -1;
        return;
    else
        out = 0;
        return;
    end
end
