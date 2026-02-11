classdef class10_props_events_basic <handle
    properties
        A
        B
    end
    events
        Changed
        Reset
    end
    methods
        function obj =class10_props_events_basic()
            obj.A =0 ;
            obj.B =1 ;
        end
        function update(obj ,v )
            obj.A =v ;
            notify(obj ,'Changed' );
        end
    end
end