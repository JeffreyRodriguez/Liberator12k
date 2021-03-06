
//$t=0.6;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Components/Grip Handle.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <Lugs.scad>;
use <Trigger.scad>;


/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Lower_Left", "Lower_Right", "Lower_Middle"]

/* [Assembly] */
_SHOW_LOWER_LEFT = true;
_SHOW_LOWER_RIGHT = true;
_SHOW_LOWER_MIDDLE = true;
_SHOW_TRIGGER = true;
_SHOW_LOWER_LUGS = true;

_ALPHA_LOWER = 1;  // [0:0.1:1]

/* [Vitamins] */
LOWER_BOLT = "#8-32"; // ["M4", "#8-32"]
LOWER_BOLT_CLEARANCE = 0.015;
LOWER_BOLT_HEAD = "flat"; // ["socket", "flat"]
LOWER_BOLT_NUT = "heatset"; // ["hex", "heatset", "heatset-long"]

function LowerCenterWidth() = 0.51;

function LowerBolt() = BoltSpec(LOWER_BOLT);
assert(LowerBolt(), "LowerBolt() is undefined. Unknown LOWER_BOLT?");


function LowerWallFront() = 0.5;
function LowerMaxX() = ReceiverLugFrontMaxX()
                     + LowerWallFront();
function LowerGuardHeight() = TriggerFingerDiameter()
                            + TriggerFingerWall()
                            + GripCeiling();

module TriggerFingerSlot(radius=TriggerFingerRadius(), length=0.6, $fn=Resolution(12, 60)) {

  union() {

    // Chamfered front edge
    translate([0.65+length, 0, TriggerFingerOffsetZ()])
    translate([0,1.25/2,-radius])
    rotate([90,0,0])
    ChamferedCircularHole(r1=radius, r2=1/16,
             h=1.25, $fn=$fn);

    // Chamfered rear edge
    intersection() {
      translate([0.65, 0, TriggerFingerOffsetZ()])
      translate([0,GripWidth()/2,-radius])
      rotate([90,0,0])
      ChamferedCircularHole(r1=radius, r2=1/4,
               h=GripWidth(), $fn=$fn);

      translate([0,-GripWidth(),TriggerFingerOffsetZ()])
      mirror([0,0,1])
      cube([length+(radius*4), GripWidth()*2, radius*2]);
    }

    // Slot hull
    translate([0.65, 0, TriggerFingerOffsetZ()])
    hull()
    for (i = [0,length])
    translate([i,0,-radius])
    rotate([90,0,0])
    cylinder(r=radius,
             h=2, $fn=$fn, center=true);
  }
}

module GuardBolt(boltSpec=LowerBolt(), length=UnitsImperial(1.25),
                 head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT,
                 cutter=false, clearance=0.005) {

  color("Silver")
  translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[0]),
             -LowerMaxY(),
             GripCeilingZ()-TriggerFingerDiameter()+0])
  rotate([90,0,0])
  rotate([0,0,90])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=cutter?clearance:0,
             capOrientation=true, head=head, nut=nut,
             capHeightExtra=cutter?1:0, nutHeightExtra=cutter?1:0);
}

module HandleBolts(boltSpec=LowerBolt(), length=UnitsMetric(30),
                   head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT,
                   cutter=false, clearance=0.005) {
  boltsXZ = [

     // Handle Bottom-Rear
     [-2.0,GripCeilingZ()-2.9],

     // Handle Bottom-Front
     [-1.375,GripCeilingZ()-1.375]
  ];

  color("Silver")
  for (xz = boltsXZ)
  translate([xz[0],-length/2,xz[1]])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec, boltLength=length, clearance=cutter?clearance:0,
              capOrientation=true, head=head, nut=nut,
              capHeightExtra=cutter?1:0,
              nutHeightExtra=cutter?1:0);
}

module TriggerGuard() {
  height = LowerGuardHeight();

