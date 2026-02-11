function f_04_nested_blocks_locals()

    g =0 ;
    nested_locals(3 ,4 );

end
function out =nested_locals(a ,b )
    x =a + b ;
    ;
    out =g ;
    return ;
end