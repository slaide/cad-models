module gear1(
    cutout=true,
){
    difference(){
        union(){
            spur_gear(
                circ_pitch  = module_pitch,
                teeth = gear1_teeth,
                thickness = gear_thickness-gear_support_thickness*2,
                pressure_angle = 20,
                orient=RIGHT,
            );

            // rod
            xcyl(l=body_width+0.01,d=handle_hole_diameter);
            
            // support right
            translate([
                gear_thickness/2-gear_support_box_gap,
                0,0
            ])
                xcyl(
                    l=gear_support_thickness-gear_support_box_gap,
                    d=gear1_outer_diameter-module_pitch,
                    anchor=RIGHT
                );

            // support left
            translate([
                -(gear_thickness/2-gear_support_box_gap),
                0,0
            ])
                xcyl(
                    l=gear_support_thickness-gear_support_box_gap,
                    d=gear1_outer_diameter-module_pitch,
                    anchor=LEFT
                );
        }
            
        // handle hole
        if(cutout)
            cuboid([gear_slot_width,gear1_slot_length,gear1_slot_length]);
    }
}

module gear2(){
    spur_gear(
        circ_pitch = module_pitch,
        teeth = gear2_teeth,
        thickness = gear_thickness-gear_support_thickness*2,
        pressure_angle = 20,
        orient=RIGHT,
    );
    
    // rod
    let(
        //rod_diameter=4.6,
        rod_diameter = handle_hole_diameter / (gear1_outer_diameter-module_pitch) * (gear2_outer_diameter-module_pitch) * 0.8,
    ){
        xcyl(
            l=body_width+0.01,
            d=rod_diameter,
        );
    }
    
    // support right
    translate([
        gear_thickness/2-gear_support_box_gap,
        0,0
    ])
        xcyl(
            l=gear_support_thickness-gear_support_box_gap,
            d=gear2_outer_diameter-module_pitch,
            anchor=RIGHT
        );
        
    // support left
    translate([
        -gear_thickness/2+gear_support_box_gap,
        0,0
    ])
        xcyl(
            l=gear_support_thickness-gear_support_box_gap,
            d=gear2_outer_diameter-module_pitch,
            anchor=LEFT
        );
}
