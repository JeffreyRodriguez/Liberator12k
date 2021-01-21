include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/HullIf.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Receiver Assembly"; // ["Receiver Assembly", "Receiver", "ReceiverBackSegment"]

_SHOW_RECEIVER            = true;
_SHOW_RECEIVER_RODS       = true;
_SHOW_RECEIVER_BACK       = true;
_SHOW_RECEIVER_STOCK      = true;
_SHOW_RECEIVER_SIDEPLATES = true;

_RECEIVER_ALPHA = 1; // [0:0.1:1]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

/* [Receiver Options] */
RECEIVER_TUBE_OD =  1.7501;
RECEIVER_OD      = 2.0001;
RECEIVER_ID      = 1.2501;

/* [Bolts] */
RECEIVER_SIDEPLATE_BOLT = "#8-32";          // ["M4", "#8-32"]
RECEIVER_SIDEPLATE_BOLT_HEAD = "flat";      // ["socket", "flat"]
RECEIVER_SIDEPLATE_BOLT_NUT = "heatset";    // ["hex", "heatset"]
RECEIVER_SIDEPLATE_BOLT_CLEARANCE = 0.005;

RECEIVER_TENSION_NUT_TYPE = "heatset";    // ["hex", "heatset"]
RECEIVER_TENSION_BOLT = "#8-32";          // ["M4", "#8-32", "#10-24", "1/4\"-20"]
RECEIVER_TENSION_BOLT_CLEARANCE = 0.01;

// Settings: Vitamins
function ReceiverSideplateBolt() = BoltSpec(RECEIVER_SIDEPLATE_BOLT);
assert(ReceiverSideplateBolt(), "ReceiverSideplateBolt() is undefined. Unknown RECEIVER_SIDEPLATE_BOLT?");

function ReceiverRod() = BoltSpec(RECEIVER_TENSION_BOLT);
assert(ReceiverRod(), "ReceiverRod() is undefined. Unknown RECEIVER_TENSION_BOLT?");

// Settings: Lengths
function ReceiverLength() = 4.5;
function ReceiverBackLength() = 0.5;
function ReceiverStockLength() = 12-ReceiverLength()-ReceiverBackLength()-0.1875;
function ReceiverTopSlotWidth() = 0.75;
function ReceiverBottomSlotWidth() = 1;
function ReceiverSideSlotHeight() = 0.5;
function RecieverSideSlotDepth() = 0.125;

// Settings: Diameters
function ReceiverOD()     = RECEIVER_OD;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverID()     = RECEIVER_ID;
function ReceiverIR()     = ReceiverID()/2;

// Settings: Walls
function WallTensionRod() = 0.1875;

// Settings: Positions
function LowerOffsetZ() = -1.125;

function TensionRodBottomZ() = -7/8;
function TensionRodBottomOffsetSide() = 0.75;

function TensionRodTopZ() = 0.75;
function TensionRodTopOffsetSide() = 0.625;

function ReceiverBottomZ() = TensionRodBottomZ()-WallTensionRod();
function ReceiverTopZ() = TensionRodTopZ()-WallTensionRod();

// ************
// * Vitamins *
// ************
module ReceiverRodIterator() {
  for (YZ = [[TensionRodTopOffsetSide(),TensionRodTopZ()],
             [-TensionRodTopOffsetSide(),TensionRodTopZ()],
             [TensionRodBottomOffsetSide(),TensionRodBottomZ()],
             [-TensionRodBottomOffsetSide(),TensionRodBottomZ()]])
  translate([0,YZ[0], YZ[1]])
  rotate([0,-90,0])
  children();
}
module ReceiverRods(headType="none", nutType=RECEIVER_TENSION_NUT_TYPE, length=12, cutter=false, clearance=RECEIVER_TENSION_BOLT_CLEARANCE, teardrop=false, debug=false) {

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  ReceiverRodIterator()
  NutAndBolt(bolt=ReceiverRod(),
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?0.375:0),
             nut=nutType,
             teardrop=cutter&&teardrop,
             clearance=cutter?clearance:0);
}


module ReceiverBottomSlot(clearance=0.005) {
  translate([-0.5, -(ReceiverBottomSlotWidth()/2)-clearance,0])
  mirror([1,0,0])
  mirror([0,0,1])
  cube([ReceiverLength()-0.5,ReceiverBottomSlotWidth()+(clearance*2),abs(TensionRodBottomZ())]);

  translate([-0.5, -(ReceiverBottomSlotWidth()/2)+0.125-clearance,0])
  mirror([1,0,0])
  mirror([0,0,1])
  cube([ReceiverLength()-0.5,ReceiverBottomSlotWidth()-0.25+(clearance*2),abs(TensionRodBottomZ())+25]);
}

