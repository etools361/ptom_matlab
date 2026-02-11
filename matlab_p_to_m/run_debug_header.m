function run_debug_header()
root = 'E:\work\prog\github\ptom_c-main';
addpath(fullfile(root, 'matlab_p_to_m'));
pPath = fullfile(root, 'pcode_out_flat', '_OldClass__method1.p');

[pfile, ok, msg] = p_to_m_read_pfile(pPath);
disp(ok);
disp(msg);
if ~ok
    return;
end

data = p_to_m_unscramble(pfile.Data, pfile.Scramble);
head = data(1:min(16, numel(data)));
hex = dec2hex(head, 2);
disp(hex);
end
