% 14_switch_string.ael - switch on strings
s = 'b';
out = 0;
switch s
    case 'a'
        out = 1;
    case 'b'
        out = 2;
    otherwise
        out = -1;
end
