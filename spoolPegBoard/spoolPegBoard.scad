$fn=10;

/*[backing board size]*/
board_width=240;
board_height=245;
board_depth=4;

/* [common peg parameters] */
// [peg length in mm] offset of peg top from board, measured perpendicular, regardless of angle!
peg_length=60;
peg_diameter=5;
peg_top_area_fraction=0.55;
// angle between board normal and peg
peg_tilt_deg=20;
/* [spacing for bottom pegs] */
peg_spacing_x1=55;
peg_spacing_y1=55;
/* [spacing for top pegs] */
peg_spacing_x2=30;
peg_spacing_y2=30;

/*[spacing between pegs and board egdes]*/
// padding to make it look nice (and account for rounded bottom)
peg_side_padding=20;
// padding for holes
peg_top_padding=30;

peg_area_width=board_width-peg_side_padding;
peg_area_height=board_height-peg_top_padding;

hook_hole_width=13;
hook_hole_height=5;
hook_hole_horizontaloffset=39;
hook_hole_verticaloffset=10;

/* terminate input parameters */
if(false){}

include <BOSL2/std.scad>

// for internal use only
peg_shift=peg_length*tan(peg_tilt_deg);
peg_rounding1=-4;

// height difference between top of bottom area and bottom of top area
peg_inter_area_height=(peg_spacing_y1+peg_spacing_y2)/2;
// total peg area height
real_peg_area_height=board_height-peg_top_padding-peg_inter_area_height;

// lower peg area with wide spaced pegs
peg_area_bottom_height=real_peg_area_height*(1-peg_top_area_fraction);

num_pegs_x1=floor(peg_area_width/peg_spacing_x1);
num_pegs_y1=floor(peg_area_bottom_height/peg_spacing_y1);

top_of_bottom_pegs=num_pegs_y1*peg_spacing_y1;
bottom_of_top_pegs=top_of_bottom_pegs+peg_inter_area_height;

// upper peg area with narrow spaced pegs
peg_area_top_height=real_peg_area_height*peg_top_area_fraction;

num_pegs_x2=floor(peg_area_width/peg_spacing_x2);
num_pegs_y2=floor(peg_area_top_height/peg_spacing_y2);

peg_bottom_offset=(peg_area_height-(num_pegs_y1*peg_spacing_y1+num_pegs_y2*peg_spacing_y2+peg_inter_area_height))/2;

module peg(){
    translate([
        0,
        peg_shift/2-peg_rounding1,
        peg_length/2
    ])
    cyl(
        h=peg_length,
        d=peg_diameter,
        shift=[0,peg_shift],
        rounding1=peg_rounding1,
        rounding2=2,
        anchor=FRONT,
    );
}

module hookHole(){
    cube([hook_hole_width,hook_hole_height,board_depth],center=true);
}

module baseBoard(){
    difference(){
        cuboid(
            [board_width,board_height,board_depth],
            anchor=FRONT+LEFT,
            rounding=10,
            edges=[
                FRONT+LEFT,
                FRONT+RIGHT,
                BACK+LEFT,
                BACK+RIGHT,
            ],
        );
        
        union(){
            translate([+hook_hole_horizontaloffset,board_height-hook_hole_verticaloffset,0])
            hookHole();
            
            translate([board_width-hook_hole_horizontaloffset,board_height-hook_hole_verticaloffset,0])
            hookHole();
            
            translate([+hook_hole_horizontaloffset,+hook_hole_verticaloffset,0])
            hookHole();
            
            translate([board_width-hook_hole_horizontaloffset,+hook_hole_verticaloffset,0])
            hookHole();
        }
    }
}


baseBoard();

if(false)
translate([0,0,0])
#cube([board_width,peg_area_bottom_height,board_depth]);

for(idx=[0:1:num_pegs_x1]){
    for(idy=[0:1:num_pegs_y1]){
        translate([
            board_width/2
            -num_pegs_x1/2*peg_spacing_x1
            +idx*peg_spacing_x1,
            
            idy*peg_spacing_y1+peg_bottom_offset,
            
            board_depth/2
        ])
        peg();
    }
}

if(false)
translate([0,bottom_of_top_pegs,0])
#cube([board_width,peg_area_top_height,board_depth]);

for(idx=[0:1:num_pegs_x2]){
    for(idy=[0:1:num_pegs_y2]){
        translate([
            board_width/2
            -num_pegs_x2/2*peg_spacing_x2
            +idx*peg_spacing_x2,
            
            bottom_of_top_pegs+idy*peg_spacing_y2+peg_bottom_offset,
            
            board_depth/2,
        ])
        peg();
    }
}







