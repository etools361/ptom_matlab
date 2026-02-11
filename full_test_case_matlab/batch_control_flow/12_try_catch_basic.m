% 12_try_catch_basic.ael - try/catch block
a = 0;
try
    a = 1;
    b = 2;
catch ME
    a = -1;
    msg = ME.message;
end
