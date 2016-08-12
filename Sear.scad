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


use <Reference.scad>;

use <Sear Bolts.scad>;

function SearOffsetX() = 0;
function SearPinOffsetZ() = -ReceiverCenter()-0.125-RodRadius(PivotRod());
function SearYokeWidth() = ReceiverID() - RodDiameter(SearRod()) -0.125; // Leave a sixteenth inch on each side (roughly)

function SearTravel() = RodDiameter(StrikerRod());


function SearLength() = ReceiverCenter()+RodRadius(StrikerRod())+0.6+0.9-0.3125;
module Sear(clearance=undef) {
  
  // Sear Rod
  translate([SearOffsetX(),0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,SearTravel()*Animate(ANIMATION_STEP_RESET)])
  translate([SearOffsetX(),0,0])
  mirror([0,0,1])
  color("LightGreen")
  translate([0,0,-RodRadius(StrikerRod())])
  Rod(rod=SearRod(), length=SearLength());
  
  translate([0,0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,SearTravel()*Animate(ANIMATION_STEP_RESET)])
  translate([0,0,SearPinOffsetZ()])
  rotate([90,0,0])
  color("Red")
  %Rod(rod=PivotRod(), length=0.5, center=true);
}

module SearGuide() {
  
  %SearBolts();
  
  color("LightSeaGreen", 0.5)
  render(convexity=4)
  translate([0,0,-ReceiverCenter()])
  difference() {
    ReceiverInsert(topFactor=0.6);
    
    // Sear hole
    translate([SearOffsetX(),0,-0.5-ManifoldGap()])
    cylinder(r=RodRadius(SearRod(), RodClearanceLoose()),
             length=ReceiverLength()+0.5,
             $fn=RodFn(SearRod()));
    
    translate([0,0,ReceiverCenter()])
    SearBolts(cutter=true);
  }
}

scale([25.4, 25.4, 25.4])
{
  %Sear();
  
  //DebugHalf(3)
  
  SearGuide();
  
  
  *Reference();
}
