classdef class1_basic
    properties
        Value
    end
    methods
        function obj = class1_basic(v)
            if nargin > 0
                obj.Value = v;
            else
                obj.Value = 0;
            end
        end
        function y = add(obj, x)
            y = obj.Value + x;
        end
    end
end
