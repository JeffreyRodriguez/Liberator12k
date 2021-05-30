include <../../Meta/Animation.scad>;

use <../../Meta/Resolution.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/RenderIf.scad>;
use <../../Meta/Units.scad>;

use <../../Shapes/Chamfer.scad>;

use <../../Vitamins/Rod.scad>;

use <Lugs.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Trigger_Left", "Trigger_Right", "Trigger_Middle"]

/* [Assembly] */
_SHOW_TRIGGER_LEFT = true;
_SHOW_TRIGGER_RIGHT = true;
_SHOW_TRIGGER_MIDDLE = true;

/* [Vitamins] */
SEAR_WIDTH = 0.2501;
SEAR_CLEARANCE = 0.005;
SEAR_PIN_DIAMETER = 0.09375;
SEAR_PIN_CLEARANCE = 0.01;

function SearRod() = Spec_RodOneQuarterInch();
function SearPinRod() = Spec_RodThreeThirtysecondInch();

// Shorthand: Measurements
function SearDiameter(clearance) = SEAR_WIDTH+(clearance*2);
function SearRadius(clearance)   = SearDiameter(clearance)/2;

function SearSpringCompressed() = 0.3;

function SearPinOffsetZ() = -0.25-RodRadius(SearPinRod());
function SearBottomOffset() = 0.25;



function TriggerFingerDiameter() = 1;
function TriggerFingerRadius() = TriggerFingerDiameter()/2;

function TriggerFingerOffsetZ() = GripCeilingZ();
function TriggerFingerWall() = 0.3;

function TriggerHeight() = GripCeiling()+TriggerFingerDiameter();
function TriggerWidth() = 0.50;
function SearTravel() = 0.25;
function TriggerTravel() = SearTravel()*1.5;
function SearLength() = abs(SearPinOffsetZ()) + SearTravel();

function TriggerAnimationFactor() = SubAnimate(ANIMATION_STEP_TRIGGER)-SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1);

module Sear(animationFactor=0, length=SearLength(), cutter=false, clearance=SEAR_CLEARANCE) {
  clear = cutter ? clearance : 0;
  
  translate([0,0,-SearTravel()*animationFactor]) {
    
    color("Silver") RenderIf(!cutter)
    difference() {
      translate([-SearRadius(clear),-SearRadius(clear),SearPinOffsetZ()-SearBottomOffset()-(cutter?SearTravel()+SearSpringCompressed():0)])
      cube([SearDiameter(clear), SearDiameter(clear), length]);
      
      if (!cutter)
      SearPin(cutter=true);
    }
    
    children();
  }
}
module SearPin(cutter=false, clearance=SEAR_PIN_CLEARANCE) {
  translate([0,0,SearPinOffsetZ()])
  rotate([90,0,0])
  color("SteelBlue") RenderIf(!cutter)
  Rod(rod=SearPinRod(), clearance=cutter?RodClearanceLoose():undef, length=0.5, center=true);
}

module SearJig(width=0.75, height=1) {
  translate([0,0,SearPinOffsetZ()-SearBottomOffset()])
  difference() {
    translate([-RodRadius(SearRod())-0.125,-width/2,0])
    cube([height,width,SearLength()]);

    // Sear Pin Hole
    translate([-1,0,SearBottomOffset()])
    rotate([0,90,0])
    Rod(rod=SearPinRod(), cutter=true,
         teardrop=true, teardropAngle=180,
         length=3);

    // Sear Rod Hole
    translate([0,0,-ManifoldGap()])
    Rod(rod=SearRod(),
        //teardrop=true, teardropTruncated=false,
        clearance=RodClearanceLoose(),
        length=SearLength()*2);

    // Set screw hole
    translate([0,0,SearLength()-0.5])
    rotate([0,90,0])
    NutAndBolt(bolt=Spec_BoltM3(),
            teardrop=true, teardropAngle=180,
            nutBackset=RodRadius(SearRod()),
            nutHeightExtra=RodRadius(SearRod()),
    length=3);
  }
}

