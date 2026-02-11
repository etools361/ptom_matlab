% 11_deep_nested.ael - 深度嵌套（三层）
% 目的：观察三层嵌套 {{{1, 2}}} 的 IR 模式和 DEPTH 变化
a = [];

function test_deep_nested()
    a = {{{1, 2}}};
end
