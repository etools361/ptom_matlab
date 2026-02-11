% 11_do_while_basic.ael - do-while 循环
% 目的：测试 do { ... } while(cond); 的循环结构
i = 0;
while true
    i = i + 1;
    if ~(i < 3)
        break;
    end
end