*!scale(25.4) SearJig();

module TriggerSearPinTrack() {
  translate([0,SearPinOffsetZ()])
  hull() {
    Rod2d(SearPinRod(), RodClearanceLoose());

    translate([TriggerTravel(), -SearTravel()])
    Rod2d(SearPinRod(), RodClearanceLoose());
  }
}

module SearSupportTab(cutter=false, clearance=0.015) {

  color("Chocolate")
  render(convexity=4)
  difference() {
    union() {
      rotate([90,0,0])
      linear_extrude(height=RodDiameter(rod=SearRod())-0.01, center=true) {

        // Sear Body
        translate([ReceiverLugRearMaxX(),0])
        mirror([0,1])
        square([abs(ReceiverLugRearMaxX())+0.375, TriggerHeight()-clearance]);

        // Front Corner
        translate([0,GripCeilingZ()])
        square([ReceiverLugFrontMinX()+TriggerTravel(), GripCeiling()-ManifoldGap()]);

        // Back Corner
        translate([ReceiverLugRearMinX()+0.01,ReceiverLugRearZ()+ManifoldGap()])
        mirror([0,1])
        square([abs(ReceiverLugRearMinX()), 0.375]);
      }
    }

    if (!cutter)
    translate([0,0,-SearTravel()])
    Sear(length=SearLength()+(SearTravel()*4), cutter=true);

    ReceiverLugFront(cutter=true, clearance=clearance);

    ReceiverLugRear(cutter=true, clearance=clearance, hole=false);

  }
}

module TriggerSideCutter(clearance=0) {
  translate([ReceiverLugRearMinX(),ManifoldGap()])
  mirror([0,1])
  square([ReceiverLugFrontMaxX()+abs(ReceiverLugRearMinX()),
          TriggerHeight()+ManifoldGap(2)]);
}

module Trigger2d() {
  triggerFront = 0.5;
  triggerBack = abs(ReceiverLugRearMinX())-TriggerTravel()-0.01;
  triggerLength = TriggerTravel()+RodDiameter(SearRod())+triggerFront+triggerBack;
  triggerHeight = TriggerHeight()-0.01;

  render()
  difference() {

    // Trigger Body
    translate([-triggerBack,0])
    mirror([0,1])
    square([triggerLength,triggerHeight-0.01]);

    TriggerSearPinTrack();

    // Finger curve
    translate([TriggerFingerRadius()+TriggerTravel()+RodDiameter(SearRod())+triggerFront-0.15,
             -GripCeiling()-TriggerFingerRadius()])
    circle(r=TriggerFingerRadius(), $fn=Resolution(16,30));


    // Retainer cutout
    translate([-triggerBack,ReceiverLugRearZ()-0.375])
    square([ReceiverLugRearLength(),
            abs(ReceiverLugRearZ())+0.375]);

    // Clearance for the receiver lugs
    projection(cut=true)
    rotate([-90,0,0]) {
      ReceiverLugFront(cutter=true);

      for (x=[0, TriggerTravel()])
      translate([x,0,0])
      ReceiverLugRear(cutter=true, hole=false);
    }
  }
}

module TriggerBody() {
  sideplateWidth = (TriggerWidth()/2)
                 - RodRadius(SearRod(), RodClearanceSnug());
  
  color("Gold")
  render()
  difference() {
    translate([0,(TriggerWidth()/2),0])
    rotate([90,0,0])
    linear_extrude(height=TriggerWidth())
    Trigger2d();

    // Trigger finger chamfer
    translate([TriggerFingerRadius()+TriggerTravel()+RodDiameter(SearRod())+0.5-0.15,
               -TriggerWidth()/2, -GripCeiling()-TriggerFingerRadius()])
    rotate([-90,0,0])
    ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                          h=TriggerWidth(), $fn=Resolution(16,30));

    // Sear Slot (extended)
    translate([ReceiverLugRearMaxX(),-RodRadius(SearRod(), RodClearanceLoose()),ManifoldGap()])
    mirror([0,0,1])
    cube([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.385,
          RodDiameter(SearRod(), RodClearanceLoose()), 2+ManifoldGap()]);

