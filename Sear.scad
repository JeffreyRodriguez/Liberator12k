//$t=0.999999999;
//$t=0;
include <Components/Animation.scad>;

use <Components/Manifold.scad>;
use <Components/Debug.scad>;
use <Components/Semicircle.scad>;
use <Components/Spindle.scad>;
use <Components/Receiver Insert.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Spring.scad>;

use <Firing Pin Guide.scad>;

use <Reference.scad>;

function SearOffsetX() = -RodRadius(SearRod());
function SearYokeWidth() = ReceiverID() - RodDiameter(SearRod()) -0.125; // Leave a sixteenth inch on each side (roughly)

function SearTravel() = RodRadius(StrikerRod(), RodClearanceLoose());
module Sear(clearance=undef) {
  // Sear Rod
  translate([SearOffsetX(),0,-RodDiameter(StrikerRod())*Animate(ANIMATION_STEP_TRIGGER)])
  mirror([0,0,1])
  color("Orange")
  translate([0,0,-RodRadius(StrikerRod())])
  Rod(rod=SearRod(),
   length=TeeCenter(ReceiverTee())-RodRadius(StrikerRod()));
}

module SearYoke() {
  translate([SearOffsetX(),0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  // Sear Arm
  color("Lime", 0.25)
  render(convexity=4)
  
  mirror([0,0,1])
  difference() {
      
    // Main bar
    translate([0,-SearYokeWidth()/2,ReceiverIR()])
    cube([RodDiameter(SearRod()),
          SearYokeWidth(),
          TeeCenter(ReceiverTee())-ReceiverIR() +RodRadius(StrikerRod())+0.25]);
    
    // Sear Rod Cutout
    translate([0,0,-RodRadius(StrikerRod())-ManifoldGap()])
    Rod(rod=SearRod(),
  clearance=RodClearanceLoose(),
     length=TeeCenter(ReceiverTee())+RodRadius(StrikerRod()));
    
    // Trigger-interface rod
    translate([0,0,TeeCenter(ReceiverTee())+0.25])
    rotate([90,0,0])
    Rod(PivotRod(), center=true);
    
    // Trigger bar cutout
    translate([-1,-0.13,ReceiverCenter()-RodDiameter(StrikerRod())])
    cube([2,0.26, RodDiameter(StrikerRod())+0.25+RodRadius(PivotRod())]);
    
  }
}



module SearGuide() {
  
  color("LightSeaGreen", 0.5)
  render(convexity=4)
  translate([0,0,-ReceiverCenter()])
  difference() {
    ReceiverInsert(topFactor=0.8);
    
    // Sear hole
    translate([-RodRadius(SearRod()),0,-ManifoldGap()])
    cylinder(r=RodRadius(SearRod(), RodClearanceLoose()),
        length=ReceiverLength(),
           $fn=RodFn(SearRod()));
    
    // Sear yoke slot
    translate([-RodDiameter(SearRod())-0.02,-(SearYokeWidth()/2)-0.01, -ManifoldGap()])
    cube([RodDiameter(SearRod())+0.04, SearYokeWidth()+0.02, TeeCenter(ReceiverTee())+ManifoldGap(2)]);
    
    // Sear Yoke Retaining Tab
    translate([-0.01,-0.13, ReceiverCenter()-ManifoldGap()])
    mirror([0,0,1])
    mirror([1,0,0])
    *cube([0.25, 0.26, ReceiverIR()+0.25+RodDiameter(SearRod(), RodClearanceLoose())]);
    
    translate([0,0,ReceiverCenter()])
    FiringPinGuideScrew();
  }
}

scale([25.4, 25.4, 25.4])
{
  
  //DebugHalf(3)
  SearGuide();
  
  //!scale(25.4) rotate([90,0,0])
  *SearYoke();
  
  Sear();
  
  *Reference();
}
