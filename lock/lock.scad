include <BOSL2/std.scad>
include <BOSL2/gears.scad>

include <gears.scad>

$slop=0.1;

/*[front part (screws lock system into door)]*/
front_height=149;
front_width=20;
front_thickness=3;

/*[front screw holes]*/
front_hole_distance=130;
front_hole_diameter=5;

/*[body (containing gears and rail)]*/
body_height=102;
body_width=13.6;
body_depth=73;
body_shell_thickness=1.0;

/*[bolt part of the rail]*/
bolt_height=23.7;
bolt_length=body_depth-8;
bolt_width=11.5;

assert(bolt_width<(body_width-2*body_shell_thickness),"bolt may not be wider than body inner space");

// square hole (for door handle)
gear1_slot_length=8+.1;

/*[bolt chamfer]*/
bolt_chamfer_width=11;
bolt_chamfer_length=12.5;

//offset of bolt hole from top of front
front_bolt_top=78-(151-front_height)/2;

// space between wall and gear (i.e. space for structural components)
inner_gear_clearance=2;
rail_width=bolt_width-2*inner_gear_clearance;
gear_thickness=rail_width;

if(false){}

$fn = $preview ? 32 : 256;

gear_slop=0.15;

gear_factor=0.85;
// Primary gear with square hole
gear1_teeth = round(40*gear_factor);
// Secondary gear (pinion)
gear2_teeth = round(18*gear_factor);
// Gear module (tooth size)
module_pitch = 2;

bolt_and_gear_height=bolt_height+module_pitch*1.5;

gear_tooth_length=module_pitch/2;

// hole needs to be a bit bigger than bolt itself
bolt_hole_height=bolt_height+1;
bolt_hole_width=bolt_width+1;

// Calculate gear parameters
gear1_pitch_radius = gear1_teeth * module_pitch / (2*PI);
gear2_pitch_radius = gear2_teeth * module_pitch / (2*PI);
center_distance = gear1_pitch_radius + gear2_pitch_radius;

// Calculate rack pitch for 1.5" movement per 90° rotation
// 90° rotation = 1/4 of gear2 circumference
gear1_circumference=2 * PI * gear1_pitch_radius;
gear2_circumference = 2 * PI * gear2_pitch_radius;
linear_distance_per_revolution = gear2_circumference;
linear_distance_per_90deg = linear_distance_per_revolution / 4;

gear1_outer_diameter=gear1_circumference/PI+gear_tooth_length;
gear2_outer_diameter=gear2_circumference/PI+gear_tooth_length;

echo(str("gear 1 diameter ",gear1_outer_diameter,"mm, circumference ",gear1_circumference,"mm"));
echo(str("gear 2 diameter ",gear2_outer_diameter,"mm, circumference ",gear2_circumference,"mm"));

// For 1.5" (38.1mm) per 90°, we need the right gear size
// Current calculation gives us the actual movement
echo(str("90° rotation produces: ", linear_distance_per_90deg, "mm linear movement"));
echo(str("To get 38.1mm (1.5\"), gear2 needs radius: ", 38.1 * 4 / (2 * PI), "mm"));

gear_slot_width=body_width+1;

// extra flat space between wall and gear    
gear_support_thickness=1;
gear_support_box_gap=0.25;//.25;//.25;


// Information
echo("=== RACK AND PINION SYSTEM ===");
echo(str("Primary gear teeth: ", gear1_teeth));
echo(str("Secondary gear (pinion) teeth: ", gear2_teeth));
echo(str("Gear ratio: ", gear1_teeth/gear2_teeth, ":1"));
echo(str("Pinion pitch radius: ", gear2_pitch_radius, "mm"));
echo(str("Linear movement per 90° rotation: ", linear_distance_per_90deg, "mm"));
echo(str("Center distance between gears: ", center_distance, "mm"));


// handle hole
// top of hole 6mm from top
// 16mm hole diameter
// 9mm square side length
// 21mm from back

// top outer body to bottom of hole
handle_hole_offset_top=22;
// back out body to same closest edge of hole
handle_hole_offset_back=22;

handle_hole_diameter=16;


body_support_brace_y=[
    0,
    25,
];
body_support_depth=2;
   
include <body.scad>

include <front.scad>

rail_stop_back_offset=-41.5;
rail_length=abs(rail_stop_back_offset);

include <bolt.scad>

