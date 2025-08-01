include <BOSL2/std.scad>

// text that goes on the flag
// e.g. 1, 2, A, C, F, BAD, BOS, TIT, IIIIIIII, LXI, 
flag_text="IIIIIIII";

/*[base]*/
// thickness of base
base_thickness=2;
// diameter of base area (flag pole is placed on extrusion from this part)
base_diameter=32;

/*[flag polse]*/
// height of flag pole (excl. base and flag)
// i.e. clearance for minis.
flag_pole_height=70;
// flag pole diameter
flag_pole_diameter=2.5;

/*[flag]*/
// length of flag
flag_length=25;
// height of the flag
flag_height=10;
// thickness of the flag itself
flag_thickness=2;

// can be positive or negative (protrusion/indent)
flag_text_depth=0.5;
// fraction of flag height occupied by text
font_height_flag_height_fraction=0.8;

flag_base_radius=flag_pole_diameter/2+1.5;

if(false){}

// trick from u/schorsch3000
$fn = $preview ? 32 : 256;

base_radius=base_diameter/2;
flag_pole_radius=flag_pole_diameter/2;

font_size=flag_height*font_height_flag_height_fraction;

fontname="Liberation Mono:bold";

flag_x_offset=flag_pole_radius+base_radius;

module flag_text(){
    flag_text_indent=((flag_text_depth>0) ? 0 : flag_text_depth);
    
    flag_side1_yoffset=flag_thickness/2+flag_text_indent;
    flag_side2_yoffset=-flag_thickness/2-flag_text_indent;
    
    translate([
        flag_x_offset-flag_length/2,
        0,
        flag_pole_height+flag_height*(1-font_height_flag_height_fraction)/2,
    ])
    union(){
        translate([0,flag_side1_yoffset,0])
        rotate([90,0,180])
        #text3d(flag_text,h=abs(flag_text_depth),size=font_size,anchor=BOTTOM,font=":bold");
        
        translate([0,flag_side2_yoffset,0])
        rotate([90,0,0])
        #text3d(flag_text,h=abs(flag_text_depth),size=font_size,anchor=BOTTOM,font=":bold");
    }
}

// base
zcyl(l=base_thickness,r=base_radius,anchor=BOTTOM);

translate([flag_x_offset,0,0])
union(){
    // flag base
    zcyl(l=base_thickness,r=flag_base_radius,anchor=BOTTOM);

    // flag pole
    zcyl(l=flag_pole_height+flag_height,r=flag_pole_diameter/2,anchor=BOTTOM);
}

// flag base extension
cuboid([flag_x_offset,flag_base_radius*2,base_thickness],anchor=BOTTOM+LEFT);

module flag_flag(){
    translate([flag_x_offset,0,flag_pole_height])
    cuboid([flag_length,flag_thickness,flag_height],anchor=BOTTOM+RIGHT);
}

if(flag_text_depth<0){
    difference(){
        flag_flag();
        flag_text();
    }
}else{
    union(){
        flag_flag();
        flag_text();
    }
}
