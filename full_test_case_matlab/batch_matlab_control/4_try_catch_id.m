% MATLAB control flow: try/catch with identifier
out = 0;
try
    error('demo:err', 'boom');
catch ME
    out = numel(ME.identifier);
end
