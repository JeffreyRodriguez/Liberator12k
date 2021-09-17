//$t=0;
//$t=0.681;
include <../Meta/Animation.scad>;

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
use <Lower/Lugs.scad>;

use <Receiver.scad>;
use <Frame.scad>;
use <Stock.scad>;
use <FCG.scad>;

use <Forend/Evolver.scad>;
use <Forend/PumpAR15.scad>;
use <Forend/Revolver.scad>;
use <Forend/TopBreak.scad>;
use <Forend/Trigun.scad>;
use <Forend/Pump.scad>;
use <Forend/Pump Reversed Mag.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Stock", "Stock_Backplate", "Stock_Buttpad"]

/* [Assembly] */
_FOREND = "TopBreak"; // ["TopBreak", "Trigun", "Revolver", "Evolver", "AR15", "Pump"]
_RECEIVER_TYPE  = "Standard"; // ["Standard", "Frame"]
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_STOCK_BACKPLATE = true;
_SHOW_FOREND = true;
_SHOW_BUTTPAD = true;
_SHOW_BULLPUP_BOLT = true;

_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]


_CUTAWAY_STOCK = false;
_CUTAWAY_BUTTPAD = false;
_CUTAWAY_RECEIVER = false;

/* [Vitamins] */
BULLPUP_BOLT = "1/4\"-20"; // ["#8-32", "1/4\"-20","M4", "M6"]
BULLPUP_BOLT_CLEARANCE = 0.015;


/* [Fine Tuning] */


// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();


function BullpupBolt() = BoltSpec(BULLPUP_BOLT);
assert(BullpupBolt(), "BullpupBolt() is undefined. Unknown BULLPUP_BOLT?");

function Bullpup_BackplateLength() = 0.5;

function Bullpup_BoltX() = -ReceiverLength()-ReceiverFrontLength()-Bullpup_BackplateLength();
function Bullpup_BoltY() = 0.625;
function Bullpup_BoltZ() = -2;
function Bullpup_BoltWall() = 0.3125;


function Bullpup_LowerX() = 5.5;
function Bullpup_LowerZ() = (Bullpup_BoltZ() - Bullpup_BoltWall())
                          - ReceiverBottomZ();

