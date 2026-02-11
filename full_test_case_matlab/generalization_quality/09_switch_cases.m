% Generalization test 09: switch/case/default paths

function out = genq_switch_cases(v)
    out = [];
    out = 0;
    switch v
    case 0
        out = 10;
    case 1
        out = 20;
    otherwise
        out = 30;
    end
    out = out;
    return;
end
