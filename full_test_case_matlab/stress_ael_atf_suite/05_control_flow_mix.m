% Mix: if/else, while, for, do-while, break/continue
i = 0;
acc = 0;
while i < 10
    i = i + 1;
    if i == 2
        continue;
    end
    if i == 9
        break;
    end
    acc = acc + i;
end
i = 0;
while i < 5
    acc = acc + i;
    i = i + 1;
end
while true
    acc = acc + 1;
    if ~(acc < 20)
        break;
    end
end
