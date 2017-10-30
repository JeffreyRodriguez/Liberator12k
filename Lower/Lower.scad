//$t=0.6;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Units.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <Receiver Lugs.scad>;
use <Trigger.scad>;

use <../Components/Grip Handle.scad>;
use <../Components/Trigger Finger Slot.scad>;

function LowerWallFront() = 0.5;
function LowerMaxX() = ReceiverLugFrontMaxX()+LowerWallFront();
function LowerGuardHeight() = TriggerFingerDiameter()+TriggerFingerWall()+GripCeiling();

module GuardBolt(boltSpec=Spec_BoltM4(), length=UnitsMetric(30), clearance=true) {
  cutter = (clearance) ? 1 : 0;

  color("SteelBlue")
  translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[0]),
             -LowerMaxY()+0.07,
             GripCeilingZ()-TriggerFingerDiameter()+0])
  rotate([90,0,0])
  rotate([0,0,90])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clearance,
             capOrientation=true,
              capHeightExtra=cutter, nutBackset=0.05, nutHeightExtra=cutter);
}

module HandleBolts(boltSpec=Spec_BoltM4(), length=UnitsMetric(30), clearance=true) {
  cutter = (clearance) ? 1 : 0;

  boltsXZ = [

     // Handle Bottom-Rear
     [-2.0,GripCeilingZ()-2.9],

     // Handle Bottom-Front
     [-1.125,GripCeilingZ()-1.375]
  ];

  color("SteelBlue")
  for (xz = boltsXZ)
  translate([xz[0],-LowerMaxY()+0.07,xz[1]])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=clearance,
              capOrientation=true,
              capHeightExtra=cutter, nutBackset=0.05, nutHeightExtra=cutter);
}

module TriggerFinger() {
  render()
  translate([0.65, 0, TriggerFingerOffsetZ()])
  TriggerFingerSlot();
}


module TriggerGuard() {
  height = LowerGuardHeight();

  union() {
    difference() {

      // Main block
      translate([ReceiverLugRearMinX(), -GripWidth()/2, -height])
      cube([LowerMaxX()+abs(ReceiverLugRearMinX()),
            GripWidth(),
            height]);

      // Bottom chamfer
      translate([0,0,-height+0.1])
      rotate([0,-90,0])
      linear_extrude(height=5, center=true)
      difference() {
        translate([-height,-GripWidth()])
        square([height,GripWidth()*2]);

        hull()
        for (i = [-1, 1])
        translate([0,((GripWidth()/2)-0.09)*i])
        circle(r=0.1, $fn=Resolution(12,24));
      }
    }

    LowerReceiverSupports();
    GripHandle();

    // Text
    if (Resolution(false, true)) {
      translate([-0.2,
                 (GripWidth()/2)-0.05,
                 -0.55])
      rotate([90,0,180])
      linear_extrude(height=0.07) {
        difference() {
          circle(r=0.43, $fn=30);
          circle(r=0.35, $fn=30);
        }

        translate([-0.29,-0.29])
        text("A", font="Arial Black", size=0.6); // Anarchism A
      }

      translate([-0.2,
                 -(GripWidth()/2)+0.05,
                 -0.55])
      rotate([90,0,0])
      linear_extrude(height=0.07) {
        difference() {
          circle(r=0.43, $fn=30);
          circle(r=0.35, $fn=30);
        }

        translate([-0.35,-0.35])
        text("V", font="Arial Black", size=0.6); // Voluntaryism V
      }
    }
  }
}

module LowerReceiverSupports() {

  // Front receiver lug support
  hull() {

    // Front Top cube
    translate([LowerMaxX(),-0.625,0])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([LowerMaxX()-0.5, 1.25, GripCeiling()+TriggerFingerRadius()]);

    // Rear cube
    translate([LowerMaxX(),-0.5,0])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([LowerMaxX()-0.25, 1, GripCeiling()]);
  }

  // Front receiver lug support
  hull() {

    // Front Bottom cube
    translate([LowerMaxX(),
               -0.625,
               0])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([LowerWallFront(), 1.25, LowerGuardHeight()]);

    // Front Bottom Taper cube
    translate([LowerMaxX(),
               -0.25,
               0])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([LowerWallFront()*2, 0.5, LowerGuardHeight()]);
  }

