include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

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
use <Charging Pump.scad>;
use <Linear Hammer.scad>;
use <Lugs.scad>;
use <Frame.scad>;
use <Recoil Plate.scad>;
use <Firing Pin.scad>;


/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Buttstock", "FrameForend", "ReceiverCoupling", "ReceiverLugCenter", "ReceiverLugFront", "ReceiverLugRear", "LowerLeft", "LowerRight", "LowerMiddle", "TriggerLeft", "TriggerRight", "TriggerMiddle","HammerHead", "HammerTail"]

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.7501;
RECEIVER_TUBE_ID = 1.5001;

/* [Bolts] */
COUPLING_BOLT = "#8-32"; // ["M4", "#8-32"]
COUPLING_BOLT_CLEARANCE = 0.015;
LOWER_BOLT = "#8-32"; // ["M4", "#8-32"]
LOWER_BOLT_CLEARANCE = 0.015;
LOWER_BOLT_HEAD = "flat"; // ["socket", "flat"]
LOWER_BOLT_NUT = "heatset"; // ["hex", "heatset"]

// Settings: Lengths
function FrameBoltExtension() = 0.5;
function ReceiverFrontLength() = 0.5;
function ReceiverCouplingLength() = 1;
function ReceiverLength() = 12;
function ReceiverSlotWidth() = 0.75;

// Calculated: Measurements
function ReceiverID()     = RECEIVER_TUBE_ID;
function ReceiverIR()     = ReceiverID()/2;
function ReceiverOD()     = RECEIVER_TUBE_OD;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverPipeWall(od, id) = (od/2)-(id/2);

function HammerTravel() = LowerMaxX() + ReceiverFrontLength()
                              - HammerCollarWidth()
                              + RodRadius(SearRod())
                              - FiringPinHousingLength();
echo("HammerTravel", HammerTravel());

// Settings: Vitamins
function CouplingBolt() = BoltSpec(COUPLING_BOLT);
assert(CouplingBolt(), "CouplingBolt() is undefined. Unknown COUPLING_BOLT?");

function LowerBolt() = BoltSpec(LOWER_BOLT);
assert(LowerBolt(), "LowerBolt() is undefined. Unknown LOWER_BOLT?");


// Settings: Positions
function ReceiverBoltZ() = LowerOffsetZ()+0.25;
function ReceiverBoltY() = 0.875;

