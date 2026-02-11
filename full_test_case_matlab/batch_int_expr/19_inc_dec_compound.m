% 19_inc_dec_compound.ael - 自增自减与复合赋值
% 目的：覆盖 i++, ++i, i+=, i-=, i*=, i/=, i%=
i = 0;
test_inc_dec();

function test_inc_dec()
    i = 0;
    i = i + 1;
    % 后置自增
    i = i + 1;
    % 前置自增
    i = i - 1;
    % 后置自减
    i = i - 1;
    % 前置自减
    i = i + 2;
    i = i - 1;
    i = i * 3;
    i = i / 2;
    i = mod(i, 2);
end
