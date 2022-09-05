//$t=0;
//$t=0.681;
include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/MLOK.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;

use <../Forend/Evolver.scad>;
use <../Forend/PumpAR15.scad>;
use <../Forend/Revolver.scad>;
use <../Forend/TopBreak.scad>;
use <../Forend/Trigun.scad>;
use <../Forend/Pump.scad>;
use <../Forend/Pump Reversed Mag.scad>;

use <FCG.scad>;
use <Frame.scad>;
use <Lower.scad>;
use <Receiver.scad>;
use <Stock.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/Bullpup_Front", "Prints/Bullpup_Rear", "Prints/Bullpup_TriggerBar"]

/* [Assembly] */
_FOREND = ""; // ["", "TopBreak", "Trigun", "Revolver", "Evolver", "AR15", "Pump"]
_RECEIVER_TYPE  = "Standard"; // ["Standard", "Frame"]
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_FCG = true;
_SHOW_STOCK_BACKPLATE = true;
_SHOW_FOREND = true;
_SHOW_BUTTPAD = true;
_SHOW_BULLPUP_BOLT = true;

_ALPHA_BULLPUP = 1; // [0:0.1:1]
_ALPHA_BULLPUP_TRIGGER_BAR = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]


_CUTAWAY_BULLPUP = false;
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
function Bullpup_RearLength() = ReceiverLength()+0.5;
function Bullpup_MinX() = - ReceiverFrontLength()
                          - Bullpup_RearLength();

function Bullpup_BoltX() = Bullpup_MinX();
function Bullpup_BoltY() = 0.625;
function Bullpup_BoltZ() = -2.5;
function Bullpup_BoltWall() = 0.3125;
function Bullpup_BoltLength() = 11.75;

function Bullpup_BottomZ() = Bullpup_BoltZ()-Bullpup_BoltWall();

function Bullpup_FrontLength() = Bullpup_BoltLength() - Bullpup_RearLength();

function Bullpup_LowerX() = Bullpup_BoltLength()-7;
function Bullpup_LowerZ() = (Bullpup_BoltZ() - Bullpup_BoltWall())
                          - ReceiverBottomZ();
echo("Bullpup_BoltLength", Bullpup_BoltLength());
// ************
// * Vitamins *
// ************
module Bullpup_Bolts(cutaway=false, head="hex", nut="heatset", cutter=false, teardrop=false, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) Cutaway(cutaway)
  for (M = [0,1]) mirror([0,M,0])
  translate([Bullpup_BoltX(), Bullpup_BoltY(), Bullpup_BoltZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=BullpupBolt(),
             boltLength=Bullpup_BoltLength(), capOrientation=false,
             head=head, capHeightExtra=(cutter?ButtpadLength():0),
             nut=nut, nutHeightExtra=(cutter?1:0),
             clearance=clear, teardrop=cutter&&teardrop);
}
///

