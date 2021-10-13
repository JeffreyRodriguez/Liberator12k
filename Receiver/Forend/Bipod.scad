use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/Chamfer.scad>;


// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

BARREL_OD = 1.06;

module Bipod(barrelRadius=BARREL_OD/2, bottomDiameter=1,
             length=1, extend=1, frontWall=0.25, bipodLegLength=6,
             wall = 0.25,  chamferRadius = 0.1) {

  bipodLegDiameter = 0.5;
  bipodLegRadius = bipodLegDiameter/2;
  bipodLegAngle = 25;

  {

    // Bipod legs
    color("Silver")
    translate([length/2,0,0])
    for (m = [0,1]) mirror([0,m,0])
    rotate([bipodLegAngle,0,0])
    translate([0,bipodLegRadius+barrelRadius,-bipodLegLength-barrelRadius])
    %cylinder(r=bipodLegRadius, h=bipodLegLength);

    color("Tan") render()
    difference() {
      hull() {

        // Around the barrel
        rotate([0,90,0])
        ChamferedCylinder(r1=barrelRadius+wall,
                          r2=chamferRadius,
                           h=length);

        // Bipod Leg Support
        translate([length/2,0,0])
        for (m = [0,1]) mirror([0,m,0])
        rotate([bipodLegAngle,0,0])
        translate([0,bipodLegRadius+barrelRadius,-extend])
        ChamferedCylinder(r1=bipodLegRadius+wall,
                             r2=chamferRadius, h=extend);
      }

      // Square Tube center axis
      rotate([0,90,0])
      cylinder(r=barrelRadius, h=length);

      // Bipod leg holes
      translate([length/2,0,0])
      for (m = [0,1]) mirror([0,m,0])
      rotate([bipodLegAngle,0,0])
      translate([0,bipodLegRadius+barrelRadius,-extend-wall])
      cylinder(r=bipodLegRadius+0.005, h=extend+wall);

      // Set screw
      translate([length/2,0,0])
      cylinder(r=0.05, h=barrelRadius+wall);
    }
  }
}

Bipod();

*!scale(25.4)
rotate([0,-90,0])
Bipod();
