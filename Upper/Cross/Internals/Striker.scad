//$t = 0;

include <../../../Meta/Animation.scad>;

use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;

use <../../../Components/Pipe/Insert.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../Reference.scad>;
use <../../../Lower/Trigger.scad>;


function StrikerRodLength() = 6;
//function StrikerTravel() = ReceiverCenter() - BushingDepth(BreechBushing()) -0.4+RodRadius(SearRod());
//function StrikerTravel() = ReceiverIR()+RodRadius(SearRod())-0.125;
function StrikerTravel() = 0.55;

function StrikerCollarMaxX() = -TeePipeEndOffset(ReceiverTee(),StockPipe())-StrikerTravel();
function StrikerInnerRadius() = RodRadius(StrikerRod(), RodClearanceLoose())*1.02;
function StrikerSpacerRadius() = PipeInnerRadius(pipe=StockPipe(), clearance=PipeClearanceLoose(), clearanceSign=-1)*0.95;
function StrikerSpacerLength() = 3;

function StrikerTopWidth() = 0.5;
function StrikerCollarLength() = 1.5;
function StrikerSpringPreloadLength() = 0.5;
function StrikerSpringLength(extension=0) = 3
                                          - StrikerSpringPreloadLength()
                                          - StrikerTravel()
                                          + (StrikerTravel()*extension);

function StrikerTopExtension() = 0.7;
function StrikerTopLength() = StrikerCollarLength()-0.5
                              +abs(StrikerTravel())+StrikerTopExtension();

function StrikerBoltSpec() = Spec_BoltM3();
function StrikerBoltX() = StrikerCollarMaxX()-0.5;

module StrikerBolt(cutter=true, teardropAngle=0) {
  clearance = cutter ? 1 : 0;

  translate([StrikerBoltX(),0,
             -UnitsMetric(15)+StrikerSpacerRadius()-BoltCapHeight(StrikerBoltSpec())])
  mirror([1,0,0])
  NutAndBolt(bolt=StrikerBoltSpec(), boltLength=UnitsMetric(15),
             capHeightExtra=clearance,
             nutHeightExtra=clearance, nutBackset=0,
             boltLengthExtra=clearance, teardrop=cutter, teardropAngle=teardropAngle);
}

module StrikerTop2d() {
  intersection() {

    // The square we'll actually be using
    rotate(90)
    translate([-StrikerTopWidth()/2,RodRadius(StrikerRod())*sin(45)])
    square([StrikerTopWidth(),ReceiverIR()]);

    // Intersected with a donut shape
    rotate(90)
    difference() {
      circle(r=StrikerSpacerRadius(), $fn=40);
      SquareRod2d(rod=StrikerRod(), clearance=RodClearanceLoose());
    }
  }
}

module StrikerTop() {
  color("Violet")
  render(convexity=4)
  difference() {
    translate([StrikerCollarMaxX()-StrikerCollarLength()+0.5,0,0])
    rotate([0,90,0])
    linear_extrude(height=StrikerTopLength())
    StrikerTop2d();

    StrikerBolt(cutter=true, teardropAngle=90);
  }
}

module StrikerCollar(debug=false) {
  color("Magenta")
  render(convexity=4)
  difference() {

    // Body
    translate([-TeePipeEndOffset(ReceiverTee(),StockPipe())-StrikerTravel(),0,0])
    rotate([0,-90,0])
    difference() {
      cylinder(r=StrikerSpacerRadius(),
               h=StrikerCollarLength(),
                $fn=Resolution(20,40));

      linear_extrude(height=StrikerCollarLength()-0.5) {

        // Striker Top
        mirror([1,0])
        offset(r=0.01)
        StrikerTop2d();

        // Clear the tips from the top
        translate([(StrikerSpacerRadius()*sin(45))-0.05,
                   -StrikerSpacerRadius()])
        square([StrikerSpacerRadius()*2,
                 StrikerSpacerRadius()*2]);
      }
    }

    StrikerBolt(cutter=true, teardropAngle=180);

    // Rod Hole
    rotate([0,-90,0])
    SquareRod(rod=StrikerRod(), clearance=RodClearanceLoose(), length=StrikerCollarLength()*2);
  }
}

module StrikerSpacer(length=3, rodClearance=RodClearanceLoose()) {
  render()
  linear_extrude(height=length) {
    PipeInsert2d(pipeSpec=StockPipe(), pipeClearance=PipeClearanceLoose())
    SquareRod2d(rod=StrikerRod(), clearance=rodClearance);
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

module Striker(length=StrikerRodLength()) {

  // Mock Spring
  *color("SteelBlue")
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
    SquareRod(StrikerRod(), length=length);

    StrikerCollar();
    StrikerTop();
  }
}

module StrikerJig(width=1, height=0.75) {
  difference() {
    translate([-RodRadius(SearRod()),-width/2,-RodRadius(StrikerRod())-0.125])
    mirror([1,0,0])
    cube([abs(StrikerBoltX())+0.25,width,height]);

    translate([StrikerBoltX(),0,-1])
    Bolt(bolt=StrikerBoltSpec(), cutter=true,
         teardrop=true, teardropAngle=180,
         length=3);

    // Striker rod hole
    translate([ManifoldGap(),0,0])
    rotate([0,-90,0])
    SquareRod(rod=StrikerRod(),
        //teardrop=true, teardropTruncated=false,
        clearance=RodClearanceLoose(),
        length=StrikerCollarLength()*2);


    // Set screw hole
    translate([-0.5,0,0])
    NutAndBolt(bolt=StrikerBoltSpec(),
            teardrop=true, teardropAngle=180,
            nutBackset=RodRadius(StrikerRod()),
            nutHeightExtra=RodRadius(StrikerRod()),
    length=3);
  }
}

//!scale(25.4)rotate([0,90,0]) translate([RodRadius(SearRod()),0,0])
*%StrikerJig(width=0.75);

*!scale(25.4)
rotate([90,0,0])
translate([0,RodRadius(StrikerRod()),0])
StrikerTop();

*!scale(25.4)
rotate([0,-90,0])
translate([-StrikerCollarMaxX()+StrikerCollarLength(),0,0])
StrikerCollar();

*!scale(25.4) StrikerSpacer();

Striker(debug=true);

translate([ButtTeeCenterX(),0,0]) {

  // Striker Foot
  translate([TeePipeEndOffset(ReceiverTee(),StockPipe()),0,0])
  rotate([0,90,180])
  StrikerFoot();

  // Striker Spacers
  for (i = [0,1,2])
  color([0.2*(4-i),0.2*(4-i),0.2*(4-i), 0.5]) // Some colorization
  translate([TeePipeEndOffset(ReceiverTee(),StockPipe())
             +(StrikerSpacerLength()*i)
             +ManifoldGap(1+i),0,0])
  rotate([0,90,0])
  StrikerSpacer(length=StrikerSpacerLength(), alpha=0.5);
}

color("black", 0.25)
*Reference();
