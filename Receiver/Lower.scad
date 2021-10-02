
//$t=0.6;
use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;
use <../Meta/Units.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Components/Grip Handle.scad>;
use <../Shapes/Components/T Lug.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <FCG.scad>;
use <Receiver.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Lower_Left", "Lower_Right", "Lower_Middle", "Lower_MountFront", "Lower_MountRear"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_LOWER_LEFT = true;
_SHOW_LOWER_RIGHT = true;
_SHOW_LOWER_MIDDLE = true;
_SHOW_TRIGGER = true;
_SHOW_LOWER_LUGS = true;
_SHOW_LOWERMOUNT_FRONT = true;
_SHOW_LOWERMOUNT_REAR = true;

/* [Transparency] */
_ALPHA_LOWER = 1;  // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_LOWERMOUNT_FRONT = false;
_CUTAWAY_LOWERMOUNT_REAR = false;

/* [Vitamins] */
LOWER_BOLT = "#8-32"; // ["M4", "#8-32"]
LOWER_BOLT_CLEARANCE = 0.015;
LOWER_BOLT_HEAD = "flat"; // ["socket", "flat"]
LOWER_BOLT_NUT = "heatset"; // ["hex", "heatset", "heatset-long"]

/* [Vitamins] */
RECEIVER_LUG_BOLTS = "M4"; // ["#8-32", "M4"]
RECEIVER_LUG_BOLTS_CLEARANCE = 0.005;


// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function GripWidth() = 1;
function GripCeiling() = 0.75;
function GripCeilingZ() = -GripCeiling();

function LowerMaxWidth() = GripWidth()+0.25;
function LowerMaxY() = (GripWidth()/2)+0.125;

function ReceiverLugWidth() = 1;

function ReceiverLugFrontLength() = 0.75;
function ReceiverLugFrontMaxX() = 1.6;
function ReceiverLugFrontMinX() = ReceiverLugFrontMaxX()-ReceiverLugFrontLength();
function ReceiverLugFrontZ() = -0.5;

function ReceiverLugRearLength() = 0.75;
function ReceiverLugRearMinX() = -1.625;
function ReceiverLugRearMaxX() = ReceiverLugRearMinX()+ReceiverLugRearLength();
function ReceiverLugRearZ() = -1;


function ReceiverLugBoltRadius() = 0.0775;

function ReceiverLugBoltX(bolt) = bolt[0];
function ReceiverLugBoltZ(bolt) = bolt[1];

// XYZ
function ReceiverLugBoltsArray() = [

   // Front-Top
   [ReceiverLugFrontMaxX()+0.25,
    -0.375],

   // Back-Top
   [ReceiverLugRearMinX()+(ReceiverLugRearLength()/2),
    -0.375]
];

function LowerCenterWidth() = 0.51;

function LowerOffsetZ() = ReceiverBottomZ();

function LowerBolt() = BoltSpec(LOWER_BOLT);
assert(LowerBolt(), "LowerBolt() is undefined. Unknown LOWER_BOLT?");


function LowerWallFront() = 0.5;
function LowerMaxX() = ReceiverLugFrontMaxX()
                     + LowerWallFront();

function TriggerGuardDiameter() = 1;
function TriggerGuardDiameter() = 1;
function TriggerGuardRadius() = TriggerGuardDiameter()/2;

function TriggerGuardOffsetZ() = GripCeilingZ();
function TriggerGuardWall() = 0.3;

function TriggerPocketHeight() = GripCeiling()
                               + TriggerGuardDiameter();

function LowerGuardHeight() = TriggerPocketHeight()
                            + TriggerGuardWall();
                            

//************
//* Vitamins *
//************
module ReceiverLugBolts(boltSpec=BoltSpec(RECEIVER_LUG_BOLTS),
                            length=UnitsMetric(30),
                            head="socket", nut="hex",
                            cutter=false,
                            clearance=RECEIVER_LUG_BOLTS_CLEARANCE,
                            teardrop=false,
                            teardropAngle=90) {

  color("Silver")
  for (bolt = ReceiverLugBoltsArray())
  translate([ReceiverLugBoltX(bolt), -length/2, ReceiverLugBoltZ(bolt)])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length,
             head=head, nut=nut,
             teardrop=teardrop, teardropAngle=teardropAngle,
             clearance=(cutter?clearance:0), capOrientation=true,
             capHeightExtra=cutter ? 1 : 0,
             nutHeightExtra=cutter ? 1 : 0);
}

