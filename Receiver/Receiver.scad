include <../Meta/Animation.scad>;

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

use <Lower/Receiver Lugs.scad>;
use <Lower/Trigger.scad>;
use <Lower/Lower.scad>;

use <Buttstock.scad>;
use <Frame.scad>;
use <Lugs.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Buttstock", "ButtstockTab", "ReceiverCoupling", "ReceiverBack", "ReceiverLugCenter", "ReceiverLugFront", "ReceiverLugRear", "LowerLeft", "LowerRight", "LowerMiddle", "TriggerLeft", "TriggerRight", "TriggerMiddle"]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.75;
RECEIVER_TUBE_ID = 1.5001;

/* [Bolts] */
COUPLING_BOLT = "1/4\"-20";    // ["1/4\"-20", "M4", "#8-32"]
COUPLING_BOLT_NUT = "heatset"; // ["hex", "heatset"]
LOWER_BOLT = "#8-32";          // ["M4", "#8-32"]
LOWER_BOLT_HEAD = "flat";      // ["socket", "flat"]
LOWER_BOLT_NUT = "heatset";    // ["hex", "heatset"]
COUPLING_BOLT_CLEARANCE = 0.015;
LOWER_BOLT_CLEARANCE = 0.015;

// Settings: Lengths
function ReceiverFrontLength() = 0.5;
function ReceiverBackLength() = 0.5;
function ReceiverCouplingLength() = 1;
function ReceiverCouplingWidth() = 2.25;
function ReceiverLength() = 12;
function ReceiverSlotWidth() = 1;

// Calculated: Measurements
function ReceiverID()     = RECEIVER_TUBE_ID;
function ReceiverIR()     = ReceiverID()/2;
function ReceiverOD()     = RECEIVER_TUBE_OD;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverPipeWall(od, id) = (od/2)-(id/2);

// Settings: Vitamins
function CouplingBolt() = BoltSpec(COUPLING_BOLT);
assert(CouplingBolt(), "CouplingBolt() is undefined. Unknown COUPLING_BOLT?");

function LowerBolt() = BoltSpec(LOWER_BOLT);
assert(LowerBolt(), "LowerBolt() is undefined. Unknown LOWER_BOLT?");


// Settings: Positions
function ReceiverBoltZ() = -7/8;
function ReceiverBoltY() = 1.125;

