% MATLAB parallel: parfor loop (requires Parallel Computing Toolbox)
acc = 0;
parfor i = 1:3
    acc = acc + i;
end
