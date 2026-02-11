% Bitwise vs logical ops, shifts, precedence
a = 1;
b = 2;
c = 3;
d = 4;
x = bitand(a, b) && bitor(c, d);
y = bitxor(bitor(a, b), bitand(c, d));
z = bitshift(a, b) + bitshift(c, -(1));
