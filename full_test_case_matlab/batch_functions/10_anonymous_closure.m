% 10_anonymous_closure - anonymous closure with captured variable
a = 5;
f = @(x) x + a;
b = f(3);
a = 7;
c = f(3);
