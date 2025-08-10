include <BOSL2/std.scad>

// reference: https://www.thingiverse.com/thing:2669427

// ring inner diameter
ring_id=15.5;

ring_thickness=2;

num_slots=4;

if(false){}

$fn=$preview?32:256;

ring_ir=ring_id/2;
ring_length=30;

ring_or=ring_ir+ring_thickness;

ring_cutout_length=18;
ring_cutout_height=12;

ring_bend_slot_width=0.3;

module ring_body(){
    difference(){
        teardrop(r=ring_or,h=ring_length,ang=32,cap_h=ring_or);

        ycyl(r=ring_ir,h=ring_length);

        translate([0,-ring_length/2,-ring_or])
            cuboid(
                [ring_or*2,ring_cutout_length,ring_cutout_height],
                rounding=ring_cutout_height/2,
                edges=[TOP+BACK],
                anchor=BOTTOM+FRONT,
            );

        translate([0,0,-ring_ir+1/2])
            cuboid([ring_bend_slot_width,ring_length,ring_thickness+1],anchor=TOP);
    }
}

cube_wall_thickness=2;
cube_cutout_long_height=0.25;

// spacing between slots (slot wall thickness)
slot_spacing=2;

cube_width=10;

cube_cutout_slot_height=4;
cube_cutout_slot_width=cube_width;
cube_cutout_slot_length=4;

cube_length=ring_length;
cube_height=cube_cutout_slot_length+cube_wall_thickness+cube_cutout_long_height;

assert(((num_slots+1)*cube_cutout_slot_length+(num_slots)*slot_spacing)<cube_length, "this many slots dont into the ring length");

module cube_cutout_slot(chamfer=true){
    difference(){
        cuboid(
            [cube_cutout_slot_width,cube_cutout_slot_length,cube_cutout_slot_height],            
            edges=[FRONT+TOP],
            anchor=TOP
        );
        
        if(chamfer)
            translate([0,-cube_cutout_slot_length/2,0])
                prismoid(
                    [cube_width,0],
                    [cube_width,1.5],
                    h=2,
                    shift=[0,1],
                    anchor=TOP+FRONT
                );
    }
}

// distance between same edge of slots
slot_offset=cube_cutout_slot_length+slot_spacing;

slot_total_length=num_slots*slot_offset;
// offset of additional front cube for entry space
slot_front_offset=cube_cutout_slot_length*0;

cube_cutout_long_width=cube_width;
cube_cutout_long_length=cube_length-cube_wall_thickness-slot_front_offset;

module ring_slot_cube(){
    difference(){
        cuboid([cube_width,cube_length,cube_height],anchor=BOTTOM);

        translate([0,-(cube_length-cube_cutout_long_length)/2,cube_height-cube_wall_thickness])
            cuboid([cube_cutout_long_width,cube_cutout_long_length,cube_cutout_long_height],anchor=TOP);

        translate([0,0,cube_height-cube_wall_thickness]){
            for(yoffset=[0:slot_offset:num_slots*slot_offset]){
                translate([0,-(cube_length-cube_cutout_slot_length)/2-slot_front_offset+yoffset,0])
                    cube_cutout_slot(yoffset==0?false:true);
            }
        }
    }
}

module ring_whole(){
    ring_body();

    translate([0,0,ring_or])
        ring_slot_cube();
}

difference(){
    //translate([0,0,ring_length/2+2])
    //rotate([90+25,0,0])
    union(){
        ring_whole();

        // extend ring
        if(false)
        translate([0,-ring_length/2,0])
        rotate([-90,0,180])
        linear_extrude(10)
        projection(cut=true)
        rotate([90,0,0])
        translate([0,ring_length/2-1,0])
            ring_whole();
    }
    
    //#cuboid([2000,2000,2000],anchor=TOP);
}