  union() {
    difference() {

      // Main block
      translate([ReceiverLugRearMinX(), -GripWidth()/2, -height])
      ChamferedCube([LowerMaxX()+abs(ReceiverLugRearMinX()),
            GripWidth(),
            height], r=0.0625);

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
                 (GripWidth()/2),
                 -0.55])
      rotate([90,0,180])
      linear_extrude(height=0.05, center=true) {
        difference() {
          circle(r=0.43, $fn=50);
        
        text("A", font="Arial Black", size=0.5,
             halign = "center", valign="center"); // Anarchism A
        }
      }

      translate([-0.2,
                 -(GripWidth()/2),
                 -0.55])
      rotate([90,0,0])
      linear_extrude(height=0.05, center=true) {
        difference() {
          circle(r=0.43, $fn=50);

          text("V", font="Arial Black", size=0.5,
              halign = "center", valign="center"); // Voluntaryism V
        }
      }
    }
  }
}

module LowerReceiverSupports() {

  // Center cube
  translate([LowerMaxX()-0.25,-GripWidth()/2,0])
  mirror([1,0,0])
  mirror([0,0,1])
  cube([LowerMaxX(), GripWidth(), GripCeiling()]);

  // Front receiver lug support
  hull() {

    // Front Top cube
    translate([LowerMaxX(),-0.625,0])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([LowerMaxX()-ReceiverLugFrontMinX()+0.0625, 1.25, GripCeiling()+0.25],
                  r=1/16);

    // Rear cube
    translate([LowerMaxX()-0.375,-1.25/2,0])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([LowerMaxX()-ReceiverLugFrontMinX(), 1.25, GripCeiling()],
                  r=1/4);
  }

  // Front receiver lug support
  hull() {

    // Front Bottom cube
    translate([LowerMaxX(),
               -0.625,
               0])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([LowerWallFront(), 1.25, LowerGuardHeight()], r=1/16);

    // Front Bottom Taper cube
    translate([LowerMaxX(),
               -0.25,
               0])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([LowerWallFront()+TriggerFingerRadius(), 0.5, LowerGuardHeight()]);
  }

  // Rear receiver lug support
  hull() {

    translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[1])-0.4,-(GripWidth()/2)+ManifoldGap(),0])
    mirror([0,0,1])
    ChamferedCube([1, GripWidth(), 0.74], r=1/16);

    translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[1]),0,ReceiverLugBoltZ(ReceiverLugBoltsArray()[1])])
    rotate([90,0,0])
    cylinder(r=0.225, h=1.25, center=true, $fn=Resolution(12,24));
  }
}

module LowerTriggerPocket() {
  render()
  difference() {
    union() {
      translate([0,-(LowerCenterWidth()/2)-ManifoldGap(), ManifoldGap()])
      mirror([0,0,1]) {

        // Tigger Body
        translate([ReceiverLugRearMinX(),0,0])
        cube([ReceiverLugFrontMinX()+abs(ReceiverLugRearMinX()),
              LowerCenterWidth()+ManifoldGap(2),
              TriggerHeight()]);

        // Trigger Front Extension Cutout
        cube([ReceiverLugFrontMaxX(),
              LowerCenterWidth()+ManifoldGap(2),
              TriggerHeight()-TriggerFingerRadius()]);
      }

      translate([0,ManifoldGap(),0])
      SearSupportTab(cutter=false);
    }

    ReceiverLugBolts(cutter=true);
  }
}

module LowerCutouts(chamferLugs=true, boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT) {
  ReceiverLugFront(width=TriggerWidth(),
                   cutter=true, chamferCutterHorizontal=chamferLugs);
  ReceiverLugRear(width=TriggerWidth(), hole=false,
                   cutter=true, chamferCutterHorizontal=chamferLugs);

  GuardBolt(length=1.25, boltSpec=boltSpec, head=head, nut=nut, cutter=true);

  HandleBolts(length=1.25, boltSpec=boltSpec, head=head, nut=nut, cutter=true);

  ReceiverLugBolts(length=1.25, boltSpec=boltSpec, head=head, nut=nut, cutter=true);

  TriggerFingerSlot();

  Sear(cutter=true);
}


module GripSplitter(clearance=0) {
  translate([-10, -(LowerCenterWidth()/2) -clearance, -10])
  cube([20, LowerCenterWidth()+(clearance*2), 20]);
}

