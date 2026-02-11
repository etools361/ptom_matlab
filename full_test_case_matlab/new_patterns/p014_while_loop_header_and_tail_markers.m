% Base pattern p014: while-like loop header + tail scaffolds.
% Targets regressions like 9_if_while_combo where hooked/baseline IR contains:
% NUM_LOCAL ; BEGIN_LOOP ; LOOP_AGAIN ; ADD_LABEL ; SET_LABEL head
% and the loop tail may include LOOP_EXIT before the end label.

function out = p014_while_loop_header_and_tail_markers()
    sum = 0;
    i = 0;
    % Keep an outer if to create a non-loop join label around the loop block.
    if 2 > 1
        while i < 3
            if i > 1
                break;
            end
            if i == 0
                i = i + 1;
                continue;
            end
            sum = sum + i;
            i = i + 1;
        end
    end
    out = sum;
    return;
end
