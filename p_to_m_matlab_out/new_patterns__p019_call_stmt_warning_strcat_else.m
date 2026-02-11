function out =p019_call_stmt_warning_strcat_else(flag )
    instN ='N' ;
    instID ='ID' ;
    if flag
        out =[];
        return ;
    else
        warning('' ,0 ,strcat(' ' ,instN ,' - ' ,instID ),sprintf('The following component is selected but cannot be changed:\n' ));
    end
    out =[];
    return ;
end