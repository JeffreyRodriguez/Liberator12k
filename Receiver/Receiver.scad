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

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Receiver", "Receiver_Back"]

/* [Assembly] */
_SHOW_RECEIVER            = true;
_SHOW_RECEIVER_RODS       = true;
_SHOW_RECEIVER_BACK       = true;

_ALPHA_RECEIVER = 1; // [0:0.1:1]

_CUTAWAY_RECEIVER = false;

/* [Vitamins] */

// Threaded rods that extend through the receiver and stock.
TENSION_BOLT           = "#8-32";   // ["M4", "#8-32", "#10-24", "1/4\"-20"]
TENSION_NUT_TYPE       = "heatset"; // ["hex", "heatset"]
TENSION_BOLT_CLEARANCE = 0.01;
TENSION_BOLT_LENGTH    = 12;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32", "#10-24", "1/4\"-20"]

// Settings: Vitamins
function TensionBolt() = BoltSpec(TENSION_BOLT);
assert(TensionBolt(), "TensionBolt() is undefined. Unknown TENSION_BOLT?");

function MlokBolt() = BoltSpec(TENSION_BOLT);
assert(MlokBolt(), "TensionBolt() is undefined. Unknown MLOK_BOLT?");


// Settings: Lengths
function ReceiverLength() = 4.5;
function ReceiverBackLength() = 0.5;
function ReceiverStockLength() = 12
                               - ReceiverLength()
                               - ReceiverBackLength()
                               - 0.1875;

function ReceiverBottomSlotWidth() = 1;

function ReceiverTopSlotWidth() = 0.75;
function ReceiverTopSlotHeight() = 1.25;
function ReceiverTopSlotHorizontalWidth() = ReceiverTopSlotWidth()+0.25;
function ReceiverTopSlotHorizontalHeight() = 0.25;

function ReceiverSideSlotHeight() = 0.5;
function ReceiverSideSlotDepth() = 0.125;
function ReceiverSlotClearance() = 0.005;


// Settings: Diameters
function ReceiverOD()     = 2;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverID()     = 1.25;
function ReceiverIR()     = ReceiverID()/2;

// Settings: Walls
function WallTensionRod() = 0.25;

// Settings: Positions
function TensionBoltLength() = TENSION_BOLT_LENGTH;

function TensionRodBottomZ() = -7/8;
function TensionRodBottomOffsetSide() = 0.75;

function TensionRodTopZ() = 0.75;
function TensionRodTopOffsetSide() = 0.625;

function ReceiverBottomZ() = TensionRodBottomZ()-WallTensionRod();
function ReceiverTopZ() = TensionRodTopZ()+WallTensionRod()+0.625;

// ************
// * Vitamins *
// ************
module TensionBoltIterator() {
  for (YZ = [[TensionRodTopOffsetSide(),TensionRodTopZ()],
             [-TensionRodTopOffsetSide(),TensionRodTopZ()],
             [TensionRodBottomOffsetSide(),TensionRodBottomZ()],
             [-TensionRodBottomOffsetSide(),TensionRodBottomZ()]])
  translate([0,YZ[0], YZ[1]])
  rotate([0,-90,0])
  children();
}
module TensionBolts(headType="none", nutType=TENSION_NUT_TYPE, length=12, cutter=false, clearance=TENSION_BOLT_CLEARANCE, teardrop=false, debug=false) {

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  TensionBoltIterator()
  NutAndBolt(bolt=TensionBolt(),
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?0.375:0),
             nut=nutType,
             teardrop=cutter&&teardrop,
             clearance=cutter?clearance:0);
}


module ReceiverMlokBolts(headType="flat", nutType="heatset", length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  color("Silver") RenderIf(!cutter)
  for (X = [0,UnitsMetric(60),UnitsMetric(80)])
  translate([-0.75-X,0,ReceiverTopSlotHeight()+ReceiverSlotClearance()])
  NutAndBolt(bolt=MlokBolt(),
             boltLength=length+ManifoldGap(2),
             head=headType,
             nut=nutType, nutHeightExtra=(cutter?1:0),
             teardrop=cutter&&teardrop, teardropAngle=180,
             clearance=cutter?clearance:0);
}
// **********
// * Shapes *
// **********
module ReceiverMlokSlot(length=ReceiverLength(), depth=0.0625, clearance=0) {
  width = UnitsMetric(7)+clearance;
  
  translate([0, -width/2, ReceiverTopZ()+ManifoldGap()])
  mirror([0,0,1])
  mirror([1,0,0])
  cube([length, width, depth]);
}
module ReceiverBottomSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance()) {
  translate([-0.5, -(ReceiverBottomSlotWidth()/2)-clearance,0])
  mirror([1,0,0])
  mirror([0,0,1])
  cube([length-0.5,ReceiverBottomSlotWidth()+(clearance*2),abs(TensionRodBottomZ())]);

  translate([-0.5, -(ReceiverBottomSlotWidth()/2)+0.125-clearance,0])
  mirror([1,0,0])
  mirror([0,0,1])
  cube([length-0.5,ReceiverBottomSlotWidth()-0.25+(clearance*2),abs(TensionRodBottomZ())+25]);
}

