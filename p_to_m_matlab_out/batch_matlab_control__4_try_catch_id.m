out =0 ;
try
    error('demo:err' ,'boom' );
catch ME
    out =numel(ME.identifier );
end