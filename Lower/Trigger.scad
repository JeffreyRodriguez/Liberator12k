include <../Meta/Animation.scad>;

use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Units.scad>;

use <../Finishing/Chamfer.scad>;

use <../Vitamins/Rod.scad>;

use <Receiver Lugs.scad>;

function SearRod() = Spec_RodOneQuarterInch();
function SearPinRod() = Spec_RodOneEighthInch();

// Shorthand: Measurements
function SearRadius(clearance)   = RodRadius(SearRod(), clearance);
function SearDiameter(clearance) = RodDiameter(SearRod(), clearance);

function SearSpringCompressed() = 0.4;

function SearPinOffsetZ() = -0.25-RodRadius(SearPinRod());
function SearBottomOffset() = 0.25;



function TriggerFingerDiameter() = 1;
function TriggerFingerRadius() = TriggerFingerDiameter()/2;

function TriggerFingerOffsetZ() = GripCeilingZ();
function TriggerFingerWall() = 0.3;

function TriggerHeight() = GripCeiling()+TriggerFingerDiameter();
function TriggerWidth() = 0.49;
function SearTravel() = 0.25;
function TriggerTravel() = SearTravel()*1.5;
function SearLength() = abs(SearPinOffsetZ()) + SearTravel();

function TriggerAnimationFactor() = Animate(ANIMATION_STEP_TRIGGER)-Animate(ANIMATION_STEP_TRIGGER_RESET);

module Sear(animationFactor=TriggerAnimationFactor(), length=SearLength()) {

  // Sear Rod
  translate([0,0,-SearTravel()*animationFactor])
  translate([0,0,SearPinOffsetZ()-SearBottomOffset()])
  color("LightGreen")
  SquareRod(rod=SearRod(), length=length);

  translate([0,0,-SearTravel()*animationFactor])
  translate([0,0,SearPinOffsetZ()])
  rotate([90,0,0])
  color("Red")
  Rod(rod=SearPinRod(), length=0.5, center=true);
}

module SearCutter(length=SearLength()+SearTravel(), searLengthExtra=0, crosspin=true,wideTrack=false) {
  color("Red", 0.25)
  union() {
    translate([0,0,SearPinOffsetZ()-SearBottomOffset()-SearTravel()-SearSpringCompressed()])
    SquareRod(rod=SearRod(),
        clearance=RodClearanceLoose(),
        length=length+searLengthExtra);

    if (wideTrack)
    translate([-RodDiameter(SearRod())*0.4,
               -RodRadius(SearRod()),
               SearPinOffsetZ()-SearBottomOffset()-SearTravel()-SearSpringCompressed()])
    cube([RodDiameter(SearRod())*0.8,
          RodDiameter(SearRod()),
          SearLength()+SearTravel()+searLengthExtra]);

    if (crosspin)
    VerticalSearPinTrack();
  }
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


module VerticalSearPinTrack(width=0.5) {
  rotate([90,0,0])
  linear_extrude(height=width, center=true)
  translate([-RodRadius(SearPinRod(), RodClearanceLoose()),
             RodRadius(SearPinRod(), RodClearanceLoose())+SearPinOffsetZ()])
  mirror([0,1])
  square([RodDiameter(SearPinRod(), RodClearanceLoose()),
          RodDiameter(SearPinRod(), RodClearanceLoose())+SearTravel()]);
}

module TriggerSearPinTrack() {
  translate([0,SearPinOffsetZ()])
  hull() {
    Rod2d(SearPinRod(), RodClearanceLoose());

    translate([TriggerTravel(), -SearTravel()])
    Rod2d(SearPinRod(), RodClearanceLoose());
  }
}

module SearSupportTab(cutter=false) {
  clearance=cutter ? 0.01 : 0;

  color("LightGrey")
  render(convexity=4)
  difference() {
    union() {
      rotate([90,0,0])
      linear_extrude(height=RodDiameter(rod=SearRod())-0.01, center=true) {

        // Sear Body
        translate([ReceiverLugRearMaxX(),0])
        mirror([0,1])
        square([abs(ReceiverLugRearMaxX())+0.375, TriggerHeight()]);

        // Front Corner
        translate([0,GripCeilingZ()])
        square([ReceiverLugFrontMinX()+TriggerTravel(), GripCeiling()-ManifoldGap()]);

        // Back Corner
        translate([ReceiverLugRearMinX(),ReceiverLugRearZ()+ManifoldGap()])
        mirror([0,1])
        square([abs(ReceiverLugRearMinX()), 0.375]);
      }
    }

    if (!cutter)
    translate([0,0,-SearTravel()])
    SearCutter(length=SearLength()+(SearTravel()*4), wideTrack=true);

    ReceiverLugFront(cutter=true, clearance=0.01);

    ReceiverLugRear(cutter=true, hole=false, clearance=0.0);

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


    translate([-triggerBack,ReceiverLugRearZ()-0.375])
    square([ReceiverLugRearLength(),
            abs(ReceiverLugRearZ())+0.375]);

    // Clearance for the receiver lugs
    projection(cut=true)
    rotate([-90,0,0]) {
      ReceiverLugFront(cutter=true, clearance=0.01);

      for (x=[0, TriggerTravel()])
      translate([x,0,0])
      ReceiverLugRear(cutter=true, hole=false, clearance=0.01);
    }
  }
}

module Trigger(animationFactor=TriggerAnimationFactor(),
               left=true, leftAlpha=1,
               right=true, rightAlpha=1) {
  sideplateWidth = (TriggerWidth()/2)
                 - RodRadius(SearRod(), RodClearanceSnug());

  translate([-(TriggerTravel()*animationFactor),0,0]) {

    if (right)
    color("Gold", rightAlpha)
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
    color("Gold", leftAlpha)
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
  Sear(animationFactor=animationFactor, length=searLength);
  SearSupportTab();
  Trigger(animationFactor=animationFactor,
          left=true, leftAlpha=0.3,
          right=true, rightAlpha=1);
}

TriggerGroup(animationFactor=sin(180*$t), searLength=1.1525);

TRIGGER_PLATER_MIDDLE = false;
TRIGGER_PLATER_LEFT = false;
TRIGGER_PLATER_RIGHT = false;

if (TRIGGER_PLATER_MIDDLE)
!scale(25.4)
rotate(180)
translate([0,-TriggerHeight()/2,0.12])
rotate([90,0,00])
SearSupportTab(cutter=false);

if (TRIGGER_PLATER_LEFT)
!scale(25.4)
rotate(180)
translate([0,-TriggerHeight()/2,0])
rotate([90,0,0])
translate([0,-RodRadius(SearRod(), RodClearanceLoose()),0])
Trigger(left=true, right=false);

if (TRIGGER_PLATER_RIGHT)
!scale(25.4)
rotate(180)
translate([0,-TriggerHeight()/2,0])
rotate([90,0,0])
translate([0,TriggerWidth()/2,0])
Trigger(left=false, right=true);
