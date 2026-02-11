% 13_anonymous_builtin_handle - handle to builtin used by anonymous function
h = @sin;
g = @(x) h(x) + 1;
y = g(pi / 2);
