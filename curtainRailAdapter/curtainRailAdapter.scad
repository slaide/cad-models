include<BOSL2/std.scad>

/*
curtain rail adapter

the new ikea curtain rail is too narrow for the \___/ shaped pins that are integrated into our rail holders, when in their rotated position perpendicular to the rail.
their narrow width is barely wider than the rail slit at the top, so if positioned correctly they might by themselves already hold up the rail.

this adapter pads out the area around them and centers them in the rail.

the top thickness (insert_top_offset) of this case is calculated so that the screws still utilize the whole thread length inside the pins.
*/

// make connector (if true. connect two rails to each other)
// or holder (if false. connect rail to wall holder)
makeRailConnector=false;

heightmargin=0.1;

// tube inner width
width=12;
// tube inner height (6.6, minus some margin)
height=6.6-heightmargin;

insert_length=makeRailConnector?40:13;

// length of the metal clip (long axis), plus a bit of padding
length=insert_length+4;
insert_height=4.5;
insert_width=8;

insert_top_offset=1;

// 8.5 minus margin
railSlot_width=8.5-0.9;
railSlot_height=0.6;

if(false){}

$fn=$preview?32:256;

module containerWedge(){
    translate([0,0,railSlot_height-0.1])
    intersection(){
        wedgediameter=20;
        
        xcyl(l=width,d=wedgediameter,anchor=TOP);
        
        translate([0,0,-5])
            cuboid([wedgediameter,wedgediameter,wedgediameter],anchor=BOTTOM);
    }
}

difference(){
    union(){
        cuboid([width,length,height],anchor=TOP);
        cuboid([railSlot_width,length,railSlot_height],anchor=BOTTOM);
        
        if(makeRailConnector){
            translate([0,length/2-10,0])
            containerWedge();
            
            translate([0,-(length/2-10),0])
            containerWedge();
        }
    }
    
    if(!makeRailConnector){
        tube(l=height*2,or=3/2,ir=0);
    
        translate([0,0,-insert_top_offset])
            cuboid([insert_width+0.2,length,insert_height],anchor=TOP);
    }
}