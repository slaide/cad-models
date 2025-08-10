
module front(){            
    module screw_hole(
        hole_center_z,
        k=2,
    ){
        translate([0,-front_thickness/2,hole_center_z])
        rotate([90,0,0]){
            cylinder(
                h=k,
                d1=front_hole_diameter,
                d2=front_hole_diameter+k*2,
                anchor=TOP
            );
        }
        translate([0,-front_thickness/2+k,hole_center_z])
        rotate([90,0,0]){
            cylinder(
                h=front_thickness-k,
                d=front_hole_diameter,
                anchor=TOP
            );
        }
    }
            
    difference(){
        cuboid(
            [front_width,front_thickness,front_height],
            rounding=front_width/2,
            edges=[TOP+LEFT,TOP+RIGHT,BOTTOM+RIGHT,BOTTOM+LEFT],
        );
        
        union(){
            // bolt hole
            translate([0,0,front_height/2-front_bolt_top+module_pitch+0.1])
                cuboid([bolt_hole_width,bolt_length,bolt_hole_height+module_pitch+0.2],anchor=TOP);
            
            // top screw hole
            top_hole_z=front_hole_distance/2;
            screw_hole(top_hole_z);
                
            // bottom screw hole
            bottom_hole_z=-front_hole_distance/2;
            screw_hole(bottom_hole_z);
        }

        // cut outline of body into front for assembly
        translate([0,-1+front_thickness/2,0])
        // small scale increase for better fit
        scale([(body_width+0.5)/body_width,1,(body_height+0.5)/body_height])
        hull()
            body(1);
    }
}