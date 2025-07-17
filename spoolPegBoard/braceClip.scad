include<BOSL2/std.scad>

// needs to protrude 17mm + hole depth + extra
// 1cm gap
// 25mm tall

// thickness
depth=2.8;
width=12;
braceClipHeight=20;
brace_radius=5;

brace_depth=21;
brace_height=15;

// pin at bottom of back clip presses extrudes this much (i.e. increase for higher grip force)
clip_pressure_depth=1.2;

if(false){}

$fn=20;

// front brace block (big thing keeping forces in check)
brace_top_depth=depth+brace_depth;
brace_bottom_depth=depth;

// shorthand for the diameter of the top radius clip
brace_diameter=brace_radius*2;

// front notch/hook thing at the top of the front brace
brace_frontHook_height=brace_radius/2;
brace_notchRounding=2;
brace_frontHook_depth=depth+brace_notchRounding;

brace_notchHeight=brace_frontHook_height;
brace_notchDepth=brace_frontHook_depth/2;


actual_frontBrace_topDepth=brace_top_depth+brace_frontHook_depth/2;
actual_frontBrace_bottomDepth=brace_bottom_depth+brace_frontHook_depth/2;

// back clip
cuboid([width,depth,braceClipHeight]);

// holder top brace
translate([0,-brace_radius-depth/2,braceClipHeight/2])
rotate([90,0,90])
back_half()
tube(or=brace_radius+depth,ir=brace_radius,h=width);

// front brace
translate([0,

    -depth*0.5
    -brace_diameter,
    
    +braceClipHeight/2
])
prismoid(
    size2=[width,actual_frontBrace_topDepth],
    size1=[width,actual_frontBrace_bottomDepth],
    h=brace_height,
    shift=[0,-(actual_frontBrace_topDepth-actual_frontBrace_bottomDepth)/2],
    anchor=TOP+BACK,
);

// front brace hook
translate([0,
    +brace_frontHook_depth/2
    -depth/2
    -depth
    -brace_diameter
    -brace_depth
    -brace_frontHook_depth
    ,
    braceClipHeight/2,
])
difference(){
    prismoid(
        size1=[width,brace_frontHook_depth],
        size2=[width,brace_frontHook_depth],
        h=brace_frontHook_height,
        anchor=FRONT+BOTTOM,
    );
    translate([0, brace_frontHook_depth-brace_notchDepth, 0])
    cuboid(
        [width, brace_notchDepth, brace_notchHeight],
        anchor=FRONT+BOTTOM,
        rounding=brace_notchRounding,
        edges=BOTTOM+FRONT,
    );
}


// back clip hook to put pressure on the clip
translate([0,-clip_pressure_depth,-braceClipHeight/2-depth])
diff()prismoid(size1=[width,depth],size2=[width,depth],h=depth,shift=[0,clip_pressure_depth]){
    edge_profile([FRONT+BOTTOM],excess=10,convexity=10){
        mask2d_roundover(h=0.5,mask_angle=$edge_angle);
    }
}





