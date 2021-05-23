//$t=0;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;

use <Lower/LowerMount.scad>;
use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;

use <Receiver.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Stock", "Stock_Latch", "Stock_LatchPlunger", "Stock_LatchRetainer", "Stock_LatchButton_Left", "Stock_LatchButton_Right", "Stock_Buttpad"]

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_STOCK = true;
_SHOW_STOCK_LATCH = true;
_SHOW_STOCK_LATCH_BUTTONS = true;
_SHOW_STOCK_LATCH_CAP = true;
_SHOW_STOCK_LATCH_PLUNGER = true;
_SHOW_STOCK_LATCH_SPRING_PIN = true;
_SHOW_STOCK_PIVOT_PIN = true;
_SHOW_STOCK_MLOK_BOLTS = true;
_SHOW_BUTTPAD = true;
_SHOW_BUTTPAD_BOLT = true;

_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]
_ALPHA_STOCK_LATCH = 1; // [0:0.1:1]
_ALPHA_STOCK_LATCH_CAP = 1; // [0:0.1:1]


_CUTAWAY_STOCK = false;
_CUTAWAY_BUTTPAD = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_STOCK_LATCH = false;
_CUTAWAY_STOCK_LATCH_CAP = false;

/* [Vitamins] */
BUTTPAD_BOLT = "1/4\"-20"; // ["#8-32", "1/4\"-20","M4", "M6"]
BUTTPAD_BOLT_CLEARANCE = 0.015;

STOCK_LATCH_BOLT = "#8-32"; // ["#8-32", "M4"]
STOCK_LATCH_CLEARANCE = 0.015;

/* [Fine Tuning] */

$fs = UnitsFs()*0.25;

Stock_LatchSpringZ = -0.625;
Stock_LatchPlungerDistance = 0.25;
StockButtonLength = 1;
StockButtonBackset = 1.25;
StockButtonPivotAngle = 15;
StockButtonPivotWall = 0.3125+(1/16);
StockButtonPivotX = ButtpadX()+1.75;//-ReceiverLength()-0.5-StockButtonPivotWall;
StockButtonPivotY = StockButtonPivotWall;//(ReceiverIR()+ReceiverSideSlotDepth()-StockButtonPivotWall);
StockButtonMinX = StockButtonPivotX-StockButtonBackset;

function ButtpadBolt() = BoltSpec(BUTTPAD_BOLT);
assert(ButtpadBolt(), "ButtpadBolt() is undefined. Unknown BUTTPAD_BOLT?");

function Stock_LatchPivotBolt() = BoltSpec(STOCK_LATCH_BOLT);
assert(Stock_LatchPivotBolt(), "Stock_LatchPivotBolt() is undefined. Unknown STOCK_LATCH_BOLT?");

function Stock_LatchBodyBolt() = BoltSpec(STOCK_LATCH_BOLT);
assert(Stock_LatchBodyBolt(), "Stock_LatchBodyBolt() is undefined. Unknown STOCK_LATCH_BOLT?");

function StockLength() = TensionBoltLength()-ReceiverLength()-0.22;
//function StockLength() = 2;
echo("StockLength", StockLength());
function ButtpadSleeveLength() = 1;
function ButtpadLength() = 3;
function ButtpadWall() = 0.1875;
function ButtpadX() = -(ReceiverLength()+StockLength());
function Stock_LatchLength() = abs(ButtpadX()-StockButtonPivotX)+StockButtonPivotWall+0.375+0.0625;

// ************
// * Vitamins *
// ************
module ButtpadBolt(debug=false, head="flat", nut="heatset", cutter=false, teardrop=false, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (i = [[-1,0,0], [-1.5,0,-1.25]])
  translate([ButtpadX()+i.x, 0, i.z])
  rotate([0,-90,0])
  NutAndBolt(bolt=ButtpadBolt(),
             boltLength=3.5, capOrientation=true,
             head=head, capHeightExtra=(cutter?ButtpadLength():0),
             nut=nut, nutHeightExtra=(cutter?1:0),
             clearance=clear, teardrop=cutter&&teardrop);
}
module Stock_MlokBolts(headType="flat", nutType="heatset", length=0.625, cutter=false, clearance=0.005, teardrop=false) {
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
module Stock_ButtonPivotPin(debug=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (My = [0,1]) mirror([0,My,0])
  translate([StockButtonPivotX, StockButtonPivotY, -0.5])
  cylinder(r=(3/32/2), h=1+(cutter?1:0));
  
}
module Stock_ButtonPin(debug=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([StockButtonPivotX-StockButtonBackset+0.5,
             StockButtonPivotY, 0.25])
  mirror([0,0,1])
  cylinder(r=(3/32/2)+clear, h=0.75);
  
}
module Stock_LatchSpringPin(debug=false, cutter=false, teardrop=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([ButtpadX()-ManifoldGap(),0, Stock_LatchSpringZ])
  rotate([0,90,0])
  linear_extrude(Stock_LatchLength()-0.5+(cutter?0.75:0), center=false)
  Teardrop(r=(3/32/2)+clear, enabled=cutter&&teardrop);
  
}


// ************
// * Shapes *
// ************
module Stock_MlokSlot(length=1.5, width = UnitsMetric(7)+0.005, depth=0.0625) {  
  translate([ButtpadX()+1-(width/2), -(length/2), ReceiverBottomZ()-0.5])
  cube([width, length, depth]);
}

// ********
// * Meta *
// ********
module StockButtonPivot(factor=0, angle=15) {
  translate([StockButtonPivotX, StockButtonPivotY,0])
  rotate([0,0,angle*factor])
  translate([-StockButtonPivotX, -StockButtonPivotY,0])
  children();
}
  
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
    
