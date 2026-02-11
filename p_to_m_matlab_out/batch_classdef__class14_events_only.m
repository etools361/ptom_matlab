classdef class14_events_only
    events
        Fired
    end
    methods
        function fire(obj )
            notify(obj ,'Fired' );
        end
    end
end