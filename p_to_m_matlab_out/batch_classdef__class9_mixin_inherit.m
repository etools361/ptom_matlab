classdef class9_mixin_inherit <handle &matlab.mixin.Copyable
    properties
        Value
    end
    methods
        function obj =class9_mixin_inherit(v )
            if nargin >0
                obj.Value =v ;
            else
                obj.Value =0 ;
            end
        end
    end
end