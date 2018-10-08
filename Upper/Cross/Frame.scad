use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

use <../../Shapes/Teardrop.scad>;

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

module FrameRod(length=FrameRodLength(),
                clearance=RodClearanceLoose(),
                rodFnAngle=90,
                nutHeight=FrameNutHeight(),
                nutRadius=0.25,
                washerHeight=DEFAULT_WASHER_HEIGHT,
                washerDiameter=0.65, washerHeight=0.07) {

  translate([ReceiverLugRearMinX(),0,0]) {
    
    // Rod
    rotate([0,90,0])
    translate([0,0,ManifoldGap()])
    Rod(rod=FrameRod(), length=length -ManifoldGap(2), clearance=clearance);
                     
    // Nuts
    %color("DimGrey") {
      
      // Front
      translate([length,0,0])
      rotate([0,-90,0])
      cylinder(r=nutRadius, h=nutHeight, $fn=6);
      
      // Rear
      translate([-washerHeight,0,0])
      rotate([0,-90,0])
      cylinder(r=nutRadius, h=nutHeight, $fn=6);
    }
                     
    // Washers
    %color("Silver") {
      
      // Front
      translate([length-washerHeight-nutHeight,0,0])
      rotate([0,90,0])
      cylinder(r=washerDiameter/2, h=washerHeight, $fn=20);
      
      // Rear
      rotate([0,-90,0])
      cylinder(r=washerDiameter/2, h=washerHeight, $fn=20);
    }
  }
}

module FrameIterator(mXY = [[0,1],[0,1]]) {
  for (mX = mXY[0]) mirror([mX, 0])
  for (mY = mXY[1]) mirror([0, mY])
  translate([ReceiverCenter() - RodRadius(FrameRod()) - WallFrameRod(),
             TeeRimRadius(ReceiverTee())+RodRadius(FrameRod())])
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
                         washerHeight=DEFAULT_WASHER_HEIGHT,
                        alpha=1) {
  translate([ReceiverLugFrontMaxX()+ManifoldGap(),0,0]) {

    color("LightSlateGrey", alpha)
    translate([washerHeight,0,0])
    FrameNuts(nutHeight=length);

    // Washers
    for (X = [ManifoldGap(2), length+washerHeight+ManifoldGap(3)])
    translate([X,0,0])
    FrameWashers(washerHeight=washerHeight);
  }
}

module Quadrail2d(rod=Spec_RodFiveSixteenthInch(), rodClearance=RodClearanceLoose(),
                  bodyRadius=ReceiverOR()+WallTee(),
                  wallRod=WallFrameRod(),
                  flatAngles=[0,180],
                  flatClearance=0.005,
                  scallopAngles=[], //[90,-90],
                  scallopOffset=ReceiverOR()+WallTee(),
                  scallopRadius=1.125,
                  $fn=Resolution(20, 60)) {
  difference() {
    hull() {

      // Cross-fitting walls
      circle(r=bodyRadius, $fn=Resolution(20,80));

      // Frame Walls
      FrameIterator()
      Rod2d(rod=FrameRod(), extraWall=wallRod, clearance=rodClearance, $fn=Resolution(20,50));

      children();
    }


    // Flat angles
    for (flatAngle = flatAngles)
    rotate(flatAngle)
    translate([ReceiverCenter()-flatClearance-ManifoldGap(),-2])
    square([1,4]);

    // Scallops
    for (scallopAngle = scallopAngles)
    rotate(scallopAngle)
    translate([scallopRadius+scallopOffset,0])
    for (m = [0,1]) mirror([0,m])
    rotate(90+(45/2))
    Teardrop(r=scallopRadius);
  }
}

//scale(25.4)
render() {
  FrameCouplingNuts();

  translate([ReceiverLugRearMinX(),0,0]) {
    %Frame();

    translate([-ManifoldGap(),0,0])
    mirror([1,0,0])
    %FrameNuts(washers=true);

    %rotate([0,90,0])
    linear_extrude(height=1)
    Quadrail2d();
  }
  
  Reference();
}


FrameRod();
