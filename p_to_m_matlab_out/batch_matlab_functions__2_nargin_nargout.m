function f_2_nargin_nargout()

    out =demo_nargout(3 );

end
function [a ,b ]=demo_nargout(x )
    if nargout >1
        a =x ;
        b =x + 1 ;
    else
        a =x ;
        b =[];
    end
end