use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Reference.scad>;

function FrameRodLength() = 11.75;
function FrameNutHeight() = 0.25;
function OffsetFrameRod() = 0.4;
function OffsetFrameBack() = ReceiverLugRearMinX()-0.25;
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
             rodFnAngle=90) {

  render(convexity=4)
  translate([OffsetFrameBack(),0,0])
  rotate([0,90,0])
  linear_extrude(height=FrameRodLength())
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
  rotate([0,90,0])
  FrameIterator()
  cylinder(r=nutRadius, h=nutHeight, $fn=6);
}

module Quadrail2d(rod=Spec_RodFiveSixteenthInch(), rodClearance=RodClearanceLoose(),
                  wallTee=WallTee(), wallRod=WallFrameRod(),
                  clearFloor=false, clearCeiling=false) {

  difference() {
    hull() {

      // Cross-fitting walls
      circle(r=ReceiverOR() + wallTee, $fn=Resolution(20,80));

      // Frame Walls
      FrameIterator()
      Rod2d(rod=FrameRod(), extraWall=wallRod, clearance=rodClearance, $fn=Resolution(20,50));
    }


    // Clear the floor for the lower receiver
    if (clearFloor)
    translate([ReceiverCenter()-0.005,-2])
    square([1,4]);

    // Clear the ceiling
    if (clearCeiling)
    mirror([1,0])
    translate([ReceiverCenter()-0.005,-2])
    square([1,4]);
  }
}

scale(25.4)
render()
difference() {

  rotate([0,90,0])
  linear_extrude(height=1)
  Quadrail2d();

  #Frame();

  translate([-ManifoldGap(),0,0])
  #FrameNuts();
}
