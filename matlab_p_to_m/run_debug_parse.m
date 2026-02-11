function run_debug_parse()
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
inflated = p_to_m_inflate_zlib(data);
disp(numel(inflated));
disp(inflated(1:min(16, numel(inflated)))');

mfile = struct('Tokens', uint32(zeros(1, 7)), 'Size', uint32(0), 'Data', uint8([]));
if isempty(inflated)
    disp('inflate empty');
    return;
end
if numel(inflated) < 28
    disp('inflate too short');
    return;
end
mfile.Tokens = swapbytes(typecast(inflated(1:28), 'uint32'));
mfile.Data = inflated(29:end);
mfile.Size = uint32(numel(mfile.Data));

disp(mfile.Tokens);
name_count = sum(double(mfile.Tokens));
[names, offset] = p_to_m_parse_names(mfile.Data, name_count);
disp(name_count);
disp(offset);
disp(names);
code_len = numel(mfile.Data) - offset + 1;
disp(code_len);

[m_text, info] = p_to_m_parse_mfile(mfile);
disp(info);
disp(numel(m_text));
disp(m_text);
end
