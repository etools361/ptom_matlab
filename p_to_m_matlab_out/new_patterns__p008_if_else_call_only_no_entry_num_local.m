function out =p008_if_else_call_only_no_entry_num_local(x )
    y =[];
    if x ==1
        foo(y ,x );
    end
    foo(y ,x );
    out =y ;
    return ;
end