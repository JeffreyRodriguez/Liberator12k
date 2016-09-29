//$t = 0;

include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

use <../../Components/Pipe Insert.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Reference.scad>;
use <../../Lower/Trigger.scad>;


function StrikerRodLength() = StockLength();
//function StrikerTravel() = ReceiverCenter() - BushingDepth(BreechBushing()) -0.4+RodRadius(SearRod());
function StrikerTravel() = ReceiverIR()+RodRadius(SearRod())-0.125;
function StrikerCollarMaxX() = -TeePipeEndOffset(ReceiverTee(),StockPipe())-StrikerTravel();
function StrikerInnerRadius() = RodRadius(StrikerRod(), RodClearanceLoose())*1.02;
function StrikerSpacerRadius() = 0.34;
function StrikerSpacerLength() = 3;

function StrikerCollarLength() = 3.5;
function StrikerSpringPreloadLength() = 0.5;
function StrikerSpringLength(extension=0) = 3
                                          - StrikerSpringPreloadLength()
                                          - StrikerTravel()
                                          + (StrikerTravel()*extension);

function StrikerBoltSpec() = Spec_BoltM3();

module StrikerBolt(cutter=true, teardropAngle=0) {
  clearance = cutter ? 1 : 0;
  boltsArray = [
    0.75,
    (StrikerCollarLength()/2),
    StrikerCollarLength()-0.75
  ];

  for (boltOffsetX = boltsArray)
  translate([StrikerCollarMaxX()-boltOffsetX,0,
             -UnitsMetric(14)+StrikerSpacerRadius()-BoltCapHeight(StrikerBoltSpec())])
  NutAndBolt(bolt=StrikerBoltSpec(), boltLength=UnitsMetric(14),
             capHeightExtra=clearance,
             nutHeightExtra=clearance, nutBackset=0,
             boltLengthExtra=clearance, teardrop=cutter, teardropAngle=teardropAngle);
}

module StrikerTop() {
  length = StrikerCollarLength()
         + StrikerTravel()
         + TeePipeEndOffset(ReceiverTee(),StockPipe());
  
  length = StrikerCollarLength()+abs(StrikerTravel())+ReceiverIR()+0.1;
  
  color("Violet", 0.5)
  render(convexity=4)
  difference() {
    translate([StrikerCollarMaxX()-StrikerCollarLength(),0,0])
    //mirror([1,0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    intersection() {

      // The square we'll actually be using
      rotate(90)
      translate([-RodRadius(StrikerRod()),RodRadius(StrikerRod())*0.7])
      square([RodDiameter(StrikerRod()),ReceiverIR()]);

      // Intersected with a donut shape
      rotate(90)
      difference() {
        circle(r=StrikerSpacerRadius(), $fn=20);
        Rod2d(StrikerRod());
      }
    }

    StrikerBolt(cutter=true,teardropAngle=90);
  }
}

module StrikerCollar(debug=false) {
  color("Magenta", 0.5)
  render(convexity=4)
  difference() {

    // Body
    translate([-TeePipeEndOffset(ReceiverTee(),StockPipe())-StrikerTravel(),0,0])
    rotate([0,-90,0])
    linear_extrude(height=StrikerCollarLength())
    difference() {
      circle(r=StrikerSpacerRadius(),
           $fn=Resolution(20,30));

      // Cap Hole
      translate([0,-RodRadius(StrikerRod(), clearance=RodClearanceLoose())])
      square(StrikerSpacerRadius());

      // Rod Hole
      Rod2d(StrikerRod(), RodClearanceLoose());
    }
    StrikerBolt(cutter=true, teardropAngle=180);
  }
}

module StrikerSpacer(length=3, rodClearance=RodClearanceLoose()) {
  render()
  linear_extrude(height=length) {
    PipeInsert2d(pipeSpec=StockPipe(), pipeClearance=PipeClearanceLoose())
    Rod2d(rod=StrikerRod(), clearance=rodClearance);
  };
}

module StrikerFoot() {
  color("Olive", 0.7)
  render(convexity=4)
  difference() {
    cylinder(r=TeeInnerRadius(ReceiverTee()),
             h=TeePipeEndOffset(ReceiverTee(),StockPipe())
               + TeeInnerRadius(ReceiverTee()),
           $fn=Resolution(20,40));

    // Round the top
    translate([0,0,TeePipeEndOffset(ReceiverTee(),StockPipe())])
    difference() {
      translate([-TeeCenter(ReceiverTee()), -TeeCenter(ReceiverTee())])
      cube([TeeWidth(ReceiverTee()),TeeWidth(ReceiverTee()),TeeWidth(ReceiverTee())]);

      rotate([0,90,0])
      cylinder(r=TeeInnerRadius(ReceiverTee()),
                h=TeeCenter(ReceiverTee()),
                center=true,
                $fn=Resolution(20,40));
    }

    // Striker Rod Hole
    translate([0,0,-0.1])
    cylinder(r=StrikerInnerRadius(),
             h=TeeWidth(ReceiverTee()) + 0.2,
           $fn=RodFn(StrikerRod()));

    // Striker Rod Hole Taper
    translate([0,0,-0.01])
    cylinder(r1 =StrikerInnerRadius(),
             r2 =StrikerInnerRadius(),
             h  =RodDiameter(StrikerRod()),
             $fn=RodFn(StrikerRod()));
  }
}

module Striker() {

  // Mock Spring
  color("SteelBlue")
  translate([StrikerCollarMaxX()-StrikerCollarLength(),0,0])
  rotate([0,-90,0])
  cylinder(r=StrikerSpacerRadius(),
            h=StrikerSpringLength(Animate(ANIMATION_STEP_STRIKER)),
          $fn=10);

  // Striker Collar and Top
  translate([StrikerTravel()*(Animate(ANIMATION_STEP_STRIKER)),0,0])
  translate([-StrikerTravel()*(Animate(ANIMATION_STEP_CHARGE)),0,0])
  {
    StrikerBolt(cutter=false);

    // Mock Striker Rod
    color("Orange")
    translate([-RodRadius(SearRod()),0,0])
    rotate([0,-90,0])
    Rod(FrameRod(), length=StrikerRodLength());
    
    StrikerTop();
    StrikerCollar();
  }

  translate([ButtTeeCenterX(),0,0]) {

    // Striker Foot
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe()),0,0])
    rotate([0,90,180])
    StrikerFoot();

    // Striker Spacers
    for (i = [0,1])
    color([0.2*(4-i),0.2*(4-i),0.2*(4-i)]) // Some colorization
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe())
               +(StrikerSpacerLength()*i)
               +ManifoldGap(1+i),0,0])
    rotate([0,90,0])
    StrikerSpacer(length=StrikerSpacerLength());
  }
}

*!scale(25.4)
rotate([90,0,0])
translate([0,RodRadius(StrikerRod()),0])
StrikerTop();

*!scale(25.4)
rotate([0,90,0])
translate([-StrikerCollarMaxX(),0,0])
StrikerCollar();

*!scale(25.4) StrikerSpacer();

Striker(debug=true);

color("black", 0.25)
*Reference();
