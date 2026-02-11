classdef class4_props_methods
    properties (SetAccess =private )
        Value
    end
    methods
        function obj =class4_props_methods(v )
            if nargin >0
                obj.Value =v ;
            else
                obj.Value =0 ;
            end
        end
        function y =add(obj ,x )
            y =obj.Value + x ;
        end
    end
end