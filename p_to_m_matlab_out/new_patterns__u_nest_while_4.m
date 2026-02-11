function out =u_nest_while_4()
    sum =0 ;
    w0 =0 ;
    w1 =0 ;
    w2 =0 ;
    w3 =0 ;
    w0 =0 ;
    while w0 <2
        w1 =0 ;
        while w1 <2
            w2 =0 ;
            while w2 <2
                w3 =0 ;
                while w3 <2
                    sum =sum + 1 ;
                    w3 =w3 + 1 ;
                end
                w2 =w2 + 1 ;
            end
            w1 =w1 + 1 ;
        end
        w0 =w0 + 1 ;
    end
    out =sum ;
    return ;
end