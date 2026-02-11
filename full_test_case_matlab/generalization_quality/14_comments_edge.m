% Generalization test 14: comments and tricky sequences

function out = genq_comments_edge()
    a = [];
    a = 1;
    % end-of-line comment
    %  block comment with operators: + - * / == != <= >= && ||
    a = a + 1;
    %  multiline
    %        block comment
    %
    out = a;
    return;
end
