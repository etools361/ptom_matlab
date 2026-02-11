function run_batch_matlab_p_to_m()
root = 'E:\work\prog\github\ptom_c-main';
addpath(fullfile(root, 'matlab_p_to_m'));

inputDir = fullfile(root, 'pcode_out_flat');
outDir = fullfile(root, 'p_to_m_matlab_out');
mapFile = fullfile(root, 'pcode_out_flat', 'map.csv');

if exist(outDir, 'dir') ~= 7
    mkdir(outDir);
end

report = p_to_m_batch(inputDir, outDir, ...
    'Threads', 4, ...
    'StructuredOut', false, ...
    'Format', true, ...
    'IndentWidth', 4, ...
    'BaseNameOnly', true);

reportFile = fullfile(outDir, 'matlab_p_to_m_report.txt');
fid = fopen(reportFile, 'wb');
if fid >= 0
    fprintf(fid, 'Total=%d\nOk=%d\nFail=%d\nElapsedSeconds=%.3f\n', ...
        report.Total, report.Ok, report.Fail, report.ElapsedSeconds);
    fclose(fid);
end

disp(report);
end
