include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Finishing/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <../Lower/Receiver Lugs.scad>;
use <../Lower/Trigger.scad>;
use <../Lower/Lower.scad>;

use <Buttstock.scad>;
use <Charging Pump.scad>;
use <Linear Hammer.scad>;
use <Lugs.scad>;
use <Frame.scad>;
use <Recoil Plate.scad>;

// Settings: Lengths
function FrameBoltExtension() = 0.5;
function FrameExtension() = 0.5;
function ReceiverCouplingLength() = 1;
function ReceiverLength() = 12;


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
      translate([RecoilPlateRearX(),0,0])
      mirror([1,0,0])
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

module ReceiverFront(debug=false, width=2.25) {
  color("MediumSlateBlue")
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

module PipeUpperAssembly(receiverLength=ReceiverLength(),
                         pipeOffsetX=FrameExtension(),
                         pipeAlpha=1, centerLug=false,
                         lower=true, lowerLeft=true, lowerRight=true,
                         lugs=true, stock=true,
                         frameUpperBolts=true, frameUpperBoltLength=FrameUpperBoltLength(),
                         triggerAnimationFactor=TriggerAnimationFactor(),
                         debug=true) {

  translate([RecoilPlateRearX()-receiverLength,0,0]) {
      if (stock) {
        Buttstock(debug=debug);
        ButtstockBolt(debug=debug);
      }

  }

  translate([FiringPinMinX(),0,0])
  HammerAssembly(debug=true);
  
  RecoilPlateFiringPinAssembly();
  
  RecoilPlate();
  
  FrameAssembly();

  ReceiverBolts();

  ReceiverCoupling();

  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0]) {

    if (lower)
    translate([0,0,LowerOffsetZ()])
    Lower(showTrigger=true, showLeft=lowerLeft, showRight=lowerRight, alpha=1, triggerAnimationFactor=triggerAnimationFactor,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());

    if (lugs)
    PipeLugAssembly(pipeOffsetX=pipeOffsetX, length=receiverLength,
                    pipeAlpha=pipeAlpha);

  }
}

ReceiverFront();

PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  stock=true, lower=true,
                  debug=false);

*!scale(25.4) translate([0,0,-LowerOffsetZ()])
PipeLugCenter();

// Frame Upper
*!scale(25.4)
translate([-ReceiverOR(),0,-FrameExtension()])
rotate([0,90,0])
FrameUpper();
