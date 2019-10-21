include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Lugs.scad>;
use <Buttstock.scad>;
use <Charging Pump.scad>;
use <Recoil Plate.scad>;

// Settings: Lengths
function FrameUpperRearExtension() = 3.5;
function FrameBoltExtension() = 0.5;
function FrameExtension() = 0.5;
function FrameLength() = 1;

// Settings: Walls
function WallFrameUpperBolt() = 0.25;
function FrameUpperBoltLength() = 10;

// Settings: Vitamins
function FrameUpperBolt() = Spec_BoltOneHalf();
function FrameBolt() = Spec_Bolt8_32();

// Settings: Positions
function FrameUpperBoltOffsetZ() = 1.39;
function FrameUpperBoltOffsetY() = 1;

// Shorthand: Measurements
function FrameUpperBoltRadius(clearance=0)
    = BoltRadius(FrameUpperBolt(), clearance);

function FrameUpperBoltDiameter(clearance=0)
    = BoltDiameter(FrameUpperBolt(), clearance);

// Calculated: Positions
function FrameUpperBoltExtension() = FrameUpperBoltLength()
                                   -0.5
                                   -FrameUpperRearExtension();

module FrameBolts(teardrop=false, flip=false,
              debug=false, clearance=0.005, cutter=false) {

  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  mirror([0,0,flip?180:0])
  translate([-FrameExtension()+FrameBoltExtension()+ManifoldGap(),
             Y*0.875 , /*Y*1.6/2,*/
             LowerOffsetZ()+0.25/*-(1.905/2)*/])
  rotate([0,90,0])
  NutAndBolt(bolt=FrameBolt(), boltLength=2,
             head="flat", nut="heatset", capOrientation=true,
             teardrop=cutter&&teardrop, clearance=cutter?clearance:0);
}

module FrameUpperBoltIterator() {
    for (Y = [FrameUpperBoltOffsetY(),-FrameUpperBoltOffsetY()])
    translate([-FrameUpperRearExtension()-NutHexHeight(FrameUpperBolt())-ManifoldGap(),
               Y, FrameUpperBoltOffsetZ()])
    rotate([0,90,0])
    children();
}

module FrameUpperBolts(length=FrameUpperBoltLength(),
              debug=false, cutter=false, clearance=0.005, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha)
  DebugHalf(enabled=debug) {
    FrameUpperBoltIterator()
    NutAndBolt(bolt=FrameUpperBolt(), boltLength=length,
         head="hex", nut="hex", clearance=clear);
  }
}

module FrameUpperBoltSupport(length=1, $fn=Resolution(20,60)) {
  for (Y = [FrameUpperBoltOffsetY(),-FrameUpperBoltOffsetY()])
  translate([0, Y, FrameUpperBoltOffsetZ()])
  rotate([0,90,0])
  ChamferedCylinder(r1=FrameUpperBoltRadius()+WallFrameUpperBolt(),
                    r2=1/16, h=length,
                    teardropTop=true, teardropBottom=true);
}

module FrameUpper(debug=false) {
  length = FrameUpperRearExtension()+RecoilPlateRearX();

  color("Olive")
  DebugHalf(enabled=debug) render()
  difference() {

    union() {

      // Bolt supports
      translate([RecoilPlateRearX(),0,0])
      mirror([1,0,0])
      hull()
      FrameUpperBoltSupport(length=length);

      // Join bolt wall and pipe
      translate([RecoilPlateRearX(),-(2/2),ReceiverIR()/2])
      mirror([1,0,0])
      ChamferedCube([length,
                     2,
                     FrameUpperBoltOffsetZ()-(ReceiverIR()/2)],
                    r=1/16);

      // Lower Frame
      translate([RecoilPlateRearX(),-(2.25/2),LowerOffsetZ()])
      mirror([1,0,0])
      ChamferedCube([FrameLength()-ManifoldGap(2),
                     2.25,
                     abs(LowerOffsetZ())+FrameUpperBoltOffsetY()],
                    r=1/16);
    }

    ReceiverTube(cutter=true);

    translate([RecoilPlateRearX(),0,0])
    FrameUpperBolts(cutter=true);


    FrameBolts(cutter=true);

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

module PipeUpperAssembly(receiverLength=ReceiverLength(),
                         pipeOffsetX=FrameExtension(),
                         pipeAlpha=1, centerLug=false,
                         lower=true, lowerLeft=true, lowerRight=true,
                         lugs=true, stock=false,
                         frameUpperBolts=true,
                         triggerAnimationFactor=TriggerAnimationFactor(),
                         debug=true) {

  translate([RecoilPlateRearX()-receiverLength,0,0]) {
      if (stock) {
        Buttstock(debug=debug);
        ButtstockBolt(debug=debug);
      }

  }

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

  if (frameUpperBolts)
  FrameUpperBolts(debug=false);

  FrameBolts();

  FrameUpper();
}


AnimateSpin() {

  PipeUpperAssembly(pipeAlpha=0.3,
                    receiverLength=12,
                    stock=true, lower=true,
                    debug=false);
}

*!scale(25.4) translate([0,0,-LowerOffsetZ()])
PipeLugCenter();

// Frame Upper
*!scale(25.4)
translate([-ReceiverOR(),0,-FrameExtension()])
rotate([0,90,0])
FrameUpper();