module ReceiverTopSlot(length=ReceiverLength(), width=ReceiverTopSlotWidth(), height=2, clearance=0.005) {
  chamferRadius = 1/32;
  
  intersection() {
    translate([ManifoldGap()+chamferRadius, -(width/2)-clearance,0])
    mirror([1,0,0])
    ChamferedCube([ManifoldGap()+length+(chamferRadius*2),width+(clearance*2),height], r=chamferRadius);
  
    translate([ManifoldGap(), -(width/2)-clearance,0])
    mirror([1,0,0])
    cube([ManifoldGap()+length,width+(clearance*2),height]);
  }
}

module ReceiverSegment(length=1, chamferFront=true, chamferBack=true) {
  hull() {
    
    // Around the stock tube
    rotate([0,-90,0])
    ChamferedCylinder(r1=ReceiverOR(), r2=1/16,h=length,
                      chamferBottom=chamferFront, chamferTop=chamferBack,
                      $fn=Resolution(30,60));
    
    // Tension bolt supports
    ReceiverRodIterator()
    ChamferedCylinder(r1=WallTensionRod(), r2=1/16, h=length,
                      chamferBottom=chamferFront, chamferTop=chamferBack,
                      teardropTop=true, $fn=Resolution(15,30));
  }
  
  // Flat bottom
  translate([-length, -TensionRodBottomOffsetSide(), -ReceiverOR()])
  rotate([90,0,90])
  linear_extrude(height=length)
  ChamferedSquare(xy=[(TensionRodBottomOffsetSide())*2,ReceiverOR()], r=1/16,
                  teardropBottom=false,
                  teardropTop=false);
  
  // Flat sides
  *translate([-length, -ReceiverOR(), -1/2])
  rotate([90,0,90])
  linear_extrude(height=length)
  ChamferedSquare(xy=[ReceiverOD(),1], r=1/16,
                  teardropBottom=false,
                  teardropTop=false);
  
  *translate([-length, -ReceiverOR(), -1/2])
  ChamferedCube([length, ReceiverOD(),1],
                 chamferXYZ=[1,0,chamferFront||chamferBack?1:0], r=1/16);
}
module Receiver(receiverLength=ReceiverLength(), topSlotHeight=ManifoldGap(), doRender=true, alpha=1, debug=false) {

  color("DimGray", alpha) RenderIf(doRender)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      ReceiverSegment(length=ReceiverLength(),
                      chamferFront=false, chamferBack=false);
      
      children();
    }
    
    // ID cutout
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=6, $fn=Resolution(40,80));
    
    ReceiverTopSlot(height=topSlotHeight);
    ReceiverBottomSlot();

    // Side slots
    translate([-0.5,-(ReceiverIR()+RecieverSideSlotDepth()),-ReceiverSideSlotHeight()/2])
    mirror([1,0,0])
    ChamferedCube([ReceiverLength(),
                   (ReceiverIR()+RecieverSideSlotDepth())*2,
                   ReceiverSideSlotHeight()],
                  r=1/16, teardropXYZ=[false, false, false],
                  teardropTopXYZ=[false, false, false]);
    
    ReceiverRods(cutter=true);
  }
}

module ReceiverBackSegment(length=ReceiverBackLength()) {
  color("Brown") render()
  difference() {
    translate([-ReceiverLength(),0,0])
    ReceiverSegment(length=length, chamferBack=false, chamferFront=false);
    
    ReceiverRods(nutType="none", headType="none", cutter=true);
    
    translate([-ReceiverLength(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=0.65/2, r2=1/16, chamferTop=false,
                          h=length-0.1875, $fn=40);
  }
}

module ReceiverBackSegment_print() {
  rotate([0,-90,0])
  translate([ReceiverLength()+ReceiverBackLength(),0,0])
  ReceiverBackSegment();
}

module ReceiverAssembly(debug=false) {
  if (_SHOW_RECEIVER_RODS)
  ReceiverRods();

  if (_SHOW_RECEIVER)
  Receiver(alpha=_RECEIVER_ALPHA, debug=debug)
  children();
}


if (_RENDER == "Receiver Assembly") {
  ReceiverAssembly(debug=_DEBUG_ASSEMBLY);
  
  ReceiverBackSegment();
}
  
scale(25.4) {
  
  if (_RENDER == "Receiver")
  rotate([0,90,0])
  Receiver();
  
  if (_RENDER == "MiniReceiver")
  rotate([0,90,0])
  Receiver();
  
  if (_RENDER == "ReceiverStockSegment")
  ReceiverStockSegment_print();

  if (_RENDER == "ReceiverBackSegment")
  ReceiverBackSegment_print();
  
}
