function out =p026_elseif_chain_long_cond_no_brace(a ,b )
    out ='' ;
    if a &&a ~='' &&b &&b ~=''
        out =b ;
    elseif ~a ||a =='' &&b &&b ~=''
        out =b ;
    elseif a &&a ~=''
        out =a ;
    end
    out =out ;
    return ;
end