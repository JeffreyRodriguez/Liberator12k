include <Components/Animation.scad>;

use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;

function StrikerX() = -TeeInnerRadius(ReceiverTee());
function StrikerRod() = Spec_RodFiveSixteenthInch();
function StrikerRadius() = 0.34;
function StrikerInnerRadius(clearance=RodClearanceLoose()) = RodRadius(rod=StrikerRod(), clearance=clearance);

function StrikerSpringPreloadLength() = 0.5;
function StrikerFaceLength() = 3.45;
function StrikerDepressorLength() = 3.45;
function FiringPinDepth() = 0.85;

function FiringPinGuideHeight() = (TeeWidth(ReceiverTee())/2)-BushingDepth(BreechBushing());
function FiringPinLength() = FiringPinDepth()
                             + abs(StrikerX())
                             + FiringPinGuideHeight()
                             + (1/16);

function SpringCapLength() = 0.1;

function StrikerSpringLength(extension=0) = (3-StrikerSpringPreloadLength())
                                            - (StrikerX()*extension);

function StrikerSpacerLength() = abs(ButtTeeCenterX())
                               - TeePipeEndOffset(ReceiverTee(),StockPipe())
                               - StrikerFaceLength()
                               + SpringCapLength()
                               - StrikerSpringLength(1)
                               - StrikerDepressorLength()
                               - ManifoldGap(3);

function SearTowerHeight() = TeeCenter(ReceiverTee()) - 0.35;

module FiringPin() {
  Rod(rod=FiringPinRod(), clearance=RodClearanceLoose(), length=FiringPinLength());
}

module FiringPinGuide(height=FiringPinGuideHeight(),
                      od=TeeInnerDiameter(ReceiverTee())) {
  offsetX = (TeeWidth(ReceiverTee())/2) -BushingDepth(BreechBushing());

  color("Lime")
  render(convexity=4)
  difference() {
    translate([offsetX,0,0])
    rotate([0,-90,0])
    cylinder(r=od/2, h=height, $fn=RodFn(FiringPinRod())*Resolution(2, 4));

    // Tapered Entrance
    translate([offsetX-height+(1/16)-0.01,0,0])
    rotate([0,-90,0])
    cylinder(r1=RodRadius(FiringPinRod()),
             r2=RodRadius(FiringPinRod())*1.4,
              h=1/16,
            $fn=RodFn(FiringPinRod()));

    // Firing Pin Hole
    translate([offsetX+0.1,0,0])
    rotate([0,-90,0])
    Rod(rod=FiringPinRod(), length=height+0.2, clearance=RodClearanceLoose());

    // Scoop out a path for the charging handle
    translate([-0.01,
               -RodRadius(StrikerRod(), RodClearanceLoose()),
               RodRadius(FiringPinRod())*2])
    rotate([0,-10,0])
    cube([RodDiameter(StrikerRod())+0.11,
          RodDiameter(StrikerRod(),
          RodClearanceLoose()),1]);

    // Clearance for the sear
    translate([-0.01,-0.26/2,-0.3])
    rotate([0,35,0])
    mirror([0,0,1])
    cube([RodDiameter(StrikerRod())+0.11,0.26,1]);

    // Clear the top of the sear and it's support towers
    translate([0,0,-TeeCenter(ReceiverTee())])
    cylinder(r=TeeInnerRadius(ReceiverTee())+0.01, h=SearTowerHeight(), $fn=20);
  }
}



module Striker() {
  
  echo("StrikerRadius", StrikerRadius());
  echo("StrikerSpacerLength", StrikerSpacerLength());


  translate([StrikerX()* (1-Animate(ANIMATION_STEP_STRIKER)),0,0])
  rotate([0,-90,0])
  {

    // Mock Striker Rod
    color("White")
    translate([0,0,FiringPinDepth()])
    %Rod(FrameRod(), length=12);

    // Striker Face
    StrikerFace();

    // Position the spring
    translate([0,0,StrikerFaceLength()-(SpringCapLength()/2)]) {
        
      // Mock Spring
      color("Silver", 0.75)
      %cylinder(r=StrikerRadius(),
                h=StrikerSpringLength(Animate(ANIMATION_STEP_STRIKER)),
                $fn=10);
      
      // Striker Depressor
      translate([0,0,StrikerSpringLength(Animate(ANIMATION_STEP_STRIKER)) - (SpringCapLength()/2) + StrikerDepressorLength()])
      mirror([0,0,1])
      StrikerDepressor();
    }
  }
  
  
  translate([ButtTeeCenterX(),0,0]) {

    // Striker Foot
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe()),0,0])
    rotate([0,90,180])
    StrikerFoot();

    // Striker Spacer
    translate([TeePipeEndOffset(ReceiverTee(),StockPipe())+ManifoldGap(),0,0])
    rotate([0,90,0])
    StrikerSpacer(length=StrikerSpacerLength());
  }

}

module StrikerFace(length=StrikerFaceLength(),
                   od=StrikerRadius()*2,
                   id=StrikerInnerRadius(RodClearanceSnug()),
               firingPin = Spec_RodOneEighthInch(),
               depth=FiringPinDepth()) {

  difference() {
    // Body
    color("Orange")
    StrikerSpringCap(baseLength=length-SpringCapLength(), rodOffsetZ=FiringPinDepth());
    
    // Firing Pin
    translate([0,0,FiringPinDepth()+ManifoldGap()])
    mirror([0,0,1])
    #FiringPin();
  }
}

module StrikerDepressor($fn=RodFn(StrikerRod())*Resolution(1, 2)) {
  color("Purple")
  StrikerSpringCap(baseLength=StrikerDepressorLength()-SpringCapLength(), $fn=$fn);
}

module StrikerSpacer(length=2, $fn=RodFn(StrikerRod())*Resolution(1, 2)) {
    color("Pink")
    StrikerSpringCap(baseLength=length, cap_length=0, $fn=$fn);
}

module StrikerFoot() {
  color("Olive", 0.7)
  difference() {
    cylinder(r=TeeInnerRadius(ReceiverTee()),
             h=TeePipeEndOffset(ReceiverTee(),StockPipe()) + TeeInnerRadius(ReceiverTee()),
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
    cylinder(r1 =NozzleMultipleCeiling(StrikerInnerRadius()+0.05),
             r2 =StrikerInnerRadius(),
             h  =RodDiameter(StrikerRod()),
             $fn=RodFn(StrikerRod()));
  }
}

module StrikerSpringCap(baseLength=0.25,
                        cap_length=SpringCapLength(),
                        wall=NozzleDiameter()*2,
                        rodOffsetZ=-ManifoldGap(),
                        clearance=RodClearanceLoose(),
                        $fn=RodFn(StrikerRod())*Resolution(1, 2)) {
  difference() {
    union() {
      if (baseLength > 0)
      cylinder(r=StrikerRadius(), h=baseLength+ManifoldGap());

      if (cap_length > 0)
      translate([0,0,baseLength])
      cylinder(r1=StrikerRadius(), r2=StrikerInnerRadius(clearance)+wall, h=cap_length);
    }

    // Rod
    translate([0,0,rodOffsetZ])
    cylinder(r=StrikerInnerRadius(clearance),
             h=baseLength + cap_length + 0.2,
             $fn=RodFn(StrikerRod()));
  }
}

//translate([0,50,0])
scale([25.4, 25.4, 25.4]) {
  FiringPinGuide();
  Striker();

  Reference();
}
