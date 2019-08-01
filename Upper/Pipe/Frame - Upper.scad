include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Cylinder Redux.scad>;
use <../../Components/Pipe/Cap.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Charging Pump.scad>;
use <Recoil Plate.scad>;
use <Linear Hammer.scad>;
use <Frame.scad>;
use <Pipe Upper.scad>;

// Settings: Lengths
function FrameUpperRearExtension() = 3.5;

// Settings: Walls
function WallFrameUpperBolt() = 0.25;
function FrameUpperBoltLength() = 10;

// Settings: Vitamins
function FrameUpperBolt() = Spec_BoltThreeEighths();
function FrameUpperBolt() = Spec_BoltFiveSixteenths();
function FrameUpperBolt() = Spec_BoltOneHalf();

// Calculated: Positions
function FrameUpperBoltExtension() = FrameUpperBoltLength()
                                   -0.5
                                   -FrameUpperRearExtension();

function FrameUpperBoltOffsetZ() = 1.39;
function FrameUpperBoltOffsetY() = 1;
                             
// Shorthand: Measurements
function FrameUpperBoltRadius(clearance=false)
    = BoltRadius(FrameUpperBolt(), clearance);

function FrameUpperBoltDiameter(clearance=false)
    = BoltDiameter(FrameUpperBolt(), clearance);

module FrameUpperBoltIterator() {
    for (Y = [FrameUpperBoltOffsetY(),-FrameUpperBoltOffsetY()])
    translate([-FrameUpperRearExtension()-BoltNutHeight(FrameUpperBolt())-ManifoldGap(),
               Y, FrameUpperBoltOffsetZ()])
    rotate([0,90,0])
    children();
}

module FrameUpperBolts(length=FrameUpperBoltLength(),
              debug=false, cutter=false, alpha=1) {

  color("Silver", alpha)
  DebugHalf(enabled=debug) {
    FrameUpperBoltIterator()
    NutAndBolt(bolt=FrameUpperBolt(), boltLength=length,
         capHex=true, clearance=cutter);
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

FrameUpperBoltSupport(length=0.5);

FrameUpperBolts(extraLength=0.5, debug=false);


module FrameUpper(debug=false) {
  length = FrameUpperRearExtension()+RecoilPlateRearX();
  
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {

    union() {
      
      // Bolt wall
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
    }

    PipeLugPipe(cutter=true);

    translate([RecoilPlateRearX(),0,0])
    FrameUpperBolts(cutter=true);
    
    // Charger Cutout
    translate([RecoilPlateRearX()+ManifoldGap(),-(0.52/2),ReceiverIR()/2])
    mirror([1,0,0])
    cube([ChargerTowerLength()+ChargerTravel()+ManifoldGap(),0.52,2]);
    
    // Charger Cutout Wide Top
    translate([RecoilPlateRearX()+ManifoldGap(),-(1.02/2),ChargingRodOffset()])
    mirror([1,0,0])
    cube([ChargerTowerLength()+ChargerTravel()+ManifoldGap(),1.02,2]);
  }
}

ChargingPumpAssembly();

FrameUpper();

translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  frame=false,
                  stock=true, tailcap=false,
                  debug=false);


// Frame Upper
*!scale(25.4)
translate([-ReceiverOR(),0,FrameUpperRearExtension()])
rotate([0,-90,0])
FrameUpper();