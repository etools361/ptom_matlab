function out =p018_call_stmt_warning_strcat()
    compName ='C' ;
    instName ='I' ;
    warning('' ,0 ,strcat(' ' ,compName ,' - ' ,instName ),sprintf('The following component is selected but cannot be changed:\n' ));
    out =[];
    return ;
end