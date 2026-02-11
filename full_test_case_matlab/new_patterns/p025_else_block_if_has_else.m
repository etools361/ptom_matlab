% p025: else block starts with an if/else (should not collapse into else-if chain).

function out = p025_else_block_if_has_else(flag1, flag2)
    v = 0;
    if flag1
        v = 1;
    else
        if flag2
            v = 2;
        else
            v = 3;
        end
    end
    out = v;
    return;
end
