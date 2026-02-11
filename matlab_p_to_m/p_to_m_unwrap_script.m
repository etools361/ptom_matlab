function out = p_to_m_unwrap_script(m_text, m_path)
%P_TO_M_UNWRAP_SCRIPT Remove synthetic wrapper function for script files.

out = m_text;
if isempty(m_text) || nargin < 2 || isempty(m_path)
    return;
end

base = lower(strrep(strrep(get_basename_no_ext(m_path), ' ', ''), '-', '_'));
line_break = detect_line_break(m_text);
lines = regexp(m_text, '\r\n|\n|\r', 'split');

first_idx = 0;
for i = 1:numel(lines)
    line_trim = strtrim(lines{i});
    if isempty(line_trim)
        continue;
    end
    if starts_with_comment(line_trim)
        continue;
    end
    first_idx = i;
    break;
end

if first_idx == 0
    return;
end

[is_func, func_name, has_io] = parse_function_decl(lines{first_idx});
if ~is_func || has_io
    return;
end

if strcmpi(func_name, base)
    return;
end

if ~is_wrapper_name(func_name)
    return;
end

end_idx = find_wrapper_end(lines, first_idx);
if end_idx == 0
    return;
end

if ~has_function_after(lines, end_idx)
    return;
end

lines = [lines(1:first_idx-1), lines(first_idx+1:end_idx-1), lines(end_idx+1:end)];
out = strjoin(lines, line_break);
end

function tf = starts_with_comment(line_trim)
tf = ~isempty(line_trim) && line_trim(1) == '%';
end

function base = get_basename_no_ext(path)
[~, base, ~] = fileparts(path);
end

function lb = detect_line_break(text)
if ~isempty(strfind(text, sprintf('\r\n')))
    lb = sprintf('\r\n');
elseif ~isempty(strfind(text, sprintf('\r')))
    lb = sprintf('\r');
else
    lb = sprintf('\n');
end
end

function [is_func, name, has_io] = parse_function_decl(line)
is_func = false;
name = '';
has_io = false;
line_trim = strtrim(line);
if ~starts_with_token(line_trim, 'function')
    return;
end
rest = strtrim(line_trim(numel('function')+1:end));
if isempty(rest)
    return;
end
if ~isempty(strfind(rest, '='))
    has_io = true;
    parts = strsplit(rest, '=', 'CollapseDelimiters', false);
    if numel(parts) < 2
        return;
    end
    rest = strtrim(parts{2});
end
tok = regexp(rest, '^([A-Za-z]\\w*)\\s*(\\(([^)]*)\\))?', 'tokens', 'once');
if isempty(tok)
    return;
end
name = tok{1};
args = '';
if numel(tok) >= 3
    args = strtrim(tok{3});
end
if ~isempty(args)
    has_io = true;
end
is_func = true;
end

function tf = starts_with_token(line_trim, token)
tok_len = numel(token);
if numel(line_trim) < tok_len
    tf = false;
    return;
end
if numel(line_trim) == tok_len
    tf = strcmp(line_trim, token);
    return;
end
tf = strncmp(line_trim, [token ' '], tok_len + 1);
end

function tf = is_wrapper_name(name)
tf = numel(name) >= 2 && strncmpi(name, 'f_', 2);
end

function tf = has_function_after(lines, end_idx)
tf = false;
for i = end_idx + 1:numel(lines)
    line_trim = strtrim(lines{i});
    if isempty(line_trim)
        continue;
    end
    if starts_with_comment(line_trim)
        continue;
    end
    if starts_with_token(line_trim, 'function')
        tf = true;
    end
    return;
end
end

function end_idx = find_wrapper_end(lines, first_idx)
end_idx = 0;
depth = 1;
for i = first_idx+1:numel(lines)
    line = strip_strings_and_comments(lines{i});
    line_trim = strtrim(line);
    if isempty(line_trim)
        continue;
    end
    if is_block_start(line_trim)
        depth = depth + 1;
        continue;
    end
    if is_block_end(line_trim)
        depth = depth - 1;
        if depth == 0
            end_idx = i;
            return;
        end
    end
end
end

function tf = is_block_start(line_trim)
tf = starts_with_token(line_trim, 'function') || ...
     starts_with_token(line_trim, 'if') || ...
     starts_with_token(line_trim, 'for') || ...
     starts_with_token(line_trim, 'while') || ...
     starts_with_token(line_trim, 'switch') || ...
     starts_with_token(line_trim, 'try') || ...
     starts_with_token(line_trim, 'parfor') || ...
     starts_with_token(line_trim, 'spmd') || ...
     starts_with_token(line_trim, 'classdef') || ...
     starts_with_token(line_trim, 'properties') || ...
     starts_with_token(line_trim, 'methods') || ...
     starts_with_token(line_trim, 'events') || ...
     starts_with_token(line_trim, 'enumeration') || ...
     starts_with_token(line_trim, 'arguments');
end

function tf = is_block_end(line_trim)
tf = strcmp(line_trim, 'end') || starts_with_token(line_trim, 'end');
end

function out = strip_strings_and_comments(line)
out = '';
if isempty(line)
    return;
end
buf = char(line);
in_str = false;
res = char(zeros(1, numel(buf)));
ri = 0;
i = 1;
while i <= numel(buf)
    c = buf(i);
    if in_str
        if c == ''''
            if i < numel(buf) && buf(i+1) == ''''
                i = i + 2;
                continue;
            end
            in_str = false;
        end
        i = i + 1;
        continue;
    end
    if c == '%'
        break;
    end
    if c == ''''
        in_str = true;
        i = i + 1;
        continue;
    end
    ri = ri + 1;
    res(ri) = c;
    i = i + 1;
end
out = strtrim(res(1:ri));
end
