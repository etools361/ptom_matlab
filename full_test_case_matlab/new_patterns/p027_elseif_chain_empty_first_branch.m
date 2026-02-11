% p027: else-if chain with empty first branch (braced)
% Covers: empty then-block followed by else-if chain.

function out = p027_elseif_chain_empty_first_branch(x)
    if x == 1
    elseif x == 2
        x = 3;
    elseif x == 3
        x = 4;
    end
    out = x;
    return;
end
