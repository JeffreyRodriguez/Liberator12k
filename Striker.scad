//$t = 0.99;

include <Meta/Animation.scad>;

use <Meta/Debug.scad>;
use <Meta/Manifold.scad>;
use <Meta/Resolution.scad>;
use <Components/Pipe Insert.scad>;

use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

use <Reference.scad>;
use <Lower/Trigger.scad>;


function StrikerRodLength() = StockLength();
function StrikerTravel() = ReceiverCenter() - BushingDepth(BreechBushing())
                           -0.4;
function StrikerX() = -TeePipeEndOffset(ReceiverTee(),StockPipe())-(StrikerTravel()*(1+Animate(ANIMATION_STEP_CHARGE)));
function StrikerInnerRadius() = RodRadius(StrikerRod(), RodClearanceLoose())*1.02;
function StrikerSpacerRadius() = 0.34;
function StrikerSpacerLength() = 3;

function StrikerCollarLength() = RodDiameter(StrikerRod())*2;
function StrikerSpringPreloadLength() = StrikerCollarLength();
function StrikerSpringLength(extension=0) = 3
                                          - StrikerSpringPreloadLength()
                                          + (StrikerTravel()*extension);

module StrikerTop() {
  color("Violet")
  render(convexity=4)
  translate([StrikerX()-StrikerCollarLength(),0,0])
  rotate([0,90,0])
  linear_extrude(height=StrikerCollarLength()
                       +TeePipeEndOffset(ReceiverTee(),StockPipe())
                       +ReceiverIR()
                       -RodDiameter(SearRod()))
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
}

module StrikerCollar(debug=true) {

  if (debug==true)
  translate([-StrikerTravel()*(1+Animate(ANIMATION_STEP_CHARGE)),0,0]) {

    // Mock Striker Rod
    color("Orange")
    translate([BreechRearX()-0.4-RodRadius(SearRod()),0,0])
    rotate([0,-90,0])
    Rod(FrameRod(), length=StrikerRodLength());
  }

  // Mock Spring
  color("White", 0.5)
  translate([StrikerX(),0,0])
  rotate([0,-90,0])
  cylinder(r=StrikerSpacerRadius(),
            h=StrikerSpringLength(Animate(ANIMATION_STEP_STRIKER)),
          $fn=10);

  color("Magenta")
  render(convexity=4)
  difference() {

    // Body
    translate([StrikerX(),0,0])
    rotate([0,-90,0])
    linear_extrude(height=StrikerCollarLength())
    difference() {
      circle(r=StrikerSpacerRadius(),
           $fn=Resolution(20,30));

      // Cap Hole
      translate([0,-RodRadius(StrikerRod(), clearance=RodClearanceLoose())])
      square(RodDiameter(StrikerRod(), clearance=RodClearanceLoose()));

      // Rod Hole
      Rod2d(StrikerRod(), RodClearanceLoose());
    }
  }
}

module StrikerSpacer(length=2, rodClearance=RodClearanceLoose()) {
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

module Striker(debug=true) {

  // Striker Collar and Top
  translate([StrikerTravel()*(Animate(ANIMATION_STEP_STRIKER)),0,0]) {
    StrikerTop();
    StrikerCollar(debug=debug);
  }

  translate([ButtTeeCenterX(),0,0]) {

    // Striker Foot
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe()),0,0])
    rotate([0,90,180])
    StrikerFoot();

    // Striker Spacers
    for (i = [0,1,2])
    color([0.2*(4-i),0.2*(4-i),0.2*(4-i)]) // Some colorization
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe())
               +(StrikerSpacerLength()*i)
               +ManifoldGap(1+i),0,0])
    rotate([0,90,0])
    StrikerSpacer(length=StrikerSpacerLength());
  }
}

//!scale(25.4) rotate([90,0,0]) StrikerTop();

{
  Striker();

  //rotate([90,0,0]) StrikerTop();
  //DebugHalf(dimension=50)
  *color("black", 0.25)
  %Reference();
}
