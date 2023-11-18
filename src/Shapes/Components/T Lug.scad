include <../../Meta/Common.scad>;

use <../Chamfer.scad>;

CUTTER=false;
CUTTER_CHAMFER_HORIZONTAL=false;

module T_Lug2d(
              width=Inches(0.5),
             height=Inches(1),
          tabHeight=Inches(0.25),
           tabWidth=Inches(1),
          clearance=Inches(0.005),
          clearVertical=false,
             cutter=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Vertical
  translate([-height, -(width/2)-(clearVertical ? clear : 0)])
  square([height+clearance, width+(clearVertical ? clear2 : 0)]);

  // Horizontal
  translate([-tabHeight-clear, -(tabWidth/2)-clear])
  square([tabHeight+clear2,tabWidth+clear2]);
}

module T_Lug(length=0.75,
              width=Inches(0.5),
             height=Inches(1),
          tabHeight=Inches(0.25),
           tabWidth=Inches(1),
          clearance=Inches(0.005),
      clearVertical=false,
      chamferCutterHorizontal=false,
             cutter=false) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  if (cutter) {
    rotate([0,90,0])
    translate([0,0,-clear])
    linear_extrude(height=length+clear2)
    T_Lug2d(width=width,
           height=height,
        tabHeight=tabHeight,
         tabWidth=tabWidth,
        clearance=clearance,
    clearVertical=clearVertical,
           cutter=cutter);

    if (chamferCutterHorizontal)
    for (M = [0,1]) mirror([0,M,0])
    translate([0,(width/2)-clear,tabHeight+clear2])
    rotate([-90,0,0])
    SquareHoleEndChamfer([length+clear2, tabHeight+clear2], r=1/16);
  } else {

    // Horizontal
    translate([0,-tabWidth/2,0])
    ChamferedCube([length, tabWidth, tabHeight], r=3/64,
                   teardropFlip=[true,true,true]);

    // Vertical
    translate([0,-width/2,0])
    ChamferedCube([length, width, height], r=3/64,
                   teardropFlip=[true,true,true]);
  }
}

T_Lug(cutter=CUTTER, chamferCutterHorizontal=CUTTER_CHAMFER_HORIZONTAL);
