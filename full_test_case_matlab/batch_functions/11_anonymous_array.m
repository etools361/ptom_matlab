% 11_anonymous_array - anonymous functions in a cell array
ops = {@(x) x + 1, @(x) x * 2, @(x,y) x - y};
r1 = ops{1}(5);
r2 = ops{2}(5);
r3 = ops{3}(9, 4);
