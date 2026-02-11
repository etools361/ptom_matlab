% Base pattern p012: for-loop header needs BEGIN_LOOP, and tail needs LOOP_AGAIN/LOOP_EXIT scaffolds.
% This targets cases seen in utilities/demo_fet1_1 where atf2ir was missing OP=36/38/39.

function out = p012_dummy(x)
    out = x;
    return;
end

function out = p012_for_loop_header_and_tail_scaffold_markers(nf)
    i = 0;
    acc = 0;
    i = 0;
    while i < nf / 2.0
        acc = acc + p012_dummy(i);
        i = i + 1;
    end
    out = acc;
    return;
end
