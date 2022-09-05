use <../Shapes/Teardrop.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Chamfer.scad>;
use <../Meta/Debug.scad>;
use <../Vitamins/Pipe.scad>;
use <../SCAD Operations/helix_extrude.scad>;

caseDiameter = 9;
caseRadius = caseDiameter/2;
caseLength=25;
height = 200;
angle=360*5;
extraWall = 1;
PIPE = Spec_OnePointFiveSch40ABS();
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

module Helix(starts=1, angle=360*5, height=200) {
  color("SaddleBrown") render()
  union() {
    difference() {
      cylinder(r=radius, h=height, $fn=20);

      for (R = [0:starts-1])
      rotate(360/starts*R)
      helix_extrude(angle=angle/starts, height=height, $fn=24)
      translate([radius-caseRadius,0,0])
      Case2d();
    }

    for (R = [0:starts-1])
    rotate(360/starts*R)
    translate([radius-caseRadius,0,0])
    Case3d();
  }
}

module HelixWall(wallClearance=1,alpha=.75) {
  color("SlateGray", alpha) render()
  render() DebugHalf(dimension=1000)
  difference() {
    scale(25.4)
    Pipe(pipe=PIPE,
         length=height/25.4,
         hollow=false);

    linear_extrude(height=height)
    for (R = [0:8])
    rotate(360/8/2*R*2)
    translate([radius,0])
    circle(r=caseRadius+wallClearance, $fn=20);

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

Feedramp();
Helix();
HelixWall();
