include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Cap.scad>;
use <../../Components/Pipe/Lugs.scad>;
use <../../Components/Pipe/Tailcap.scad>;
use <../../Components/Pipe/Buttstock.scad>;
use <../../Components/Pipe/Linear Hammer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Pipe Upper.scad>;

// Settings: Lengths
function BreechBoltLength() = 5.4;

// Settings: Walls
function WallFrame() = 0.1875;

// Measured: Vitamins
function BreechPlateThickness() = 3/8;
function BreechPlateWidth() = 2;

// Settings: Positions
function BreechFrontX() = 0;

// Settings: Vitamins
function BreechBolt() = Spec_BoltOneHalf();

// Calculated: Positions
function BreechRearX()  = BreechFrontX()-BreechPlateThickness();
function BreechPlateHeight()
                           = ReceiverOD()
                           + (2*BoltDiameter(BreechBolt()))
                           + (4*WallFrame());
                           
echo("BreechPlateHeight(): ", BreechPlateHeight());

function FiringPinMinX() = BreechRearX()-FiringPinBodyLength();
function BreechBoltOffset(frameBolt=BreechBolt(),
                           receiverPipe=ReceiverPipe(),
                           wallFrame=WallFrame())
                           = ReceiverOR()
                           + BoltRadius(frameBolt)
                           + WallFrame();

// Shorthand: Measurements
function FrameMajorWall() = WallFrame();

module FixedBreechFiringPinAssembly(
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
    translate([-thickness, -BreechPlateWidth()/2, -BreechPlateHeight()/2])
    cube([thickness, BreechPlateWidth(), BreechPlateHeight()]);
    
    FixedBreechFiringPinAssembly(cutter=true);
    
    BreechBolts(frame=frame, cutter=true);
  }
}


module BreechBolts(pipe=ReceiverPipe(),
              frame=BreechBolt(), length=BreechBoltLength(),
              wallLower=WallLower(), 
              frameWall=WallFrame(),
              debug=false, cutter=false) {
                
  color("Silver")
  DebugHalf(enabled=debug) {
    translate([BreechRearX()-ManifoldGap(),0,0])
    translate([0,0,BreechBoltOffset()])
    rotate([0,90,0])
    Bolt(bolt=frame, length=BreechBoltLength()+ManifoldGap(2),
         hex=true, clearance=cutter);
    
    translate([BreechRearX()-ManifoldGap(),0,0])
    translate([0,0,-BreechBoltOffset()])
    rotate([0,90,0])
    Bolt(bolt=frame, length=BreechBoltLength()+ManifoldGap(2),
         hex=true, clearance=cutter);
  }
}

module FixedBreechAssembly(debug=false) {
  FixedBreechFiringPinAssembly();
  BreechBolts(debug=debug);
  Breech(debug=debug);
}

FixedBreechAssembly(debug=false);

module BreechTemplate() {
  scale(25.4)
  rotate([0,-90,0])
  Breech(thickness=0.03125);
}

module FixedBreechPipeUpperAssembly(
         receiver=Spec_PipeThreeQuarterInch(), receiverLength=ReceiverLength(),
         pipeAlpha=1,
         frame=true, stock=false, tailcap=false,
         hammerTravelFactor=LinearHammerTravelFactor(),
         debug=true) {
  
  FixedBreechAssembly();
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly(travelFactor=hammerTravelFactor);
  
  translate([BreechRearX(),0,0])
  PipeUpperAssembly(pipeAlpha=pipeAlpha,
                    receiver=receiver,
                    receiverLength=receiverLength,
                    frame=frame, stock=stock, tailcap=tailcap,
                    debug=debug);
}

FixedBreechPipeUpperAssembly(stock=false, tailcap=true,
                             frame=true, debug=true);

Breech();

*!BreechTemplate();

