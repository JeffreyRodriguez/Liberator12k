use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

use <../../Lower/Receiver Lugs.scad>;

use <Reference.scad>;

DEFAULT_WASHER_HEIGHT       = UnitsImperial(0.07);
DEFAULT_COUPLING_NUT_LENGTH = UnitsImperial(1);

function FrameRodLength() = 10;
function FrameNutHeight() = 0.25;
function FrameWasherHeight() = DEFAULT_WASHER_HEIGHT;
function OffsetFrameRod() = 0.4;
function OffsetFrameBack() = ReceiverLugRearMinX();
function FrameRodMatchedAngle() = 45;

function FrameCouplingNutLength(nutLength=DEFAULT_COUPLING_NUT_LENGTH,
                                washerHeight=DEFAULT_WASHER_HEIGHT) = nutLength+(washerHeight*2)+ManifoldGap(3);

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

module Frame(clearance=RodClearanceLoose(),
             length=FrameRodLength(),
             rodFnAngle=90) {

  color("SteelBlue")
  render(convexity=4)
  rotate([0,90,0])
  linear_extrude(height=length)
  FrameRods(clearance=clearance);
}

module FrameNuts(nutHeight=FrameNutHeight(),
                 nutRadius=0.25,
                 washers=false,
                 washerHeight=DEFAULT_WASHER_HEIGHT) {

  color("DarkGoldenrod")
  translate([washers ? washerHeight : 0,0,0])
  rotate([0,90,0])
  FrameIterator()
  cylinder(r=nutRadius, h=nutHeight, $fn=6);

  if (washers)
  FrameWashers();
}

module FrameWashers(washerDiameter=0.65, washerHeight=0.07) {
  color("Silver")
  rotate([0,90,0])
  FrameIterator()
  cylinder(r=washerDiameter/2, h=washerHeight, $fn=12);
}

module FrameCouplingNuts(length=DEFAULT_COUPLING_NUT_LENGTH,
                         washerHeight=DEFAULT_WASHER_HEIGHT) {
  translate([ReceiverLugFrontMaxX()+ManifoldGap(),0,0]) {

    color("LightSlateGrey")
    translate([washerHeight,0,0])
    FrameNuts(nutHeight=length);

    // Washers
    for (X = [ManifoldGap(2), length+washerHeight+ManifoldGap(3)])
    translate([X,0,0])
    FrameWashers(washerHeight=washerHeight);
  }
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

  FrameCouplingNuts();

  translate([-ManifoldGap(),0,0])
  mirror([1,0,0])
  %FrameNuts(washers=true);

  *%rotate([0,90,0])
  linear_extrude(height=1)
  Quadrail2d();
}
