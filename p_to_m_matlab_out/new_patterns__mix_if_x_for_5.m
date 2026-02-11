function out =mix_if_x_for_5()
    out =0 ;
    if 1
        sum =0 ;
        i0 =0 ;
        i1 =0 ;
        i2 =0 ;
        i3 =0 ;
        i4 =0 ;
        i0 =0 ;
        while i0 <2
            i1 =0 ;
            while i1 <2
                i2 =0 ;
                while i2 <2
                    i3 =0 ;
                    while i3 <2
                        i4 =0 ;
                        while i4 <2
                            sum =sum + 1 ;
                            i4 =i4 + 1 ;
                        end
                        i3 =i3 + 1 ;
                    end
                    i2 =i2 + 1 ;
                end
                i1 =i1 + 1 ;
            end
            i0 =i0 + 1 ;
        end
        out =out + 1 ;
    else
        out =out + 2 ;
    end
    out =out ;
    return ;
end