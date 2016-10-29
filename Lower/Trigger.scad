//$t=0.8;
//$t=0;
include <../Meta/Animation.scad>;

use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Units.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Spring.scad>;

use <Receiver Lugs.scad>;

DEFAULT_SEAR_ROD = Spec_RodOneQuarterInch();
DEFAULT_SEAR_PIN_ROD = Spec_RodOneEighthInch();
function SearRod() = DEFAULT_SEAR_ROD;
function SearPinRod() = DEFAULT_SEAR_PIN_ROD;

// Spec_BicLighterThumbSpring
// Spec_BicSoftFeelFinePenSpring
function TriggerSpring() = Spec_BicLighterThumbSpring();
function SearSpringCompressed() = 0.4;

function SearPinOffsetZ() = -0.25-RodRadius(SearPinRod());
function SearBottomOffset() = 0.25;


function TriggerFingerDiameter() = 1;
function TriggerFingerRadius() = TriggerFingerDiameter()/2;
function TriggerFingerOffsetZ() = GripCeilingZ() -TriggerFingerRadius();
function TriggerFingerWall() = 0.3;

function TriggerHeight() = GripCeiling()+TriggerFingerDiameter();
function TriggerWidth() = 0.49;
function SearTravel() = 0.25;
function TriggerTravel() = SearTravel()*1.5;
function SearLength() = 1.5 + abs(SearPinOffsetZ()) + SearTravel();

module Sear() {

  // Sear Rod
  translate([0,0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,SearTravel()*Animate(ANIMATION_STEP_TRIGGER_RESET)])
  translate([0,0,SearPinOffsetZ()-SearBottomOffset()])
  color("LightGreen")
  Rod(rod=SearRod(), length=SearLength());

  translate([0,0,-SearTravel()*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,SearTravel()*Animate(ANIMATION_STEP_TRIGGER_RESET)])
  translate([0,0,SearPinOffsetZ()])
  rotate([90,0,0])
  color("Red")
  %Rod(rod=SearPinRod(), length=0.8, center=true);
}

module SearCutter(searLengthExtra=0) {
  color("Red", 0.25)
  union() {
    translate([0,0,SearPinOffsetZ()-SearBottomOffset()-SearTravel()-SearSpringCompressed()])
    Rod(rod=SearRod(),
        clearance=RodClearanceLoose(),
        length=SearLength()+SearTravel()+searLengthExtra);

    VerticalSearPinTrack();
  }
}

module VerticalSearPinTrack(width=0.9) {
  rotate([90,0,0])
  linear_extrude(height=width, center=true)
  translate([-RodRadius(SearPinRod(), RodClearanceLoose()),
             RodRadius(SearPinRod(), RodClearanceLoose())+SearPinOffsetZ()])
  mirror([0,1])
  square([RodDiameter(SearPinRod(), RodClearanceLoose()),
          RodDiameter(SearPinRod(), RodClearanceLoose())+SearTravel()]);
}

module TriggerSearPinTrack() {
  pinRadius   = RodRadius(SearPinRod(), RodClearanceLoose());
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
        square([abs(ReceiverLugRearMaxX())+0.3, TriggerHeight()]);

        // Front Corner
        translate([0,GripCeilingZ()])
        square([ReceiverLugFrontMinX()+0.1, GripCeiling()-ManifoldGap()]);
      }

      translate([ReceiverLugRearMinX()-0.25-clearance,
                 (GripWidth()/2)-RodDiameter(SearRod())+clearance,
                 -TriggerHeight()+ManifoldGap()+clearance])
      mirror([0,0,1])
      rotate([90,0,0])
      linear_extrude(height=(GripWidth()/2)-RodRadius(SearRod())+clearance) {

        // Grip Middle Interface Lug Horizontal
        square([ReceiverLugRearLength()+0.45+(clearance*2),
              0.5+(clearance*2)]);


        // Grip Middle Interface Lug Vertical
        translate([ReceiverLugRearLength()-0.25,0,0])
        square([0.5+(clearance*2),
              1+(clearance*2)]);

        // Trigger-interfacing Surface/grip lug
        square([abs(ReceiverLugRearMinX())+0.25+(clearance*2),
              0.2+(clearance*2)]);
      }


      // Top-rear trigger retaining lug
      translate([ReceiverLugRearMaxX()-clearance,
                 -RodRadius(rod=SearRod()),
                 ReceiverLugRearZ()-clearance+ManifoldGap()])
      cube([0.2+(TriggerTravel()*(cutter?1:0))+(clearance*2),
            (GripWidth()/2)-RodRadius(SearRod())+clearance,
            abs(ReceiverLugRearZ())+(clearance*2)]);
    }

    if (!cutter)
    SearCutter();

    ReceiverLugFront(clearance=0.01);

    ReceiverLugRear(hole=false, clearance=0.0);

  }
}

