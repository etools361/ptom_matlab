function f_7_return_in_loop()

    r =-1 ;
    r =find_first_gt3();

end
function out =find_first_gt3()
    i =0 ;
    while i <10
        if i >3
            out =i ;
            return ;
        end
        i =i + 1 ;
    end
    out =-1 ;
    return ;
end