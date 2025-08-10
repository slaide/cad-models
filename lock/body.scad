
    
gears_yoffset =     body_depth
                    -handle_hole_offset_back
                    -handle_hole_diameter/2;
                    
gears_1_offset=[
                    0,
                    
                    gears_yoffset,
                    
                    body_height/2
                    -handle_hole_offset_top
                    +handle_hole_diameter/2
               ];
            
gears_2_offset=[
                    0,
                    
                    gears_yoffset,
                    
                    gears_1_offset[2]
                    -gear1_outer_diameter
                    +gear_tooth_length
                    
                    -gear_slop
               ];
            
gears_3_offset=[
                    0,
                    
                    gears_yoffset,
                    // z offset is based on position of previous gear, then offset
                    // at final placement (further down)
                    gears_2_offset[2]                 
                ];

function smallgearoffset(angle=220) =
    let(
        radius=gear1_outer_diameter/2+gear2_outer_diameter/2-gear_tooth_length+gear_slop*2,
        
        yoffset=sin(angle)*radius,
        zoffset=cos(angle)*radius
    )
        gears_3_offset + [ 0, yoffset, zoffset ];
        
                    
module body(
    shell_thickness=body_shell_thickness
){   
    module body_shell(shelloffset){
        translate([
            0,
            (body_depth)/2-shelloffset/2,
            0
        ])
            cuboid(
                [
                    body_width-shelloffset*2,
                    body_depth-shelloffset*1,
                    body_height-shelloffset*2,
                ],
                rounding=18-shelloffset,
                edges=[TOP+BACK,BOTTOM+BACK]
            );
    }

    module gear1supports(gearoffset){
        module supportsleft(){
            translate([ -body_width/2, gearoffset[1], gearoffset[2] ])
                xcyl(
                    l = body_shell_thickness+inner_gear_clearance-get_slop(),
                    d = gear1_outer_diameter,
                    anchor = LEFT
                );
        }
        // gear 1 additional bracing (left)
        supportsleft();
        // gear 1 additional bracing (right)
        mirror([1,0,0])
        supportsleft();
    }
    module gear2supports(gearoffset){
        module supportsleft(){
            translate([ -body_width/2, gearoffset[1], gearoffset[2] ])
                xcyl(
                    l = body_shell_thickness+inner_gear_clearance-get_slop(),
                    d = gear2_outer_diameter,
                    anchor = LEFT
                );
       }
       
       // gear 2 additional bracing (left)
       supportsleft();
       // gear 2 additional bracing (right)   
       mirror([1,0,0])
       supportsleft();
    }
    
    rail_floor_top=front_height/2-front_bolt_top-bolt_hole_height;
    
    rail_top_stopper_bottom=front_height/2-front_bolt_top-bolt_hole_height+bolt_and_gear_height;
    
    //rail_space_height=rail_top_stopper_bottom-rail_top_stopper_bottom;
    rail_space_height=bolt_and_gear_height;
    
    difference(){
        union(){
            difference(){
                // outer hull
                body_shell(0);
                
                // inner space
                body_shell(shell_thickness);
            }
        
            // rail bottom
            translate([
                0,
                0,
                rail_floor_top,
            ])
                cuboid([body_width,body_depth,2],anchor=FRONT+TOP);
                
            // some braces for stability
            for(support_y=body_support_brace_y){
                translate([0,support_y,0])
                    cuboid([body_width,body_support_depth,body_height],anchor=FRONT);
            }
                
            // gear additional bracing
            gear1supports(gears_1_offset);
            gear1supports(gears_2_offset);            
            gear2supports(smallgearoffset());
        }
        
        // handle hole + gear
        translate(gears_1_offset)
            gear1(cutout=false);
            
        // gear connecting handle to rail 1/2
        translate(gears_2_offset)
        rotate([360/gear1_teeth*0.5,0,0])
            gear1(cutout=false);
                
        // rail space cutout
        translate([
            0,
            -body_shell_thickness,
            front_height/2-front_bolt_top-bolt_hole_height
        ])
            cuboid(
                [
                    body_width-body_shell_thickness*2,
                    body_depth,
                    rail_space_height
                ],
                anchor=FRONT+BOTTOM
            );
            
        // gear connecting handle to rail 2/2
        if(true)
            color("pink")
                translate(smallgearoffset())
                rotate([-360/gear2_teeth*0.5,0,0])
                    gear2();
    }
    
    module railtopstopper(){
        let(
            rail_top_stopper_thickness=2,
            rail_top_stopper_width=body_shell_thickness+inner_gear_clearance-get_slop(),
        ){
            translate([
                -body_width/2,
                0,
                rail_top_stopper_bottom,
            ])
                cuboid(
                    [
                        rail_top_stopper_width,
                        body_depth,
                        rail_top_stopper_thickness
                    ],
                    anchor=FRONT+LEFT+TOP
                );
        }
    }
    
    // rail top stopper (left)
    railtopstopper();
    // rail top stopper (right)
    mirror([1,0,0])
    railtopstopper();    
}