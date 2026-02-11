function out =nest_for_3()
    sum =0 ;
    i0 =0 ;
    i1 =0 ;
    i2 =0 ;
    i0 =0 ;
    while i0 <2
        i1 =0 ;
        while i1 <2
            i2 =0 ;
            while i2 <2
                sum =sum + 1 ;
                i2 =i2 + 1 ;
            end
            i1 =i1 + 1 ;
        end
        i0 =i0 + 1 ;
    end
    out =sum ;
    return ;
end