% MATLAB indexing: logical indexing
A = [1 2 3 4];
mask = A > 2;
B = A(mask);
A(mask) = 0;
