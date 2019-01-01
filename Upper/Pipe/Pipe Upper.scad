include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Frame.scad>;
use <../../Components/Pipe/Frame Standoffs.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

// Settings: Walls
function WallLower()      = 0.25;
function WallFrameSide() = 0.1875;
function WallFrameFront() = 0.215;
function WallFrameBack()  = 0.3;

// Settings: Lengths
function ReceiverLength() = 12;
function FrameLength() = 10;
function HammerBoltLength() = 2.5;
function HammerSpringLength() = 3;

// Settings: Vitamins
function ButtTee()    = Spec_AnvilForgedSteel_OneInch();
function ReceiverPipe()  = Spec_OnePointFiveSch40ABS();
function StrikerRod() = Spec_RodOneHalfInch();
function HammerBolt() = Spec_BoltOneHalf();

// Calculated: Positions
function LowerX() = LowerMaxX()-BreechRearX();
function ButtTeeCenterX() = -ReceiverLength()
                          - (TeePipeEndOffset(ButtTee(),ReceiverPipe())*2);

// Shorthand: Measurements
function ReceiverID()     = PipeInnerDiameter(ReceiverPipe());
function ReceiverIR()     = PipeInnerRadius(ReceiverPipe());
function ReceiverOD()     = PipeOuterDiameter(ReceiverPipe());
function ReceiverOR()     = PipeOuterRadius(ReceiverPipe());

function SearRadius(clearance)   = RodRadius(SearRod(), clearance);
function SearDiameter(clearance) = RodDiameter(SearRod(), clearance);

// Linear Hammer
function HammerTravel() = LowerMaxX()-1.0625;

module LinearHammer() {
  translate([-1-BoltCapHeight(HammerBolt())-HammerTravel(),0,0]) {
    
    translate([BreechRearX()+ManifoldGap(),0,0])
    rotate([0,90,0])
    NutAndBolt(bolt=HammerBolt(), boltLength=HammerBoltLength(), nutBackset=0.03125,
               capHex=true, capOrientation=true);
    
    translate([BreechRearX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=5/16/2, h=HammerBoltLength()+HammerSpringLength(), $fn=Resolution(10,20));
    
    color("Orange")
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=HammerBoltLength()-NutHexHeight(HammerBolt()), $fn=Resolution(20,50));
  }
}

module PipeUpperAssembly(receiver=Spec_PipeThreeQuarterInch(),
                 hollowReceiver=true, frame=true,
                 butt=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                 debug=true) {
  translate([-LowerMaxX()-BreechPlateThickness(),0,0])
  PipeLugAssembly(length=ReceiverLength(), debug=debug);
                   
  FramePipeStandoffs(debug=debug);
  
  if (frame)
  StandoffFrameAssembly(debug=debug);
  
  
  LinearHammer();
}

PipeUpperAssembly(frame=true, debug=true);
