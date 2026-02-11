function f_6_return_if_else()

    r =0 ;
    r =select_sign(1 );

end
function out =select_sign(x )
    if x >0
        out =1 ;
        return ;
    elseif x <0
        out =-1 ;
        return ;
    else
        out =0 ;
        return ;
    end
end