// ************
// * Vitamins *
// ************
module Bullpup_Bolts(debug=false, head="hex", nut="heatset", cutter=false, teardrop=false, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (M = [0,1]) mirror([0,M,0])
  translate([Bullpup_BoltX(), Bullpup_BoltY(), Bullpup_BoltZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=BullpupBolt(),
             boltLength=ReceiverLength()+FrameExtension(), capOrientation=false,
             head=head, capHeightExtra=(cutter?ButtpadLength():0),
             nut=nut, nutHeightExtra=(cutter?1:0),
             clearance=clear, teardrop=cutter&&teardrop);
}
module Bullpup_TakedownPinRetainer(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([Bullpup_BoltX(), 0, ReceiverTakedownPinZ()-0.125])
  rotate([0,90,0])
  cylinder(r=(3/32/2)+clear, h=2);
  
  if (cutter)
  translate([Bullpup_BoltX(), 0, ReceiverTakedownPinZ()-0.125])
  rotate([0,90,0])
  cylinder(r=0.125, h=2);
  
}
///

// *****************
// * Printed Parts *
// *****************
module Bullpup_Base(length=1, mirrored=false, debug=false, alpha=1) {
  color("Chocolate", alpha) render() DebugHalf(enabled=debug)
  difference() {
      
    union() {
      
      // Bullpup Supports
      hull() {
        
        // Bullpup bolt supports
        mirror([mirrored?1:0,0,0])
        hull()
        for (M = [0,1]) mirror([0,M,0])
        translate([0, Bullpup_BoltY(), Bullpup_BoltZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=Bullpup_BoltWall(), r2=1/16, h=length);
      }
      //
      
      children();
    }
    
    Bullpup_Bolts(cutter=true, teardrop=false);
  }
}
module Bullpup_Front() {
  Bullpup_Base(length=Bullpup_LowerX());
}
module Bullpup_Rear(length=ReceiverLength()+Bullpup_BackplateLength(), debug=false, alpha=1) {
  color("Chocolate", alpha) render() DebugHalf(enabled=debug)
  difference() {
    
    
    Bullpup_Base(mirrored=true, length=length) {
        
      // Receiver Bottom Body
      mirror([1,0,0])
      translate([0, -(1.25/2), -2.125])
      ChamferedCube([length, 1.25, 2+ReceiverBottomZ()+0.125],
                    r=1/16, teardropFlip=[true, true, true]);
      
      // Bottom Slot Section
      difference() {
        
        translate([-Bullpup_BackplateLength()-0.5,0,-0.26])
        ReceiverBottomSlotInterface(length=length-0.5,
                                    height=abs(ReceiverBottomZ())-0.26+0.1);
        
        // Receiver ID
        translate([Bullpup_BoltX(),0,0])
        rotate([0,90,0])
        ChamferedCircularHole(r1=ReceiverIR(), r2=1/8, h=length,
                              teardropBottom=true,
                              teardropTop=true);
        
        // Hammer Guide
        translate([Bullpup_BoltX(),-0.3125/2,-ReceiverIR()-0.375])
        mirror([1,0,0])
        ChamferedCube([length, 0.3125, ReceiverIR()], r=1/16, teardropFlip=[true,true,true]);
      }
      //
      
      // Backplate
      difference() {
        translate([Bullpup_BoltX(),0,0])
        mirror([1,0,0])
        ReceiverSegment(length=0.5, highTop=false,
                        chamferFront=true, chamferBack=true);
    
        // Clearance for the tension bolts
        translate([Bullpup_BoltX()+ManifoldGap(),0,0])
        mirror([1,0,0])
        TensionBoltIterator() {
          ChamferedCircularHole(r1=WallTensionRod(), r2=1/16, h=0.5);
          
          
          for (xyz = [[0,-WallTensionRod(),0],
                      [-WallTensionRod(),0,0]])
          translate(xyz)
          ChamferedSquareHole([WallTensionRod()*2,WallTensionRod()*2], 
                              length=0.5, chamferRadius=1/16,
                              corners=false, center=false);
        }
      }
      //
      
      // Sear support
      translate([-LowerMaxX(),0,0])
      hull() {
        translate([0.125,-0.3125/2,-ReceiverIR()-0.3125])
        ChamferedCube([0.25, 0.3125, ReceiverIR()], r=1/16, teardropFlip=[true,true,true]);
        
        translate([LowerMaxX()-1.25,-0.3125/2,-ReceiverIR()-0.25])
        ChamferedCube([0.25, 0.3125, 0.25], r=1/16, teardropFlip=[true,true,true]);
      }
      //
    }
    
    translate([-LowerMaxX(),0,0])
    translate([-0.01,0,ReceiverBottomZ()])
    Sear(length=SearLength()+abs(ReceiverBottomZ()), cutter=true);
    
    // Trigger bar hole
    translate([-LowerMaxX()-0.125-TriggerTravel(), -(0.51/2), -2])
    cube([LowerMaxX()+1.5,0.51,0.26]);
    
    
    translate([-ReceiverFrontLength(),0,0])
    ReceiverTakedownPin(cutter=true);
    
    Bullpup_TakedownPinRetainer(cutter=true);
    
    ButtpadBolt(cutter=true, teardrop=false);
  }
}

///

// **************
// * Assemblies *
// **************
module BullpupAssembly() {
  
  Bullpup_Bolts();
  Bullpup_TakedownPinRetainer();
  
  translate([StockLength()-0.5,0,0]) {
    
    if (_SHOW_BULLPUP_BOLT)
    ButtpadBolt();
    
    if (_SHOW_STOCK_BACKPLATE)
    Stock_Backplate();
    
    if (_SHOW_BUTTPAD)
    Stock_Buttpad(alpha=_ALPHA_BUTTPAD, debug=_CUTAWAY_BUTTPAD);
  }
    

  if (_SHOW_LOWER)
  translate([Bullpup_LowerX(),0,Bullpup_LowerZ()])
  Lower(showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true);
  
  Bullpup_Rear();
  Bullpup_Front();
}

scale(25.4)
if ($preview) {
  
  if (_SHOW_FOREND)
  if (_FOREND == "TopBreak") {
    BreakActionAssembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                   -Animate(ANIMATION_STEP_LOAD),
                        chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                   -Animate(ANIMATION_STEP_CHARGER_RESET),
                        lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                   -Animate(ANIMATION_STEP_LOCK),
                        extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                   -SubAnimate(ANIMATION_STEP_LOAD, end=0.25));
  } else if (_FOREND == "Revolver") {
    RevolverForendAssembly();
  } else if (_FOREND == "Evolver") {
    EvolverForendAssembly();
  } else if (_FOREND == "AR15") {
    PumpAR15ForendAssembly();
  } else if (_FOREND == "Trigun") {
    TrigunForendAssembly();
  } else if (_FOREND == "Pump") {
    PumpForend();
  }
  
  if (_SHOW_RECEIVER)
  translate([-0.5,0,0]) {
    if (_RECEIVER_TYPE == "Frame") {
      Receiver_LargeFrame(debug=_CUTAWAY_RECEIVER);
      FrameBolts(debug=_CUTAWAY_RECEIVER);
    } else {
      Receiver(debug=_CUTAWAY_RECEIVER);
    }
  }
  
  BullpupAssembly();
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
