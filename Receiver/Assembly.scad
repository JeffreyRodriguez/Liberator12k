//$t=0;
//$t=0.681;
include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/MLOK.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;


use <Forend/Evolver.scad>;
use <Forend/PumpAR15.scad>;
use <Forend/Revolver.scad>;
use <Forend/TopBreak.scad>;
use <Forend/Trigun.scad>;
use <Forend/Pump.scad>;
use <Forend/Pump Reversed Mag.scad>;

use <Bullpup.scad>;
use <Lower.scad>;
use <FCG.scad>;
use <Frame.scad>;
use <Receiver.scad>
use <Stock.scad>;

/* [Assembly] */
// Does your shoulder thing go up?
_CONFIGURATION  = "Stocked"; // ["Pistol", "Stocked", "Bullpup"]

// Choose your weapon
_FOREND = ""; // ["", "TopBreak", "Trigun", "Revolver", "Evolver", "AR15", "Pump"]

// The forend might disagree with your choice
_RECEIVER_SIZE  = "Framed"; // ["Framed", "Micro"]

_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_FOREND = true;
_SHOW_STOCK = true;
_SHOW_FCG = true;

_CUTAWAY_RECEIVER = false;
_CUTAWAY_LOWER = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_STOCK = false;

scale(25.4)
if ($preview) {
  
  if (_SHOW_FOREND)
  if (_FOREND == "TopBreak") {
    TopBreak_Assembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                   -Animate(ANIMATION_STEP_LOAD),
                        chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                   -Animate(ANIMATION_STEP_CHARGER_RESET),
                        lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                   -Animate(ANIMATION_STEP_LOCK),
                        extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                   -SubAnimate(ANIMATION_STEP_LOAD, end=0.25),
                        debug=_CUTAWAY_FOREND);
  } else if (_FOREND == "Revolver") {
    RevolverForendAssembly(debug=_CUTAWAY_FOREND);
  } else if (_FOREND == "Evolver") {
    EvolverForendAssembly(debug=_CUTAWAY_FOREND);
  } else if (_FOREND == "AR15") {
    translate([-0.5,0,0])
    PumpAR15ForendAssembly(debug=_CUTAWAY_FOREND);
  } else if (_FOREND == "Trigun") {
    TrigunForendAssembly(debug=_CUTAWAY_FOREND);
  } else if (_FOREND == "Pump") {
    PumpForend(debug=_CUTAWAY_FOREND);
  }
  
  if (_SHOW_FCG)
  translate([-0.5,0,0])
  SimpleFireControlAssembly(actionRod=false);
  
  
  if (_SHOW_RECEIVER)
  translate([-0.5,0,0]) {
    Receiver_TensionBolts(debug=_CUTAWAY_RECEIVER, headType="socket");
    
    if (_RECEIVER_SIZE == "Framed") {
      Frame_Receiver(debug=_CUTAWAY_RECEIVER);
      Frame_Bolts(debug=_CUTAWAY_RECEIVER);
    } else {
      Receiver(debug=_CUTAWAY_RECEIVER);
    }
  }
  
  if (_CONFIGURATION == "Stocked") translate([-0.5,0,0]) {
    if (_SHOW_STOCK)
    StockAssembly(debug=_CUTAWAY_STOCK);
    
    if (_SHOW_LOWER) {
      Lower();
      LowerMount();
    }
  } else if (_CONFIGURATION == "Bullpup") {
    BullpupAssembly();
  } else if (_CONFIGURATION == "Pistol") translate([-0.5,0,0]) {
    ReceiverBackSegment();
    
    if (_SHOW_LOWER) {
      Lower();
      LowerMount();
    }
  }
}