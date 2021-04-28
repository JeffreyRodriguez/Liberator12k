//$t=0;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/Dovetail.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;

use <Lower/LowerMount.scad>;

use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;

use <Frame.scad>;
use <Receiver.scad>;


/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Stock", "StockButtonHousing", "StockLatchPlunger", "StockButton_Left", "StockButton_Right", "Buttpad"]

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_STOCK = true;
_SHOW_STOCK_LATCH = true;
_SHOW_STOCK_LATCH_HOUSING = true;
_SHOW_STOCK_LATCH_BUTTONS = true;
_SHOW_STOCK_PIVOT_PIN = true;
_SHOW_STOCK_LATCH_PLUNGER = true;
_SHOW_BUTTPAD = true;
_SHOW_BUTTPAD_BOLT = true;

_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]
_ALPHA_STOCK_LATCH_HOUSING = 1; // [0:0.1:1]

_CUTAWAY_STOCK = false;
_CUTAWAY_BUTTPAD = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_STOCK_LATCH_HOUSING = false;

/* [Vitamins] */
BUTTPAD_BOLT = "1/4\"-20"; // ["#8-32", "1/4\"-20","M4", "M6"]
BUTTPAD_BOLT_CLEARANCE = 0.015;

STOCK_LATCH_BOLT = "#8-32"; // ["#8-32", "M4"]
STOCK_LATCH_CLEARANCE = 0.015;

/* [Fine Tuning] */
MERGE_HIGH_TOP = false;

$fs = UnitsFs()*0.25;

StockLatchPlungerDistance = 0.25;
StockButtonLength = 1;
StockButtonBackset = 1.25;
StockButtonPivotAngle = 15;
StockButtonPivotWall = 0.3125+(1/16);
StockButtonPivotX = ButtpadX()+1.75;//-ReceiverLength()-0.5-StockButtonPivotWall;
StockButtonPivotY = StockButtonPivotWall;//(ReceiverIR()+ReceiverSideSlotDepth()-StockButtonPivotWall);
StockButtonMinX = StockButtonPivotX-StockButtonBackset;

function ButtpadBolt() = BoltSpec(BUTTPAD_BOLT);
assert(ButtpadBolt(), "ButtpadBolt() is undefined. Unknown BUTTPAD_BOLT?");

function StockLatchPivotBolt() = BoltSpec(STOCK_LATCH_BOLT);
assert(StockLatchPivotBolt(), "StockLatchPivotBolt() is undefined. Unknown STOCK_LATCH_BOLT?");

function StockLatchBodyBolt() = BoltSpec(STOCK_LATCH_BOLT);
assert(StockLatchBodyBolt(), "StockLatchBodyBolt() is undefined. Unknown STOCK_LATCH_BOLT?");

function StockLength() = TensionBoltLength()-ReceiverLength()-0.22;
//function StockLength() = 2;
echo("StockLength", StockLength());
function ButtpadSleeveLength() = 1;
function ButtpadLength() = 3;
function ButtpadWall() = 0.1875;
function ButtpadX() = -(ReceiverLength()+StockLength());
function StockLatchHousingLength() = abs(ButtpadX()-StockButtonPivotX)+StockButtonPivotWall+0.375+0.0625;

// ************
// * Vitamins *
// ************
module ButtpadBolt(debug=false, head="flat", nut="heatset", cutter=false, teardrop=false, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (i = [[-1,0,0], [-2.5,0,-2]])
  translate([ButtpadX()+i.x, 0, i.z])
  rotate([0,-90,0])
  NutAndBolt(bolt=ButtpadBolt(),
             boltLength=3.5, capOrientation=true,
             head=head, capHeightExtra=(cutter?ButtpadLength():0),
             nut=nut, nutHeightExtra=(cutter?1:0),
             clearance=clear, teardrop=cutter&&teardrop);
}
module StockButtonPivotPin(debug=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (My = [0,1]) mirror([0,My,0])
  translate([StockButtonPivotX, StockButtonPivotY, -0.5])
  cylinder(r=(3/32/2), h=1+(cutter?1:0));
  
}
module StockButtonPin(debug=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([StockButtonPivotX-StockButtonBackset+0.5,
             StockButtonPivotY, 0.25])
  mirror([0,0,1])
  cylinder(r=(3/32/2)+clear, h=0.75);
  
}
module StockLatchBolt(debug=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([StockButtonPivotX-1, 0, ReceiverIR()])
  rotate([0,180,0])
  NutAndBolt(bolt=StockLatchPivotBolt(), 
             boltLength=1.5,
             head="flat",
             nut="heatset", nutBackset=1/16, nutHeightExtra=(cutter?1:0),
             clearance=clear);
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
    ReceiverSegment(length=length, highTop=false);
    
    ReceiverBottomSlot(length=ReceiverLength()+length);
    
    // Center Hole
    translate([-ReceiverLength(),0,0])
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=length, $fn=80);
    
    TensionBolts(nutType="none", headType="none", cutter=true);
    
    ReceiverSideSlot(length=ReceiverLength()+StockLength());
    
    StockButtons(cutter=true);
    
    // Stock button scallops
    for (M = [0,1]) mirror([0,M,0])
    translate([StockButtonMinX+0.625,ReceiverOR(),0])
    scale([2,0.75,1.5])
    sphere(r=0.25);
  }
}

