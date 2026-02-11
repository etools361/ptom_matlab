function out =p005_elseif_header_long_cond_no_entry_num_local(a ,b ,c ,d ,e ,f ,g ,h )
    r =0 ;
    if a ==0
        r =10 ;
    elseif b + c *d - e >f &&g ==h
        r =20 ;
    else
        r =-1 ;
    end
    out =r ;
    return ;
end