% p015_break_continue.ael
% 最小复现：while + break/continue
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
