include<BOSL2/std.scad>

height=75;
thickness=5.35;
width=50;

if(false){}

$fn=$preview?32:256;

difference(){
    import("Toothbrush+and+Paste+Holder+x+2-makerworld-Lepracaun.stl");
    
    translate([5.6,4,height])
        cuboid(
            [40,40,thickness],
            edges=[
                FRONT+LEFT,
                FRONT+RIGHT,
                BACK+LEFT,
                BACK+RIGHT,
            ],
            rounding=3,
            anchor=TOP
        );
        
    #translate([-6.75,-30.7,height])
        zcyl(l=thickness,d=18.5,anchor=TOP);
        
    #translate([-6.75+24,-30.7,height])
        zcyl(l=thickness,d=18.5,anchor=TOP);
}