  // Rear receiver lug support
  hull() {

    translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[1])-0.4,-(GripWidth()/2)+ManifoldGap(),0])
    mirror([0,0,1])
    cube([1, GripWidth(), 0.74]);

    translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[1]),0,ReceiverLugBoltZ(ReceiverLugBoltsArray()[1])])
    rotate([90,0,0])
    cylinder(r=0.225, h=1.25, center=true, $fn=Resolution(12,24));
  }
}

module LowerTriggerPocket() {
  render()
  difference() {
    union() {
      translate([0,-0.25-ManifoldGap(), ManifoldGap()])
      mirror([0,0,1]) {

        // Tigger Body
        translate([ReceiverLugRearMinX(),0,0])
        cube([ReceiverLugFrontMinX()+abs(ReceiverLugRearMinX()),
              0.5+ManifoldGap(2),
              TriggerHeight()]);

        // Trigger Front Extension Cutout
        cube([ReceiverLugFrontMaxX(),
              0.5+ManifoldGap(2),
              TriggerHeight()-TriggerFingerRadius()]);
      }

      translate([0,ManifoldGap(),0])
      SearSupportTab(cutter=false);
    }

    ReceiverLugBoltHoles();
  }
}

module LowerCutouts() {
  ReceiverLugFront(cutter=true);
  ReceiverLugRear(cutter=true, hole=false);

  GuardBolt(clearance=true);

  HandleBolts(clearance=true);

  ReceiverLugBoltHoles();

  TriggerFinger();

  SearCutter();
}


module GripSplitter(clearance=0) {
  translate([-10, -0.25 -clearance, -10])
  cube([20, 0.5+(clearance*2), 20]);
}

module LowerSidePlates(showLeft=true, showRight=true, alpha=1) {

  // Trigger Guard Sides
  color("DarkSlateBlue", alpha)
  render()
  difference() {

    TriggerGuard();

    GripSplitter(clearance=0.001);

    LowerCutouts();

    if (showLeft == false)
    translate([-10,0,-10])
    cube([20,2,20]);

    if (showRight == false)
    translate([-10,-2,-10])
    cube([20,2,20]);
  }

}

module LowerMiddle() {
  color("DimGrey")
  render()
  difference() {
    intersection() {
      TriggerGuard();

      // Just the middle
      GripSplitter(clearance=0);
    }

    LowerCutouts();

    SearSupportTab(cutter=true);

    // Trigger Pocket
    LowerTriggerPocket();

    // #L12K easter egg
    if (Resolution(false, true))
    translate([-1.5, 0.2, -3.75])
    rotate([0,45,0])
    rotate([0,0,180])
    rotate([90,0,0])
    linear_extrude(height=0.25) {
      text("#", font="Arial", size=0.35);

      translate([0.45, 0.08])
      text("L12K", font="Arial", size=0.3);
    }
  }
}

module Lower(showReceiverLugs=false, showReceiverLugBolts=false,
            showGuardBolt=false, showHandleBolts=false,
            showTrigger=false, showTriggerLeft=true, showTriggerRight=true,
            showMiddle=true, showLeft=true, showRight=true,
            searLength=SearLength(),
            alpha=0.5) {

  // Trigger Guard Center
  if (showMiddle)
  LowerMiddle();

  // Trigger
  if (showTrigger) {
    TriggerGroup(left=showTriggerLeft, right=showTriggerRight, searLength=searLength);
  }

  if (showReceiverLugs) {
    ReceiverLugFront();
    ReceiverLugRear();
  }

  if (showReceiverLugBolts)
  ReceiverLugBoltHoles(clearance=false);

  if (showGuardBolt)
  GuardBolt(clearance=false);

  if (showHandleBolts)
  HandleBolts(clearance=false);

  LowerSidePlates(showLeft=showLeft, showRight=showRight, alpha=alpha);
}

Lower(showReceiverLugs=true, showReceiverLugBolts=true,
      showGuardBolt=true,
      showHandleBolts=true,
      showTrigger=true, showTriggerLeft=true, showTriggerRight=true,
      showLeft=true,
      showMiddle=true,
      showRight=true, alpha=0.5);
