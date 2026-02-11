function run_debug_inflate()
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

try
    import java.io.ByteArrayInputStream
    import java.io.ByteArrayOutputStream
    import java.util.zip.InflaterInputStream
    bis = ByteArrayInputStream(uint8(data));
    try
        iis = InflaterInputStream(bis);
        out = read_stream(iis);
        disp(['nowrap=false bytes=' num2str(numel(out))]);
    catch ME2
        disp(getReport(ME2));
    end

    bis2 = ByteArrayInputStream(uint8(data));
    try
        inflater = java.util.zip.Inflater(true);
        iis2 = InflaterInputStream(bis2, inflater);
        out2 = read_stream(iis2);
        disp(['nowrap=true bytes=' num2str(numel(out2))]);
    catch ME3
        disp(getReport(ME3));
    end
catch ME
    disp(getReport(ME));
end
end

function out = read_stream(iis)
import java.io.ByteArrayOutputStream
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
end
