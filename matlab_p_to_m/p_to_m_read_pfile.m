function [pfile, ok, msg] = p_to_m_read_pfile(p_path)

pfile = struct( ...
    'Major', '', ...
    'Minor', '', ...
    'Scramble', uint32(0), ...
    'Crc', uint32(0), ...
    'Uk2', uint32(0), ...
    'SizeAfter', uint32(0), ...
    'SizeBefore', uint32(0), ...
    'Data', uint8([]));
ok = false;
msg = '';

fid = fopen(p_path, 'rb');
if fid < 0
    msg = sprintf('Failed to open input: %s', p_path);
    return;
end

header = fread(fid, 32, '*uint8')';
if numel(header) < 32
    fclose(fid);
    msg = 'Header too short';
    return;
end

pfile.Major = char(header(1:6));
pfile.Minor = char(header(7:12));
pfile.Scramble = p_to_m_read_u32_be(header, 13);
pfile.Crc = p_to_m_read_u32_be(header, 17);
pfile.Uk2 = p_to_m_read_u32_be(header, 21);
pfile.SizeAfter = p_to_m_read_u32_be(header, 25);
pfile.SizeBefore = p_to_m_read_u32_be(header, 29);

if ~strcmp(pfile.Major, 'v01.00') || ~strcmp(pfile.Minor, 'v00.00')
    fclose(fid);
    msg = 'Unsupported version';
    return;
end
if pfile.SizeAfter == 0 || pfile.SizeBefore == 0
    fclose(fid);
    msg = 'Invalid sizes';
    return;
end

pfile.Data = fread(fid, double(pfile.SizeAfter), '*uint8')';
fclose(fid);
if numel(pfile.Data) ~= double(pfile.SizeAfter)
    msg = 'Truncated data';
    return;
end

ok = true;
end

function v = p_to_m_read_u32_be(buf, offset)
v = swapbytes(typecast(uint8(buf(offset:offset+3)), 'uint32'));
end
