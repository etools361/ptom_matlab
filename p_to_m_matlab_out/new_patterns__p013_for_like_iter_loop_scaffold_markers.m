function out =p013_iter_is_valid(x )
    out =x ~=[];
    return ;
end

function out =p013_iter_next(x )
    out =x ;
    return ;
end

function out =p013_for_like_iter_loop_scaffold_markers(list )
    it =list ;
    acc =0 ;
    while p013_iter_is_valid(it )
        if acc >3
            break ;
        end
        if acc ==2
            acc =acc + 1 ;
            it =p013_iter_next(it );
            continue ;
        end
        acc =acc + 1 ;
        it =p013_iter_next(it );
    end
    out =acc ;
    return ;
end