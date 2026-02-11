function out =p009_drop_local_updates_local_ref(parmName ,itemInfoP )
    checkVal =[];
    parmList =[];
    if parmName =='w'
        var_present =pcb_get_parm_type(itemInfoP ,'w' );
        if var_present ~=[]
            w =pcb_get_mks(itemInfoP ,'w' );
            checkVal =w ;
        end
    end
    if parmName =='l'
        var_present =pcb_get_parm_type(itemInfoP ,'l' );
        if var_present ~=[]
            l =pcb_get_mks(itemInfoP ,'l' );
            checkVal =l ;
        end
    end
    out =parmList ;
    return ;
end