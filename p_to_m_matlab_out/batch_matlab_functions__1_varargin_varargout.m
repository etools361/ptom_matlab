function f_1_varargin_varargout()

    out =demo_varargs(1 ,2 ,3 );
    [a ,b ]=demo_varargs(1 );

end
function varargout =demo_varargs(varargin )
    n =nargin ;
    s =0 ;
    for k =1 :n
        s =s + varargin{k };
    end
    if n ==0
        varargout{1 }=0 ;
    else
        varargout{1 }=s ;
        if n >1
            varargout{2 }=s *2 ;
        end
    end
end