//$t=0;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/MLOK.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;

use <Lower/LowerMount.scad>;
use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;

use <Receiver.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Stock", "Stock_Backplate", "Stock_Buttpad"]

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_STOCK = true;
_SHOW_STOCK_BACKPLATE = true;
_SHOW_STOCK_TAKEDOWN_PIN = true;
_SHOW_BUTTPAD = true;
_SHOW_BUTTPAD_BOLT = true;

_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]
_ALPHA_STOCK_BACKPLATE = 1; // [0:0.1:1]


_CUTAWAY_STOCK = false;
_CUTAWAY_BUTTPAD = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_STOCK_BACKPLATE = false;

/* [Vitamins] */
BUTTPAD_BOLT = "1/4\"-20"; // ["#8-32", "1/4\"-20","M4", "M6"]
BUTTPAD_BOLT_CLEARANCE = 0.015;

Stock_Backplate_BOLT = "#8-32"; // ["#8-32", "M4"]
Stock_Backplate_CLEARANCE = 0.015;

/* [Fine Tuning] */

$fs = UnitsFs()*0.25;


function ButtpadBolt() = BoltSpec(BUTTPAD_BOLT);
assert(ButtpadBolt(), "ButtpadBolt() is undefined. Unknown BUTTPAD_BOLT?");

function ButtpadLength() = 3;
function ButtpadWall() = 0.1875;
function Stock_BackplateLength() = 1.5;

function StockLength() = TensionBoltLength()-ReceiverLength()-0.125;
function StockMinX() = -(ReceiverLength()+StockLength());
function ButtpadX() = StockMinX()-0.5;
function Stock_TakedownPinX() = StockMinX()+0.75;

// ************
// * Vitamins *
// ************
module ButtpadBolt(debug=false, head="flat", nut="heatset", cutter=false, teardrop=false, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (Z = [0,-1.5])
  translate([StockMinX()-2, 0, Z])
  rotate([0,-90,0])
  NutAndBolt(bolt=ButtpadBolt(),
             boltLength=3.5, capOrientation=true,
             head=head, capHeightExtra=(cutter?ButtpadLength():0),
             nut=nut, nutHeightExtra=(cutter?1:0),
             clearance=clear, teardrop=cutter&&teardrop);
}
module Stock_TakedownPin(cutter=false, clearance=0.005, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([Stock_TakedownPinX(),
             0,
             ReceiverTakedownPinZ()])
  rotate([90,0,0])
  linear_extrude(ReceiverOD(), center=true)
  Teardrop(r=0.125+clear, enabled=cutter);
}

module Stock_TakedownPinRetainer(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([ButtpadX(), 0, ReceiverTakedownPinZ()-0.125])
  rotate([0,90,0])
  cylinder(r=(3/32/2)+clear, h=2, $fn=20);
  
  if (cutter)
  translate([StockMinX(), 0, ReceiverTakedownPinZ()-0.125])
  rotate([0,90,0])
  cylinder(r=0.125, h=2, $fn=20);
  
}

///

// *****************
// * Printed Parts *
// *****************
module Stock(length=StockLength(), doRender=true, debug=false, alpha=1) {
  color("Tan", alpha=alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    
    // Main body
    translate([-ReceiverLength(),0,0])
    ReceiverSegment(length=length, highTop=false, chamferBack=true);
    
    TensionBolts(nutType="none", headType="none", cutter=true);
    
    translate([-ReceiverLength(),0,0]) {
      ReceiverBottomSlot(length=length);
      ReceiverRoundSlot(length=length);
      ReceiverSideSlot(length=length);
    }
    
    Stock_TakedownPin(cutter=true);
  }
}

module Stock_Backplate(length=Stock_BackplateLength(), clearance=0.008, debug=false, alpha=1) {
  color("Chocolate", alpha) render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Backplate
      difference() {
        translate([StockMinX(),0,0])
        ReceiverSegment(length=0.5, highTop=false,
                        chamferFront=true, chamferBack=true);
    
        // Clearance for the tension bolts
        translate([StockMinX()+ManifoldGap(),0,0])
        TensionBoltIterator() {
          ChamferedCircularHole(r1=WallTensionRod(), r2=1/16, h=0.5, $fn=30);
          
          for (xyz = [[0,-WallTensionRod(),0],
                      [-WallTensionRod(),0,0]])
          translate(xyz)
          ChamferedSquareHole([WallTensionRod()*2,WallTensionRod()*2], 
                              length=0.5, chamferRadius=1/16,
                              corners=false, center=false, $fn=30);
        }
      }
      
