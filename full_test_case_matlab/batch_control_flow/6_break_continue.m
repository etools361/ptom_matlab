% 6_break_continue.ael - 循环中的 break / continue
% 目的：在 while 中测试 break/continue 的 CFG 模式
i = 0;
while i < 10
    i = i + 1;
    if i == 3
        continue;
    end
    if i == 5
        break;
    end
end
