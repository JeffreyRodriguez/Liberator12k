//$t=0.8;
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
use <Striker.scad>;
use <Charger.scad>;

use <Sear.scad>;

use <Reference.scad>;

//function TriggerSpring() = Spec_BicSoftFeelFinePenSpring();
function TriggerSpring() = Spec_BicLighterThumbSpring();


//function SearTowerHeight() = TeeCenter(ReceiverTee()) - 0.35;


function TriggerAngle() = 360/16;
function TriggerWidth() = 0.5;
function TriggerPinX() = -1/4;
function TriggerPinZ() = -TeeCenter(ReceiverTee())-RodRadius(TriggerRod());
function TriggerTravel() = RodDiameter(StrikerRod())*1.5;

function TriggerMaxMajor() = 2.63;

module TriggerSearPinTrack() {
  pinOffset = 0.125;
  searTravel = RodDiameter(StrikerRod());
  pinRadius   = RodRadius(PivotRod(), RodClearanceLoose());
  pinDiameter = pinRadius*2;
  
  translate([0,0,-ReceiverCenter()])
  rotate([-90,0,0])
  linear_extrude(height=1, center=true)
  translate([0,pinOffset])
  polygon([
  
    // Rear elbow, top
    [0, 0],
  
    // Front elbow, top
    [TriggerTravel(), searTravel],
  
    // Front extension top
    [TriggerTravel()+pinRadius, searTravel],
  
    // Front extension bottom
    [TriggerTravel()+pinRadius, pinDiameter+searTravel],
  
    [TriggerTravel(), pinDiameter+searTravel],
  
    [0,pinDiameter],
  
    // Rear extension, bottom
    [-pinRadius,pinDiameter],
    
    // Rear extension, top
    [-pinRadius, 0]
  ]);
}

module TriggerReturnTab(clearance=0, width=0.5, height=0.5, extraDepth=0) {
  
  union() {
    translate([-RodRadius(SearRod()),0,-ReceiverCenter()-1.5])
    translate([0,-(width/2)-clearance,-clearance])
    mirror([1,0,0])
    cube([TriggerTravel()+extraDepth+clearance,width+(clearance*2),height+(clearance*2)]);
  }
}
  

module Trigger(left=true, right=true) {
  triggerFront = 0.35;
  triggerBack = 0.0;
  triggerLength = TriggerTravel()+RodDiameter(SearRod())+triggerFront+triggerBack;
  triggerHeight = 0.6+0.9;
  
  fingerCurveRadius = 0.5;
  
  color("OliveDrab")
  render()
  translate([-(TriggerTravel()*Animate(ANIMATION_STEP_TRIGGER)),0,0])
  translate([(TriggerTravel()*Animate(ANIMATION_STEP_RESET)),0,0]) {

    if (right==true)
    difference() {
      union() {
        translate([-triggerBack-RodRadius(SearRod()),-TriggerWidth()/2,-ReceiverCenter()])
        mirror([0,0,1])
        cube([triggerLength,TriggerWidth(),triggerHeight]);
        
        TriggerReturnTab(extraDepth=triggerBack+0.5);
      }
      
      TriggerSearPinTrack();
      
      // Remove side plate
      translate([-RodRadius(SearRod(),RodClearanceLoose()),
                  RodRadius(SearRod(), RodClearanceLoose()),
                 -ReceiverCenter()-triggerHeight-ManifoldGap()])
      cube([TriggerTravel()+RodDiameter(SearRod(),RodClearanceLoose()),1,triggerHeight+ManifoldGap(2)]);
      
      // Cutout for the side plate rear tab
      translate([-RodRadius(SearRod(),RodClearanceLoose())-TriggerTravel()+0.125,
                  RodRadius(SearRod(), RodClearanceLoose()),
                 -ReceiverCenter()-1.8])
      cube([TriggerTravel()+RodDiameter(SearRod(),RodClearanceLoose()),1,1]);
      
      // Cutout for the side plate front tab
      translate([0,RodRadius(SearRod(), RodClearanceLoose()),-ReceiverCenter()-0.625])
      cube([TriggerTravel()+RodRadius(SearRod(), RodClearanceLoose())+0.125,1,0.25]);
      
      // Bolt Clearance
      translate([0,-RodRadius(SearRod(), RodClearanceLoose()),-ReceiverCenter()-0.25])
      cube([1,1,0.25]);
      
      // Finger curve
      translate([fingerCurveRadius+TriggerTravel()+RodRadius(SearRod())+0.1,
                 0,-ReceiverCenter()-1.05])
      rotate([90,0,0])
      cylinder(r=fingerCurveRadius, h=1, center=true, $fn=Resolution(16,30));
      
      // Sear Hole
      translate([-RodRadius(SearRod(), RodClearanceLoose()),-RodRadius(SearRod(), RodClearanceLoose()),-ReceiverCenter()+ManifoldGap()])
      mirror([0,0,1])
      cube([TriggerTravel()+RodDiameter(SearRod(), RodClearanceLoose()),
            RodDiameter(SearRod(), RodClearanceLoose()), triggerHeight+ManifoldGap(2)]);
    }
  }

}

module TriggerGroup(debug=true) {
    Trigger();
  
    if (debug)
    Striker(debug=debug);

    //DebugHalf(4)
    *Charger();
  
    Sear();
    //!scale(25.4)
    //DebugHalf(3)
    
    if (debug==true)
    %SearGuide(debug=true);
  
    if (debug==true)
    %FiringPinGuide(debug=true);
  
    echo("Striker Travel: ", StrikerTravel());
}

//scale([25.4, 25.4, 25.4])
{

  TriggerGroup();
  *Reference();
  
  echo("ReceiverCenter()-ReceiverIR()",ReceiverCenter());
}

module trigger_plater($t=0) {
  scale([25.4, 25.4, 25.4]) {
    for (i=[[0, SafetyRod()], [1, ResetRod()]])
    translate([i[0],-1/4,0])
    Spindle(pin=i[1], height=0.28, center=false);

    translate([1/8,1/2,1/8])
    rotate([90,0,0])
    Trigger();
  }
}

*!trigger_plater();


*!scale(25.4)
rotate([90,0,0])
Trigger();