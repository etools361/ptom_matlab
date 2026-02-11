function out =genq_nested_ternary()
    a =[];
    b =[];
    c =[];
    d =[];
    e =[];
    a =1 ;
    b =2 ;
    c =3 ;
    d =4 ;
    e =ael_ternary(a <b ,ael_ternary(b <c ,b ,c ),d );
    out =e ;
    return ;
end