    Stock_LatchButtons(cutter=true);
    
    // Stock button scallops
    for (M = [0,1]) mirror([0,M,0])
    translate([StockButtonMinX+0.625,ReceiverOR(),0])
    scale([2,1,1.5])
    sphere(r=0.25);
  }
}

module Stock_print() {
  rotate([0,-90,0])
  translate([ReceiverLength()+StockLength(),0,0])
  Stock();
}
module Stock_LatchButton(length=StockButtonLength, cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  height = ReceiverSideSlotHeight();
  chamferRadius=1/16;
  
  color("Olive") RenderIf(!cutter)
  difference() {
    intersection() {
      union() {
        
        if (!cutter)
        hull() {
          
          // Latch arm
          translate([StockButtonMinX,
                     StockButtonPivotY-StockButtonPivotWall,
                     -(height/2)])
          ChamferedCube([StockButtonBackset,
                         (StockButtonPivotWall*2), height],
                         r=chamferRadius);
          
          // Latch pivot support
          translate([StockButtonPivotX,StockButtonPivotY,0])
          ChamferedCylinder(r1=StockButtonPivotWall,
                            center=true, h=height, r2=chamferRadius);
          
          // Pivot outer edge
          translate([StockButtonPivotX,StockButtonPivotY,-(height/2)])
          ChamferedCube([StockButtonPivotWall, StockButtonPivotWall,height]);
        }
        
        // Latch button
        translate([0,ReceiverOR()+clear,0])
        rotate([90,0,0])
        linear_extrude((ReceiverOR())+clear)
        hull() for (X = [StockButtonMinX, StockButtonMinX+length-(height/2)]) translate([X,0,0])
        Teardrop(r=(height/2)+clear, enabled=cutter, $fn=80);
      }
      
      // Back curve
      translate([StockButtonPivotX,(ReceiverIR()-0.25),0])
      ChamferedCylinder(r1=StockButtonBackset+clear+clear, h=height+clear2,
               center=true, r2=chamferRadius, $fn=80);
      
      // Latch arm
      translate([StockButtonPivotX,
                  StockButtonPivotY,
                  -(height/2)-clear])
      rotate(-StockButtonPivotAngle)
      translate([1,-StockButtonPivotWall+clearance,0])
      mirror([1,0,0])
      ChamferedCube([StockButtonBackset+2+clear2,
                     StockButtonPivotWall*2+(cutter?1:-clearance),
                     height+clear2], r=chamferRadius);
      
    }
    
    translate([StockButtonPivotX, StockButtonPivotY,0])
    for (R = [0, -StockButtonPivotAngle]) rotate([0,0,R])
    translate([-StockButtonPivotX, -StockButtonPivotY,0])
    ButtpadBolt(cutter=true, teardrop=true, head="none", nut="none");
    
    Stock_ButtonPivotPin(cutter=true);
    Stock_ButtonPin(cutter=true);
  }
}

module Stock_LatchButtons(factor=0, cutter=false) {
  for (M = [0,1]) mirror([0,M])
  StockButtonPivot(factor) {
    Stock_ButtonPin(cutter=cutter);
    Stock_LatchButton(cutter=cutter);
  }
}

