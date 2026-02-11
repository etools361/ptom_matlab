function out = p_to_m_format(m_text, indent_width)
%P_TO_M_FORMAT Apply a simple indentation pass to reconstructed M code.

out = m_text;
if nargin < 1 || isempty(m_text)
    return;
end
if nargin < 2 || isempty(indent_width)
    indent_width = 4;
end

line_break = detect_line_break(m_text);
lines = regexp(m_text, '\r\n|\n|\r', 'split');
out_lines = cell(size(lines));
out_n = 0;
indent = 0;
prev_blank = true;

for i = 1:numel(lines)
    line_trim = strtrim(lines{i});
    if isempty(line_trim)
        if prev_blank
            continue;
        end
        out_n = out_n + 1;
        out_lines{out_n} = '';
        prev_blank = true;
        continue;
    end

    word = first_word(line_trim);
    dedent = false;
    indent_after = false;

    if ~isempty(word)
        if is_block_end(word)
            dedent = true;
        elseif is_block_mid(word)
            dedent = true;
            indent_after = true;
        elseif is_block_start(word)
            indent_after = true;
        end
    end

    if dedent && indent > 0
        indent = indent - 1;
    end

    out_n = out_n + 1;
    out_lines{out_n} = [repmat(' ', 1, indent * indent_width) line_trim];
    prev_blank = false;

    if indent_after
        indent = indent + 1;
    end
end

if prev_blank && out_n > 0
    out_n = out_n - 1;
end
if out_n <= 0
    out = '';
else
    out = strjoin(out_lines(1:out_n), line_break);
end
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

function word = first_word(line_trim)
word = '';
if isempty(line_trim)
    return;
end
if ~(isletter(line_trim(1)) || line_trim(1) == '_')
    return;
end
tok = regexp(line_trim, '^([A-Za-z]\w*)', 'tokens', 'once');
if isempty(tok)
    return;
end
word = tok{1};
end

function tf = is_block_start(word)
tf = any(strcmp(word, { ...
    'function','if','for','while','switch','try','parfor','spmd', ...
    'classdef','properties','methods','events','enumeration', ...
    'arguments','arguments_block'}));
end

function tf = is_block_mid(word)
tf = any(strcmp(word, {'else','elseif','case','otherwise','catch'}));
end

function tf = is_block_end(word)
tf = any(strcmp(word, {'end','feend'}));
end
