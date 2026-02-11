% MATLAB control flow: for loop over cell array
C = {10, 20, 30};
acc = 0;
for v = C
    acc = acc + v{1};
end
