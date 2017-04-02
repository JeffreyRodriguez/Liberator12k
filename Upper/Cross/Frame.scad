use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

use <Reference.scad>;

function FrameRodLength() = 10;
function FrameNutHeight() = 0.25;
function OffsetFrameRod() = 0.4;
function OffsetFrameBack() = -ReceiverCenter()-WallFrameBack()-FrameNutHeight();
function FrameRodMatchedAngle() = 45;

function FrameRodAngles() = [
                    FrameRodMatchedAngle(),
                    -FrameRodMatchedAngle(),
                    FrameRodMatchedAngle()+180,
                    -FrameRodMatchedAngle()-180
                   ];

function FrameRodOffset()
           = TeeRimRadius(ReceiverTee())
           + RodRadius(FrameRod())
           + OffsetFrameRod()
           ;

module Frame(clearance=RodClearanceLoose(),
             length=FrameRodLength(),
             rodFnAngle=90) {

  color("SteelBlue")
  render(convexity=4)
  translate([OffsetFrameBack(),0,0])
  rotate([0,90,0])
  linear_extrude(height=length)
  FrameRods(clearance=clearance);
}

module FrameIterator() {
  for (angle = FrameRodAngles())
  rotate(angle)
  translate([-FrameRodOffset(ReceiverTee()), 0])
  rotate(-angle)
  children();
}

module FrameRods(clearance=RodClearanceLoose(),
                 rodFnAngle=90) {

  FrameIterator()
  rotate(rodFnAngle)
  Rod2d(rod=FrameRod(), clearance=clearance);
}

module FrameNuts(nutHeight=FrameNutHeight(), nutRadius=0.3) {
  color("SteelBlue")
  rotate([0,90,0])
  FrameIterator()
  cylinder(r=nutRadius, h=nutHeight, $fn=6);
}

module Quadrail2d(rod=Spec_RodFiveSixteenthInch(), rodClearance=RodClearanceLoose(),
                  bodyRadius=1.478, wallRod=WallFrameRod(),
                  clearFloor=false) {
  difference() {
    hull() {

      // Cross-fitting walls
      circle(r=bodyRadius, $fn=Resolution(20,80));

      // Frame Walls
      FrameIterator()
      Rod2d(rod=FrameRod(), extraWall=wallRod, clearance=rodClearance, $fn=Resolution(20,50));

      children();
    }


    // Clear the floor for the lower receiver
    if (clearFloor)
    translate([ReceiverCenter()-0.005,-2])
    square([1,4]);
  }
}

scale(25.4)
render() {

  %Frame();

  translate([-ManifoldGap(),0,0])
  %FrameNuts();

  %rotate([0,90,0])
  linear_extrude(height=1)
  Quadrail2d();
}
