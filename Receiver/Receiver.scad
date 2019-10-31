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
_RENDER = "Assembly"; // ["Assembly", "FrameForend", "ReceiverCoupling", "ReceiverLugCenter", "ReceiverLugFront", "ReceiverLugRear", "LowerLeft", "LowerRight", "LowerMiddle", "TriggerLeft", "TriggerRight", "TriggerMiddle", "HammerHead", "HammerTail", "Buttstock"]

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.75;
RECEIVER_TUBE_ID = 1.5;

// Settings: Lengths
function FrameBoltExtension() = 0.5;
function FrameExtension() = 0.5;
function ReceiverCouplingLength() = 1;
function ReceiverLength() = 12;

// Calculated: Measurements
function ReceiverID()     = RECEIVER_TUBE_ID;
function ReceiverIR()     = ReceiverID()/2;
function ReceiverOD()     = RECEIVER_TUBE_OD;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverPipeWall() = ReceiverOR()-ReceiverIR();

function HammerTravel() = LowerMaxX() + FrameExtension()
                              - HammerCollarWidth()
                              + RodRadius(SearRod())
                              - FiringPinHousingLength();
echo("HammerTravel", HammerTravel());

// Settings: Vitamins
function ReceiverBolt() = Spec_Bolt8_32();

// Settings: Positions
function ReceiverBoltZ() = LowerOffsetZ()+0.25;
function ReceiverBoltY() = 0.875;

module ReceiverBolts(teardrop=false,
              debug=false, clearance=0.005, cutter=false) {

  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  translate([-FrameExtension()+FrameBoltExtension()+ManifoldGap(),
             ReceiverBoltY()*Y,
             ReceiverBoltZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=ReceiverBolt(), boltLength=2,
             head="flat", nut="heatset", capOrientation=true,
             teardrop=cutter&&teardrop, clearance=cutter?clearance:0);
}

module ReceiverCoupling(debug=false) {
  length = FrameUpperRearExtension()+RecoilPlateRearX();

  color("Olive")
  DebugHalf(enabled=debug) render()
  difference() {

    union() {

      // Bolt supports
      translate([RecoilPlateRearX()-length,0,0])
      hull()
      FrameSupport(length=length);

      // Join bolt wall and pipe
      translate([RecoilPlateRearX(),-(2/2),ReceiverIR()/2])
      mirror([1,0,0])
      ChamferedCube([length,
                     2,
                     FrameBoltZ()-(ReceiverIR()/2)],
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

    ReceiverTube(cutter=true);
    
    ReceiverBolts(cutter=true);

    // Lower lug cutout
    translate([RecoilPlateRearX()-FrameExtension(),-(1.256/2),ReceiverIR()/2])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([length+ManifoldGap(),1.256,2]);


    // Charger Cutout
    translate([RecoilPlateRearX()+ManifoldGap(),-(0.52/2),ReceiverIR()/2])
    mirror([1,0,0])
    cube([length+ManifoldGap(2),0.52,2]);

    // Charger Cutout Wide Top
    translate([RecoilPlateRearX()+ManifoldGap(),-(1.02/2),ChargingRodOffset()])
    mirror([1,0,0])
    cube([length+ManifoldGap(2),1.02,2]);
  }
}

module ReceiverCoupling_print()
translate([0,0,-FrameExtension()])
rotate([0,90,0])
ReceiverCoupling();

module ReceiverFront(width=2.25, debug=false, alpha=1) {
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    RecoilPlateHousing() {
      hull()
      FrameSupport(length=RecoilSpreaderThickness());
      
      translate([0,-width/2, LowerOffsetZ()])
      ChamferedCube([RecoilSpreaderThickness(),
                     width,
                     abs(LowerOffsetZ())+FrameBoltZ()],
                    r=1/16);
      
      children();
    }

    FrameBolts(cutter=true);

    ReceiverBolts(cutter=true, teardrop=false);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true);
  }
}

echo ("Wing offset", ChargingRodOffset()+0.07);

module Charger(clearance=RodClearanceLoose(),
               bolt=true,
               cutter=false, debug=false) {

  color("OrangeRed") DebugHalf(enabled=debug) render() {
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
          ChamferedCube([1.125, 1, ReceiverIR()-0.375], r=1/32);

          // Rounded base
          rotate([0,-90,0])
          cylinder(r=ReceiverIR()-0.02, h=1.125, $fn=Resolution(30,60));
        }
      }

      translate([RecoilPlateRearX()-0.625,-0.1875,0])
      mirror([1,0,0])
      ChamferedCube([1, 0.375, ReceiverOR()], r=1/16);

      translate([ChargerTravel(),0,0])
      ChargingRod(cutter=true, clearance=RodClearanceSnug());

      ChargingRodBolts(cutter=true, teardrop=true);

    }
  }
}

module PipeUpperAssembly(receiverLength=ReceiverLength(),
                         pipeOffsetX=FrameExtension(),
                         pipeAlpha=1, frameUpperBoltLength=FrameUpperBoltLength(),
                         triggerAnimationFactor=TriggerAnimationFactor(),
                         debug=true) {

  translate([FiringPinMinX(),0,0])
  HammerAssembly(alpha=0.5);
  
  RecoilPlateFiringPinAssembly();
  
  RecoilPlate();
                           
  Charger();
  
  FrameAssembly();

  ReceiverBolts();

  ReceiverCoupling();

  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0]) {

    translate([0,0,LowerOffsetZ()])
    Lower(alpha=1,
          showTrigger=true,
          triggerAnimationFactor=triggerAnimationFactor,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());

    PipeLugAssembly(length=receiverLength,
                    pipeOffsetX=pipeOffsetX,
                    pipeAlpha=pipeAlpha);

  }

  translate([RecoilPlateRearX()-receiverLength,0,0])
  ButtstockAssembly(receiverRadius=ReceiverOR());
}



scale(25.4) {
  if (_RENDER == "Assembly") {

    PipeUpperAssembly(pipeAlpha=0.3,
                      receiverLength=12,
                      debug=false);
    ReceiverFront(alpha=0.5);
  }
  
  if (_RENDER == "FrameForend")
    FrameForend_print();

  if (_RENDER == "ReceiverCoupling")
    ReceiverCoupling_print();

  if (_RENDER == "ReceiverLugCenter")
    PipeLugCenter_print();

  if (_RENDER == "ReceiverLugFront")
    PipeLugFront_print();

  if (_RENDER == "ReceiverLugRear")
    PipeLugRear_print();

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

  if (_RENDER == "Buttstock")
    Buttstock_print();
}

echo ("Pipe Lug Sear Length: ", SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());
