function f_3_persistent()

    out1 =counter();
    out2 =counter();

end
function v =counter()
    persistent n
    if isempty(n )
        n =0 ;
    end
    n =n + 1 ;
    v =n ;
end