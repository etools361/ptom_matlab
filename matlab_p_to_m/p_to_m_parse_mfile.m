function [m_text, info] = p_to_m_parse_mfile(mfile)

info = struct('NameCount', 0, 'ParseOk', true, 'ErrorOffset', 0);
tokens = p_to_m_token_table();

name_count = sum(double(mfile.Tokens));
info.NameCount = name_count;
[names, offset] = p_to_m_parse_names(mfile.Data, name_count);

if offset > numel(mfile.Data)
    m_text = '';
    return;
end

code_data = mfile.Data(offset:end);
parts = cell(1, 1024);
n = 0;
last_was_operand = false;
last_char = '';

    function append_part(part)
        if isempty(part)
            return;
        end
        if n >= numel(parts)
            parts = [parts cell(1, numel(parts))];
        end
        n = n + 1;
        parts{n} = part;
        last_char = part(end);
    end

    function tf = is_space_char(ch)
        tf = ~isempty(ch) && isspace(ch);
    end

i = 1;
while i <= numel(code_data)
    b = code_data(i);

    if bitand(b, 128)
        if i + 1 > numel(code_data)
            info.ParseOk = false;
            info.ErrorOffset = i;
            break;
        end
        res_id = 128 + 256 * (double(bitand(b, 127)) - 1) + double(code_data(i + 1));
        name = '';
        idx = res_id + 1;
        if idx >= 1 && idx <= numel(names)
            name = names{idx};
        end
        if ~isempty(name)
            need_space = true;
            if i + 2 <= numel(code_data)
                next_b = code_data(i + 2);
                if next_b < 134
                    next_tok = tokens{double(next_b) + 1};
                    if ~isempty(next_tok)
                        if next_tok(1) == '''' || strcmp(next_tok, '.''') || strcmp(next_tok, '.') || ...
                                strcmp(next_tok, '.*') || strcmp(next_tok, './') || strcmp(next_tok, '.\') || strcmp(next_tok, '.^') || ...
                                strcmp(next_tok, '(') || strcmp(next_tok, '{')
                            need_space = false;
                        end
                    end
                end
            end
            append_part(name);
            if need_space
                append_part(' ');
            end
        end
        last_was_operand = true;
        i = i + 2;
        continue;
    end

    if b < 134
        token = tokens{double(b) + 1};
        if ~isempty(token)
            is_plus = strcmp(token, '+');
            is_minus = strcmp(token, '-');
            if is_plus || is_minus
                is_binary = last_was_operand;
                if is_binary && ~is_space_char(last_char)
                    append_part(' ');
                end
                append_part(token);
                if is_binary
                    append_part(' ');
                end
                last_was_operand = false;
            else
                append_part(token);
                if strcmp(token, ')') || strcmp(token, ']') || strcmp(token, '}') || token(1) == '''' || strcmp(token, '.''')
                    last_was_operand = true;
                else
                    last_was_operand = false;
                end
            end
        else
            last_was_operand = false;
        end
        i = i + 1;
        continue;
    end

    info.ParseOk = false;
    info.ErrorOffset = i;
    break;
end

if n == 0
    m_text = '';
else
    m_text = [parts{1:n}];
end
end
