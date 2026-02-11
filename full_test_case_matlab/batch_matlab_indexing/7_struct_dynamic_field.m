% MATLAB indexing: dynamic struct fields and struct arrays
s = struct('a', 1, 'b', 2);
f = 'b';
v = s.(f);
s.(f) = 3;
s(2).a = 9;
