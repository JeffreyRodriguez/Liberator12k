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

use <Lower/Mount.scad>;

use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;

use <Frame.scad>;
use <Receiver.scad>;


/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Stock", "StockButtonHousing", "StockButton_Left", "StockButton_Right", "StockPlug", "Buttpad"]

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_STOCK = true;
_SHOW_STOCK_LATCH = true;
_SHOW_BUTTPAD = true;
_SHOW_STOCK_PLUG = true;
_SHOW_BUTTPAD_BOLT = true;

_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]

_CUTAWAY_STOCK = false;
_CUTAWAY_BUTTPAD = false;
_CUTAWAY_ASSEMBLY = false;

/* [Vitamins] */
BUTTPAD_BOLT = "1/4\"-20"; // ["#8-32", "1/4\"-20","M4", "M6"]
BUTTPAD_BOLT_CLEARANCE = 0.015;

STOCK_LATCH_BOLT = "#8-32"; // ["#8-32", "M4"]
STOCK_LATCH_CLEARANCE = 0.015;

/* [Fine Tuning] */
MERGE_HIGH_TOP = false;

$fs = UnitsFs()*0.25;

StockButtonLength = 0.75;
StockButtonBackset = 2.5;
StockButtonPivotWall = 0.25;
StockButtonPivotX = -ReceiverLength()-0.5-StockButtonPivotWall;
StockButtonPivotY = (ReceiverIR()+ReceiverSideSlotDepth()-StockButtonPivotWall);
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
function StockBackLength() = 0.5;
function StockPlugSlotWidth() = 0.5;
function StockPlugLength() = 0.5;
function ButtpadSleeveLength() = 1;
function ButtpadLength() = 2.5;
function ButtpadWall() = 0.1875;
function ButtpadX() = -(ReceiverLength()+StockLength());

// ************
// * Vitamins *
// ************
module ButtpadBolt(debug=false, cutter=false, teardrop=true, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (Z = [0, -2])
  translate([ButtpadX()-ButtpadLength(), 0, Z])
  rotate([0,-90,0])
  NutAndBolt(bolt=ButtpadBolt(),
             boltLength=3.5,
             head="flat", capHeightExtra=(cutter?ButtpadLength():0),
             nut="heatset", nutHeightExtra=(cutter?1:0), capOrientation=true,
             clearance=clear);
}