module Lower_Mount_TakedownPinRetainer(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([-LowerMaxX()+ReceiverLugRearMaxX(), 0, Receiver_TakedownPinZ()-0.125])
  rotate([0,-90,0])
  cylinder(r=(3/32/2)+clear, h=ReceiverLugRearMaxX()-Receiver_TakedownPinX()-LowerMaxX()+0.125);
  
  if (cutter)
  translate([-LowerMaxX()+ReceiverLugRearMinX(), 0, Receiver_TakedownPinZ()-0.125])
  rotate([0,-90,0])
  cylinder(r=0.125, h=2);
}

module GuardBolt(boltSpec=LowerBolt(), length=UnitsImperial(1.25),
                 head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT,
                 cutter=false, clearance=0.005) {

  color("Silver")
  translate([ReceiverLugBoltX(ReceiverLugBoltsArray()[0]),
             -LowerMaxY(),
             GripCeilingZ()-TriggerGuardDiameter()+0])
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

//**********
//* Shapes *
//**********
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

module TriggerGuardSlot(radius=TriggerGuardRadius(), length=0.6, $fn=Resolution(12, 60)) {

  union() {

    // Chamfered front edge
    translate([0.65+length, 0, TriggerGuardOffsetZ()])
    translate([0,1.25/2,-radius])
    rotate([90,0,0])
    ChamferedCircularHole(r1=radius, r2=1/16,
             h=1.25, $fn=$fn);

    // Chamfered rear edge
    intersection() {
      translate([0.65, 0, TriggerGuardOffsetZ()])
      translate([0,GripWidth()/2,-radius])
      rotate([90,0,0])
      ChamferedCircularHole(r1=radius, r2=1/4,
               h=GripWidth(), $fn=$fn);

      translate([0,-GripWidth(),TriggerGuardOffsetZ()])
      mirror([0,0,1])
      cube([length+(radius*4), GripWidth()*2, radius*2]);
    }

    // Slot hull
    translate([0.65, 0, TriggerGuardOffsetZ()])
    hull()
    for (i = [0,length])
    translate([i,0,-radius])
    rotate([90,0,0])
    cylinder(r=radius,
             h=2, $fn=$fn, center=true);
  }
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
          circle(r=0.43);
        
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
          circle(r=0.43);

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
    cube([LowerWallFront()+TriggerGuardRadius(), 0.5, LowerGuardHeight()]);
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
    translate([0,-(LowerCenterWidth()/2)-ManifoldGap(), ManifoldGap()])
    mirror([0,0,1]) {

      // Tigger Body
      translate([ReceiverLugRearMinX(),0,0])
      cube([ReceiverLugFrontMinX()+abs(ReceiverLugRearMinX()),
            LowerCenterWidth()+ManifoldGap(2),
            TriggerPocketHeight()]);

      // Trigger Front Extension Cutout
      cube([ReceiverLugFrontMaxX(),
            LowerCenterWidth()+ManifoldGap(2),
            TriggerPocketHeight()-TriggerGuardRadius()]);
    }

    ReceiverLugBolts(cutter=true);
  }
}

module LowerCutouts(chamferLugs=true, boltSpec=LowerBolt(), head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT) {
  ReceiverLugFront(width=LowerCenterWidth(),
                   cutter=true, chamferCutterHorizontal=chamferLugs);
  ReceiverLugRear(width=LowerCenterWidth(), hole=false,
                   cutter=true, chamferCutterHorizontal=chamferLugs);

  GuardBolt(length=1.25, boltSpec=boltSpec, head=head, nut=nut, cutter=true);

  HandleBolts(length=1.25, boltSpec=boltSpec, head=head, nut=nut, cutter=true);

