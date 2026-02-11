function out =p022_if_body_two_assigns(flag )
    a =1 ;
    b =2 ;
    if flag ==1
        a =-a ;
        b =-b ;
    end
    out ={a ,b };
    return ;
end