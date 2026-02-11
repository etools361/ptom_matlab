% 7_return_in_loop.ael - 循环中的 early return
% 目的：在 while 内部根据条件提前返回
r = -1;
r = find_first_gt3();

function out = find_first_gt3()
    i = 0;
    while i < 10
        if i > 3
            out = i;
            return;
        end
        i = i + 1;
    end
    out = -1;
    return;
end
