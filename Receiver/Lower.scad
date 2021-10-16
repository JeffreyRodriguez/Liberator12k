
//$t=0.6;
use <../Meta/Cutaway.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
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
_SHOW_RECEIVER = true;
_SHOW_FCG = true;
_SHOW_LOWER_LEFT = true;
_SHOW_LOWER_RIGHT = true;
_SHOW_LOWER_MIDDLE = true;
_SHOW_LOWER_MOUNT_FRONT = true;
_SHOW_LOWER_MOUNT_REAR = true;
_SHOW_LOWER_BOLTS = true;
_SHOW_TAKEDOWN_PIN = true;
_SHOW_TAKEDOWN_PIN_RETAINER = true;

/* [Transparency] */
_ALPHA_LOWER = 1;    // [0:0.1:1]
_ALPHA_RECEIVER = 1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_LOWER = true;
_CUTAWAY_LOWERMOUNT_FRONT = false;
_CUTAWAY_LOWERMOUNT_REAR = false;
_CUTAWAY_RECEIVER = false;

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


function Lower_BoltX(bolt) = bolt[0];
function Lower_BoltZ(bolt) = bolt[1];

// XYZ
function Lower_BoltsArray() = [

   // Front-Top
   [ReceiverLugFrontMaxX()+0.25,
    -0.375],

   // Back-Top
   [ReceiverLugRearMinX()+(ReceiverLugRearLength()/2),
    -0.375],
    
   // Front-Bottom
   [ReceiverLugFrontMaxX()+0.25,
    GripCeilingZ()-TriggerGuardDiameter()],

   // Handle Bottom-Rear
   [-2.0,GripCeilingZ()-2.9],

   // Handle Bottom-Front
   [-1.375,GripCeilingZ()-1.375]
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
module Lower_Bolts(boltSpec=LowerBolt(),
                  length=UnitsMetric(30),
                  head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT,
                  cutter=false,
                  clearance=RECEIVER_LUG_BOLTS_CLEARANCE,
                  teardrop=false,
                  teardropAngle=90) {

  // Receiver lug bolt
  for (bolt = Lower_BoltsArray())
  translate([-LowerMaxX(),0, LowerOffsetZ()])
  translate([Lower_BoltX(bolt), -length/2, Lower_BoltZ(bolt)])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length,
             head=head, nut=nut,
             teardrop=teardrop, teardropAngle=teardropAngle,
             clearance=(cutter?clearance:0), capOrientation=true,
             capHeightExtra=cutter ? 1 : 0,
             nutHeightExtra=cutter ? 1 : 0,
             doRender=!cutter);
}

module Lower_MountTakedownPinRetainer(cutter=false, clearance=0.005) {
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


//**********
//* Shapes *
//**********
module TriggerGuardSlot(radius=TriggerGuardRadius(), length=0.6, $fn=Resolution(12, 60)) {

  translate([-LowerMaxX(),0, LowerOffsetZ()])
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
      translate([-LowerMaxX(),0, LowerOffsetZ()])
      translate([ReceiverLugRearMinX(), -GripWidth()/2, -height])
      ChamferedCube([LowerMaxX()+abs(ReceiverLugRearMinX()),
            GripWidth(),
            height], r=0.0625);

      // Bottom chamfer
      translate([-LowerMaxX(),0, LowerOffsetZ()])
      translate([0,0,-height+0.1])
      rotate([0,-90,0])
      linear_extrude(height=5, center=true)
      difference() {
        translate([-height,-GripWidth()])
        square([height,GripWidth()*2]);

        hull()
        for (i = [-1, 1])
        translate([0,((GripWidth()/2)-0.09)*i])
        circle(r=0.1);
      }
    }

    LowerReceiverSupports();
    
    translate([-LowerMaxX(),0, LowerOffsetZ()])
    GripHandle();

    // Text
    translate([-LowerMaxX(),0, LowerOffsetZ()])
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
  translate([-LowerMaxX(),0, LowerOffsetZ()])
  translate([LowerMaxX()-0.25,-GripWidth()/2,0])
  mirror([1,0,0])
  mirror([0,0,1])
  cube([LowerMaxX(), GripWidth(), GripCeiling()]);

  // Front receiver lug support
  translate([-LowerMaxX(),0, LowerOffsetZ()])
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
  translate([-LowerMaxX(),0, LowerOffsetZ()])
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
  translate([-LowerMaxX(),0, LowerOffsetZ()])
  hull() {

    translate([Lower_BoltX(Lower_BoltsArray()[1])-0.4,-(GripWidth()/2)+ManifoldGap(),0])
    mirror([0,0,1])
    ChamferedCube([1, GripWidth(), 0.74], r=1/16);

    translate([Lower_BoltX(Lower_BoltsArray()[1]),0,Lower_BoltZ(Lower_BoltsArray()[1])])
    rotate([90,0,0])
    cylinder(r=0.225, h=1.25, center=true);
  }
}

