//$t=0.8;
//$t=0;
include <Components/Animation.scad>;

use <Components/Manifold.scad>;
use <Components/Debug.scad>;
use <Components/Spindle.scad>;

use <Vitamins/Nuts And Bolts.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Spring.scad>;

use <Grip Tabs.scad>;

use <Reference.scad>;

//function TriggerSpring() = Spec_BicSoftFeelFinePenSpring();
function TriggerSpring() = Spec_BicLighterThumbSpring();

function SearPinOffsetZ() = GripOffsetZ()-0.33;
function SearOverTravel() = -0.75;
function SearLength() = ReceiverCenter()+0.6+0.9+SearOverTravel();

function SearTravel() = 0.25; //RodDiameter(StrikerRod());



function GripTriggerFingerSlotDiameter() = 0.9;
function GripTriggerFingerSlotRadius() = GripTriggerFingerSlotDiameter()/2;
function GripTriggerFingerSlotOffsetZ() = GripFloorZ() -GripTriggerFingerSlotRadius();
function GripTriggerFingerSlotWall() = 0.25;

function GripBottomZ() = GripFloorZ()-GripTriggerFingerSlotDiameter();

function TriggerWidth() = 0.45;
function TriggerTravel() = SearTravel()*1.5;

function TriggerBoltSpec() = Spec_BoltM3();
function TriggerBoltX() = -0.5;
function TriggerBoltZ() = GripFloorZ()-0.5;
function TriggerSpindleRadius() = 0.13;

module TriggerBolt(length=23/25.4, cutter=1) {
  translate([TriggerBoltX(), GripWidth()/2, TriggerBoltZ()])
  rotate([90,0,0])
  color("SteelBlue")
  NutAndBolt(bolt=TriggerBoltSpec(), boltLength=length, clearance=true,
              capHeightExtra=cutter, nutHeightExtra=cutter);
}

module Sear() {
  
  // Sear Rod
  translate([0,0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,SearTravel()*Animate(ANIMATION_STEP_RESET)])
  translate([0,0,GripFloorZ()-0.9-SearOverTravel()])
  color("LightGreen")
  Rod(rod=SearRod(), length=SearLength());
  
  translate([0,0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,SearTravel()*Animate(ANIMATION_STEP_RESET)])
  translate([0,0,SearPinOffsetZ()])
  rotate([90,0,0])
  color("Red")
  %Rod(rod=PivotRod(), length=0.75, center=true);
}

module SearCutter() {
  color("Red", 0.25)
  union() {
    translate([0,0,GripFloorZ()-0.9-SearTravel()-SearOverTravel()])
    Rod(rod=SearRod(), clearance=RodClearanceLoose(), length=SearLength()+SearTravel());
    
    VerticalSearPinTrack();
  }
}

module VerticalSearPinTrack(width=GripWidth()-0.25) {
  rotate([90,0,0])
  linear_extrude(height=width, center=true)
  translate([-RodRadius(PivotRod(), RodClearanceLoose()),
             RodRadius(PivotRod(), RodClearanceLoose())+SearPinOffsetZ()])
  mirror([0,1])
  square([RodDiameter(PivotRod(), RodClearanceLoose()),
          RodDiameter(PivotRod(), RodClearanceLoose())+SearTravel()]);
}

module TriggerSearPinTrack() {
  pinRadius   = RodRadius(PivotRod(), RodClearanceLoose());
  pinDiameter = pinRadius*2;

  translate([0,SearPinOffsetZ()+pinRadius])
  polygon([

    // Rear elbow, top
    [0, 0],

    // Front elbow, top
    [TriggerTravel(), -SearTravel()],

    // Front extension top
    [TriggerTravel()+(pinRadius*1.5), -SearTravel()-pinRadius],

    // Front extension bottom
    [TriggerTravel()+(pinRadius*1.5), -pinDiameter-SearTravel()-pinRadius],

    [TriggerTravel(), -pinDiameter-SearTravel()],

    [0,-pinDiameter],

    // Rear extension, bottom
    [-pinRadius,-pinDiameter],

    // Rear extension, top
    [-pinRadius, 0]
  ]);
}

module SearSupportTab() {
  color("Lime")
  render(convexity=4)
  difference() {
    union() {
      rotate([90,0,0])
      linear_extrude(height=RodDiameter(rod=SearRod())-0.01, center=true) {
          
        // Sear Body
        translate([GripTabRearMaxX(),GripBottomZ()])
        square([abs(GripTabRearMaxX())+0.3, GripOffsetZ()+abs(GripBottomZ())]);
          
        // Front Corner
        translate([0,GripFloorZ()])
        square([GripTabFrontMinX()+0.1, GripFloor()-ManifoldGap()]);
      }
      
    }
    
    TriggerBolt();
    
    SearCutter();
    
    GripTabFront(clearance=0.01);
    
    GripTabRear(hole=false, clearance=0.01);
    
  }
}

