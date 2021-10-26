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

use <Bullpup.scad>;
use <Lower.scad>;
use <FCG.scad>;
use <Frame.scad>;
use <Receiver.scad>
use <Stock.scad>;

/* [Assembly] */
_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;
_SHOW_FOREND = true;
_SHOW_STOCK = true;
_SHOW_FCG = true;

/* [Configuration] */
// Does your shoulder thing go up?
_CONFIGURATION  = "Stocked"; // ["Pistol", "Stocked", "Bullpup"]

// Choose your weapon
_FOREND = ""; // ["", "TopBreak", "Trigun", "Revolver", "Evolver", "AR15", "Pump"]

// The forend might disagree with your choice
_RECEIVER_SIZE  = "Framed"; // ["Framed", "Micro"]

/* [Cutaways] */
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
                        hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS,
                        cutaway=_CUTAWAY_FOREND);
  } else if (_FOREND == "Revolver") {
    RevolverForendAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, cutaway=_CUTAWAY_FOREND);
  } else if (_FOREND == "Evolver") {
    EvolverForendAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, cutaway=_CUTAWAY_FOREND);
  } else if (_FOREND == "AR15") {
    translate([-0.5,0,0])
    PumpAR15ForendAssembly(cutaway=_CUTAWAY_FOREND);
  } else if (_FOREND == "Trigun") {
    TrigunForendAssembly(cutaway=_CUTAWAY_FOREND);
  } else if (_FOREND == "Pump") {
    PumpForend(cutaway=_CUTAWAY_FOREND);
  }

  if (_SHOW_FCG)
  translate([-0.5,0,0])
  SimpleFireControlAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, actionRod=false);


  if (_SHOW_RECEIVER)
  translate([-0.5,0,0]) {
    //Receiver_TensionBolts(cutaway=_CUTAWAY_RECEIVER, headType="socket");

    if (_RECEIVER_SIZE == "Framed") {
      Frame_ReceiverAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, cutaway=_CUTAWAY_RECEIVER);
    } else {
      Receiver(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, cutaway=_CUTAWAY_RECEIVER);
    }
  }

  if (_CONFIGURATION == "Stocked") translate([-0.5,0,0]) {
    if (_SHOW_STOCK)
    StockAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS, cutaway=_CUTAWAY_STOCK);

    if (_SHOW_LOWER) {
      LowerMount(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS);
      Lower(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS);
    }
  } else if (_CONFIGURATION == "Bullpup") {
    BullpupAssembly();
  } else if (_CONFIGURATION == "Pistol") translate([-0.5,0,0]) {
    ReceiverBackSegment();

    if (_SHOW_LOWER) {
      LowerMount();
      Lower();
    }
  }
}
