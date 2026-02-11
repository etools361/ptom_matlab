% p028_addr_of_assign.ael
% Minimal address-of assignment: b = &a
a = 1;
b = [];
b = ael_addr_of(a);
