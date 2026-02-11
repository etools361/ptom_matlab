function out =p011_func_with_loop()
    l ={1 ,2 };
    while is_list(l )
        l =cdr(l );
    end
    out =0 ;
    return ;
end

function out =p011_func_without_loop_but_with_if_chain()
    s ='a' ;
    if s =='a'
        s ='a' ;
    elseif s =='b'
        s ='b' ;
    else
        s ='c' ;
    end
    out =s ;
    return ;
end