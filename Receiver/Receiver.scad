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
_RENDER = "Assembly"; // ["Assembly", "Buttstock", "FrameForend", "ReceiverCoupling", "ReceiverLugCenter", "ReceiverLugFront", "ReceiverLugRear", "LowerLeft", "LowerRight", "LowerMiddle", "TriggerLeft", "TriggerRight", "TriggerMiddle", "HammerHead", "HammerTail"]

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.7501;
RECEIVER_TUBE_ID = 1.5001;

// Settings: Lengths
function FrameBoltExtension() = 0.5;
function ReceiverFrontLength() = 0.5;
function ReceiverCouplingLength() = 1;
function ReceiverLength() = 12;

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
function CouplingBolt() = Spec_Bolt8_32();

// Settings: Positions
function ReceiverBoltZ() = LowerOffsetZ()+0.25;
function ReceiverBoltY() = 0.875;

module CouplingBolts(teardrop=false, boltHead="flat",
              debug=false, clearance=0.005, cutter=false) {

  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  translate([-ReceiverFrontLength()+FrameBoltExtension()+ManifoldGap(),
             ReceiverBoltY()*Y,
             ReceiverBoltZ()])
  rotate([0,90,0]) {
    if (cutter)
    cylinder(r1=0.1875, r2=0, h=0.1875*3, $fn=20);

    NutAndBolt(bolt=CouplingBolt(), boltLength=ReceiverCouplingLength(),
               head=boltHead, nut="heatset", capOrientation=true,
               teardrop=cutter&&teardrop,
               clearance=cutter?clearance:0);
  }
}

module ReceiverCoupling(od=RECEIVER_TUBE_OD,
                        id=RECEIVER_TUBE_ID,
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

      // Lower Frame
      translate([RecoilPlateRearX(),-(2.25/2),LowerOffsetZ()])
      mirror([1,0,0])
      ChamferedCube([ReceiverCouplingLength()-ManifoldGap(2),
                     2.25,
                     abs(LowerOffsetZ())+FrameBoltY()],
                    r=1/16);
    }

    FrameBolts(cutter=true);

    ReceiverTube(od=od, id=id, cutter=true);

    CouplingBolts(cutter=true);

    // Lower lug cutout
    translate([RecoilPlateRearX()-ReceiverFrontLength(),-(1.256/2),(id/2)/2])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([length+ManifoldGap(),1.256,2]);


    // Charger Cutout
    translate([RecoilPlateRearX()+ManifoldGap(),-(0.52/2),(id/2)/2])
    mirror([1,0,0])
    cube([length+ManifoldGap(2),0.52,2]);

    // Charger Cutout Wide Top
    translate([RecoilPlateRearX()+ManifoldGap(),-(1.02/2),ChargingRodOffset()])
    mirror([1,0,0])
    cube([length+ManifoldGap(2),1.02,2]);
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

module ReceiverGuide(od=RECEIVER_TUBE_OD,
               id=RECEIVER_TUBE_ID,
               length=0.5,
               height=0.25,
               clearance=RodClearanceLoose(),
               bolt=true,
               cutter=false, debug=false) {

  color("OliveDrab") DebugHalf(enabled=debug) render()
  union() {

    // Tower
    translate([0,-0.5/2,0])
    ChamferedCube([length, 0.5, 1 + height], r=1/16);

    // Top wings
    translate([0,-1/2,1.005])
    ChamferedCube([length, 1, height], r=1/16);
  }
}

module Charger(od=RECEIVER_TUBE_OD,
               id=RECEIVER_TUBE_ID,
               clearance=RodClearanceLoose(),
               bolt=true,
               cutter=false, debug=false) {

  color("Tan") DebugHalf(enabled=debug) render() {
    difference() {

      // Charging Pusher
      union() {

        // Tower
        translate([RecoilPlateRearX(),-0.5/2,0.375])
        mirror([1,0,0])
        ChamferedCube([ChargerTowerLength(), 0.5, ChargingRodOffset()-0.25], r=1/32);

        // Top wings
        translate([RecoilPlateRearX(),-1/2,ChargingRodOffset()+0.07])// TODO: FIX magic number 0.07
        mirror([1,0,0])
        ChamferedCube([ChargerTowerLength(), 1, 0.25], r=1/32);

        // Charging Pusher Wide Base
        translate([RecoilPlateRearX(),0,0])
        intersection() {

          translate([0,-0.5,0.375])
          mirror([1,0,0])
          ChamferedCube([1.125, 1, (id/2)-0.375], r=1/32);

          // Rounded base
          rotate([0,-90,0])
          cylinder(r=(id/2)-0.02, h=1.125, $fn=Resolution(30,60));
        }
      }

      translate([RecoilPlateRearX()-0.625,-0.1875,0])
      mirror([1,0,0])
      ChamferedCube([1, 0.375, (od/2)], r=1/16);

      translate([ChargerTravel(),0,0])
      ChargingRod(cutter=true, clearance=RodClearanceSnug());

      ChargingRodBolts(cutter=true, teardrop=true);

    }
  }
}

module Receiver(od=RECEIVER_TUBE_OD,
                id=RECEIVER_TUBE_ID,
                receiverLength=ReceiverLength(),
                pipeOffsetX=ReceiverFrontLength(),
                pipeAlpha=0.5, buttstockAlpha=0.5, frameUpperBoltLength=FrameUpperBoltLength(),
                triggerAnimationFactor=TriggerAnimationFactor(),
                lower=true, debug=true) {

  CouplingBolts();

  ReceiverCoupling(od=od, id=id, debug=debug);

  translate([RecoilPlateRearX()-receiverLength,0,0])
  ButtstockAssembly(od=od, alpha=buttstockAlpha, debug=debug);

  translate([RecoilPlateRearX()-LowerMaxX()-ReceiverFrontLength(),0,0]) {

    if (lower)
    translate([0,0,LowerOffsetZ()])
    Lower(alpha=1,
          showTrigger=true,
          triggerAnimationFactor=triggerAnimationFactor,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+WallLower()+ReceiverPipeWall(od=od, id=id)+SearTravel());

    PipeLugAssembly(od=od, id=id, length=receiverLength,
                    pipeOffsetX=pipeOffsetX,
                    pipeAlpha=pipeAlpha, debug=debug);

  }
}

scale(25.4) {
  if (_RENDER == "Assembly") {

    translate([RecoilPlateRearX(),0,0])
    mirror([1,0,0])
    ReceiverGuide();

    FrameAssembly();

    Receiver(pipeAlpha=0.3,
                      receiverLength=12,
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
    LowerLeft_print();

  if (_RENDER == "LowerRight")
    LowerRight_print();

  if (_RENDER == "LowerMiddle")
    LowerMiddle_print();

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