  ReceiverLugBolts(length=1.25, boltSpec=boltSpec, head=head, nut=nut, cutter=true);

  TriggerGuardSlot();
}

module GripSplitter(clearance=0) {
  translate([-10, -(LowerCenterWidth()/2) -clearance, -10])
  cube([20, LowerCenterWidth()+(clearance*2), 20]);
}

module ReceiverLugRear(width=UnitsImperial(0.5), extraTop=ManifoldGap(),
                       cutter=false, clearance=UnitsImperial(0.002), clearVertical=false,
                       chamferCutterHorizontal=false,
                       teardrop=true, teardropAngle=90, hole=true) {

  color("DarkOrange")
  render()
  difference() {
    translate([ReceiverLugRearMinX(),0,ReceiverLugRearZ()])
    T_Lug(width=width, length=ReceiverLugRearLength(),
          height=abs(ReceiverLugRearZ())+extraTop,
          cutter=cutter, clearance=clearance, clearVertical=clearVertical,
          chamferCutterHorizontal=chamferCutterHorizontal);

    // Grip Bolt Hole
    if (hole)
    ReceiverLugBolts(teardrop=teardrop, teardropAngle=teardropAngle,
                         cutter=true);
  }
}

module ReceiverLugFront(width=UnitsImperial(0.5), extraTop=ManifoldGap(),
                        cutter=false, clearance=UnitsImperial(0.002), clearVertical=false,
                        chamferCutterHorizontal=false,) {
  color("DarkOrange")
  render()
  translate([ReceiverLugFrontMaxX(),0,ReceiverLugFrontZ()])
  mirror([1,0,0])
  T_Lug(width=width, length=ReceiverLugFrontLength(), tabWidth=1.25,
        height=abs(ReceiverLugFrontZ())+extraTop,
        cutter=cutter, clearance=clearance, clearVertical=clearVertical,
        chamferCutterHorizontal=chamferCutterHorizontal);
}

//*****************
//* Printed Parts *
//*****************
module Lower_MountFront(id=ReceiverID(), alpha=1, debug=false, doRender=true) {
  mountLength = 1.75-0.01;
  
  color("Chocolate")
  RenderIf(doRender) DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      translate([0,0,ReceiverBottomZ()])
      ReceiverLugFront(extraTop=-ReceiverBottomZ());
      
      translate([ReceiverLugFrontMaxX(),0,0])
      ReceiverBottomSlotInterface(length=mountLength, height=abs(ReceiverBottomZ()));
    }
    
    difference() {
      
      // Receiver ID
      translate([ReceiverLugFrontMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=id/2, r2=1/8, h=mountLength,
                            teardropBottom=true,
                            teardropTop=true);
      // Sear support
      hull() {
        translate([0.125,-0.3125/2,-(id/2)-0.3125])
        ChamferedCube([0.25, 0.3125, id/2], r=1/16, teardropFlip=[true,true,true]);
        
        translate([LowerMaxX()-1.25,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, 0.25], r=1/16, teardropFlip=[true,true,true]);
      }
    }
    
    translate([-0.01,0,ReceiverBottomZ()])
    Sear(length=SearLength()+abs(ReceiverBottomZ()), cutter=true);
  }
}

module Lower_MountRear(id=ReceiverID(), alpha=1, debug=false, doRender=true) {
  mountLength = ReceiverLength()
              - abs(ReceiverLugRearMaxX())
              - LowerMaxX()
              - ManifoldGap();
  
  color("Chocolate")
  RenderIf(doRender) DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      
      translate([0,0,ReceiverBottomZ()])
      ReceiverLugRear(extraTop=-ReceiverBottomZ());
      
