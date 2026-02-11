% p003: if / else if / else 链（elseif header 不应插入 entry NUM_LOCAL）
% 目的：
% - 复现并回归：SET_LABEL (elseif header) 后不应有 NUM_LOCAL
% - 与 p002（else{ if(...) }）区分：p002 的 else body 入口需要 NUM_LOCAL

function out = p003_if_elseif_else_chain(x)
    r = 0;
    if x == 0
        r = 10;
    elseif x == 1
        r = 20;
    else
        r = -1;
    end
    out = r;
    return;
end
