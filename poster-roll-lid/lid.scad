include <BOSL2/std.scad>

thickness=4;

// ring outer radius
diameter=83-4;

hole_x=diameter/2*2/3;

hole_spacing=10;
hole_diameter=2.5;

if(false){}

// trick from u/schorsch3000
$fn = $preview ? 32 : 256;

num_sections=floor(2*hole_x*3.14/hole_spacing);
angle_per_section=360/(num_sections);
echo(str("spacing should ",hole_spacing,"mm, is ",2*hole_x*3.14/num_sections,"mm"));

difference(){
    zcyl(l=thickness,r=diameter/2);
    
    union(){
        for(a=[1:num_sections]){
            rotate([0,0,angle_per_section*a])
            translate([hole_x,0,0])
            #zcyl(l=thickness,r=hole_diameter/2);
        }
    }
}