module ReceiverBottomSlotInterface(length=0.75, height=ReceiverOR(), extension=0, clearance=0.005) {
  clear = clearance;
  clear2 = clear*2;
  
  difference() {
    union() {
      translate([-length,-(1/2)+clear,-height+WallTensionRod()+clear])
      ChamferedCube([length, 1-clear2, height-WallTensionRod()], r=1/32, teardropFlip=[true,true,true]);
      
      translate([-length,-(0.75/2)+clear,-height-extension])
      ChamferedCube([length, 0.75-clear2, height+extension], r=1/32, teardropFlip=[true,true,true]);
    }
  }
}
module ReceiverTopSlot(length=ReceiverLength(), width=ReceiverTopSlotWidth(), height=ReceiverTopSlotHeight(), clearance=ReceiverSlotClearance()) {
  chamferRadius = 1/32;
  horizontalWidth = ReceiverTopSlotHorizontalWidth();
  horizontalHeight = ReceiverTopSlotHorizontalHeight();
  
  rotate([0,-90,0])
  linear_extrude(length) {
    
    // Vertical slot
    translate([0,-(width/2)-clearance])
    ChamferedSquare([height+clearance, width+(clearance*2)],
                     r=chamferRadius,
                     teardropTop=false, teardropBottom=false);
    
    // Horizontal slot
    translate([TensionRodTopZ()+WallTensionRod()-clearance,
               -(horizontalWidth/2)-clearance])
    ChamferedSquare([horizontalHeight+clearance*2,
                     horizontalWidth+(clearance*2)],
                     r=chamferRadius,
                     teardropTop=false, teardropBottom=false);
  }
}

module ReceiverSideSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance()) {
  clear = clearance;
  clear2 = clear*2;
  
  width = (ReceiverIR()+ReceiverSideSlotDepth()+clear)*2;
  height = ReceiverSideSlotHeight()+clear2;
  
  translate([0,-width/2,-height/2])
  rotate([0,-90,0])
  linear_extrude(length)
  ChamferedSquare(xy=[height,width], r=1/16,
                  teardropTop=false, teardropBottom=false);
}
module ReceiverTopSegment(length=1) {
  translate([0, -TensionRodTopOffsetSide(), 0])
  rotate([0,-90,0])
  linear_extrude(length)
  ChamferedSquare(xy=[ReceiverTopZ(),(TensionRodTopOffsetSide()*2)], r=1/4,
                  teardropBottom=false,
                  teardropTop=false, $fn=50);
}

module ReceiverSegment(length=1, chamferFront=false, chamferBack=false, highTop=true) {
  hull() {
    
    // Around the stock tube
    rotate([0,-90,0])
    ChamferedCylinder(r1=ReceiverOR(), r2=1/16,h=length,
                      chamferBottom=chamferFront, chamferTop=chamferBack,
                      $fn=Resolution(50,120));
    
    // Tension bolt supports
    TensionBoltIterator()
    ChamferedCylinder(r1=WallTensionRod(), r2=1/16, h=length,
                      chamferBottom=chamferFront, chamferTop=chamferBack,
                      teardropTop=true, $fn=Resolution(20,40));
    
    // Top cover
    if (highTop)
    ReceiverTopSegment(length=length);
  }
  
  // Flat bottom
  translate([-length, -TensionRodBottomOffsetSide(), -ReceiverOR()])
  rotate([90,0,90])
  linear_extrude(height=length)
  ChamferedSquare(xy=[(TensionRodBottomOffsetSide())*2,ReceiverOR()], r=1/16,
                  teardropBottom=false,
                  teardropTop=false);
}


// *****************
// * Printed Parts *
// *****************
module Receiver(receiverLength=ReceiverLength(), doRender=true, alpha=1, debug=false) {

  color("Tan", alpha) RenderIf(doRender)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      ReceiverSegment(length=ReceiverLength());
      
      children();
    }
    
    // ID cutout
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=6, $fn=Resolution(40,80));
    
    ReceiverMlokSlot();
    ReceiverMlokBolts(cutter=true, teardrop=true);
    
    ReceiverTopSlot();
    ReceiverBottomSlot();
    ReceiverSideSlot();
    
    TensionBolts(cutter=true);
  }
}

module ReceiverBackSegment(length=ReceiverBackLength()) {
  color("Chocolate") render()
  difference() {
    translate([-ReceiverLength(),0,0])
    ReceiverSegment(length=length);
    
    TensionBolts(nutType="none", headType="none", cutter=true);
    
    // Spring hole
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

// **************
// * Assemblies *
// **************
module ReceiverAssembly(debug=false) {
  if (_SHOW_RECEIVER_RODS)
  TensionBolts(debug=debug);

  if (_SHOW_RECEIVER) {
    Receiver(alpha=_ALPHA_RECEIVER, debug=debug)
    children();
    
    ReceiverMlokBolts();
  }
}



scale(25.4)
if ($preview) {
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  
  if (_SHOW_RECEIVER_BACK)
  ReceiverBackSegment();
} else {
  
  if (_RENDER == "Receiver")
  rotate([0,90,0])
  Receiver();

  if (_RENDER == "Receiver_Back")
  ReceiverBackSegment_print();
  
}
