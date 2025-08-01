include <BOSL2/std.scad>

// text that goes on the ring
ring_text="BURNING";

// ring outer radius
or=19;
// ring inner radius
ir=15;

if(false){}

// trick from u/schorsch3000
$fn = $preview ? 32 : 256;

// font size is calculated to take up all space between inner and outer radius
font_size=(or-ir)*0.7;

// tweak this until it looks right
letter_spacing=font_size/1.15;

// flat ring part
thickness_ring_upper=0.4;
// bottom 
thickness_ring_lower=0.8;
// text protrusion
target_thickness_text=0.4;
// depends on font size, angle and some other stuff, but this works well enough
thickness_text=0.45+target_thickness_text;

// chamfer angle at bottom of ring (to allow picking ring up)
side_angle=55;
// Angle to tilt text upward
tilt_angle = 65;

ring_textbacking_thickness=tan(90-tilt_angle)*(or-ir);

// put text baseline (the height of text where the underline would go)
// at this fraction of the whole height of the text area (approx.)
baseline_fraction=0.75;

// whatever font. this is used in the bosl 2 examples.
fontname="Liberation Mono:bold";

module ringtext(angle_start,angle_length){
    // Fixed: Create normals that match the path length and are properly oriented
    path_radius = ir+(or-ir)*baseline_fraction;
    path = path3d(arc(100, r=path_radius, angle=[angle_start+0, angle_start+angle_length]));
    path_length = len(path);

    // Calculate normals perpendicular to the circular path
    // Since we know it's a 180-degree arc, calculate normals from angles
    normals = [for(i = [0:path_length-1]) 
        let(
            // Calculate angle for this point along the 180-degree arc
            angle = angle_start+angle_length * i / (path_length - 1),
            // Normal points radially outward with upward tilt
            normal_3d = [
                cos(angle) * cos(tilt_angle), 
                sin(angle) * cos(tilt_angle), 
                sin(tilt_angle)
            ]
        ) normal_3d
    ];

    // Render the path text
    translate([0,0,thickness_text/2])
    path_text(
        path,
        ring_text,
        thickness=thickness_text,
        font=fontname,
        size=font_size,
        lettersize = letter_spacing,
        normal=normals
    );
}

// this depends on the ring size, but with the current values, this holds.
assert(len(ring_text)<=37, "text must not have more than 37 characters")
if(len(ring_text)<=18){
    #ringtext(0,180);
    #ringtext(180,180);
}else{
    #ringtext(0,360);
}

// upper ring segment
translate([0,0,-thickness_ring_upper/2])
tube(or=or,ir=ir,h=thickness_ring_upper);

// lower ring segment
translate([0,0,-thickness_ring_upper-thickness_ring_lower/2])
rotate_extrude(angle=360)
translate([ir+(or-ir)/2,0,0])
trapezoid(h=thickness_ring_lower,w2=or-ir,ang=90+side_angle);

// text backing
translate([0,0,0])//ring_textbacking_thickness/2])
rotate_extrude(angle=360)
translate([ir+(or-ir)/2,0,0])
trapezoid(h=ring_textbacking_thickness,w1=or-ir,ang=[90,90-tilt_angle],anchor=FRONT);
