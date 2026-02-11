function out = p_to_m_inflate_zlib(data)

out = uint8([]);
if isempty(data)
    return;
end

try
    import java.io.ByteArrayInputStream
    import java.io.ByteArrayOutputStream
    import java.util.zip.InflaterInputStream

    bis = ByteArrayInputStream(uint8(data));
    iis = InflaterInputStream(bis);
    baos = ByteArrayOutputStream();
    while true
        b = iis.read();
        if b == -1
            break;
        end
        baos.write(b);
    end
    iis.close();
    raw = int8(baos.toByteArray());
    out = typecast(raw, 'uint8');
    out = out(:).';
catch
    out = uint8([]);
end
end
