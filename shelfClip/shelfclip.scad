include<BOSL2/std.scad>

thickness=2;
width=8;
innerclipheight=30;
// thickness of the plane this hook is placed over
clipdist=20;
hookAngle=25;
clipLength=15;
frontClipRadius=10;

if(false){}

//$fn=400;

clipradius=clipdist/2;

cuboid([thickness,innerclipheight,width],anchor=BOTTOM+CENTER);

translate([
    clipradius+thickness/2,
    innerclipheight/2,
    0
])
linear_extrude(width)
ring(
    r1=clipradius,
    r2=clipradius+thickness,
    angle=[0,180]
);

translate([
    -(clipradius+thickness/2),
    -innerclipheight/2,
    0
])
linear_extrude(width)
ring(
    r1=frontClipRadius,
    r2=frontClipRadius+thickness,
    angle=[180+hookAngle,360]
);

translate([
    -cos(hookAngle)*(frontClipRadius+thickness/2),
    -sin(hookAngle)*(frontClipRadius+thickness/2),
    0
])
translate([
    -frontClipRadius
    -thickness/2
    ,
    -innerclipheight/2,
    0
])
rotate([0,0,hookAngle])
#cuboid([thickness,clipLength,width],anchor=FRONT+BOTTOM);
