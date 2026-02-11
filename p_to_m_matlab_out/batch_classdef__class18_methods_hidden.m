classdef class18_methods_hidden
    methods (Hidden )
        function out =hiddenCall(obj ,x )
            out =x + 1 ;
        end
    end
    methods
        function out =publicCall(obj ,x )
            out =obj.hiddenCall(x );
        end
    end
end