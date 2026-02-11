% 3_global_vs_local.ael - 全局变量与局部变量同名
% 目的：观察符号表与 ATF 记录中的作用域差异
x = 1;
test();

function test()
    x = 2;
    x = x + 1;
end
