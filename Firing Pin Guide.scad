include <Components/Animation.scad>;

use <Components/Semicircle.scad>;
use <Components/Manifold.scad>;
use <Components/Debug.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;

use <Reference.scad>;


function FiringPinProtrusion() = 3/32;
function FiringPinHeadLength() = 0.4;
function FiringPinLength() = BushingHeight(BreechBushing())
                           + FiringPinProtrusion()
                           + FiringPinHeadLength();



module FiringPinGuideScrew(nutHeight=0.1) {

  // M3 Nut and Screw Hole
  translate([-ReceiverIR()/2,0,-RodRadius(StrikerRod())])
  mirror([0,0,1])
  union() {
    cylinder(r=0.065, h=1.282, $fn=5);

    // Nut Slot
    translate([0,0,-RodRadius(StrikerRod())])
    rotate(90)
    cylinder(r=0.15, h=nutHeight+RodRadius(StrikerRod()), $fn=6);
  }
}

module FiringPin() {
  color("Red")
  render(convexity=4)
  translate([BreechFrontX() - FiringPinLength()+FiringPinProtrusion(),0,0])
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

module FiringPinGuide(od=ReceiverID(),
                    debug=true) {
  height = ReceiverLength()
         - PipeThreadDepth(StockPipe())
         - BushingDepth(BreechBushing());

  if (debug==true)
  color("Red")
  FiringPin();

  color("PaleTurquoise",0.5)
  render(convexity=4)
  difference() {

    // Body
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    linear_extrude(height=height)
    difference() {
      circle(r=od/2,
           $fn=Resolution(20,30));

      // Striker Hole
      Rod2d(rod=StrikerRod(), clearance=RodClearanceLoose());
    }

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

    // Sear Hole
    mirror([0,0,1])
    translate([RodRadius(SearRod()),0,-RodRadius(StrikerRod())*0.9])
    Rod(rod=SearRod(), clearance=RodClearanceLoose(), length=(od/2)+(RodRadius(StrikerRod())*0.9));

    // Firing Pin Retaining Pin Holes
    for (i=[1,-1])
    translate([BreechRearX()-0.3,0,
               RodDiameter(FiringPinRod(),RodClearanceLoose())*i*1.23])
    rotate([90,0,0])
    Rod(FiringPinRod(), RodClearanceLoose(), length=1, center=true);

    // Bottom Bolt
    FiringPinGuideScrew();
  }
}

//scale(25.4) rotate([0,90,0])
FiringPinGuide(debug=false);
