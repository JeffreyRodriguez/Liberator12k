use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Ammo/Shell Slug.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Components/Cylinder.scad>;
use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Lower.scad>;
use <../../../Finishing/Chamfer.scad>;
use <../Frame.scad>;
use <../Reference.scad>;
use <Forend.scad>;


function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function LugRadius() = TeeRimRadius(ReceiverTee())+(WallFrameRod()*0.6);
function LugAngle() = 45;
function ForendOffset() = 4;
function ForendTravel() = 2;
function BarrelLugLength() = 1;


module HelicalMagazine(columns=3, rows=3, shellLength = 2.75, spindleOffset=(0.870/2)+0.25) {
  height = shellLength*rows;
  columnTwist = 0;
  
  helixOffset = 0.78+0.25+0.015;
  
  // Helix
  rotate(-25)
  //for (R = [0:columns-1]) rotate((360/columns)*R)
  linear_extrude(height=shellLength*rows, twist=360, slices=height*100)
  translate([helixOffset,00])
  square([.1,.2]);
  
  // Center
  rotate(-360*$t)
  linear_extrude(height=height, twist=columnTwist)
  difference() {
    circle(r=helixOffset-0.125, $fn=20);
    
    for (R = [0:columns-1]) rotate((360/columns-1)*R)
    translate([spindleOffset,0])
    circle(r=0.89/2, $fn=40);
  }
  
  // Shells
  %color("Red", alpha=0.5)
  rotate(-360*$t)
  translate([0,0,height*$t])
  for (R = [0:columns-1]) rotate((360/columns-1)*R)
  for (Z = [0:rows-1])
  translate([spindleOffset,0,shellLength*Z])
  ShellSlugBall();
  
}
!HelicalMagazine();

module ForendHelicalAssembly(barrelLength=14, frontLength=1, alpha=.5) {
  
  translate([0,0,0])
  Barrel(barrelLength=barrelLength-ForendOffset(), hollow=true);
  
}

ForendHelicalAssembly();
Reference();

// Plate
*!scale(25.4) {
  ReferenceBuildArea();

  // Rear (user-end) Segment
  translate([-2,-2,0])
  rotate([0,-90,180])
  ForendHelicalAssembly();
}
