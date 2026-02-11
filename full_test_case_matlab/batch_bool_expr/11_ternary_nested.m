% 11_ternary_nested.ael - 嵌套三元运算
% 目的：cond ? a : (cond2 ? b : c) 的模式
x = 1;
r = ael_ternary(x == 0, 0, ael_ternary(x == 1, 1, -1));