      translate([ReceiverLugRearMaxX(),0,-0.26])
      ReceiverBottomSlotInterface(length=mountLength, height=abs(ReceiverBottomZ())-0.26);
    }
      
    translate([LowerMaxX(),0,0])
    Receiver_TakedownPin(cutter=true);
    
    translate([LowerMaxX(),0,0])
    Lower_Mount_TakedownPinRetainer(cutter=true);
    
    difference() {
      
      // Receiver ID
      translate([ReceiverLugRearMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=id/2, r2=1/8, h=mountLength,
                            teardropBottom=true,
                            teardropTop=true);
      
      // Hammer Guide
      translate([ReceiverLugRearMaxX(),-0.3125/2,-(id/2)-0.375])
      mirror([1,0,0])
      ChamferedCube([mountLength, 0.3125, id/2], r=1/16, teardropFlip=[true,true,true]);
      
      // Bevel
      translate([LowerMaxX()-ReceiverLength()+00.75,-ReceiverIR(),-ReceiverIR()])
      rotate([0,-90-45,0])
      cube([ReceiverID(), ReceiverID(), ReceiverID()]);
      
    }
  }
}

//**************
//* Assemblies *
//**************
module LowerMount(id=ReceiverID(), alpha=1, debug=false) {
  Lower_Mount_TakedownPinRetainer();
  
  Receiver_TakedownPin();
  
  if (_SHOW_LOWERMOUNT_FRONT)
  Lower_MountFront(debug=_CUTAWAY_LOWERMOUNT_FRONT);
  
  if (_SHOW_LOWERMOUNT_REAR)
  Lower_MountRear(debug=_CUTAWAY_LOWERMOUNT_REAR);
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
            showMiddle=true, showLeft=true, showRight=true,
            boltSpec=LowerBolt(), boltHead=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT,
            alpha=1) {
      boltLength = 1.25;

  translate([-LowerMaxX(),0, LowerOffsetZ()]) {

    // Trigger Guard Center
    if (showMiddle)
    Lower_Middle();

    if (showReceiverLugs) {
      ReceiverLugFront(width=LowerCenterWidth());
      ReceiverLugRear(width=LowerCenterWidth());
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
}

scale(25.4)
if ($preview) {
  Lower(showReceiverLugs=_SHOW_LOWER_LUGS, showReceiverLugBolts=true,
        showGuardBolt=true,
        showHandleBolts=true,
        showLeft=_SHOW_LOWER_LEFT,
        showMiddle=_SHOW_LOWER_MIDDLE,
        showRight=_SHOW_LOWER_RIGHT,
        alpha=_ALPHA_LOWER);
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Lower_Left")
    if (!_RENDER_PRINT)
      LowerSidePlates(showLeft=true, showRight=false);
    else
      rotate(180)
      rotate([90,0,0])
      translate([0,-0.25,2.125])
      LowerSidePlates(showLeft=true, showRight=false);

  if (_RENDER == "Lower_Right")
    if (!_RENDER_PRINT)
      LowerSidePlates(showLeft=false, showRight=true);
    else
      rotate([-90,0,0])
      translate([0,0.25,2.125])
      LowerSidePlates(showLeft=false, showRight=true);

  if (_RENDER == "Lower_Middle")
    if (!_RENDER_PRINT)
      translate([0,0.25,2.125])
      Lower_Middle();
    else
      rotate(180)
      rotate([90,0,0])
      translate([0,0.25,2.125])
      Lower_Middle();

  if (_RENDER == "Lower_MountFront")
    if (!_RENDER_PRINT)
      Lower_MountFront();
    else
    rotate([0,90,0])
    translate([0.5,0,-ReceiverBottomZ()])
    Lower_MountFront();
    
  if (_RENDER == "Lower_MountRear")
    if (!_RENDER_PRINT)
      Lower_MountRear();
    else
      rotate([0,90,0])
      translate([LowerMaxX()-ReceiverLugRearMaxX(),0,-ReceiverBottomZ()])
      Lower_MountRear();
    
  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Lower_Bolts") {
    ReceiverLugBolts();
    GuardBolt();
    HandleBolts();
  }
  
  if (_RENDER == "Lower_Mount_TakedownPinRetainer")
  Lower_Mount_TakedownPinRetainer();
  
  /*
  
  ReceiverLugRear(cutter=false);

  ReceiverLugFront();

  ReceiverLugBolts();
  */

}
