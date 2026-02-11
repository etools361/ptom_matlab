% p024: single-statement if without braces (call assignment).

function out = p024_if_single_stmt_call_assign(cond)
    ctx = [];
    rect = [];
    if cond
        rect = db_add_rectangle(ctx, 1, 0, 0, 1, 1);
    end
    out = rect;
    return;
end