module Stock_Latch(cutter=false, clearance=0.008, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  height = ReceiverSideSlotHeight();
  length = Stock_LatchLength();
  
  color("Chocolate", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Central body
      translate([ButtpadX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverIR()-clearance, h=length,
                        r2=1/16, teardropTop=true, $fn=60);
      
      // Wings
      translate([ButtpadX()+length,
                 -(ReceiverIR()+ReceiverSideSlotDepth()-clearance),
                 -(ReceiverSideSlotHeight()/2)+clearance])
      mirror([1,0,0])
      ChamferedCube([0.375+0.0625,
                     (ReceiverIR()+ReceiverSideSlotDepth()-clearance)*2,
                     ReceiverSideSlotHeight()-(clearance*2)],
                    r=1/16, teardropFlip=[true, true, true]);
      
      // Bottom Slot
      translate([ButtpadX()+length,0,0])
      ReceiverBottomSlotInterface(length=length,
                                  height=abs(LowerOffsetZ()),
                                  extension=1/4);
      
      // Bottom Tab
      translate([ButtpadX(),
                 -(ReceiverBottomSlotWidth()/2)-0.125,
                 ReceiverBottomZ()-clearance])
      mirror([0,0,1])
      ChamferedCube([length,
                     ReceiverBottomSlotWidth()+0.25,
                     0.5-(clearance*2)],
                    r=1/16, teardropFlip=[true, true, true]);
    }
     
    // Center Slot
    translate([StockButtonPivotX+StockButtonPivotWall+clearance,
               -ReceiverOR(),
               -(ReceiverSideSlotHeight()/2)-clearance])
    mirror([1,0,0])
    ChamferedCube([StockButtonPivotWall+StockButtonBackset+(clearance*2),
                   ReceiverOD(),
                   ReceiverSideSlotHeight()+(clearance*2)],
                  r=1/32,teardropFlip=[true, true, true]);
     
    // Button pin installation slot
    hull() {
      translate([StockButtonPivotX-StockButtonBackset-clearance,
                 -ReceiverOR(),
                 -0.25-clearance])
      ChamferedCube([0.125,
                     ReceiverOD(),
                     0.5+(clearance*2)],
                    r=1/32,teardropFlip=[true, true, true]);
      
      translate([StockButtonPivotX-StockButtonBackset+0.375-clearance,
                 -ReceiverOR(),
                 -0.5-clearance])
      ChamferedCube([0.25,
                     ReceiverOD(),
                     0.75+(clearance*2)],
                    r=1/32,teardropFlip=[true, true, true]);
    }
    
    Stock_LatchRetainer(cutter=true);
    
    Stock_LatchSpringPin(cutter=true);
    
    ButtpadBolt(cutter=true, teardrop=false);
    
    Stock_MlokBolts(cutter=true, teardrop=true);
    
    Stock_MlokSlot();
    
    hull()
    for (M = [0,1]) mirror([0,M]) {
      for (F = [0,1]) StockButtonPivot(factor=F)
      Stock_ButtonPin(cutter=cutter);
      
      translate([-0.5,0,0])
      StockButtonPivot(factor=1)
      Stock_ButtonPin(cutter=cutter);
    }
    
    Stock_ButtonPivotPin(cutter=true);
    Stock_LatchPlunger(cutter=true);
  }
}

module Stock_LatchPlunger(cutter=false, clearance=0.008, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  cr = 1/16;
  
  plungerExtension = 1/16;
  
  color("Olive", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      hull() {
        // Wide section
        translate([ButtpadX()+1.0625,
                   -(StockButtonPivotY-(3/32/2)+clear),
                   -0.5-clear])
        mirror([1,0,0])
        ChamferedCube([0.75+clear+(cutter?0.5:0),
                       (StockButtonPivotY-(3/32/2)+clear)*2,
                       0.25+(cutter?0.5:0)+clear2], r=cr);
        
        // Narrow section
        translate([ButtpadX()+1.3125, -0.125-clear, -0.5-clear])
        mirror([1,0,0])
        ChamferedCube([0.5,0.25+clear2,0.25+clear2], r=cr);
      }
      
      // Join to release button
      translate([ButtpadX()+1.25, -0.125-clear, -0.875-clear])
      ChamferedCube([0.875,
                     0.25+clear2,0.625+(cutter?cr:0)+clear2], r=cr);
      
      // Release Button
      translate([ButtpadX()+Stock_LatchLength()+plungerExtension,
                 -0.125-clear, -0.875-clear])
      mirror([1,0,0])
      ChamferedCube([Stock_LatchPlungerDistance+1+plungerExtension+(cutter?1:0),
                     0.25+clear2,0.375+clear2], r=cr);
      
      if (cutter) {
        translate([ButtpadX()+0.25,
                   -0.125-clear, -0.875-clear])
        ChamferedCube([Stock_LatchLength()-0.375,
                       0.25+clear2,0.5+clear2], r=cr);
      }
    }
    
    if (!cutter) {
      Stock_LatchSpringPin(cutter=true, teardrop=true);
    }
  }
}
module Stock_LatchRetainer(cutter=false, clearance=0.01, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  cr = 1/16;
  wall = 1/8;
  wall2 = wall*2;
  width = 0.5;
  
  color("Tan", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    hull() {
      
      // Wide end
      translate([ButtpadX()+wall2-clear,
                 -(width/2)-clear,
                 Stock_LatchSpringZ-wall-clear])
      ChamferedCube([wall2+clear2,
                     width+clear2,
                     (wall*2)+(cutter?cr:0)+clear2], r=cr,
                     teardropFlip=[false,true,true]);
      
      // Narrow end
      translate([ButtpadX()-clear,
                 -wall-clear,
                 Stock_LatchSpringZ-wall-clear])
      ChamferedCube([cr*2+clear2,
                     wall2+clear2,
                     (wall*2)+(cutter?cr:0)+clear2], r=cr,
                     teardropFlip=[false,true,true]);
    }
    
    if (!cutter)
    Stock_LatchSpringPin(cutter=true);
  }
    
    
    
    
}
module Buttpad(doRender=true, debug=false, alpha=1) {
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
        ReceiverSegment(length=0.5, highTop=false);
        
        
        // Meet lower tab
        translate([0,-(ReceiverBottomSlotWidth()+0.25)/2,ReceiverBottomZ()-0.005])
        mirror([0,0,1])
        mirror([1,0,0])
        ChamferedCube([chamferRadius,
                       ReceiverBottomSlotWidth()+0.25,
                       0.5], r=chamferRadius);
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
    
