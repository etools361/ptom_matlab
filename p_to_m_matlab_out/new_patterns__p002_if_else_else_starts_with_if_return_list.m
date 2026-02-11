function out =p002_if_else_else_starts_with_if_return_list(w1 ,w2 ,w3 ,w4 )
    pin2_y =[];
    pin4_y =[];
    context =0 ;
    pin_layer =0 ;
    encVal =0.1 ;
    met_shape1H =0 ;
    met_shape2H =0 ;
    met_shapeXH =0 ;
    if w1 >0
        pin2_y =0.5 *w1 ;
        pin4_y =-0.5 *w1 ;
    else
        if w2 >w4

            met_shape1H =db_add_rectangle(context ,pin_layer ,w1 ,w2 ,w3 ,w4 );
            met_shape2H =db_add_rectangle(context ,pin_layer ,w1 ,w2 ,w3 ,w4 );
            if w1 + encVal >w2 - encVal
                met_shapeXH =db_add_rectangle(context ,pin_layer ,w1 ,w2 ,w3 ,w4 );
            end
        end
    end
    out ={met_shape1H ,met_shape2H ,met_shapeXH };
    return ;
end