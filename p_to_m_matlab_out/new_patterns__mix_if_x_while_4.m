function out =mix_if_x_while_4()
    out =0 ;
    if 1
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
        out =out + 1 ;
    else
        out =out + 2 ;
    end
    out =out ;
    return ;
end