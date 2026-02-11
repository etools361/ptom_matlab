function out =genq_loops_break_continue(n )
    i =[];
    acc =[];
    i =0 ;
    acc =0 ;
    while i <n
        i =i + 1 ;
        if i ==2
            continue ;
        end
        if i ==5
            break ;
        end
        acc =acc + i ;
    end
    i =0 ;
    while i <3
        acc =acc + i ;
        i =i + 1 ;
    end
    while true
        acc =acc + 1 ;
        if ~(acc <0 )
            break ;
        end
    end
    out =acc ;
    return ;
end