    // Clearance for the tension bolts
    translate([ButtpadX()+ManifoldGap(),0,0])
    TensionBoltIterator()
    cylinder(r=NutHexRadius(TensionBolt(), 0.02), h=0.5, $fn=20);
  }
}

module Buttpad_print() {
  rotate([0,-90,0])
  translate([StockLength()+ReceiverLength()+ButtpadLength(),0,0])
  Buttpad();
}

// **************
// * Assemblies *
// **************
module StockAssembly() {
  if (_SHOW_BUTTPAD_BOLT)
  ButtpadBolt();
  
  if (_SHOW_STOCK_MLOK_BOLTS)
  Stock_MlokBolts();
  
  if (_SHOW_STOCK_PIVOT_PIN)
  Stock_ButtonPivotPin();
    
  if (_SHOW_STOCK_LATCH_BUTTONS)
  Stock_LatchButtons(factor=sin(180*$t));
  
  if (_SHOW_STOCK_LATCH_SPRING_PIN)
  Stock_LatchSpringPin();
  
  if (_SHOW_STOCK_LATCH_PLUNGER)
  translate([-Stock_LatchPlungerDistance*sin(180*$t),0,0])
  Stock_LatchPlunger();
  
  if (_SHOW_STOCK_LATCH_CAP)
  Stock_LatchRetainer(alpha=_ALPHA_STOCK_LATCH_CAP, debug=_CUTAWAY_STOCK_LATCH_CAP);
  
  if (_SHOW_STOCK_LATCH)
  Stock_Latch(alpha=_ALPHA_STOCK_LATCH, debug=_CUTAWAY_STOCK_LATCH);
  
  if (_SHOW_BUTTPAD)
  Buttpad(alpha=_ALPHA_BUTTPAD, debug=_CUTAWAY_BUTTPAD);
  
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
  Stock_print();
  
  if (_RENDER == "Stock_Buttpad")
  Buttpad_print();
  
  if (_RENDER == "Stock_Latch")
  rotate([0,90,0])
  translate([-ButtpadX()-Stock_LatchLength(),0,0])
  Stock_Latch();
  
  if (_RENDER == "Stock_LatchPlunger")
  rotate([180,0,0])
  translate([-ButtpadX()-1, 0, 0.25])
  Stock_LatchPlunger();
  
  if (_RENDER == "Stock_LatchRetainer")
  rotate([0,90,0])
  translate([-ButtpadX()-0.5, 0, 0.625])
  Stock_LatchRetainer();
  
  if (_RENDER == "Stock_LatchButton_Left")
  rotate([180,0,0])
  translate([-StockButtonPivotX,-StockButtonPivotY,-ReceiverSideSlotHeight()/2])
  Stock_LatchButton();
  
  if (_RENDER == "Stock_LatchButton_Right")
  mirror([0,1,0])
  rotate([180,0,0])
  translate([-StockButtonPivotX,-StockButtonPivotY,-ReceiverSideSlotHeight()/2])
  Stock_LatchButton();
}
