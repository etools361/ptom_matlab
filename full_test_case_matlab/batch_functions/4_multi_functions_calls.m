% 4_multi_functions_calls.ael - 多函数与相互调用
% 目的：多个 defun 以及函数间调用的 CALL_META 模式
x = 0;
f();
g();

function g()
    x = x + 2;
end

function f()
    x = x + 1;
    g();
end