support_tube_ir=6/2;
support_tube_or=support_tube_ir+2;
module body_left(){
    difference(){
        translate([0,-1+front_thickness/2,0])
            body();
        
        cuboid([2000,2000,2000],anchor=LEFT);
    }

    // support tubes
    translate([-body_width/2,15,20])
        xcyl(l=body_width-body_shell_thickness,r=support_tube_ir,anchor=LEFT);

    translate([-body_width/2,15,-40])
    rotate([0,90,0])
        tube(
            l=body_width-body_shell_thickness,
            ir=support_tube_ir+get_slop(),
            or=support_tube_or,
            anchor=BOTTOM
        );
        
    translate([-body_width/2,65,20])
    rotate([0,90,0])
        tube(
            l=body_width-body_shell_thickness,
            ir=support_tube_ir+get_slop(),
            or=support_tube_or,
            anchor=BOTTOM
        );
}
module body_right(){
    difference(){
        translate([0,-1+front_thickness/2,0])
            body();
        
        cuboid([2000,2000,2000],anchor=RIGHT);
    }

    // support tubes
    translate([body_width/2,15,20])
    rotate([0,90,0])
        tube(
            l=body_width-body_shell_thickness,
            ir=support_tube_ir+get_slop(),
            or=support_tube_or,
            anchor=TOP
        );

    translate([body_width/2,15,-40])
        xcyl(l=body_width-body_shell_thickness,r=support_tube_ir,anchor=RIGHT);
        
    translate([body_width/2,65,20])
        xcyl(l=body_width-body_shell_thickness,r=support_tube_ir,anchor=RIGHT);
}

module assembly(
    cross_section=false,
){
    difference(){
        union(){
            color("gray")
                front();

            translate([0,-1+front_thickness/2,0])
            color("brown")
                body_left();

            translate([0,-1+front_thickness/2,0])
            color("brown")
                body_right();

            color("gray")
            translate([
                0,
                body_depth-15.4,
                front_height/2-front_bolt_top-bolt_hole_height
            ])
            translate([
                0,
                -bolt_length/2,
                bolt_height/2
            ])
                #bolt();

            color("pink")
            translate(gears_1_offset)
                gear1();
            color("pink")
            translate(gears_2_offset)
                gear1();
                    
            color("pink")
            translate(smallgearoffset())
                gear2();
        }

        if(cross_section)
            color("yellow")
                cuboid([2000,2000,2000],anchor=LEFT);
    }
}

// for viewing
assembly(cross_section=false);

// for export
gear1();
gear2();
front();
body_left();
!body_right();
bolt();

module handle(){
    handle_diameter=20;
    // whatever looks nice
    handle_curve_radius=20;
    
    // full short axis of the handle (door to edge)
    handle_length_short_target=60;
    // full long axis of the handle (left to right edge)
    handle_length_long_target=130;
    
    // length of short straight segment
    handle_length_short=handle_length_short_target-handle_curve_radius-handle_diameter/2;
    // length of long straight segment
    handle_length_long=handle_length_long_target-handle_curve_radius-handle_diameter/2;
    
    assert(handle_curve_radius>=handle_diameter/2);
    
    module shell(){
        translate([0,handle_curve_radius,0])
        rotate([0,90,0])
            cylinder(
                h=handle_length_short,
                d=handle_diameter,
                anchor=TOP
            );
            
        rotate_extrude(90)
        translate([handle_curve_radius,0,0])
            circle(d=handle_diameter);
            
        translate([handle_curve_radius,0,0])
        rotate([90,0,0])
            cylinder(
                h=handle_length_long,
                d=handle_diameter,
                anchor=BOTTOM
            );
    }
    
    rod_width=8+0.1;
    // length inside handle
    rod_length=35;
    
    // measure
    screw_hole_front_offset=15;
    screw_hole_diameter=5.5;
    
    assert(screw_hole_front_offset<rod_length,"screw hole must be under rod");

    difference(){
        shell();
        
        // rod hole
        translate([-handle_length_short,handle_curve_radius,0])
            cuboid([rod_length,rod_width,rod_width],anchor=LEFT);
            
        // screw hole
        translate([-(handle_length_short-screw_hole_front_offset),handle_curve_radius,-rod_width/2])
            zcyl(l=(handle_diameter-rod_width)/2,d=screw_hole_diameter,anchor=TOP);
            
        if(true && $preview)
            cuboid([1000,1000,1000],anchor=BOTTOM);
    }
}

handle();