module TriggerSideCutter(clearance=0) {
  translate([ReceiverLugRearMinX(),ManifoldGap()])
  mirror([0,1])
  square([ReceiverLugFrontMaxX()+abs(ReceiverLugRearMinX()),TriggerHeight()+ManifoldGap(2)]);
}

module Trigger2d() {
  triggerFront = 0.5;
  triggerBack = abs(ReceiverLugRearMinX())-TriggerTravel()-0.01;
  triggerLength = TriggerTravel()+RodDiameter(SearRod())+triggerFront+triggerBack;
  triggerHeight = TriggerHeight()-0.01;

  difference() {

    // Trigger Body
    translate([-triggerBack,-0.01])
    mirror([0,1])
    square([triggerLength,triggerHeight-0.01]);

    TriggerSearPinTrack();

    // Finger curve
    translate([TriggerFingerRadius()+TriggerTravel()+RodDiameter(SearRod())+triggerFront-0.15,
             -GripCeiling()-TriggerFingerRadius()])
    circle(r=TriggerFingerRadius(), h=1, center=true, $fn=Resolution(16,30));

    // Clearance for the receiver lugs
    projection(cut=true)
    rotate([-90,0,0]) {
      ReceiverLugFront(clearance=0.01);

      for (x=[0, TriggerTravel()])
      translate([x,0,0])
      ReceiverLugRear(hole=false, clearance=0.01);
    }
  }
}

module Trigger(left=true, right=true) {
  sideplateWidth = (TriggerWidth()/2)-RodRadius(SearRod(), RodClearanceLoose());

  translate([-(TriggerTravel()*Animate(ANIMATION_STEP_TRIGGER)),0,0])
  translate([(TriggerTravel()*Animate(ANIMATION_STEP_TRIGGER_RESET)),0,0]) {

    if (right)
    color("Gold")
    render(convexity=6)
    difference() {
      rotate([90,0,0])
      linear_extrude(height=TriggerWidth(), center=true)
      Trigger2d();

      // Sear Slot (extended)
      translate([ReceiverLugRearMaxX(),-RodRadius(SearRod(), RodClearanceLoose()),ManifoldGap()])
      mirror([0,0,1])
      cube([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.31,
            RodDiameter(SearRod(), RodClearanceLoose()), 2+ManifoldGap()]);

      // Sear Support Slot Front
      translate([0,-RodRadius(SearRod(), RodClearanceLoose()),GripCeilingZ()-0.01])
      cube([ReceiverLugFrontMaxX(), RodDiameter(SearRod(), RodClearanceLoose()), GripCeiling()+0.01+ManifoldGap()]);


      translate([0,TriggerWidth()/2,0])
      rotate([90,0,0])
      linear_extrude(height=sideplateWidth+0.01)
      TriggerSideCutter();
    }

    if (left)
    color("Gold", 0.7)
    render(convexity=4)
    difference() {
      translate([0,(TriggerWidth()/2),0])
      rotate([90,0,0])
      linear_extrude(height=sideplateWidth)
      Trigger2d();

      SearSupportTab(cutter=true);
    }
  }
}

module TriggerGroup() {
  Sear();
  SearSupportTab();
  Trigger(left=true, right=true);
}

//AnimateSpin()
TriggerGroup();

*color("black",0.25)
%Reference();

module trigger_plater($t=0) {
  rotate([90,0,0]) {

    // Plating note: The left-side plate should print right-side-down
    translate([0,-RodRadius(SearRod(), RodClearanceLoose()),2.7])
    Trigger(left=true, right=false);

    translate([0,TriggerWidth()/2,-0.25])
    Trigger(left=false, right=true);
  }

  translate([-0.75,-0.15,0.12])
  rotate([90,0,90])
  SearSupportTab(cutter=false);
}


echo("Sear Length", SearLength());

*!scale(25.4)
trigger_plater();
