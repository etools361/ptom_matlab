% 5_return_basic_int.ael - 函数返回整数常量
% 目的：测试最简单的 return 常量模式
r = 0;
r = ret_one();

function out = ret_one()
    out = 1;
    return;
end