module CouplingBolts(teardrop=false, boltHead="flat", extension=0.5,
              debug=false, clearance=0.005, cutter=false) {

  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (NUT = ["heatset", "hex"])
  for (Y = [-1,1])
  translate([RecoilPlateRearX()-ReceiverCouplingLength()-ManifoldGap(),
             ReceiverBoltY()*Y,
             ReceiverBoltZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=CouplingBolt(),
             boltLength=ReceiverCouplingLength()+extension+ManifoldGap(2),
             head=boltHead,
             nut=NUT, nutBackset=(NUT=="heatset"?0.125:0),
             teardrop=cutter&&teardrop,
             clearance=cutter?clearance:0);
}

module ReceiverCoupling(od=RECEIVER_TUBE_OD,
                        id=RECEIVER_TUBE_ID,
                        clearance=0.01,
                        debug=false, alpha=1) {
  length = FrameUpperRearExtension()+RecoilPlateRearX();

  color("DimGray", alpha)
  DebugHalf(enabled=debug) render()
  difference() {

    union() {

      // Bolt supports
      translate([RecoilPlateRearX()-length,0,0])
      hull()
      FrameSupport(length=length);

      // Join bolt wall and pipe
      translate([RecoilPlateRearX(),-(2.25/2),0])
      mirror([1,0,0])
      ChamferedCube([length,
                     2.25,
                     FrameBoltZ()],
                    r=1/16);

      // Around the receiver pipe
      translate([RecoilPlateRearX(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=2.25/2, r2=1/16, h=length, $fn=Resolution(30,60));

      // Coupling bolt support
      translate([RecoilPlateRearX(),-(2.25/2),LowerOffsetZ()])
      mirror([1,0,0])
      ChamferedCube([ReceiverCouplingLength()-ManifoldGap(2),
                     2.25,
                     abs(LowerOffsetZ())+FrameBoltY()],
                    r=1/16);

      // Center lug support
      translate([RecoilPlateRearX(),-(1.5/2),LowerOffsetZ()])
      mirror([1,0,0])
      ChamferedCube([length,
                     1.5,
                     abs(LowerOffsetZ())+FrameBoltY()],
                    r=1/16);
    }

    FrameBolts(cutter=true);

    ReceiverTube(od=od, id=id, cutter=true);

    CouplingBolts(cutter=true);

    // Lower lug cutout
    translate([-LowerMaxX()+RecoilPlateRearX(),0,0])
    PipeLugCenter(cutter=true);

    // Slot Cutout
    translate([RecoilPlateRearX()+ManifoldGap(),
               -(ReceiverSlotWidth()/2)-clearance,0])
    mirror([1,0,0])
    cube([length+ManifoldGap(2),ReceiverSlotWidth()+(clearance*2),2]);
  }
}

module ReceiverCoupling_print(od=RECEIVER_TUBE_OD,
                              id=RECEIVER_TUBE_ID)
translate([0,0,-ReceiverFrontLength()])
rotate([0,90,0])
ReceiverCoupling(od=od, id=id);

module ReceiverFront(width=2.25, frameLength=ReceiverFrontLength(),
                     boltHead="flat",
                     debug=false, alpha=1) {
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([-ReceiverFrontLength(),0, 0]){
        hull()
        FrameSupport(length=frameLength);

        translate([0,-width/2, LowerOffsetZ()])
        ChamferedCube([ReceiverFrontLength(),
                       width,
                       abs(LowerOffsetZ())+FrameBoltZ()],
                      r=1/16);

        children();
      }
    }

    // Picatinny rail cutout
    translate([-ReceiverFrontLength()-FrameUpperRearExtension(), -UnitsMetric(15.6/2), FrameTopZ()-0.125])
    cube([frameLength+ReceiverFrontLength()+FrameUpperRearExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);

    CouplingBolts(boltHead=boltHead, cutter=true, teardrop=false);
  }
}

module Receiver(od=RECEIVER_TUBE_OD,
                id=RECEIVER_TUBE_ID,
                receiverLength=ReceiverLength(),
                pipeOffsetX=0,
                pipeAlpha=0.5, buttstockAlpha=0.5,
                frameUpperBoltLength=FrameUpperBoltLength(),
                triggerAnimationFactor=TriggerAnimationFactor(),
                lower=true,
                lowerBolt=LowerBolt(),
                lowerBoltHead=LOWER_BOLT_HEAD,
                lowerBoltNut=LOWER_BOLT_NUT,
                debug=true) {

  CouplingBolts();

  ReceiverCoupling(od=od, id=id, debug=debug);

  translate([RecoilPlateRearX()-receiverLength,0,0])
  ButtstockAssembly(od=od, alpha=buttstockAlpha, debug=debug);

  translate([RecoilPlateRearX()-LowerMaxX(),0,0]) {

    if (lower)
    translate([0,0,LowerOffsetZ()])
    Lower(showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          boltSpec=lowerBolt, boltHead=lowerBoltHead, nut=lowerBoltNut,
          showTrigger=true,
          triggerAnimationFactor=triggerAnimationFactor,
          searLength=SearLength()+WallLower()+ReceiverPipeWall(od=od, id=id)+SearTravel(),
          alpha=1);

    PipeLugAssembly(od=od, id=id, length=receiverLength,
                    pipeAlpha=pipeAlpha, debug=debug);

  }
}

scale(25.4) {
  if (_RENDER == "Assembly") {

    FrameAssembly();

    Receiver(pipeAlpha=0.3,
             receiverLength=12,
             lowerBolt=LowerBolt(),
             lowerBoltHead=LOWER_BOLT_HEAD,
             lowerBoltNut=LOWER_BOLT_NUT,
             debug=false);

    ReceiverFront(alpha=0.25);
  }

  if (_RENDER == "Buttstock")
    Buttstock_print(od=RECEIVER_TUBE_OD);

  if (_RENDER == "FrameForend")
    FrameForend_print();

  if (_RENDER == "ReceiverCoupling")
    ReceiverCoupling_print(od=RECEIVER_TUBE_OD,
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

  if (_RENDER == "HammerHead")
    HammerHead_print();

  if (_RENDER == "HammerTail")
    HammerTail_print();
}

echo ("Pipe Lug Sear Length: ", SearLength()+WallLower()+ReceiverPipeWall(od=RECEIVER_TUBE_OD, id=RECEIVER_TUBE_ID)+SearTravel());
