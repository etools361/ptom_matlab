function [mfile, ok, msg] = p_to_m_uncompress(pfile)

mfile = struct('Tokens', uint32(zeros(1, 7)), 'Size', uint32(0), 'Data', uint8([]));
ok = false;
msg = '';

if isempty(pfile.Data)
    msg = 'Missing pfile data';
    return;
end

scrambled = p_to_m_unscramble(pfile.Data, pfile.Scramble);
inflated = p_to_m_inflate_zlib(scrambled);

if isempty(inflated)
    msg = 'Inflate failed';
    return;
end
if numel(inflated) ~= double(pfile.SizeBefore)
    msg = 'Size mismatch after inflate';
    return;
end
if numel(inflated) < 28
    msg = 'Inflated data too short';
    return;
end

mfile.Tokens = swapbytes(typecast(inflated(1:28), 'uint32'));
mfile.Data = inflated(29:end);
mfile.Size = uint32(numel(mfile.Data));
ok = true;
end