module TriggerSideCutter(clearance=0) {
  difference() {
    
    // Trigger Body
    translate([GripTabRearMinX(),GripOffsetZ()+ManifoldGap()])
    mirror([0,1])
    square([GripTabFrontMaxX()+abs(GripTabRearMinX()),2]);
    
    *difference() {
    
      translate([TriggerTravel()+RodRadius(SearRod())+0.2-clearance, GripFloorZ()-0.1])
      mirror([0,1])
      square([1+clearance,1]);
    
      translate([TriggerTravel()+RodRadius(SearRod())+0.2-clearance, GripFloorZ()-0.6-clearance])
      square([1+clearance,0.3+(clearance*2)]);
    }
  }
}

module TriggerFingerCurve(fingerCurveRadius = 0.5, triggerFront) {
  translate([fingerCurveRadius+TriggerTravel()+RodRadius(SearRod())+triggerFront-0.2,
             GripOffsetZ()-1.05])
  intersection() {
    circle(r=fingerCurveRadius, h=1, center=true, $fn=Resolution(16,30));
    
    translate([-fingerCurveRadius,-0.6,-0.5])
    square([fingerCurveRadius*2,1,1]);
  }
}

module Trigger2d() {
  triggerFront = 0.6;
  triggerBack = 0.17;
  triggerLength = TriggerTravel()+RodDiameter(SearRod())+triggerFront+triggerBack;
  triggerHeight = 0.6+0.9-0.01;

  difference() {
    union() {
      
      // Trigger Body
      translate([-triggerBack-RodRadius(SearRod()),GripOffsetZ()-0.01])
      mirror([0,1])
      square([triggerLength,triggerHeight-0.01]);

      // Trigger Rear Extension        
      translate([GripTabRearMinX()+TriggerTravel()+0.05,GripOffsetZ()-1.49])
      square([abs(GripTabRearMinX()),0.72]);
    }
    
    hull()
    for(i=[0, TriggerTravel()])
    translate([i,0])
    projection(cut=true)
    rotate([-90,0,0])
    TriggerBolt();

    TriggerSearPinTrack();

    // Finger curve
    TriggerFingerCurve(triggerFront=triggerFront);
    
    projection(cut=true)
    rotate([-90,0,0])
    GripTabFront(clearance=0.01);
  }
}

module Trigger(left=true, right=true) {
  sideplateWidth = (TriggerWidth()/2)-RodRadius(SearRod(), RodClearanceLoose());
  
  translate([-(TriggerTravel()*Animate(ANIMATION_STEP_TRIGGER)),0,0])
  translate([(TriggerTravel()*Animate(ANIMATION_STEP_RESET)),0,0]) {
    
    if (right)
    color("Salmon")
    render(convexity=6)
    difference() {
      rotate([90,0,0])
      linear_extrude(height=TriggerWidth(), center=true)
      Trigger2d();

      // Sear Slot (extended)
      translate([GripTabRearMaxX(),-RodRadius(SearRod(), RodClearanceLoose()),GripOffsetZ()+ManifoldGap()])
      mirror([0,0,1])
      cube([abs(GripTabRearMaxX())+TriggerTravel()+0.31,
            RodDiameter(SearRod(), RodClearanceLoose()), 2+ManifoldGap()]);
      
      // Sear Support Slot Front
      translate([0,-RodRadius(SearRod(), RodClearanceLoose()),GripFloorZ()-0.01])
      cube([GripTabFrontMaxX(), RodDiameter(SearRod(), RodClearanceLoose()), GripFloor()+0.01+ManifoldGap()]);
      
      
      translate([0,TriggerWidth()/2,0])
      rotate([90,0,0])
      linear_extrude(height=sideplateWidth+0.01)
      TriggerSideCutter(clearance=0.005);
    }
    
    if (left)
    color("Black", 0.4)
    render(convexity=4)
    translate([0,(TriggerWidth()/2),0])
    rotate([90,0,0])
    linear_extrude(height=sideplateWidth)
    intersection() {
      Trigger2d();
      
      TriggerSideCutter(clearance=0);
    }
  }
}

module TriggerGroup() {
  Sear();
  SearSupportTab();
  TriggerBolt(cutter=0);
  Trigger(left=true, right=true);
  //%SearCutter();
}

//AnimateSpin()
TriggerGroup();

*color("black",0.25)
%Reference();

module trigger_plater($t=0) {
  rotate([90,0,0]) {
  
    // Plating note: The left-side plate should print right-side-down
    translate([0,-RodRadius(SearRod(), RodClearanceLoose()),-GripOffsetZ()+2.7])
    Trigger(left=true, right=false);
    
    translate([0,TriggerWidth()/2,-GripOffsetZ()-0.25])
    Trigger(left=false, right=true);
  }
  
  translate([0.5,-0.15,0.12])
  rotate([90,0,90])
  SearSupportTab();
}


!scale(25.4)
trigger_plater();
