function report = p_to_m_batch(inputPath, outputDir, varargin)
%P_TO_M_BATCH Batch convert .p files to .m files.

if nargin < 2
    error('inputPath and outputDir are required');
end

opts.Threads = 1;
opts.Flatten = true;
opts.StructuredOut = false;
opts.SourceMap = '';
opts.SourceRoot = '';
opts.Verbose = false;
opts.Format = true;
opts.IndentWidth = 4;
opts.BaseNameOnly = false;
opts.JobStorageLocation = '';
opts.ReportFile = '';

if mod(numel(varargin), 2) ~= 0
    error('Options must be name/value pairs');
end
for k = 1:2:numel(varargin)
    key = lower(varargin{k});
    switch key
        case 'threads'
            opts.Threads = max(1, floor(varargin{k+1}));
        case 'flatten'
            opts.Flatten = logical(varargin{k+1});
        case 'structuredout'
            opts.StructuredOut = logical(varargin{k+1});
        case 'sourcemap'
            opts.SourceMap = varargin{k+1};
        case 'sourceroot'
            opts.SourceRoot = varargin{k+1};
        case 'verbose'
            opts.Verbose = logical(varargin{k+1});
        case 'format'
            opts.Format = logical(varargin{k+1});
        case 'indentwidth'
            opts.IndentWidth = double(varargin{k+1});
        case 'basenameonly'
            opts.BaseNameOnly = logical(varargin{k+1});
        case 'jobstoragelocation'
            opts.JobStorageLocation = varargin{k+1};
        case 'reportfile'
            opts.ReportFile = varargin{k+1};
        otherwise
            error('Unknown option: %s', varargin{k});
    end
end

if opts.BaseNameOnly
    opts.StructuredOut = false;
    opts.Flatten = true;
end

if exist(inputPath, 'file') == 2
    files = {inputPath};
    srcRoot = fileparts(inputPath);
elseif exist(inputPath, 'dir') == 7
    srcRoot = inputPath;
    files = collect_p_files(srcRoot);
else
    error('Input not found: %s', inputPath);
end

if isempty(files)
    error('No .p files found');
end

if exist(outputDir, 'dir') ~= 7
    mkdir(outputDir);
end

map = containers.Map();
sources = {};
if opts.StructuredOut && ~isempty(opts.SourceMap) && exist(opts.SourceMap, 'file') == 2
    [map, sources] = load_source_map(opts.SourceMap);
    if isempty(opts.SourceRoot)
        opts.SourceRoot = common_root(sources);
    end
    opts.SourceRoot = normalize_root(opts.SourceRoot);
else
    opts.StructuredOut = false;
end

numFiles = numel(files);
outFiles = cell(numFiles, 1);
nameCounts = containers.Map('KeyType','char','ValueType','int32');
for i = 1:numFiles
    if opts.BaseNameOnly
        [~, base] = fileparts(files{i});
        outRel = [base '.m'];
        if isKey(nameCounts, outRel)
            idx = nameCounts(outRel) + 1;
            nameCounts(outRel) = idx;
            outRel = sprintf('%s__dup%d.m', base, idx);
        else
            nameCounts(outRel) = 0;
        end
    else
        flatBase = flat_base(srcRoot, files{i});
        outRel = [flatBase '.m'];
        if opts.StructuredOut && isKey(map, flatBase)
            outRel = rel_path(map(flatBase), opts.SourceRoot);
        elseif ~opts.Flatten
            outRel = rel_path(files{i}, normalize_root(srcRoot));
        end
    end
    outFiles{i} = fullfile(outputDir, outRel);
end

results = false(numFiles, 1);
startTime = tic;

use_parallel = opts.Threads > 1 && exist('parpool', 'file') == 2;
if use_parallel
    try
        if ~license('test', 'Distrib_Computing_Toolbox')
            use_parallel = false;
        end
    catch
        use_parallel = false;
    end
end
if use_parallel
    try
        cluster = parcluster('local');
        if isempty(opts.JobStorageLocation)
            opts.JobStorageLocation = default_job_storage();
        end
        if ~isempty(opts.JobStorageLocation)
            if exist(opts.JobStorageLocation, 'dir') ~= 7
                mkdir(opts.JobStorageLocation);
            end
            cluster.JobStorageLocation = opts.JobStorageLocation;
        end
        pool = gcp('nocreate');
        if isempty(pool) || pool.NumWorkers ~= opts.Threads
            if ~isempty(cluster)
                parpool(cluster, opts.Threads);
            else
                parpool(opts.Threads);
            end
        end
    catch
        use_parallel = false;
    end
end

if use_parallel
    parfor i = 1:numFiles
        [ok, ~] = p_to_m(files{i}, outFiles{i}, ...
            'Format', opts.Format, ...
            'IndentWidth', opts.IndentWidth);
        results(i) = ok;
    end
else
    for i = 1:numFiles
        [ok, ~] = p_to_m(files{i}, outFiles{i}, ...
            'Verbose', opts.Verbose, ...
            'Format', opts.Format, ...
            'IndentWidth', opts.IndentWidth);
        results(i) = ok;
    end
