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

function MlokBolt() = BoltSpec(MLOK_BOLT);
assert(MlokBolt(), "MlokBolt() is undefined. Unknown MLOK_BOLT?");


// Settings: Lengths
function ReceiverLength() = 5;
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

function ReceiverTakedownPinX() = -ReceiverLength()+0.375;
function ReceiverTakedownPinZ() = TensionRodBottomZ()+WallTensionRod();

function ReceiverBottomZ() = TensionRodBottomZ()-WallTensionRod();
function ReceiverTopZ() = TensionRodTopZ()+WallTensionRod()+0.625;

function Receiver_MlokSideZ() = TensionRodBottomZ()+WallTensionRod()+0.125;

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


module Stock_MlokSideBolts(headType="flat", nutType="heatset", length=0.625, cutter=false, clearance=0.005, teardrop=false) {
  color("Silver") RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  translate([ButtpadX()+1,UnitsMetric(10),ReceiverBottomZ()])
  mirror([0,0,1])
  NutAndBolt(bolt=MlokBolt(),
             boltLength=length+ManifoldGap(2),
             head=headType,
             nut=nutType, nutHeightExtra=(cutter?0.25:0),
             teardrop=cutter&&teardrop, teardropAngle=180,
             clearance=cutter?clearance:0);
}
module ReceiverMlokBolts(headType="flat", nutType="heatset", length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  
  // Top Bolts
  color("Silver") RenderIf(!cutter)
  for (X = [0,UnitsMetric(60),UnitsMetric(80)])
  translate([-0.75-X,0,ReceiverTopSlotHeight()+ReceiverSlotClearance()])
  NutAndBolt(bolt=MlokBolt(),
             boltLength=length+ManifoldGap(2),
             head=headType,
             nut=nutType, nutHeightExtra=(cutter?1:0),
             teardrop=cutter&&teardrop, teardropAngle=180,
             clearance=cutter?clearance:0);

  // Side Bolts  
  color("Silver") RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  for (X = [0,UnitsMetric(20)])
  translate([-0.75-X,ReceiverBottomSlotWidth()/2,Receiver_MlokSideZ()])
  rotate([-90,0,0])
  NutAndBolt(bolt=MlokBolt(),
             boltLength=0.75+ManifoldGap(2),
             head=headType,
             nut=nutType, nutHeightExtra=(cutter?0.25:0),
             teardrop=cutter&&teardrop, teardropAngle=180,
             clearance=cutter?clearance:0);
}
module ReceiverTakedownPin(cutter=false, clearance=0.005, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([ReceiverTakedownPinX(),
             0,
             ReceiverTakedownPinZ()])
  rotate([90,0,180])
  linear_extrude(ReceiverOD(), center=true)
  Teardrop(r=0.125+clear, enabled=cutter);
}


//*****************

// **********
// * Shapes *
// **********

module Receiver_MlokSideSlot(length=1.25, width = UnitsMetric(7)+0.005, depth=0.0625) {  
  for (M = [0,1]) mirror([0,M,0])
  translate([-0.5-length, -ReceiverOR()-ManifoldGap(), Receiver_MlokSideZ()-(width/2)])
  cube([length, depth, width]);
}

module ReceiverMlokSlot(length=ReceiverLength(), width = UnitsMetric(7)+0.005, depth=0.0625) {  
  translate([0, -width/2, ReceiverTopZ()+ManifoldGap()])
  mirror([0,0,1])
  mirror([1,0,0])
  cube([length, width, depth]);
}
module ReceiverRoundSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance()) {
  
  // ID cutout
  rotate([0,-90,0])
  cylinder(r=ReceiverIR()+clearance, h=length, $fn=Resolution(40,80));
  
  rotate([0,-90,0])
  HoleChamfer(r1=ReceiverIR(), r2=3/32, teardrop=true, $fn=80);
  
  translate([-length,0,0])
  rotate([0,90,0])
  HoleChamfer(r1=ReceiverIR(), r2=3/32, teardrop=true, $fn=80);
}
module ReceiverBottomSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance(), chamferBottom=true) {
  
