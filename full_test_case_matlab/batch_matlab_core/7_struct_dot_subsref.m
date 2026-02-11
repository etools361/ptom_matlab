function out = core_struct_dot_subsref()
% MATLAB core: dot access and chained subsref
    s = struct('a', 1, 'b', { {10, 20} });
    out = s.a;
    out = s(1).a;
    out = s(1).b{2};
end
