include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Teardrop.scad>;

use <../../../Components/Firing Pin.scad>;
use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pipe/Cap.scad>;
use <../../../Components/Pipe/Lugs.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Trigger.scad>;
use <../../../Lower/Lower.scad>;

use <../Linear Hammer.scad>;
use <../Frame.scad>;
use <../Pipe Upper.scad>;

// Measured: Vitamins
function BreechPlateThickness() = 3/8;
function BreechPlateWidth() = 2;

// Settings: Lengths
function BreechBoltLength() = 5.4;
function BreechBoltRearExtension() = 1.375;

// Settings: Walls
function WallBreechBolt() = 0.1875;

// Settings: Positions
function BreechFrontX() = 0;

// Settings: Vitamins
function BreechBolt() = Spec_BoltOneHalf();
function BreechBolt() = Spec_BoltThreeEighths();
function BreechBolt() = Spec_BoltFiveSixteenths();


// Calculated: Positions
function BreechBoltOffsetZ() = ReceiverOR()
                            + BreechBoltRadius()
                            + WallBreechBolt();
function BreechBoltOffsetY() = (BreechPlateWidth()/2)
                             - BreechBoltRadius()
                             - WallBreechBolt();
function BreechRearX()  = BreechFrontX()-BreechPlateThickness();
function BreechPlateHeight(spindleOffset=1)
                           = BreechBoltOffsetZ()
                           + BreechBoltRadius()
                           + spindleOffset
                           + RodRadius(CylinderRod())
                           + (2*WallBreechBolt());
function BreechTopZ() = BreechBoltOffsetZ()
                           + WallBreechBolt()
                           + BreechBoltRadius();

// Shorthand: Measurements
function BreechBoltRadius(clearance=false)
    = BoltRadius(BreechBolt(), clearance);

function BreechBoltDiameter(clearance=false)
    = BoltDiameter(BreechBolt(), clearance);

function FiringPinMinX() = BreechRearX()-FiringPinBodyLength();


module BreechFiringPinAssembly(
         cutter=false, debug=false) {  
  translate([BreechRearX(),0,0])
  rotate([0,-90,0])
  rotate([0,0,-180])
  FiringPinAssembly(cutter=cutter, debug=debug);
}

module Breech(debug=false,
              thickness=BreechPlateThickness(),
              spindleOffset=0,
              alpha=1) {
  color("LightSteelBlue", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([BreechFrontX(),0,0])
      translate([-thickness, -BreechPlateWidth()/2, BreechBoltOffsetZ()+BreechBoltRadius()+WallBreechBolt()])
      mirror([0,0,1])
      cube([thickness, BreechPlateWidth(), BreechPlateHeight(spindleOffset)]);
      
      children();
    }
    
    
    // Revolver spindle
    translate([BreechRearX()-ManifoldGap(),0,-spindleOffset])
    rotate([0,90,0])
    Rod(CylinderRod(),
        length=BreechPlateThickness()+ManifoldGap(2),
        cutter=true);
    
    BreechFiringPinAssembly(cutter=false);
    
    BreechBolts(cutter=false);
    
    translate([BreechRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=false);

  }
}

module BreechBoltIterator() {
    for (Y = [BreechBoltOffsetY(),-BreechBoltOffsetY()])
    translate([BreechRearX()-BreechBoltRearExtension()-ManifoldGap(), Y, BreechBoltOffsetZ()])
    rotate([0,90,0])
    children();
}

module BreechBolts(length=BreechBoltLength(),
              debug=false, cutter=false) {
                
  color("Silver")
  DebugHalf(enabled=debug) {
    BreechBoltIterator()
    NutAndBolt(bolt=BreechBolt(), boltLength=length+ManifoldGap(2),
         capHex=true, clearance=cutter);
  }
}

module BreechAssembly(breechBoltLength=BreechBoltLength(), debug=false) {
  BreechFiringPinAssembly(breechBoltLength=breechBoltLength, debug=debug);
  BreechBolts(length=breechBoltLength, debug=debug);
  
  translate([BreechRearX()-LowerMaxX(),0,0])
  FrameBolts(debug=debug);
  Breech(debug=debug);
}

BreechAssembly(debug=false);

translate([BreechRearX(),0,0])
PipeUpperAssembly(frameUpper=false);

module BreechTemplate() {
  scale(25.4)
  rotate([0,-90,0])
  Breech(thickness=0.03125);
}

*!BreechTemplate();
