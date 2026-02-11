% Generalization test 06: strings with escapes (lexer preserves backslashes)

function out = genq_strings_escapes()
    s1 = [];
    s2 = [];
    s1 = sprintf('line1\\nline2\\t\\"quote\\"\\\\slash');
    s2 = 'percent=%d and %s placeholders';
    out = s1;
    return;
end
