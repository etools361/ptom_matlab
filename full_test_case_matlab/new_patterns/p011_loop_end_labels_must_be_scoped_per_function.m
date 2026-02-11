% Base pattern p011: loop-end label IDs are reused across functions.
% Goal: atf2ir must NOT inject LOOP_EXIT into a different function's control flow
% just because another function contains a loop with an END_LOOP label.

function out = p011_func_with_loop()
    l = {1, 2};
    while is_list(l)
        l = cdr(l);
    end
    out = 0;
    return;
end

function out = p011_func_without_loop_but_with_if_chain()
    s = 'a';
    if s == 'a'
        s = 'a';
    elseif s == 'b'
        s = 'b';
    else
        s = 'c';
    end
    out = s;
    return;
end
