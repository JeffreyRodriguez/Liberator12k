include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
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

FRAME_SPACER_LENGTH = 4.5;

// Settings: Lengths
function FrameBoltLength() = 10;
function FrameReceiverLength() = 3;

// Settings: Walls
function WallFrameBolt() = 0.25;

// Settings: Vitamins
function FrameBolt() = Spec_BoltOneHalf();

// Shorthand: Measurements
function FrameBoltRadius(clearance=0)
    = BoltRadius(FrameBolt(), clearance);

function FrameBoltDiameter(clearance=0)
    = BoltDiameter(FrameBolt(), clearance);

// Settings: Positions
function FrameBoltZ() = 1.5;
function FrameBoltY() = 1;
function FrameTopZ() = FrameBoltZ()
                     + FrameBoltRadius()
                     + WallFrameBolt();
function FrameBottomZ() = FrameBoltZ()
                        - FrameBoltRadius()
                        - WallFrameBolt();

function FrameExtension(length=FrameBoltLength()) = length
                                                  - FrameReceiverLength()
                                                  - NutHexHeight(FrameBolt());

module FrameBoltIterator() {
    for (Y = [FrameBoltY(),-FrameBoltY()])
    translate([-FrameReceiverLength()-NutHexHeight(FrameBolt())-ManifoldGap(),
               Y, FrameBoltZ()])
    rotate([0,90,0])
    children();
}

module FrameBolts(length=FrameBoltLength(),
              debug=false, cutter=false, clearance=0.005, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha) RenderIf(!cutter)
  DebugHalf(enabled=debug) {
    FrameBoltIterator()
    NutAndBolt(bolt=FrameBolt(), boltLength=length,
         head="hex", nut="hex", clearance=clear);
  }
}

module FrameSupport(length=FRAME_SPACER_LENGTH, $fn=Resolution(20,60)) {
  for (Y = [FrameBoltY(),-FrameBoltY()])
  translate([0, Y, FrameBoltZ()])
  rotate([0,90,0])
  ChamferedCylinder(r1=FrameBoltRadius()+WallFrameBolt(),
                    r2=1/16, h=length,
                    teardropTop=true, teardropBottom=true);
}

module FrameSpacer(length=FRAME_SPACER_LENGTH, debug=false, alpha=1) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    hull()
    FrameSupport(length=length);

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);
  }
}

module FrameSpacer_print()
rotate([0,-90,0]) translate([0,0,-FrameBoltZ()])
FrameSpacer();

module FrameAssembly(length=FrameBoltLength(),
                     spacerLength=FRAME_SPACER_LENGTH,
                     debug=false, alpha=1) {
  FrameBolts(length=length, debug=debug, alpha=alpha);

  FrameSpacer(length=spacerLength);
}

FrameAssembly();


*!FrameForend_print();
