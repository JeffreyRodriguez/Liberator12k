include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Pipe/Lugs.scad>;
use <../../Components/Firing Pin.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

DEFAULT_WALL_LOWER = 0.25;
DEFAULT_WALL_FRAME = 0.1875;

DEFAULT_RECEIVER_PIPE = Spec_OnePointFiveSch40ABS();
DEFAULT_FRAME_BOLT    = Spec_BoltOneHalf();
DEFAULT_FRAME_MINOR_BOLT    = Spec_BoltM5();

DEFAULT_LENGTH_FRAME = 12;
DEFAULT_OFFSET_FRAME_MAJOR = 0;
DEFAULT_OFFSET_FRAME_MINOR = 0;

// Measured: Vitamins
function BreechPlateThickness() = 3/8;
function BreechPlateWidth() = 2;

// Settings: Positions
function BreechFrontX() = 0;

// Settings: Vitamins
function FrameMajorRod() = Spec_RodOneHalfInch();//Spec_RodFiveSixteenthInch();
function FrameMinorRod() = Spec_RodFiveSixteenthInch();

// Calculated: Positions
function BreechRearX()  = BreechFrontX()-BreechPlateThickness();
function BreechPlateHeight(frameBolt=DEFAULT_FRAME_BOLT,
                           receiverPipe=DEFAULT_RECEIVER_PIPE,
                           wallFrame=DEFAULT_WALL_FRAME)
                           = PipeOuterDiameter(receiverPipe)
                           + (2*FrameMajorRodDiameter(frameBolt=frameBolt, wall=wallFrame))
                           + (4*wallFrame);
echo("BreechPlateHeight(): ", BreechPlateHeight());
function FrameMajorRodOffset(frameBolt=DEFAULT_FRAME_BOLT,
                           receiverPipe=DEFAULT_RECEIVER_PIPE,
                           wallFrame=DEFAULT_WALL_FRAME)
                           = PipeOuterRadius(DEFAULT_RECEIVER_PIPE)
                           + BoltRadius(frameBolt)
                           + DEFAULT_WALL_FRAME;
function FrameMajorRodOffsetX() = BreechRearX()
                                - DEFAULT_OFFSET_FRAME_MAJOR;

// Shorthand: Measurements
function FrameMajorRodRadius(frameBolt=DEFAULT_FRAME_BOLT, clearance=false) = BoltRadius(frameBolt, clearance=clearance);
function FrameMajorRodDiameter(frameBolt=DEFAULT_FRAME_BOLT, clearance=false) = BoltDiameter(frameBolt, clearance=clearance);

module PositionedFiringPinAssembly(cutter=false, debug=false) {  
  translate([BreechRearX(),0,0])
  rotate([0,-90,0])
  rotate([0,0,90])
  FiringPinAssembly(cutter=cutter, debug=debug);
}

module Breech(debug=false, alpha=1) {
  color("LightSteelBlue", alpha)
  DebugHalf(enabled=debug)
  difference() {
    translate([BreechFrontX(),0,0])
    translate([-BreechPlateThickness(), -BreechPlateWidth()/2, -BreechPlateHeight()/2])
    cube([BreechPlateThickness(), BreechPlateWidth(), BreechPlateHeight()]);
    
    PositionedFiringPinAssembly(cutter=true);
    
    Frame(cutter=true);
  }
}

module Frame(pipe=DEFAULT_RECEIVER_PIPE,
              frame=DEFAULT_FRAME_BOLT,
              frameMinorBolt=DEFAULT_FRAME_MINOR_BOLT,
              length=DEFAULT_LENGTH_FRAME,
              majorTopCap=false,
              majorBottomCap=false,
              offsetMajor=DEFAULT_OFFSET_FRAME_MAJOR,
              offsetMinor=DEFAULT_OFFSET_FRAME_MINOR,
              wallLower=DEFAULT_WALL_LOWER, 
              frameWall=DEFAULT_WALL_FRAME,
              debug=false, cutter=false) {
  color("Silver")
  DebugHalf(enabled=debug) {
    translate([BreechRearX()-offsetMajor,0,0])
    translate([0,0,FrameMajorRodOffset()])
    rotate([0,-90,0])
    Bolt(bolt=frame, length=length, capOrientation=true, hex=true, cap=majorTopCap, clearance=cutter);
    
    translate([BreechRearX()-ManifoldGap(),0,0])
    translate([0,0,-FrameMajorRodOffset()])
    rotate([0,-90,0])
    Bolt(bolt=frame, length=length-offsetMajor, capOrientation=true, cap=majorBottomCap, clearance=cutter);
  }
  
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  translate([BreechFrontX()+ManifoldGap(),Y*PipeInnerRadius(pipe),-PipeInnerRadius(pipe)])
  rotate([0,-90,0])
  Bolt(bolt=frameMinorBolt,
       length=offsetMinor+BreechPlateThickness()+ManifoldGap(2),
       clearance=cutter);
}

module FrameAssembly(majorTopCap=false,
                     majorBottomCap=false,
                     offsetMinor=DEFAULT_OFFSET_FRAME_MINOR,
                     offsetMajor=DEFAULT_OFFSET_FRAME_MAJOR,
                     debug=false) {
  PositionedFiringPinAssembly();
  Frame(majorTopCap=majorTopCap, majorBottomCap=majorBottomCap,
        offsetMajor=offsetMajor, offsetMinor=offsetMinor, debug=debug);
  Breech(debug=debug);
}

FrameAssembly(debug=false);