      // Central insert body
      translate([StockMinX()-0.5,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverIR()-clearance, h=length+0.5,
                        r2=1/16, teardropTop=true, $fn=60);
      
      // Insert wings
      translate([StockMinX()-0.5,
                 -(ReceiverIR()+ReceiverSideSlotDepth()-clearance),
                 -(ReceiverSideSlotHeight()/2)+clearance])
      ChamferedCube([length+0.5,
                     (ReceiverIR()+ReceiverSideSlotDepth()-clearance)*2,
                     ReceiverSideSlotHeight()-(clearance*2)],
                    r=1/16, teardropFlip=[true, true, true]);
      
      // Bottom Slot
      translate([StockMinX()+length,0,0])
      ReceiverBottomSlotInterface(length=length+0.5,
                                  height=abs(LowerOffsetZ()),
                                  extension=0.875);
      
      // Back tab
      translate([StockMinX()-0.5,-(1/2),0])
      mirror([0,0,1])
      ChamferedCube([0.5, 1, 2],
                    r=1/16, teardropFlip=[true, true, true]);
      
      
      // Bottom Tab
      hull() {
        
        // Wide rear section
        translate([StockMinX()-0.5,
                   -(ReceiverBottomSlotWidth()/2)-0.125,
                   ReceiverBottomZ()-clearance])
        mirror([0,0,1])
        ChamferedCube([1.5,
                       ReceiverBottomSlotWidth()+0.25,
                       1-(clearance*2)],
                      r=1/16, teardropFlip=[true, true, true]);
        
        // Narrow front section
        translate([StockMinX()-0.5,
                   -(ReceiverBottomSlotWidth()/2),
                   ReceiverBottomZ()-clearance])
        mirror([0,0,1])
        ChamferedCube([length+0.5,
                       ReceiverBottomSlotWidth(),
                       1-(clearance*2)],
                      r=1/8, teardropFlip=[true, true, true]);
      }
    }
    ///
    
    Stock_TakedownPin(cutter=true);
    Stock_TakedownPinRetainer(cutter=true);
    ButtpadBolt(cutter=true, teardrop=false);
      
    // M-LOK Side slots
    for (M = [0,1]) mirror([0,M,0])
    translate([ButtpadX()+0.125,0.625,ReceiverBottomZ()-0.625])
    rotate([-90,0,0]) {
      MlokSlot();
      MlokSlotBack();
    }
  }
}

module Stock_Buttpad(doRender=true, debug=false, alpha=1) {
  receiverRadius=ReceiverOR();
  outsideRadius = receiverRadius+ButtpadWall();
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseRadius = 0.625;
  spacerDepth=1.25;
  baseHeight = ButtpadLength();
  ribDepth=0.1875;
  compressionRadius = 3/16;

  color("Tan", alpha) RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Stock and extension hull
      translate([ButtpadX(),0,0])
      hull() {

        // Foot of the stock
        translate([-baseHeight,0,-0.25])
        rotate([0,90,0])
        for (L = [0,1]) translate([(length*L)-(outsideRadius/2),0,0])
        ChamferedCylinder(r1=baseRadius, r2=chamferRadius,
                           h=base,
                           $fn=Resolution(20,50));
        
        // Merge to receiver
        ReceiverSegment(length=0.5, highTop=false, chamferFront=true);
        
        
        // Meet lower tab
        translate([0,-(ReceiverBottomSlotWidth()+0.25)/2,-2.125])
        mirror([1,0,0])
        ChamferedCube([chamferRadius*2,
                       ReceiverBottomSlotWidth()+0.25,
                       1+2.125], r=chamferRadius);
      }
    }

    // Gripping Ridges
    translate([ButtpadX(),0,-0.5])
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    for (M = [0,1]) mirror([0,M,0])
    for (X = [0:baseRadius:length-(baseRadius/2)])
    translate([X-(baseRadius/2),
               baseRadius+(baseRadius/5),
               -ManifoldGap()])
    cylinder(r1=baseRadius/2, r2=0, h=base);
    
    ButtpadBolt(cutter=true);
  }
}
///

// **************
// * Assemblies *
// **************
module StockAssembly() {
  if (_SHOW_BUTTPAD_BOLT)
  ButtpadBolt();
  
  if (_SHOW_STOCK_TAKEDOWN_PIN) {
    Stock_TakedownPin();
    Stock_TakedownPinRetainer();
  }
  
  if (_SHOW_STOCK_BACKPLATE)
  Stock_Backplate(alpha=_ALPHA_STOCK_BACKPLATE, debug=_CUTAWAY_STOCK_BACKPLATE);
  
  if (_SHOW_BUTTPAD)
  Stock_Buttpad(alpha=_ALPHA_BUTTPAD, debug=_CUTAWAY_BUTTPAD);
  
  if (_SHOW_STOCK)
  Stock(alpha=_ALPHA_STOCK, debug=_CUTAWAY_STOCK);
}

scale(25.4)
if ($preview) {
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  
  if (_SHOW_LOWER) {
    LowerMount();

    translate([-LowerMaxX(),0,LowerOffsetZ()])
    Lower(showTrigger=true,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+abs(LowerOffsetZ())+SearTravel()-(0.25/2));
  }
  
  StockAssembly();
} else {

  if (_RENDER == "Stock")
  rotate([0,-90,0])
  translate([ReceiverLength()+StockLength(),0,0])
  Stock();
  
  if (_RENDER == "Stock_Buttpad")
  rotate([0,-90,0])
  translate([StockLength()+ReceiverLength()+ButtpadLength(),0,0])
  Stock_Buttpad();
  
  if (_RENDER == "Stock_Backplate")
  rotate([0,-90,0])
  translate([-ButtpadX(),0,0])
  Stock_Backplate();
}