module StockLatchPivotBolts(debug=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (My = [0,1]) mirror([0,My,0])
  translate([StockButtonPivotX, StockButtonPivotY, -ReceiverSideSlotHeight()/2])
  rotate([0,180,0])
  NutAndBolt(bolt=StockLatchPivotBolt(), 
             boltLength=ReceiverSideSlotHeight(),
             head="flat", capHeightExtra=(cutter?abs(LowerOffsetZ()):0), capOrientation=true,
             nut="heatset",
             clearance=clear);
  
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

// *****************
// * Printed Parts *
// *****************
module Stock(length=StockLength(), doRender=true, debug=_CUTAWAY_STOCK, alpha=1) {
  color("Tan", alpha=alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    
    // Main body
    translate([-ReceiverLength(),0,0])
    ReceiverSegment(length=length, highTop=false);
    
    // Spring seat
    translate([-ReceiverLength(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=0.65/2, r2=1/16, chamferTop=false,
                          h=0.1875, $fn=40);
    
    // Bottom slot
    translate([-ReceiverLength()+StockBackLength(),0,0])
    translate([-length,-ReceiverBottomSlotWidth()/2, -3])
    cube([length-StockBackLength(), ReceiverBottomSlotWidth(), 3]);
    
    // Center Hole
    translate([-ReceiverLength(),0,0])
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=length-StockBackLength(), $fn=80);
    
    // Buttpad slot
    translate([-ReceiverLength()-StockLength(),0,0])
    intersection() {
      translate([0,-(StockPlugSlotWidth()+0.01)/2,-ReceiverIR()-0.005])
      cube([StockBackLength()+0.01, StockPlugSlotWidth()+0.01, ReceiverID()+0.01]);
     
      rotate([0,90,0])
      cylinder(r=ReceiverIR(), h=StockBackLength()+0.01, $fn=80);
    }
    
    TensionBolts(nutType="none", headType="none", cutter=true);
    
    ReceiverSideSlot(length=ReceiverLength()+StockLength()-StockBackLength());
    
    StockButtons(cutter=true);
  }
}

module Stock_print() {
  rotate([0,-90,0])
  translate([ReceiverLength()+StockLength(),0,0])
  Stock();
}
module StockButton(angle=0, length=StockButtonLength, cutter=false, clearance=0.003) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  height = ReceiverSideSlotHeight();
  
  color("Olive") RenderIf(!cutter)
  translate([StockButtonPivotX, StockButtonPivotY,0])
  rotate([0,0,angle])
  translate([-StockButtonPivotX, -StockButtonPivotY,0])
  difference() {
    intersection() {
      union() {
        
        if (!cutter)
        union() {
          
          // Latch arm
          translate([StockButtonMinX,StockButtonPivotY-clear,-clear])
          ChamferedCube([StockButtonBackset+clear2, StockButtonPivotWall+clear2, (height/2)+clear2], r=1/16);
          
          // Latch pivot support
          translate([StockButtonPivotX,StockButtonPivotY,-clear])
          ChamferedCylinder(r1=StockButtonPivotWall+clear, h=(height/2)+clear2, r2=1/16);
        }
        
        // Latch button
        translate([0,ReceiverOR()+clear,0])
        rotate([90,0,0])
        linear_extrude((ReceiverOR()-ReceiverIR())+clear)
        hull() for (X = [StockButtonMinX, StockButtonMinX+length-(height/2)]) translate([X,0,0])
        Teardrop(r=(height/2)+clear, enabled=cutter);
      }
      
      // Back curve
      translate([StockButtonPivotX,(ReceiverIR()-0.25),0])
      ChamferedCylinder(r1=StockButtonBackset+clear, h=height+clear2,
               center=true, r2=1/16, $fn=80);
    }
    
    StockLatchPivotBolts(cutter=true);
  }
}

module StockButtons(angle=0, cutter=false) {
  for (My = [0,1]) mirror([0,My,0])
  StockButton(angle=angle, cutter=cutter);
}
module StockLatchHousing(length=0.5, cutter=false, clearance=0.003) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  height = ReceiverSideSlotHeight();
  length = abs(StockButtonBackset-StockButtonLength-0.375);
  
  color("Tan") RenderIf(!cutter)
  difference() {
    union() {
      hull()
      for (X = [0, -length]) translate([X,0,0])
      for (My = [0,1]) mirror([0,My,0])
      translate([StockButtonPivotX,StockButtonPivotY,-(height/2)-clear])
      ChamferedCylinder(r1=StockButtonPivotWall+clear, h=(height/2)+clear2, r2=1/16);
      
      translate([StockButtonPivotX+StockButtonPivotWall,-0.5,0])
      mirror([0,0,1])
      mirror([1,0,0])
      ChamferedCube([length+(StockButtonPivotWall*2), 1, ReceiverIR()], r=1/16);
      
      intersection() {
        translate([StockButtonPivotX-StockButtonPivotWall,0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=ReceiverIR(), h=length, r2=1/16, $fn=60);
      
        translate([StockButtonPivotX-StockButtonPivotWall,-0.5,0])
        mirror([0,0,1])
        mirror([1,0,0])
        ChamferedCube([length, 1, abs(LowerOffsetZ())], r=1/16);
      }
    }
    
    // Center Slot
    *translate([StockButtonPivotX+StockButtonPivotWall+(1/16),-0.25+clearance,LowerOffsetZ()])
    mirror([1,0,0])
    linear_extrude(ReceiverIR()+abs(LowerOffsetZ()))
    ChamferedSquare([1+(1/16),0.5-(clearance*2)], r=1/16,
                  teardropTop=false, teardropBottom=false);
    
    // Hammer bolt allowance
    translate([StockButtonPivotX+StockButtonPivotWall,0,0])
    rotate([0,-90,0])
    linear_extrude(StockButtonBackset)
    rotate(180)
    Teardrop(r=0.25, $fn=30);
    
    *StockLatchBolt(cutter=true);
    StockLatchPivotBolts(cutter=true);
  }
}
module StockPlug(length=0.5, extension=0.375, chamferRadius=1/16, clearance=0.008) {
  height = 1;
  width = ReceiverBottomSlotWidth()-(clearance*2);
  tabWidth = StockPlugSlotWidth()-(clearance*2);
  
  color("Olive") render()
  difference() {
    union() {
      intersection() {
        union() {
          
          // Block that goes inide the receiver
          translate([-ReceiverLength()-StockLength()+StockBackLength(),
                     -width/2,
                     -ReceiverIR()-2])
          ChamferedCube([StockPlugLength(),
                         ReceiverBottomSlotWidth()-(clearance*2),
                         ReceiverID()+2],
                        r=chamferRadius,
                        teardropFlip=[false,true,true]);
          
          // Tab through slot
          translate([-ReceiverLength()-StockLength(),
                     -tabWidth/2,
                     -ReceiverIR()])
          ChamferedCube([StockPlugLength()+StockBackLength(),
                         tabWidth,
                         ReceiverID()], r=chamferRadius,
                        teardropFlip=[false,true,true]);
        }
        
        // Round off the top
        translate([-ReceiverLength()-StockLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=ReceiverIR()-clearance, r2=chamferRadius,
                          h=StockPlugLength()+StockBackLength(),
                          teardropTop=true, $fn=60);
      }
      
      // Lower tab
      translate([-ReceiverLength()-StockLength(),
                 -width/2,
                 ReceiverBottomZ()-clearance])
      mirror([0,0,1])
      ChamferedCube([StockPlugLength()+StockBackLength(),
                     width,
                     ReceiverID()-clearance],
                    r=chamferRadius, teardropFlip=[false,true,true]);
        
      // Connect lower block to upper block
      translate([-ReceiverLength()-StockLength()+StockBackLength(),
                 -width/2,
                 0])
      mirror([0,0,1])
      ChamferedCube([StockPlugLength(),
                     width,
                     2],
                    r=chamferRadius, teardropFlip=[false,true,true]);
    }
    
    ButtpadBolt(cutter=true);
  }
}

module StockPlug_print() {
  rotate([0,90,0])
  translate([-ButtpadX()-StockBackLength()-StockPlugLength(),0,ReceiverIR()])
  StockPlug();
}

module Buttpad(doRender=true, debug=_CUTAWAY_BUTTPAD, alpha=1) {
  receiverRadius=ReceiverOR();
  outsideRadius = receiverRadius+ButtpadWall();
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseRadius = 9/16;
  spacerDepth=1.5;
  baseHeight = ButtpadLength();
  ribDepth=0.1875;

  color("Tan", alpha) RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {

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
      
      // Merge to receiver
      ReceiverSegment(length=0.5, highTop=false);
      
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
module StockAssembly(debug=_CUTAWAY_ASSEMBLY, debugStock=_CUTAWAY_STOCK, alphaStock=_ALPHA_STOCK, alphaButtpad=_ALPHA_BUTTPAD) {
  if (_SHOW_BUTTPAD_BOLT)
  ButtpadBolt();
  
  if (_SHOW_STOCK_LATCH) {
    StockLatchPivotBolts();
    StockButtons(angle=8*sin(180*$t));
    StockLatchHousing();
  }
  
  if (_SHOW_STOCK)
  Stock(alpha=alphaStock, debug=(debug || debugStock));
  
  if (_SHOW_STOCK_PLUG)
  StockPlug();
  
  if (_SHOW_BUTTPAD)
  Buttpad(alpha=alphaButtpad, debug=debug);
}

scale(25.4)
if ($preview) {
  if (_SHOW_RECEIVER)
  ReceiverAssembly();
  
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
  rotate([180,0,0])
  translate([-StockButtonPivotX,0,0])
  StockLatchHousing();

  if (_RENDER == "Stock")
  Stock_print();

  if (_RENDER == "StockPlug")
  StockPlug_print();
  
  if (_RENDER == "Buttpad")
  Buttpad_print();
}