module LowerTriggerPocket() {
  translate([-LowerMaxX(),0,ReceiverBottomZ()])
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
}

module LowerCutouts(chamferLugs=true) {
  ReceiverLugFront(width=LowerCenterWidth(),
                   cutter=true, chamferCutterHorizontal=chamferLugs);
  ReceiverLugRear(width=LowerCenterWidth(), hole=false,
                   cutter=true, chamferCutterHorizontal=chamferLugs);

  Lower_Bolts(cutter=true);

  TriggerGuardSlot();
}

module GripSplitter(clearance=0) {
  translate([-10, -(LowerCenterWidth()/2) -clearance, -10])
  cube([20, LowerCenterWidth()+(clearance*2), 20]);
}

module ReceiverLugRear(width=UnitsImperial(0.5), extraTop=ManifoldGap(),
                       cutter=false, clearance=UnitsImperial(0.002), clearVertical=false,
                       chamferCutterHorizontal=false,
                       teardrop=true, teardropAngle=90, hole=true, doRender=true) {

  color("DarkOrange")
  RenderIf(doRender)
  difference() {
    translate([0,0,ReceiverBottomZ()])
    translate([ReceiverLugRearMinX()-LowerMaxX(),0,ReceiverLugRearZ()])
    T_Lug(width=width, length=ReceiverLugRearLength(),
          height=abs(ReceiverLugRearZ())+extraTop,
          cutter=cutter, clearance=clearance, clearVertical=clearVertical,
          chamferCutterHorizontal=chamferCutterHorizontal);

    // Grip Bolt Hole
    if (hole)
    Lower_Bolts(teardrop=teardrop, teardropAngle=teardropAngle,
                         cutter=true);
  }
}

module ReceiverLugFront(width=UnitsImperial(0.5), extraTop=ManifoldGap(),
                        cutter=false, clearance=UnitsImperial(0.002), clearVertical=false,
                        chamferCutterHorizontal=false, doRender=false) {
  color("DarkOrange")
  RenderIf(doRender)
  translate([ReceiverLugFrontMaxX()-LowerMaxX(),0,LowerOffsetZ()+ReceiverLugFrontZ()])
  mirror([1,0,0])
  T_Lug(width=width, length=ReceiverLugFrontLength(), tabWidth=1.25,
        height=abs(ReceiverLugFrontZ())+extraTop,
        cutter=cutter, clearance=clearance, clearVertical=clearVertical,
        chamferCutterHorizontal=chamferCutterHorizontal);
}

//*****************
//* Printed Parts *
//*****************
module Lower_MountFront(id=ReceiverID(), alpha=1, cutaway=false, doRender=true) {
  mountLength = 1.75-0.01;
  