module CouplingBolts(boltHead="flat", nutType=COUPLING_BOLT_NUT,
                     extension=0.5,
                     clearance=0.005, cutter=false,
                     teardrop=false,
                     debug=false) {

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (Y = [-1,1])
  translate([-ReceiverCouplingLength()-ManifoldGap(),
             ReceiverBoltY()*Y,
             ReceiverBoltZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=CouplingBolt(),
             boltLength=ReceiverCouplingLength()+extension+ManifoldGap(2),
             head=boltHead,
             nut=nutType,
             teardrop=cutter&&teardrop,
             clearance=cutter?clearance:0);
}

module ReceiverCouplingPattern(width=ReceiverCouplingWidth(),
                     frameLength=0.75,
                     length=0.5, couplingBoltHull=true,
                     boltHead="flat",
                     debug=false, alpha=1) {
  union() {
    
    // Frame bolt supports
    hull()
    FrameSupport(length=frameLength);
    
    // Coupling bolt supports
    HullIf(couplingBoltHull)
    for (Y = [-ReceiverBoltY(),ReceiverBoltY()])
    translate([0,Y,ReceiverBoltZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=0.375, r2=1/32, h=length, $fn=Resolution(20,40));

    // Join the bolt wall and pipe
    translate([0,-width/2, LowerOffsetZ()])
    ChamferedCube([length,
                   width,
                   abs(LowerOffsetZ())+FrameBoltZ()],
                   teardropXYZ=[true,true,true],
                  r=1/16);
  }
}


module ReceiverCoupling(od=RECEIVER_TUBE_OD,
                        id=RECEIVER_TUBE_ID,
                        clearance=0.01,
                        debug=false, alpha=1) {

  color("DimGray", alpha) render() DebugHalf(enabled=debug)
  difference() {

    union() {
      mirror([1,0,0])
      ReceiverCouplingPattern(frameLength=FrameReceiverLength(),
                              length=ReceiverCouplingLength(),
                              couplingBoltHull=true);
      
      hull() {
        
        // Around the receiver pipe
        rotate([0,-90,0])
        ChamferedCylinder(r1=ReceiverCouplingWidth()/2, r2=1/16,
                          h=FrameReceiverLength(), $fn=Resolution(30,60));

        // Join the bolt wall and pipe
        translate([-FrameReceiverLength(),-ReceiverCouplingWidth()/2, 0])
        ChamferedCube([FrameReceiverLength(),
                       ReceiverCouplingWidth(),
                       FrameBoltZ()],
                      r=1/16);
      }

      // Center lug support
      translate([0,-(1.5/2),LowerOffsetZ()])
      mirror([1,0,0])
      ChamferedCube([FrameReceiverLength(),
                     1.5,
                     abs(LowerOffsetZ())+FrameBoltY()],
                    r=1/16);
    }

    FrameBolts(cutter=true);

    ReceiverTube(od=od, id=id, cutter=true);

    CouplingBolts(cutter=true);

    // Lower lug cutout
    translate([-LowerMaxX(),0,0])
    PipeLugCenter(cutter=true);

    // Slot Cutout
    translate([ManifoldGap(),
               -(ReceiverSlotWidth()/2)-clearance,0])
    mirror([1,0,0])
    cube([FrameReceiverLength()+ManifoldGap(2),ReceiverSlotWidth()+(clearance*2),2]);
  }
}

module ReceiverCoupling_print(od=RECEIVER_TUBE_OD,
                              id=RECEIVER_TUBE_ID)
rotate([0,90,0])
ReceiverCoupling(od=od, id=id);

module ReceiverBack(od=RECEIVER_TUBE_OD,
                    id=RECEIVER_TUBE_ID,
                    length=ReceiverBackLength(),
                    clearance=0.01,
                    debug=false, alpha=1) {

    receiverBackMinX = -FrameReceiverLength();

  color("Chocolate", alpha) render() DebugHalf(enabled=debug)
  difference() {

    union() {

      // Bolt supports
      translate([receiverBackMinX,0,0])
      hull()
      FrameSupport(length=length);

      // Join bolt wall and pipe
      translate([receiverBackMinX,-(2.25/2),FrameBoltZ()])
      mirror([0,0,1])
      ChamferedCube([length,
                     2.25,
                     1],
                    r=1/16);
    }

    FrameBolts(cutter=true);

    translate([-FrameReceiverLength(),0,0])
    ReceiverTube(od=od, id=id, cutter=true);
  }
}

module ReceiverBack_print(od=RECEIVER_TUBE_OD,
                              id=RECEIVER_TUBE_ID)
translate([0,0,-FrameReceiverLength()+ReceiverBackLength()])
rotate([0,90,0])
ReceiverBack(od=od, id=id);

module Receiver(od=RECEIVER_TUBE_OD,
                id=RECEIVER_TUBE_ID,
                receiverLength=ReceiverLength(),
                receiverBack=true,
                buttstock=true,
                pipeOffsetX=0,
                pipeAlpha=1, buttstockAlpha=1, couplingAlpha=1,
                frameBoltLength=FrameBoltLength(),
                frameBoltBackset=ReceiverBackLength(),
                couplingBoltHead="flat", couplingBoltExtension=0.5,
                triggerAnimationFactor=TriggerAnimationFactor(),
                frameBolts=true, lower=true,
                lowerBolt=LowerBolt(),
                lowerBoltHead=LOWER_BOLT_HEAD,
                lowerBoltNut=LOWER_BOLT_NUT,
                debug=true) {

  CouplingBolts(boltHead=couplingBoltHead, extension=couplingBoltExtension);
  
  if (receiverBack)
  translate([-frameBoltBackset,0,0])
  %ReceiverBack(length=frameBoltBackset, debug=debug);

  if (frameBolts)
  translate([-frameBoltBackset,0,0])
  FrameBolts(length=frameBoltLength);

  ReceiverCoupling(od=od, id=id, debug=debug, alpha=couplingAlpha);

  if (buttstock)
  translate([-receiverLength,0,0])
  ButtstockAssembly(od=od, alpha=buttstockAlpha, debug=debug);

  translate([-LowerMaxX(),0,0]) {

    if (lower)
    translate([0,0,LowerOffsetZ()])
    Lower(alpha=1, boltSpec=lowerBolt, boltHead=lowerBoltHead, nut=lowerBoltNut,
          showTrigger=true,
          triggerAnimationFactor=triggerAnimationFactor,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+abs(LowerOffsetZ())+SearTravel()-(0.25/2));

    PipeLugAssembly(od=od, id=id, length=receiverLength,
                    pipeAlpha=pipeAlpha, debug=debug);

  }
}

scale(25.4) {
  if (_RENDER == "Assembly") {

    Receiver(pipeAlpha=0.3,
             receiverLength=12,
             lowerBolt=LowerBolt(),
             lowerBoltHead=LOWER_BOLT_HEAD,
             lowerBoltNut=LOWER_BOLT_NUT,
             debug=_DEBUG_ASSEMBLY);
  }

  if (_RENDER == "Buttstock")
    Buttstock_print(od=RECEIVER_TUBE_OD);

  if (_RENDER == "ButtstockTab")
    ButtstockTab_print(od=RECEIVER_TUBE_OD);

  if (_RENDER == "ReceiverCoupling")
    ReceiverCoupling_print(od=RECEIVER_TUBE_OD,
                           id=RECEIVER_TUBE_ID);

  if (_RENDER == "ReceiverBack")
    ReceiverBack_print(od=RECEIVER_TUBE_OD,
                           id=RECEIVER_TUBE_ID);

  if (_RENDER == "ReceiverLugCenter")
    PipeLugCenter_print(od=RECEIVER_TUBE_OD,
                        id=RECEIVER_TUBE_ID);

  if (_RENDER == "ReceiverLugFront")
    PipeLugFront_print(od=RECEIVER_TUBE_OD,
                       id=RECEIVER_TUBE_ID);

  if (_RENDER == "ReceiverLugRear")
    PipeLugRear_print(od=RECEIVER_TUBE_OD,
                      id=RECEIVER_TUBE_ID);

  if (_RENDER == "LowerLeft")
    LowerLeft_print(
             boltSpec=LowerBolt(),
             head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT);

  if (_RENDER == "LowerRight")
    LowerRight_print(
             boltSpec=LowerBolt(),
             head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT);

  if (_RENDER == "LowerMiddle")
    LowerMiddle_print(
             boltSpec=LowerBolt(),
             head=LOWER_BOLT_HEAD, nut=LOWER_BOLT_NUT);

  if (_RENDER == "TriggerLeft")
    TriggerLeft_print();

  if (_RENDER == "TriggerRight")
    TriggerRight_print();

  if (_RENDER == "TriggerMiddle")
    TriggerMiddle_print();
}
