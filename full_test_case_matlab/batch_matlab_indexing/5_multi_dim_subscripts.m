% MATLAB indexing: multi-dim subscripts and slices
A = reshape(1:12, [3 4]);
x = A(2,3);
A(1,4) = 99;
B = A(1:2, 2:4);
