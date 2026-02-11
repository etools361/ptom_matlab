% 8_return_string_null.ael - 函数返回字符串和 NULL
% 目的：测试 return "str" 与 return NULL 的编码模式
s1 = '';
s2 = '';
s1 = get_name();
s2 = get_null();

function out = get_name()
    out = 'demo_name';
    return;
end

function out = get_null()
    out = [];
    return;
end
