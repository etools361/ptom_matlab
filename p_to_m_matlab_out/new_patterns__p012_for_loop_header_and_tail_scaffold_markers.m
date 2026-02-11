function out =p012_dummy(x )
    out =x ;
    return ;
end

function out =p012_for_loop_header_and_tail_scaffold_markers(nf )
    i =0 ;
    acc =0 ;
    i =0 ;
    while i <nf /2.0
        acc =acc + p012_dummy(i );
        i =i + 1 ;
    end
    out =acc ;
    return ;
end