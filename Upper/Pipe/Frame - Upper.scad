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

use <Linear Hammer.scad>;
use <Frame.scad>;
use <Pipe Upper.scad>;

// Settings: Lengths
function FrameUpperRearExtension() = 3.75;

// Settings: Walls
function WallFrameUpperBolt() = 0.25;
function FrameUpperBoltLength() = 9.875;

// Settings: Vitamins
function FrameUpperBolt() = Spec_BoltThreeEighths();
function FrameUpperBolt() = Spec_BoltFiveSixteenths();
function FrameUpperBolt() = Spec_BoltOneHalf();

// Calculated: Positions
function FrameUpperBoltExtension() = FrameUpperBoltLength()
                                   -0.5
                                   -FrameUpperRearExtension();
function FrameUpperBoltOffsetZ() = ReceiverOR()
                            + FrameUpperBoltRadius()
                            + WallFrameUpperBolt();
function FrameUpperBoltOffsetY() = FrameUpperBoltDiameter()
                             + WallFrameUpperBolt();
                             
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
module FrameUpperBoltSupport(length=1) {  
  for (Y = [FrameUpperBoltOffsetY(),-FrameUpperBoltOffsetY()])
  translate([0, Y, FrameUpperBoltOffsetZ()])
  rotate([0,90,0])
  ChamferedCylinder(r1=FrameUpperBoltRadius()+WallFrameUpperBolt(),
                    r2=1/16, h=length,
                    $fn=30);
}

FrameUpperBoltSupport(length=0.5);

FrameUpperBolts(extraLength=0.5, debug=false);