  // Wide Vertical slot
  translate([0,-(ReceiverBottomSlotWidth()/2)-clearance,0])
  mirror([0,0,1])
  rotate([0,-90,0])
  ChamferedSquareHole(sides=[abs(TensionRodBottomZ())+clearance,
                             ReceiverBottomSlotWidth()+(clearance*2)],
                       length=length,
                      chamferBottom=chamferBottom,
                      center=false, corners=false, chamferRadius=1/16);
  
  
  // Narrow Vertical slot
  translate([0,-(ReceiverBottomSlotWidth()/2)+0.125-clearance,0])
  mirror([0,0,1])
  rotate([0,-90,0])
  ChamferedSquareHole(sides=[abs(TensionRodBottomZ())+0.25+clearance,
                             ReceiverBottomSlotWidth()-0.25+(clearance*2)],
                       length=length,
                      chamferBottom=chamferBottom,
                      center=false, corners=false, chamferRadius=1/16);
  
  // Bottom edge curves
  translate([0,0,ReceiverBottomZ()])
  rotate([0,-90,0])
  linear_extrude(length)
  for (M = [0,1]) mirror([0,M])
  translate([0,(ReceiverBottomSlotWidth()/2)-0.125+clearance])
  rotate(-90)
  RoundedBoolean(r=1/16, edgeOffset=0, $fn=20);
  
  // Top edge curves
  translate([0,0,ReceiverBottomZ()+0.25-clearance])
  rotate([0,-90,0])
  linear_extrude(length)
  for (M = [0,1]) mirror([0,M])
  translate([0,(ReceiverBottomSlotWidth()/2)-0.125+clearance])
  RoundedBoolean(r=1/32, edgeOffset=0, $fn=20);
}

module ReceiverTopSlot(length=ReceiverLength(), width=ReceiverTopSlotWidth(), height=ReceiverTopSlotHeight(), clearance=ReceiverSlotClearance()) {
  chamferRadius = 1/16;
  horizontalWidth = ReceiverTopSlotHorizontalWidth();
  horizontalHeight = ReceiverTopSlotHorizontalHeight();
  
  rotate([0,-90,0]) {
    
    // Vertical slot
    translate([0,-(width/2)-clearance])
    ChamferedSquareHole(sides=[height+clearance,width+(clearance*2)], length=length,
                        center=false, corners=false, chamferRadius=chamferRadius);
    
    // Horizontal slot
    translate([TensionRodTopZ()+WallTensionRod()-clearance,
               -(horizontalWidth/2)-clearance])
    ChamferedSquareHole(sides=[horizontalHeight+(clearance*2),horizontalWidth+(clearance*2)], length=length,
                        center=false, corners=false, chamferRadius=chamferRadius);
  }
}

module ReceiverSideSlot(length=ReceiverLength(), clearance=ReceiverSlotClearance()) {
  clear = clearance;
  clear2 = clear*2;
  
  width = (ReceiverIR()+ReceiverSideSlotDepth()+clear)*2;
  height = ReceiverSideSlotHeight()+clear2;
  
  translate([0,-width/2,-height/2])
  rotate([0,-90,0])
  ChamferedSquareHole(sides=[height,width], length=length,
                      center=false, corners=false, chamferRadius=1/16);
}
module ReceiverBottomSlotInterface(length=ReceiverLength(), height=ReceiverOR(), extension=0, clearance=0.005) {
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
module ReceiverTopSegment(length=ReceiverLength()) {
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
    
    ReceiverMlokSlot();
    ReceiverMlokBolts(cutter=true, teardrop=true);
    
    translate([-0.5,0,0])
    ReceiverBottomSlot(length=ReceiverLength()-0.5, chamferBottom=false);
    ReceiverRoundSlot();
    ReceiverTopSlot();
    ReceiverSideSlot();
    Receiver_MlokSideSlot();
    
    ReceiverTakedownPin(cutter=true);
    TensionBolts(cutter=true);
  }
}

module ReceiverBackSegment(length=ReceiverBackLength()) {
  color("Chocolate") render()
  difference() {
    translate([-ReceiverLength(),0,0])
    ReceiverSegment(length=length);
    
    TensionBolts(nutType="none", headType="none", cutter=true);
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
    ReceiverMlokBolts();
    
    Receiver(alpha=_ALPHA_RECEIVER, debug=debug)
    children();
  }
}



scale(25.4)
if ($preview) {
  if (_SHOW_RECEIVER_BACK)
  ReceiverBackSegment();
  
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  
} else {
  
  if (_RENDER == "Receiver")
  rotate([0,90,0])
  Receiver();

  if (_RENDER == "Receiver_Back")
  ReceiverBackSegment_print();
  
}