  color("Chocolate")
  RenderIf(doRender) Cutaway(cutaway)
  difference() {
    union() {
      ReceiverLugFront(doRender=false, extraTop=-ReceiverBottomZ());
      
      translate([ReceiverLugFrontMaxX()-LowerMaxX(),0,0])
      ReceiverBottomSlotInterface(length=mountLength, height=abs(ReceiverBottomZ()));
    }
    
    difference() {
      
      // Receiver ID
      translate([ReceiverLugFrontMaxX()-LowerMaxX()+ManifoldGap(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=id/2, r2=1/8, h=mountLength+ManifoldGap(2),
                            teardropBottom=true,
                            teardropTop=true);
      // Sear support
      translate([-LowerMaxX(),0,0])
      hull() {
        translate([0.125,-0.3125/2,-(id/2)-0.3125])
        ChamferedCube([0.25, 0.3125, id/2], r=1/16, teardropFlip=[true,true,true]);
        
        translate([LowerMaxX()-1.25,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, 0.25], r=1/16, teardropFlip=[true,true,true]);
      }
    }
    
    Sear(length=SearLength()+abs(ReceiverBottomZ()), cutter=true, clearance=0.015);
  }
}

module Lower_MountRear(id=ReceiverID(), alpha=1, cutaway=false, doRender=true) {
  mountLength = ReceiverLength()
              - abs(ReceiverLugRearMaxX())
              - LowerMaxX()
              - ManifoldGap();
  
  color("Chocolate")
  RenderIf(doRender) Cutaway(cutaway)
  difference() {
    union() {
      
      ReceiverLugRear(doRender=doRender, extraTop=-ReceiverBottomZ());
      
      translate([-LowerMaxX(),0, 0])
      translate([ReceiverLugRearMaxX(),0,-0.26])
      ReceiverBottomSlotInterface(length=mountLength, height=abs(ReceiverBottomZ())-0.26);
    }
      
    Receiver_TakedownPin(cutter=true);
    
    Lower_MountTakedownPinRetainer(cutter=true);
    
    difference() {
      
      // Receiver ID
      translate([-LowerMaxX()+ReceiverLugRearMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=id/2, r2=1/8, h=mountLength,
                            teardropBottom=true,
                            teardropTop=true);
      
      // Hammer Guide
      translate([-LowerMaxX()+ReceiverLugRearMaxX(),-0.3125/2,-(id/2)-0.375])
      mirror([1,0,0])
      ChamferedCube([mountLength, 0.3125, id/2], r=1/16, teardropFlip=[true,true,true]);
      
      // Bevel
      translate([-ReceiverLength()+00.75,-ReceiverIR(),-ReceiverIR()])
      rotate([0,-90-45,0])
      cube([ReceiverID(), ReceiverID(), ReceiverID()]);
      
    }
  }
}

module Lower_SidePlates(showLeft=true, showRight=true, alpha=1) {

  // Trigger Guard Sides
  color("Tan", alpha)
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

module Lower_Middle() {
  color("Chocolate") render()
  difference() {
    intersection() {
      TriggerGuard();

      // Just the middle
      GripSplitter(clearance=0);
    }

    LowerCutouts(chamferLugs=false);

    // Trigger Pocket
    LowerTriggerPocket();

    // #L12K easter egg
    if (Resolution(false, true))
    translate([-LowerMaxX(),0, LowerOffsetZ()])
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
//**************
//* Assemblies *
//**************
module LowerMount(alpha=1, cutaway=false) {
  if (_SHOW_TAKEDOWN_PIN_RETAINER)
  Lower_MountTakedownPinRetainer();
  
  if (_SHOW_TAKEDOWN_PIN)
  Receiver_TakedownPin();
  
  if (_SHOW_LOWER_MOUNT_FRONT)
  Lower_MountFront();
  
  if (_SHOW_LOWER_MOUNT_REAR)
  Lower_MountRear();
}

module Lower(bolts=true,
            showMiddle=true, showLeft=true, showRight=true,
            cutaway=false, alpha=1) {
      boltLength = 1.25;
  // Trigger Guard Center
  if (showMiddle)
  Lower_Middle();

  if (_SHOW_LOWER_BOLTS)
  Lower_Bolts();

  Lower_SidePlates(showLeft=showLeft, showRight=showRight, alpha=alpha);
}

scale(25.4)
if ($preview) {
  LowerMount();
  
  Lower(bolts=_SHOW_LOWER_BOLTS,
         showLeft=_SHOW_LOWER_LEFT, showRight=_SHOW_LOWER_RIGHT,
         showMiddle=_SHOW_LOWER_MIDDLE,
         alpha=_ALPHA_LOWER);
  
  if (_SHOW_FCG)
  SimpleFireControlAssembly();
  
  if (_SHOW_RECEIVER)
  Receiver(cutaway=_CUTAWAY_RECEIVER, alpha=_ALPHA_RECEIVER);
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/Lower_Left")
    if (!_RENDER_PRINT)
      Lower_SidePlates(showLeft=true, showRight=false);
    else
      rotate(180)
      rotate([90,0,0])
      translate([0,-0.25,2.125])
      Lower_SidePlates(showLeft=true, showRight=false);

  if (_RENDER == "Prints/Lower_Right")
    if (!_RENDER_PRINT)
      Lower_SidePlates(showLeft=false, showRight=true);
    else
      rotate([-90,0,0])
      translate([0,0.25,2.125])
      Lower_SidePlates(showLeft=false, showRight=true);

  if (_RENDER == "Prints/Lower_Middle")
    if (!_RENDER_PRINT)
      Lower_Middle();
    else
      rotate(180)
      rotate([90,0,0])
      translate([0,0.25,2.125])
      Lower_Middle();

  if (_RENDER == "Prints/Lower_MountFront")
    if (!_RENDER_PRINT)
      Lower_MountFront();
    else
    rotate([0,90,0])
    translate([0.5,0,-ReceiverBottomZ()])
    Lower_MountFront();
    
  if (_RENDER == "Prints/Lower_MountRear")
    if (!_RENDER_PRINT)
      Lower_MountRear();
    else
      rotate([0,90,0])
      translate([LowerMaxX()-ReceiverLugRearMaxX(),0,-ReceiverBottomZ()])
      Lower_MountRear();
  
  /*
  ReceiverLugRear(cutter=false);
  ReceiverLugFront();
  */
    
  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/Lower_Bolts")
  Lower_Bolts();
  
  if (_RENDER == "Hardware/Lower_MountTakedownPinRetainer")
  Lower_MountTakedownPinRetainer();

}
