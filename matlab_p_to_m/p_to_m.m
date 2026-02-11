function [ok, info] = p_to_m(p_path, m_path, varargin)
%P_TO_M Convert MATLAB .p to .m using MATLAB-only logic.

ok = false;
info = struct('Message', '', 'BytesOut', 0, 'NameCount', 0, 'ParseOk', false, 'ErrorOffset', 0);

if nargin < 2
    info.Message = 'p_path and m_path are required';
    return;
end

opts.Verbose = false;
opts.Format = true;
opts.IndentWidth = 4;
if mod(numel(varargin), 2) ~= 0
    error('Options must be name/value pairs');
end
for k = 1:2:numel(varargin)
    key = lower(varargin{k});
    switch key
        case 'verbose'
            opts.Verbose = logical(varargin{k+1});
        case 'format'
            opts.Format = logical(varargin{k+1});
        case 'indentwidth'
            opts.IndentWidth = double(varargin{k+1});
        otherwise
            error('Unknown option: %s', varargin{k});
    end
end

[pfile, ok, msg] = p_to_m_read_pfile(p_path);
if ~ok
    info.Message = msg;
    return;
end

[mfile, ok, msg] = p_to_m_uncompress(pfile);
if ~ok
    info.Message = msg;
    return;
end

[m_text, parse_info] = p_to_m_parse_mfile(mfile);
if ~isempty(m_text)
    m_text = p_to_m_unwrap_script(m_text, m_path);
    if opts.Format
        m_text = p_to_m_format(m_text, opts.IndentWidth);
    end
end
info.NameCount = parse_info.NameCount;
info.ParseOk = parse_info.ParseOk;
info.ErrorOffset = parse_info.ErrorOffset;

out_dir = fileparts(m_path);
if ~isempty(out_dir) && exist(out_dir, 'dir') ~= 7
    mkdir(out_dir);
end

fid = fopen(m_path, 'wb');
if fid < 0
    info.Message = sprintf('Failed to open output: %s', m_path);
    return;
end
fwrite(fid, m_text, 'char');
fclose(fid);

info.BytesOut = numel(m_text);
ok = info.ParseOk;
if ~info.ParseOk && isempty(info.Message)
    info.Message = sprintf('Parse stopped at offset %d', info.ErrorOffset);
end

if opts.Verbose
    fprintf('Wrote %s (%d bytes)\n', m_path, info.BytesOut);
end
end
