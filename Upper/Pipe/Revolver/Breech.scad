include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Teardrop.scad>;

use <../../../Components/Firing Pin.scad>;
use <../../../Components/Pipe/Cap.scad>;
use <../../../Components/Pipe/Lugs.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;

use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Trigger.scad>;
use <../../../Lower/Lower.scad>;

use <../Linear Hammer.scad>;
use <../Pipe Upper.scad>;

// Measured: Vitamins
function BreechPlateThickness() = 3/8;
function BreechPlateWidth() = 2;

// Settings: Lengths
function BreechBoltLength() = 5.4;

// Settings: Walls
function WallBreechBolt() = 0.1875;

// Settings: Positions
function BreechFrontX() = 0;
function RevolverSpindleOffset() = 1.125;

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
function BreechPlateHeight()
                           = BreechBoltOffsetZ()
                           + BreechBoltRadius()
                           + RevolverSpindleOffset()
                           + 
                           + (2*WallBreechBolt());

// Shorthand: Measurements
function BreechBoltRadius(clearance=false)
    = BoltRadius(BreechBolt(), clearance);

function BreechBoltDiameter(clearance=false)
    = BoltDiameter(BreechBolt(), clearance);

echo("BreechPlateHeight(): ", BreechPlateHeight());

function FiringPinMinX() = BreechRearX()-FiringPinBodyLength();


module BreechFiringPinAssembly(
         cutter=false, debug=false) {  
  translate([BreechRearX(),0,0])
  rotate([0,-90,0])
  rotate([0,0,-90])
  FiringPinAssembly(cutter=cutter, debug=debug);
}

module Breech(debug=false,
              frame=BreechBolt(),
              thickness=BreechPlateThickness(),
              alpha=1) {
  color("LightSteelBlue", alpha)
  DebugHalf(enabled=debug)
  difference() {
    translate([BreechFrontX(),0,0])
    translate([-thickness, -BreechPlateWidth()/2, BreechBoltOffsetZ()+BreechBoltRadius()+WallBreechBolt()])
    mirror([0,0,1])
    cube([thickness, BreechPlateWidth(), BreechPlateHeight()]);
    
    BreechFiringPinAssembly(cutter=true);
    
    BreechBolts(frame=frame, cutter=true);
  }
}

module BreechBoltIterator() {
    for (Y = [BreechBoltOffsetY(),-BreechBoltOffsetY()])
    translate([BreechRearX()-ManifoldGap(), Y, BreechBoltOffsetZ()])
    rotate([0,90,0])
    children();
}

module BreechBolts(length=BreechBoltLength(),
              debug=false, cutter=false) {
                
  color("Silver")
  DebugHalf(enabled=debug) {
    BreechBoltIterator()
    Bolt(bolt=BreechBolt(), length=length+ManifoldGap(2),
         hex=true, clearance=cutter);
  }
}

module BreechAssembly(breechBoltLength=BreechBoltLength(), debug=false) {
  BreechFiringPinAssembly(breechBoltLength=breechBoltLength);
  BreechBolts(length=breechBoltLength, debug=debug);
  Breech(debug=debug);
}

BreechAssembly(debug=false);

module BreechTemplate() {
  scale(25.4)
  rotate([0,-90,0])
  Breech(thickness=0.03125);
}

module BreechPipeUpperAssembly(
         receiver=Spec_PipeThreeQuarterInch(),
         receiverLength=ReceiverLength(),
         breechBoltLength=BreechBoltLength(),
         pipeAlpha=1, chargingHandle=true,
         frame=true, stock=false, tailcap=false,
         hammerTravelFactor=LinearHammerTravelFactor(),
         triggerAnimationFactor=0,
         debug=true) {
  
  BreechAssembly(breechBoltLength=breechBoltLength, debug=debug);
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly(travelFactor=hammerTravelFactor);
  
  translate([BreechRearX(),0,0])
  PipeUpperAssembly(pipeAlpha=pipeAlpha,
                    receiver=receiver,
                    receiverLength=receiverLength,
                    chargingHandle=chargingHandle,
                    frame=frame, stock=stock, tailcap=tailcap,
                    triggerAnimationFactor=triggerAnimationFactor,
                    debug=debug);
}

BreechPipeUpperAssembly(stock=false, tailcap=true,
                             frame=true, debug=true);

*!BreechTemplate();

