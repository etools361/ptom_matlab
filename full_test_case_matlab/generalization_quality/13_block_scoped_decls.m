% Generalization test 13: nested blocks and local decls with init

function out = genq_block_scoped_decls()
    a = [];
    a = 0;
    ;
    out = a;
    return;
end
