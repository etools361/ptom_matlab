% 12_anonymous_multiout - anonymous function with multiple outputs
f = @(x,y) deal(x + y, x - y);
[s, d] = f(3, 1);
