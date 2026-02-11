classdef class20_methods_protected
    methods (Access=protected)
        function out = protectedCall(obj, x)
            out = x * 2;
        end
    end
    methods
        function out = callProtected(obj, x)
            out = obj.protectedCall(x);
        end
    end
end
