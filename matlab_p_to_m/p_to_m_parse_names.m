function [names, offset] = p_to_m_parse_names(data, name_count)

names = cell(1, name_count);
offset = 1;
for i = 1:name_count
    zero_idx = find(data(offset:end) == 0, 1, 'first');
    if isempty(zero_idx)
        names = names(1:i-1);
        return;
    end
    bytes = data(offset:offset + zero_idx - 2);
    names{i} = char(bytes(:).');
    offset = offset + zero_idx;
end
end
