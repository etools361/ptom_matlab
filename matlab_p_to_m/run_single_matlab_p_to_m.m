function run_single_matlab_p_to_m()
root = 'E:\work\prog\github\ptom_c-main';
addpath(fullfile(root, 'matlab_p_to_m'));

pPath = fullfile(root, 'pcode_out_flat', '_OldClass__method1.p');
mPath = fullfile(root, 'p_to_m_matlab_out', 'debug_oldclass_method1.m');

[ok, info] = p_to_m(pPath, mPath, 'Verbose', true);
disp(ok);
disp(info);
end
