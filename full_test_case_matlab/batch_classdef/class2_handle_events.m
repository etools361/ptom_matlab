classdef class2_handle_events < handle
    properties
        Value
    end
    events
        Changed
    end
    methods
        function obj = class2_handle_events(v)
            if nargin > 0
                obj.Value = v;
            else
                obj.Value = 0;
            end
        end
        function set.Value(obj, v)
            obj.Value = v;
            notify(obj, 'Changed');
        end
        function y = add(obj, x)
            y = obj.Value + x;
        end
    end
    methods (Static)
        function obj = make(v)
            obj = class2_handle_events(v);
        end
    end
end
