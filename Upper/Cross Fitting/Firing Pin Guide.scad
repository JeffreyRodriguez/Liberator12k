include <../../Meta/Animation.scad>;

use <../../Components/Semicircle.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Debug.scad>;
use <../../Components/Firing Pin Retainer.scad>;

use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Reference.scad>;
use <../../Lower/Trigger.scad>;

use <Sear Bolts.scad>;

function FiringPinOffsetX() = BreechRearX()-0.75;
function FiringPinProtrusion() = 3/32;
function FiringPinHeadLength() = 0.4;
function FiringPinLength() = BreechFrontX()
                           + FiringPinProtrusion()
                           - RodRadius(SearRod())
                           -0.125;

module FiringPin() {
  color("Red")
  render(convexity=4)
  translate([FiringPinOffsetX(),0,0])
  rotate([0,90,0])
  union() {

    // Nail Body
    Rod(rod=FiringPinRod(), clearance=RodClearanceLoose(), length=FiringPinLength());

    // Nail Double-Head
    for (i = [0,0.31])
    translate([0,0,i])
    cylinder(r=0.15, h=0.08, $fn=RodFn(FiringPinRod()));
  }
}

module FiringPinGuide(od=ReceiverID()-0.01,
                    debug=false) {
  height = ReceiverLength()
         - PipeThreadDepth(StockPipe())
         - BushingDepth(BreechBushing());
  echo("Firing Pin Guide Length", height);

  if (debug) {
    color("SteelBlue")
    translate([FiringPinOffsetX()+FiringPinHeadLength()-0.125,0,0])
    FiringPinRetainerPins();


    color("SteelBlue")
    FiringPin();
  }


  color("PaleTurquoise",0.5)
  render(convexity=4)
  difference() {

    // Body
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    cylinder(r=od/2, h=height, $fn=Resolution(20,30));

    // Striker Hole
    translate([-0.25,0,0])
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    Rod(rod=StrikerRod(), clearance=RodClearanceLoose(), length=height);

    // Tapered Striker Entrance
    translate([-height+BreechRearX()+RodDiameter(StrikerRod()),0,0])
    rotate([0,-90,0])
    cylinder(r1=RodRadius(StrikerRod()),
             r2=RodRadius(StrikerRod(),RodClearanceLoose())*1.25,
              h=RodDiameter(StrikerRod()),
            $fn=RodFn(StrikerRod()));

    // Scoop out a path for the charging wheel
    translate([BreechRearX()-FiringPinHeadLength(),
               -RodRadius(StrikerRod(), RodClearanceLoose()),
               0])
    mirror([1,0,0])
    cube([height,
          RodDiameter(StrikerRod(), RodClearanceLoose()),
          od]);

    translate([0,0,-ReceiverCenter()])
    SearCutter(searLengthExtra=1);


    translate([FiringPinOffsetX()+FiringPinHeadLength()-0.125,0,0])
    FiringPinRetainer(gap=0.14);

    // Bottom Bolt
    SearBolts(cutter=true);
  }
}

FiringPin();
SearBolts();
FiringPinGuide();

*!scale(25.4) rotate([0,90,0])
FiringPinGuide(debug=false);
