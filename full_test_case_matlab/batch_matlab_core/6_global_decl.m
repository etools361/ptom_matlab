function out = core_global_decl()
% MATLAB core: global declarations
    global g1 g2
    g1 = 1;
    g2 = g1 + 2;
    out = g2;
end
