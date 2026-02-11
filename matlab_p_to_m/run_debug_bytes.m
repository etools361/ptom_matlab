function run_debug_bytes()
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

import java.io.ByteArrayInputStream
bis1 = ByteArrayInputStream(int8(data));
vals1 = zeros(1, 4);
for i = 1:4
    v = bis1.read();
    vals1(i) = v;
end
disp(vals1);

bis2 = ByteArrayInputStream(uint8(data));
vals2 = zeros(1, 4);
for i = 1:4
    v = bis2.read();
    vals2(i) = v;
end
disp(vals2);
end
