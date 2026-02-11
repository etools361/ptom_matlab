function f_4_nested_functions()

    out =outer(5 );

end
function y =outer(x )
    y =inner(x ) + 1 ;
    function z =inner(t )
        z =t *2 ;
    end
end