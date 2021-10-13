use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../Teardrop.scad>;
use <../Chamfer.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Square Tube.scad>;

module Bipod(bottomDiameter=1, legDiameter=5/16,
             length=2, extend=1, frontWall=0.25, bipodLegLength=6,
             tubeWall = 0.25,  chamferRadius = 0.1,
             $fn=Resolution(20, 60)) {

  tube_width =1.015; // Meausred

  tubeCenterZ = tubeWall+(tube_width/2);
  topDiameter = tube_width+(tubeWall*2);

  legDiameter = legDiameter;
  bipodLegRadius = legDiameter/2;
  bipodLegAngle = -180+(60/2);

  render()
  translate([frontWall,0,0]) {

    // Bipod legs
    color("Silver")
    translate([-length/2,0,0])
    for (m = [0,1]) mirror([0,m,0])
    translate([0,(tube_width/2),0])
    rotate([bipodLegAngle,0,0])
    %cylinder(r=bipodLegRadius, h=bipodLegLength);

    difference() {
      hull() {

        // Square Tube Body
        rotate([0,-90,0])
        translate([0, -topDiameter/2,-ManifoldGap()])
        ChamferedCube([tube_width+(tubeWall*2), tube_width+(tubeWall*2), length+ManifoldGap()],
                      chamferRadius=chamferRadius);

        // Bipod Leg Support
        translate([-length/2,0,0])
        for (m = [0,1]) mirror([0,m,0])
        translate([0,(tube_width/2),0])
        rotate([bipodLegAngle,0,0])
        ChamferedCylinder(r1=bipodLegRadius+tubeWall, r2=chamferRadius, h=extend);
      }

      // Square Tube center axis
      translate([-frontWall,0,tubeCenterZ])
      rotate([0,-90,0])
      ChamferedSquareHole(side=tube_width, length=length-frontWall, center=true,
                           chamferTop=true, chamferBottom=false, teardropTop=true,
                           chamferRadius=chamferRadius,
                           corners=true, cornerRadius=0.0625);

      // Bipod leg holes
      translate([-length/2,0,0])
      for (m = [0,1]) mirror([0,m,0])
      translate([0,(tube_width/2),0])
      rotate([bipodLegAngle,0,0])
      ChamferedCircularHole(r1=bipodLegRadius+0.005, r2=chamferRadius, h=extend, chamferBottom=false);
    }
  }
}

Bipod();

*!scale(25.4)
rotate([0,90,0])
Bipod();
