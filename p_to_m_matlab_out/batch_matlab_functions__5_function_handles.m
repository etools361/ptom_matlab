function f_5_function_handles()

    h1 =@sin ;
    h2 =@local_square ;
    f =@(x ,y )x + y ;
    a =h1(pi /2 );
    b =h2(3 );
    c =f(1 ,2 );

end
function y =local_square(x )
    y =x.^2 ;
end