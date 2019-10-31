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

use <Charging Pump.scad>;

// Settings: Lengths
function FrameForendExtension() = 4.5;
function FrameUpperRearExtension() = 3.5;
function FrameBoltExtension() = 0.5;
function FrameExtension() = 0.5;

// Settings: Walls
function WallFrameUpperBolt() = 0.25;
function FrameUpperBoltLength() = 10;

// Settings: Vitamins
function FrameUpperBolt() = Spec_BoltOneHalf();
function FrameBolt() = Spec_Bolt8_32();

// Shorthand: Measurements
function FrameUpperBoltRadius(clearance=0)
    = BoltRadius(FrameUpperBolt(), clearance);

function FrameUpperBoltDiameter(clearance=0)
    = BoltDiameter(FrameUpperBolt(), clearance);

// Settings: Positions
function FrameBoltZ() = 1.39;
function FrameBoltY() = 1;
function FrameTopZ() = FrameBoltZ()
                          + FrameUpperBoltRadius()
                          + WallFrameUpperBolt();

// Calculated: Positions
function FrameUpperBoltExtension() = FrameUpperBoltLength()
                                   -0.5
                                   -FrameUpperRearExtension();

module FrameBoltIterator() {
    for (Y = [FrameBoltY(),-FrameBoltY()])
    translate([-FrameUpperRearExtension()-NutHexHeight(FrameUpperBolt())-ManifoldGap(),
               Y, FrameBoltZ()])
    rotate([0,90,0])
    children();
}

module FrameBolts(length=FrameUpperBoltLength(),
              debug=false, cutter=false, clearance=0.005, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha)
  DebugHalf(enabled=debug) {
    FrameBoltIterator()
    NutAndBolt(bolt=FrameUpperBolt(), boltLength=length,
         head="hex", nut="hex", clearance=clear);
  }
}

module FrameSupport(length=1, $fn=Resolution(20,60)) {
  for (Y = [FrameBoltY(),-FrameBoltY()])
  translate([0, Y, FrameBoltZ()])
  rotate([0,90,0])
  ChamferedCylinder(r1=FrameUpperBoltRadius()+WallFrameUpperBolt(),
                    r2=1/16, h=length,
                    teardropTop=true, teardropBottom=true);
}

module FrameForend(length=FrameForendExtension(), debug=false, alpha=1) {
  color("DarkOliveGreen", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    hull()
    FrameSupport(length=length);

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.125])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);

    ChargingRod(cutter=true);
  }
}

module FrameForend_print()
rotate([0,-90,0]) translate([0,0,-FrameBoltZ()])
FrameForend();

module FrameAssembly(length=FrameUpperBoltLength(),
                     debug=false, alpha=1) {
  FrameBolts(length=length, debug=debug, alpha=alpha);

  FrameForend();
}

FrameAssembly();


*!FrameForend_print();