    // Sear Support Slot Front
    translate([0,-RodRadius(SearRod(), RodClearanceLoose()),GripCeilingZ()-0.01])
    cube([ReceiverLugFrontMaxX(),
          RodDiameter(SearRod(), RodClearanceLoose()),
          GripCeiling()+0.01+ManifoldGap()]);
  }
}

module Trigger(animationFactor=TriggerAnimationFactor(), left=true, leftAlpha=1, right=true, rightAlpha=1) {
  sideplateWidth = (TriggerWidth()/2)
                 - RodRadius(SearRod(), RodClearanceSnug());

  translate([-(TriggerTravel()*animationFactor),0,0]) {

    if (right)
    color("Olive", rightAlpha)
    render()
    difference() {
      translate([0,RodRadius(SearRod(), RodClearanceSnug()),0])
      rotate([90,0,0])
      linear_extrude(height=TriggerWidth()-sideplateWidth, center=false)
      Trigger2d();

      // Trigger finger chamfer
      translate([TriggerFingerRadius()+TriggerTravel()+RodDiameter(SearRod())+0.5-0.15,
                 -TriggerWidth()/2, -GripCeiling()-TriggerFingerRadius()])
      rotate([-90,0,0])
      ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                            h=TriggerWidth(), $fn=Resolution(16,30));

      // Sear Slot (extended)
      translate([ReceiverLugRearMaxX(),-RodRadius(SearRod(), RodClearanceLoose()),ManifoldGap()])
      mirror([0,0,1])
      cube([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.385,
            RodDiameter(SearRod(), RodClearanceLoose()), 2+ManifoldGap()]);

      // Sear Support Slot Front
      translate([0,-RodRadius(SearRod(), RodClearanceLoose()),GripCeilingZ()-0.01])
      cube([ReceiverLugFrontMaxX(),
            RodDiameter(SearRod(), RodClearanceLoose()),
            GripCeiling()+0.01+ManifoldGap()]);
    }

    if (left)
    color("Olive", leftAlpha)
    render()
    difference() {
      translate([0,(TriggerWidth()/2),0])
      rotate([90,0,0])
      linear_extrude(height=sideplateWidth)
      Trigger2d();

      // Trigger finger chamfer
      translate([TriggerFingerRadius()+TriggerTravel()+RodDiameter(SearRod())+0.5-0.15,
                 -TriggerWidth()/2, -GripCeiling()-TriggerFingerRadius()])
      rotate([-90,0,0])
      ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                            h=TriggerWidth(), $fn=Resolution(16,30));
    }
  }
}

module TriggerGroup(animationFactor=TriggerAnimationFactor(),
                    searLength=SearLength()) {
  Sear(animationFactor=animationFactor, length=searLength)
  SearPin();
  
  SearSupportTab();
  Trigger(animationFactor=animationFactor,
          left=true, leftAlpha=1,
          right=true, rightAlpha=1);
}

module Trigger_Left_print()
rotate(180)
translate([0,-TriggerHeight()/2,0])
rotate([90,0,0])
translate([0,-RodRadius(SearRod(), RodClearanceLoose()),0])
Trigger(left=true, right=false);

module Trigger_Right_print()
rotate(180)
translate([0,-TriggerHeight()/2,0])
rotate([90,0,0])
translate([0,TriggerWidth()/2,0])
Trigger(left=false, right=true);

module Trigger_Middle_print()
rotate(180)
translate([0,-TriggerHeight()/2,0.12])
rotate([90,0,00])
SearSupportTab(cutter=false);

scale(25.4)
if ($preview) {
  TriggerGroup(animationFactor=sin(180*$t), searLength=1.67188);
} else {
  
  if (_RENDER == "Trigger_Middle")
  Trigger_Middle_print();

  if (_RENDER == "Trigger_Left")
  Trigger_Left_print();

  if (_RENDER == "Trigger_Right")
  Trigger_Right_print();
}
