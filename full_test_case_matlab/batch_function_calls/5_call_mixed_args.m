% 5_call_mixed_args.ael - 混合类型参数函数调用
% 目的：测试传递不同类型的参数
log_info('test', 100, 'success');

function log_info(name, code, msg)
    s1 = name;
    n = code;
    s2 = msg;
end
