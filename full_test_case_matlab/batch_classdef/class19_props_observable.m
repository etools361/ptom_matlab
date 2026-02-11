classdef class19_props_observable < handle
    properties (SetObservable, AbortSet)
        Value
    end
    methods
        function obj = class19_props_observable(v)
            if nargin > 0
                obj.Value = v;
            else
                obj.Value = 0;
            end
        end
    end
end