end

elapsed = toc(startTime);
report = struct( ...
    'Total', numFiles, ...
    'Ok', sum(results), ...
    'Fail', sum(~results), ...
    'ElapsedSeconds', elapsed, ...
    'Files', {files}, ...
    'OutFiles', {outFiles}, ...
    'Results', results);

if ~isempty(opts.ReportFile)
    try
        write_report(report, opts.ReportFile);
    catch ME
        warning('Failed to write report (%s): %s', opts.ReportFile, ME.message);
    end
end
end

function files = collect_p_files(rootDir)
items = dir(rootDir);
files = {};
for i = 1:numel(items)
    name = items(i).name;
    if strcmp(name, '.') || strcmp(name, '..')
        continue;
    end
    fullPath = fullfile(rootDir, name);
    if items(i).isdir
        files = [files; collect_p_files(fullPath)]; %#ok<AGROW>
    else
        [~, ~, ext] = fileparts(name);
        if strcmpi(ext, '.p')
            files = [files; {fullPath}]; %#ok<AGROW>
        end
    end
end
end

function base = flat_base(rootDir, fullPath)
rootDir = normalize_root(rootDir);
if path_starts_with(fullPath, rootDir)
    rel = fullPath(numel(rootDir)+1:end);
else
    rel = fullPath;
end
rel = regexprep(rel, '\.p$', '');
if ~isempty(rel) && rel(end) == '.'
    rel = rel(1:end-1);
end
flat = regexprep(rel, '[\\/]+', '__');
while ~isempty(strfind(flat, '..'))
    flat = strrep(flat, '..', '.');
end
flat = regexprep(flat, '[^A-Za-z0-9_]', '_');
base = flat;
end

function [map, sources] = load_source_map(mapPath)
map = containers.Map();
sources = {};
fid = fopen(mapPath, 'rb');
if fid < 0
    return;
end
line = fgetl(fid);
while ischar(line)
    line = strtrim(line);
    if ~isempty(line)
        comma = find(line == ',', 1, 'first');
        if ~isempty(comma)
            src = strtrim(line(1:comma-1));
            flat = strtrim(line(comma+1:end));
            [~, base] = fileparts(flat);
            if ~isKey(map, base)
                map(base) = src;
                sources{end+1} = src; %#ok<AGROW>
            end
        end
    end
    line = fgetl(fid);
end
fclose(fid);
end

function path = default_job_storage()
here = fileparts(mfilename('fullpath'));
root = fileparts(here);
path = fullfile(root, '_matlab_job_storage');
end

function write_report(report, reportFile)
[reportDir, ~, ~] = fileparts(reportFile);
if ~isempty(reportDir) && exist(reportDir, 'dir') ~= 7
    mkdir(reportDir);
end
fid = fopen(reportFile, 'w');
if fid < 0
    error('Cannot open report file: %s', reportFile);
end
cleanupObj = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, 'Total: %d\n', report.Total);
fprintf(fid, 'Ok: %d\n', report.Ok);
fprintf(fid, 'Fail: %d\n', report.Fail);
fprintf(fid, 'ElapsedSeconds: %.3f\n', report.ElapsedSeconds);
if report.Fail > 0
    fprintf(fid, '\nFailedFiles:\n');
    idx = find(~report.Results);
    for i = 1:numel(idx)
        fprintf(fid, '%s\n', report.Files{idx(i)});
    end
end
end

function root = common_root(paths)
root = '';
if isempty(paths)
    return;
end
common = regexp(paths{1}, '[\\/]+', 'split');
for i = 2:numel(paths)
    parts = regexp(paths{i}, '[\\/]+', 'split');
    maxLen = min(numel(common), numel(parts));
    j = 1;
    while j <= maxLen && strcmpi(common{j}, parts{j})
        j = j + 1;
    end
    if j == 1
        common = {};
        break;
    end
    common = common(1:j-1);
end
if ~isempty(common)
    root = strjoin(common, filesep);
end
root = normalize_root(root);
end

function normRoot = normalize_root(pathStr)
normRoot = strrep(pathStr, '/', filesep);
normRoot = strrep(normRoot, '\', filesep);
if isempty(normRoot)
    return;
end
if normRoot(end) == ':'
    normRoot = [normRoot filesep];
elseif normRoot(end) ~= filesep
    normRoot = [normRoot filesep];
end
end

function rel = rel_path(fullPath, rootDir)
rootDir = normalize_root(rootDir);
if ~isempty(rootDir) && path_starts_with(fullPath, rootDir)
    rel = fullPath(numel(rootDir)+1:end);
else
    [~, name, ext] = fileparts(fullPath);
    rel = [name ext];
end
rel = strrep(rel, '/', filesep);
rel = strrep(rel, '\', filesep);
end

function tf = path_starts_with(pathStr, prefix)
if isempty(prefix)
    tf = false;
    return;
end
if numel(pathStr) < numel(prefix)
    tf = false;
    return;
end
tf = strncmpi(pathStr, prefix, numel(prefix));
end
