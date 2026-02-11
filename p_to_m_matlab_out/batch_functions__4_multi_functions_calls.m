function f_4_multi_functions_calls()

    x =0 ;
    f();
    g();

end
function g()
    x =x + 2 ;
end

function f()
    x =x + 1 ;
    g();
end