module Stock_print() {
  rotate([0,-90,0])
  translate([ReceiverLength()+StockLength(),0,0])
  Stock();
}
module StockButton(length=StockButtonLength, cutter=false, clearance=0.005) {
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
      ChamferedCylinder(r1=StockButtonBackset+clear, h=height+clear2,
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
    
    StockButtonPivotPin(cutter=true);
    StockButtonPin(cutter=true);
  }
}

module StockButtons(factor=0, cutter=false) {
  for (M = [0,1]) mirror([0,M])
  StockButtonPivot(factor) {
    StockButtonPin(cutter=cutter);
    StockButton(cutter=cutter);
  }
}

module StockLatchHousing(cutter=false, clearance=0.008, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  height = ReceiverSideSlotHeight();
  length = StockLatchHousingLength();
  
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
      
      // Bottom Tab
      hull() {
        translate([ButtpadX(),
                   -(ReceiverBottomSlotWidth()/2),
                   ReceiverBottomZ()-clearance])
        mirror([0,0,1])
        ChamferedCube([length,
                       ReceiverBottomSlotWidth(),
                       0.25-(clearance*2)],
                      r=1/16, teardropFlip=[true, true, true]);
        
        translate([ButtpadX(),
                   -(ReceiverBottomSlotWidth()/2),
                   ReceiverBottomZ()-clearance])
        mirror([0,0,1])
        ChamferedCube([1,
                       ReceiverBottomSlotWidth(),
                       1.25-(clearance*2)],
                      r=1/16, teardropFlip=[true, true, true]);
      }
      
      translate([ButtpadX()+length,0,0])
      ReceiverBottomSlotInterface(length=length,
                                  height=abs(LowerOffsetZ()),
                                  extension=1/16);
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
    
    ButtpadBolt(cutter=true, teardrop=false);
    
    hull()
    for (M = [0,1]) mirror([0,M]) {
      for (F = [0,1]) StockButtonPivot(factor=F)
      StockButtonPin(cutter=cutter);
      
      translate([-0.5,0,0])
      StockButtonPivot(factor=1)
      StockButtonPin(cutter=cutter);
    }
    
    StockButtonPivotPin(cutter=true);
    StockLatchPlunger(cutter=true);
  }
}

module StockLatchPlunger(cutter=false, clearance=0.005, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  plungerExtension = 0.125;
  
  color("Olive", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  union() {
    hull() {
      // Wide section
      translate([ButtpadX()+1.125,
                 -(StockButtonPivotY-(3/32/2)+clear),
                 -0.5-clear])
      mirror([1,0,0])
      ChamferedCube([0.875+clear+(cutter?0.5:0),
                     (StockButtonPivotY-(3/32/2)+clear)*2,
                     0.25+(cutter?0.5:0)+clear2], r=1/16);
      
      // Narrow section
      translate([ButtpadX()+1.3125+0.125, -0.125-clear, -0.5-clear])
      mirror([1,0,0])
      ChamferedCube([1.0625,0.25+clear2,0.25+clear2], r=1/16);
    }
    
    // Extension
    translate([ButtpadX()+StockLatchHousingLength()+plungerExtension, -0.125-clear, -0.75-clear])
    mirror([1,0,0])
    ChamferedCube([StockLatchPlungerDistance+1+plungerExtension+(cutter?1:0),
                   0.25+clear2,0.5+clear2], r=1/16);
  }
  //StockButtonPivotX-StockButtonBackset+0.5
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
      }

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
        
        // Meet lower tab
        translate([0,-1/2,ReceiverBottomZ()-0.005])
        mirror([0,0,1])
        mirror([1,0,0])
        ChamferedCube([chamferRadius,
                       1,
                       ReceiverID()-0.005], r=chamferRadius);
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
  rotate([0,-90,0]) translate([StockLength()+ReceiverLength()+ButtpadLength()+0.5,0,0])
  Buttpad();
}

// **************
// * Assemblies *
// **************
module StockAssembly() {
  if (_SHOW_BUTTPAD_BOLT)
  ButtpadBolt();
  
  if (_SHOW_STOCK_PIVOT_PIN)
  StockButtonPivotPin();
    
  if (_SHOW_STOCK_LATCH_BUTTONS)
  StockButtons(factor=sin(180*$t));
  
  if (_SHOW_STOCK_LATCH_PLUNGER)
  translate([-StockLatchPlungerDistance*sin(180*$t),0,0])
  StockLatchPlunger();
  
  if (_SHOW_STOCK_LATCH_HOUSING)
  StockLatchHousing(alpha=_ALPHA_STOCK_LATCH_HOUSING, debug=_CUTAWAY_STOCK_LATCH_HOUSING);
  
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
  
  if (_RENDER == "StockButton_Left")
  rotate([180,0,0])
  translate([-StockButtonPivotX,-StockButtonPivotY,-ReceiverSideSlotHeight()/2])
  StockButton();
  
  if (_RENDER == "StockButton_Right")
  mirror([0,1,0])
  rotate([180,0,0])
  translate([-StockButtonPivotX,-StockButtonPivotY,-ReceiverSideSlotHeight()/2])
  StockButton();
  
  if (_RENDER == "StockButtonHousing")
  rotate([0,90,0])
  translate([-ButtpadX()-StockLatchHousingLength(),0,0])
  StockLatchHousing();
  
  if (_RENDER == "StockLatchPlunger")
  rotate([180,0,0])
  translate([-ButtpadX()-1, 0, 0.25])
  StockLatchPlunger();

  if (_RENDER == "Stock")
  Stock_print();
  
  if (_RENDER == "Buttpad")
  Buttpad_print();
}
