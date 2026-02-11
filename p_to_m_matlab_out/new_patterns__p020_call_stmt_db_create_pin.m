function out =p020_call_stmt_db_create_pin()
    context =[];
    pinX =1 ;
    pinY =2 ;
    pinAng =90 ;
    db_create_pin(context ,pinX ,pinY ,pinAng ,1 ,1 ,[],[]);
    out =[];
    return ;
end