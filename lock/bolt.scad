// includes rail
module bolt(){
    // bolt
    difference(){
        // actual space: 24.2
        cuboid([bolt_width-0.6,bolt_length,bolt_height]);
        
        translate([
            // move to left edge
            (bolt_width-bolt_chamfer_width)/2+bolt_chamfer_width/2,
            // move to front edge
            -bolt_length/2,
            // move to top
            bolt_height*2/2,
        ])
        rotate([0,90,90])
            wedge([bolt_height*2,bolt_chamfer_width,bolt_chamfer_length]);
    }
    
    // rail
    translate([
        0,
        (bolt_length-rail_length)/2,
        bolt_height/2-0.8,
    ])
    rotate([0,0,90])
        rack(
            pitch = module_pitch,
            teeth = floor(rail_length / module_pitch),
            thickness = rail_width,
            // height = 6,
            pressure_angle = 20,
            anchor=BOTTOM
        );
        
    // top stop notch
    top_stop_notch_height=6;
    top_stop_notch_width=2;
    translate([0,bolt_length/2+rail_stop_back_offset,bolt_height/2])
        cuboid(
            [rail_width,top_stop_notch_width,top_stop_notch_height],
            anchor=BOTTOM+BACK
        );
        
    echo(str("bolt can move ",body_support_brace_y[1]-body_support_brace_y[0]-body_support_depth-top_stop_notch_width," mm"));
}
