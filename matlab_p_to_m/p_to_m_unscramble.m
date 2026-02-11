function out = p_to_m_unscramble(data, scramble)

out = data;
n = floor(numel(out) / 4);
if n == 0
    return;
end

u32 = typecast(out(1:4*n), 'uint32');
scramble_number = bitand(bitshift(uint32(scramble), -12), uint32(255));
tbl = p_to_m_scramble_table();
idx = mod((0:n-1) + double(scramble_number), 256) + 1;
scramble_vals = uint32(tbl(idx));
if iscolumn(scramble_vals)
    scramble_vals = scramble_vals.';
end
u32 = bitxor(u32, scramble_vals);
out(1:4*n) = typecast(u32, 'uint8');
end
