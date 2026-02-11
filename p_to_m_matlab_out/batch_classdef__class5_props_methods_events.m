classdef class5_props_methods_events <handle
    properties (SetAccess =private ,GetAccess =public )
        Value
    end
    properties (Constant ,Hidden )
        Magic =42 ;
    end
    events
        Updated
        Reset
    end
    methods
        function obj =class5_props_methods_events(v )
            if nargin >0
                obj.Value =v ;
            else
                obj.Value =0 ;
            end
        end
        function set.Value(obj ,v )
            obj.Value =v ;
            notify(obj ,'Updated' );
        end
        function y =add(obj ,x )
            y =obj.Value + x ;
        end
        function reset(obj )
            obj.Value =0 ;
            notify(obj ,'Reset' );
        end
    end
    methods (Static ,Access =private )
        function y =helper(x )
            y =x + 1 ;
        end
    end
end