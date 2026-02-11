% 10_if_elseif_chain.ael - if / else if / else 链
% 目的：模拟 convert.ael / Interconnect_family_functions.ael 中的多分支返回结构，但这里只做赋值
x = 1;
r = 0;
if x == 0
    r = 10;
elseif x == 1
    r = 20;
else
    r = -1;
end
