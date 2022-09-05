use <../Shapes/Teardrop.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Chamfer.scad>;
use <../Meta/Debug.scad>;
use <../Vitamins/Pipe.scad>;
use <../SCAD Operations/helix_extrude.scad>;

caseDiameter = 9;
caseRadius = caseDiameter/2;
caseLength=25;
height = (caseLength+(caseDiameter*sqrt(2)))*2;
angle=360*2;
PIPE = Spec_OnePointFiveSch40ABS();
extraWall = 1;
radius=(PipeInnerRadius(PIPE)*25.4)-caseRadius-extraWall;

module Case2d(chamferRadius=1) {
  translate([caseRadius,caseLength-caseRadius])
  rotate(90)
  Teardrop(r=caseRadius, $fn=20);

  ChamferedSquare([caseDiameter, caseLength-caseRadius], r=chamferRadius);
}

module Case3d() {
  rotate_extrude()
  intersection() {
    translate([-caseRadius,0])
    hull()
    Case2d();

    square([caseRadius,caseLength+caseRadius]);
  }
}

module Core(wallClearance=1, angle=360*5, height=height) {
  color("SaddleBrown") render()
  union() {
    difference() {
      cylinder(r=radius, h=height, $fn=20);

      *helix_extrude(angle=angle/starts, height=height, $fn=24)
      translate([radius-caseRadius,0,0])
      Case2d();

      linear_extrude(height=height)
      for (R = [0:8])
      rotate(360/8/2*R*2)
      translate([radius,0])
      circle(r=caseRadius+wallClearance, $fn=20);
    }

    *for (R = [0:starts-1])
    rotate(360/starts*R)
    translate([radius-caseRadius,0,0])
    Case3d();
  }
}

module HelixWall(wallClearance=1, debug=false, alpha=0.5) {
  color("SlateGray", alpha) render()
  render() DebugHalf(enabled=debug, dimension=1000)
  difference() {
    scale(25.4)
    Pipe(pipe=PIPE,
         length=height/25.4,
         hollow=false);

    // Helical Path
    helix_extrude(angle=angle, height=height, $fn=24)
    translate([radius-caseRadius,0,0])
    Case2d();

    translate([radius-caseRadius,0,0])
    Case3d();

    translate([0,0,-1])
    cylinder(r=radius, h=height+2);
  }
}


// TODO: Here's where I stopped.
module Feedramp() {
  color("Silver")

  rotate(-45) {
    cube([PipeOuterRadius(PIPE)*25.4, caseDiameter, caseLength]);
  }
}

*Feedramp();
*Core();
HelixWall();