module LowerSidePlates(boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT, showLeft=true, showRight=true, alpha=1) {

  // Trigger Guard Sides
  color("Tan", alpha)
  render()
  difference() {

    TriggerGuard();

    GripSplitter(clearance=0.001);

    LowerCutouts(boltSpec=boltSpec, head=head, nut=nut);

    if (showLeft == false)
    translate([-10,0,-10])
    cube([20,2,20]);

    if (showRight == false)
    translate([-10,-2,-10])
    cube([20,2,20]);
  }

}

module Lower_Left_print(boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT)
rotate(180)
rotate([90,0,0])
translate([0,-0.25,2.125])
LowerSidePlates(boltSpec=LowerBolt(), head=head, nut=nut, showLeft=true, showRight=false);

module Lower_Right_print(boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT)
rotate([-90,0,0])
translate([0,0.25,2.125])
LowerSidePlates(boltSpec=LowerBolt(), head=head, nut=nut, showLeft=false, showRight=true);

module Lower_Middle(boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT) {
  color("Chocolate")
  render()
  difference() {
    intersection() {
      TriggerGuard();

      // Just the middle
      GripSplitter(clearance=0);
    }

    LowerCutouts(chamferLugs=false, boltSpec=LowerBolt(), head=head, nut=nut);

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

module Lower_Middle_print(boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT)
rotate(180)
rotate([90,0,0])
translate([0,0.25,2.125])
Lower_Middle(boltSpec=LowerBolt(), head=head, nut=nut);

module LowerMatchplate2d() {
  union() {
    intersection() {
      projection(cut=true)
      translate([0,0,0.001])
      TriggerGuard();

      translate([ReceiverLugRearMaxX()-1.375,-1])
      square([LowerMaxX()-ReceiverLugRearMaxX()+1.375,2]);
    }
  }
}

module Lower(showReceiverLugs=false, showReceiverLugBolts=false,
            showGuardBolt=false, showHandleBolts=false,
            showTrigger=false,
            showMiddle=true, showLeft=true, showRight=true,
            searLength=1.25, triggerAnimationFactor=TriggerAnimationFactor(),
            boltSpec=LowerBolt(), boltHead=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT,
            alpha=1) {
      boltLength = 1.25;

  // Trigger Guard Center
  if (showMiddle)
  Lower_Middle();

  // Trigger
  if (showTrigger) {
    TriggerGroup(searLength=searLength,
                 animationFactor=triggerAnimationFactor);
  }

  if (showReceiverLugs) {
    ReceiverLugFront(width=TriggerWidth());
    ReceiverLugRear(width=TriggerWidth());
  }

  if (showReceiverLugBolts)
  ReceiverLugBolts(boltSpec=boltSpec, length=boltLength, head=boltHead, nut=nut);

  if (showGuardBolt)
  GuardBolt(boltSpec=boltSpec, length=boltLength, head=boltHead, nut=nut);

  if (showHandleBolts)
  HandleBolts(boltSpec=boltSpec, length=boltLength, head=boltHead, nut=nut);

  LowerSidePlates(boltSpec=boltSpec, head=boltHead, nut=nut,
                  showLeft=showLeft, showRight=showRight, alpha=alpha);
}

scale(25.4)
if ($preview) {

  AnimateSpin()
  Lower(showReceiverLugs=_SHOW_LOWER_LUGS, showReceiverLugBolts=true,
        showGuardBolt=true,
        showHandleBolts=true,
        showTrigger=_SHOW_TRIGGER,
        triggerAnimationFactor=sin(180*$t),
        showLeft=_SHOW_LOWER_LEFT,
        showMiddle=_SHOW_LOWER_MIDDLE,
        showRight=_SHOW_LOWER_RIGHT,
        alpha=_ALPHA_LOWER);
} else {
  if (_RENDER == "Lower_Left")
    Lower_Left_print();

  if (_RENDER == "Lower_Right")
    Lower_Right_print();

  if (_RENDER == "Lower_Middle")
    Lower_Middle_print();
}
