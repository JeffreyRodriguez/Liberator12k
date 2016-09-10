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

function SearPinOffsetZ() = -0.25-RodRadius(SearPinRod());
function SearOverTravel() = -0.65;
function SearLength() = 1+0.6+0.9+SearOverTravel();


function TriggerHeight() = 1.5;
function TriggerWidth() = 0.49;
function SearTravel() = 0.25;
function TriggerTravel() = SearTravel()*1.5;

function TriggerBoltSpec() = Spec_BoltM3();
function TriggerBoltX() = -0.5;
function TriggerBoltZ() = GripFloorZ()-0.63;

module TriggerBolt(length=UnitsMetric(25), clearance=false) {
  cutter = clearance ? 1 : 0;

  translate([TriggerBoltX(), (GripWidth()/2), TriggerBoltZ()])
  rotate([90,0,0])
  color("SteelBlue")
  NutAndBolt(bolt=TriggerBoltSpec(), boltLength=length, clearance=clearance,
              capHeightExtra=cutter, nutHeightExtra=cutter, nutBackset=0.02);
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
  %Rod(rod=SearPinRod(), length=0.75, center=true);
}

module SearCutter() {
  color("Red", 0.25)
  union() {
    translate([0,0,GripFloorZ()-0.9-SearTravel()-SearOverTravel()])
    Rod(rod=SearRod(), clearance=RodClearanceLoose(), length=SearLength()+SearTravel());

    VerticalSearPinTrack();
  }
}

module VerticalSearPinTrack(width=0.8) {
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

module SearSupportTab() {
  color("Lime")
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
        translate([0,GripFloorZ()])
        square([ReceiverLugFrontMinX()+0.1, GripFloor()-ManifoldGap()]);
      }

    }

    TriggerBolt();

    SearCutter();

    ReceiverLugFront(clearance=0.01);

    ReceiverLugRear(hole=false, clearance=0.01);

  }
}

module TriggerSideCutter(clearance=0) {
  translate([ReceiverLugRearMinX(),ManifoldGap()])
  mirror([0,1])
  square([ReceiverLugFrontMaxX()+abs(ReceiverLugRearMinX()),2]);
}

module Trigger2d() {
  triggerFront = 0.6;
  triggerBack = abs(ReceiverLugRearMaxX()+TriggerTravel());
  triggerLength = TriggerTravel()+RodDiameter(SearRod())+triggerFront+triggerBack;
  triggerHeight = 0.6+0.9-0.01;
  fingerRadius = 0.5;

  difference() {
    union() {

      // Trigger Body
      translate([-triggerBack-RodRadius(SearRod()),-0.01])
      mirror([0,1])
      square([triggerLength,triggerHeight-0.01]);

      // Trigger Rear Extension
      translate([0,-1.49])
      mirror([1,0])
      square([abs(ReceiverLugRearMinX())-TriggerTravel()-0.01,0.47]);
    }

    hull()
    for(i=[0, TriggerTravel()])
    translate([i,0])
    projection(cut=true)
    rotate([-90,0,0])
    TriggerBolt();

    TriggerSearPinTrack();

    // Finger curve
    translate([fingerRadius+TriggerTravel()+RodRadius(SearRod())+triggerFront-0.2,
             -1.05])
      circle(r=fingerRadius, h=1, center=true, $fn=Resolution(16,30));

    // Clearance for the front receiver lug
    projection(cut=true)
    rotate([-90,0,0])
    ReceiverLugFront(clearance=0.01);
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
      translate([ReceiverLugRearMaxX(),-RodRadius(SearRod(), RodClearanceLoose()),ManifoldGap()])
      mirror([0,0,1])
      cube([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.31,
            RodDiameter(SearRod(), RodClearanceLoose()), 2+ManifoldGap()]);

      // Sear Support Slot Front
      translate([0,-RodRadius(SearRod(), RodClearanceLoose()),GripFloorZ()-0.01])
      cube([ReceiverLugFrontMaxX(), RodDiameter(SearRod(), RodClearanceLoose()), GripFloor()+0.01+ManifoldGap()]);


      translate([0,TriggerWidth()/2,0])
      rotate([90,0,0])
      linear_extrude(height=sideplateWidth+0.01)
      TriggerSideCutter();
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
  %SearCutter();
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

  translate([0.5,-0.15,0.12])
  rotate([90,0,90])
  SearSupportTab();
}


*!scale(25.4)
trigger_plater();
