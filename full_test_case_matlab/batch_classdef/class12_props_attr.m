classdef class12_props_attr < handle
    properties (SetAccess=private, GetAccess=public)
        Value
    end
    properties (Dependent)
        DoubleValue
    end
    methods
        function obj = class12_props_attr(v)
            if nargin > 0
                obj.Value = v;
            else
                obj.Value = 0;
            end
        end
        function v = get.DoubleValue(obj)
            v = obj.Value * 2;
        end
    end
end