// *****************
// * Printed Parts *
// *****************
module Bullpup_Front(length=Bullpup_FrontLength(), cutaway=false, alpha=1) {
  color("Chocolate", alpha) render() Cutaway(cutaway)
  difference() {
    union() {

      // Bullpup bolt supports
      hull()
      for (Y = [1,-1])
      translate([-0.5, Y*Bullpup_BoltY(), Bullpup_BoltZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=Bullpup_BoltWall(), r2=1/16, h=length);
    }

    Bullpup_TriggerBar(cutter=true);

    Bullpup_Bolts(cutter=true);

    translate([Bullpup_LowerX(),0,Bullpup_LowerZ()]) {
      ReceiverLugFront(cutter=true, extraTop=-ReceiverBottomZ());

      ReceiverLugRear(cutter=true, extraTop=-ReceiverBottomZ());
    }
  }
}
module Bullpup_Rear(length=ReceiverLength()+Bullpup_BackplateLength(), cutaway=false, alpha=1) {
  color("Bisque", alpha) render() Cutaway(cutaway)
  difference() {

    union() {

      // Bullpup bolt supports
      hull()
      for (Y = [1,-1])
      translate([Bullpup_MinX(), Y*Bullpup_BoltY(), Bullpup_BoltZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=Bullpup_BoltWall(), r2=1/16, h=length);

      // Hammer Guide
      *translate([Bullpup_MinX(),-0.3125/2,-ReceiverIR()-0.375])
      ChamferedCube([1, 0.3125, ReceiverIR()], r=1/16, teardropFlip=[true,true,true]);

      // Receiver Bottom Body
      translate([Bullpup_MinX(), -(1.25/2), Bullpup_BoltZ()-0.125])
      ChamferedCube([length, 1.25, ReceiverBottomZ()-Bullpup_BoltZ()+0.125],
                    r=1/16, teardropFlip=[true, true, true]);

      // Bottom Slot Section
      difference() {

        translate([-1,0,0])
        ReceiverBottomSlotInterface(length=ReceiverLength(), extension=CR());

        // Receiver ID
        translate([Bullpup_MinX(),0,0])
        rotate([0,90,0])
        ChamferedCircularHole(r1=ReceiverIR(), r2=1/8, h=ReceiverLength(),
                              teardropBottom=true,
                              teardropTop=true);
      }

      // Backplate
      difference() {
        translate([Bullpup_MinX(),0,0])
        mirror([1,0,0])
        Receiver_Segment(length=0.5, highTop=false,
                        chamferFront=true, chamferBack=true);

        // Clearance for the tension bolts
        translate([Bullpup_MinX()+0.5,0,0])
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
    }

    Bullpup_Bolts(cutter=true);

    translate([-0.5,0,0]) {

      Sear(cutter=true);

      Receiver_TakedownPin(cutter=true);

      Bullpup_TriggerBar(cutter=true);

      Stock_ButtpadBolt(cutter=true, teardrop=false);
    }
  }
}

module Bullpup_TriggerBar(cutter=false, clearance=0.005, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Olive", alpha) RenderIf(!cutter) Cutaway(cutaway)

  translate([Bullpup_LowerX(),0,Bullpup_LowerZ()])
  Trigger();

  translate([-LowerMaxX()-0.125-TriggerTravel(), -(0.5/2)-clear, Bullpup_BoltZ()-0.125-clear])
  cube([LowerMaxX()+1.5,0.5+clear2,0.25+clear2]);

}
///

// **************
// * Assemblies *
// **************
module BullpupAssembly() {

  if (_SHOW_BULLPUP_BOLT)
  Bullpup_Bolts();

  if (_SHOW_FCG)
  translate([-0.5,0,0]){
    Sear();
    SearPin();
    SimpleFireControlAssembly(actionRod=false);
  }

  translate([Bullpup_LowerX(),0,Bullpup_LowerZ()]) {
    ReceiverLugFront(extraTop=0.25);
    ReceiverLugRear(extraTop=0.25);
  }

  Bullpup_TriggerBar(cutaway=_CUTAWAY_BULLPUP, alpha=_ALPHA_BULLPUP_TRIGGER_BAR);

  translate([StockLength()-0.5,0,0]) {

    *if (_SHOW_STOCK_BACKPLATE)
    Stock_Backplate();

    if (_SHOW_BUTTPAD) {
      Stock_ButtpadBolt();
      Stock_Buttpad(alpha=_ALPHA_BUTTPAD, cutaway=_CUTAWAY_BUTTPAD);
    }
  }


  if (_SHOW_LOWER)
  translate([Bullpup_LowerX(),0,Bullpup_LowerZ()])
  Lower();

  Bullpup_Rear(cutaway=_CUTAWAY_BULLPUP, alpha=_ALPHA_BULLPUP);
  Bullpup_Front(cutaway=_CUTAWAY_BULLPUP, alpha=_ALPHA_BULLPUP);
}

ScaleToMillimeters()
if ($preview) {

  if (_SHOW_FOREND)
  if (_FOREND == "TopBreak") {
    _RECEIVER_TYPE = "Frame";
    TopBreak_Assembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                   -Animate(ANIMATION_STEP_LOAD),
                        chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                   -Animate(ANIMATION_STEP_CHARGER_RESET),
                        lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                   -Animate(ANIMATION_STEP_LOCK),
                        extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                   -SubAnimate(ANIMATION_STEP_LOAD, end=0.25));
  } else if (_FOREND == "Revolver") {
    _RECEIVER_TYPE = "Frame";
    RevolverForendAssembly();
  } else if (_FOREND == "Evolver") {
    _RECEIVER_TYPE = "Frame";
    EvolverForendAssembly();
  } else if (_FOREND == "AR15") {
    PumpAR15ForendAssembly();
  } else if (_FOREND == "Trigun") {
    _RECEIVER_TYPE = "Frame";
    TrigunForendAssembly();
  } else if (_FOREND == "Pump") {
    PumpForend();
  }

  if (_SHOW_RECEIVER)
  translate([-0.5,0,0]) {
    if (_RECEIVER_TYPE == "Frame") {
      Frame_Receiver(cutaway=_CUTAWAY_RECEIVER);
      Frame_Bolts(cutaway=_CUTAWAY_RECEIVER);
    } else {
      Receiver(cutaway=_CUTAWAY_RECEIVER);
    }
  }

  BullpupAssembly();
} else {

  if (_RENDER == "Prints/Bullpup_TriggerBar")
  rotate([0,-90,0])
  translate([ReceiverLength()+StockLength(),0,0])
  Bullpup_TriggerBar();

  if (_RENDER == "Prints/Bullpup_Front")
  rotate([0,-90,0])
  translate([0,0,0])
  Bullpup_Front();

  if (_RENDER == "Prints/Bullpup_Rear")
  rotate([0,-90,0])
  translate([-Bullpup_MinX(),0,0])
  Bullpup_Rear();
}
