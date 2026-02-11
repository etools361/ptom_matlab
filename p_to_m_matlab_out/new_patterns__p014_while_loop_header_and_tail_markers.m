function out =p014_while_loop_header_and_tail_markers()
    sum =0 ;
    i =0 ;

    if 2 >1
        while i <3
            if i >1
                break ;
            end
            if i ==0
                i =i + 1 ;
                continue ;
            end
            sum =sum + i ;
            i =i + 1 ;
        end
    end
    out =sum ;
    return ;
end