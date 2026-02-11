classdef class8_props_dep
    properties (Dependent)
        Value
    end
    properties (Access=private)
        Value_
    end
    methods
        function obj = class8_props_dep(v)
            if nargin > 0
                obj.Value_ = v;
            else
                obj.Value_ = 0;
            end
        end
        function v = get.Value(obj)
            v = obj.Value_;
        end
        function set.Value(obj, v)
            obj.Value_ = v;
        end
    end
end
