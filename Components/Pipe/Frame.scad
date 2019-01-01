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
DEFAULT_LENGTH_FRAME_STANDOFFS = 3;
DEFAULT_LENGTH_FRAME_MINOR = 2;

// Measured: Vitamins
function BreechPlateThickness() = 3/8;
function BreechPlateWidth() = 2;

function BreechPlateHeight(frameBolt=DEFAULT_FRAME_BOLT,
                           receiverPipe=DEFAULT_RECEIVER_PIPE,
                           wallFrame=DEFAULT_WALL_FRAME)
                           = PipeOuterDiameter(receiverPipe)
                           + (2*FrameMajorRodDiameter(frameBolt=frameBolt, wall=wallFrame))
                           + (4*wallFrame);
echo("BreechPlateHeight(): ", BreechPlateHeight());

function BreechFrontX() = LowerMaxX()+BreechPlateThickness();
function BreechRearX()  = BreechFrontX()-BreechPlateThickness();


// Settings: Vitamins
function FrameMajorRod() = Spec_RodOneHalfInch();//Spec_RodFiveSixteenthInch();
function FrameMinorRod() = Spec_RodFiveSixteenthInch();

// Calculated: Positions
function ReceiverCenter(receiverPipe=DEFAULT_RECEIVER_PIPE, wallLower=DEFAULT_WALL_LOWER) = PipeOuterRadius(receiverPipe)+wallLower;
function FrameMajorRodOffset(frameBolt=DEFAULT_FRAME_BOLT,
                           receiverPipe=DEFAULT_RECEIVER_PIPE,
                           wallFrame=DEFAULT_WALL_FRAME)
                           = PipeOuterRadius(DEFAULT_RECEIVER_PIPE)
                           + BoltRadius(frameBolt)
                           + DEFAULT_WALL_FRAME;
function FrameMajorRodOffsetX() = LowerMaxX()
                           - DEFAULT_LENGTH_FRAME_STANDOFFS;

// Shorthand: Measurements
function FrameMajorRodRadius(frameBolt=DEFAULT_FRAME_BOLT, clearance=false) = BoltRadius(frameBolt, clearance=clearance);
function FrameMajorRodDiameter(frameBolt=DEFAULT_FRAME_BOLT, clearance=false) = BoltDiameter(frameBolt, clearance=clearance);

module PositionedFiringPinAssembly(cutter=false, debug=false) {  
  translate([BreechRearX(),0,ReceiverCenter()])
  rotate([0,-90,0])
  rotate([0,0,90])
  FiringPinAssembly(cutter=cutter, debug=debug);
}

module Breech(debug=false, alpha=1) {
  color("LightSteelBlue", alpha)
  DebugHalf(enabled=debug)
  difference() {
    translate([BreechFrontX(),0,ReceiverCenter()])
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
              lengthStandoff=DEFAULT_LENGTH_FRAME_STANDOFFS,
              lengthMinorStandoff=DEFAULT_LENGTH_FRAME_MINOR,
              wallLower=DEFAULT_WALL_LOWER, 
              frameWall=DEFAULT_WALL_FRAME,
              debug=false, cutter=false) {
  color("Silver")
  DebugHalf(enabled=debug) {
    translate([FrameMajorRodOffsetX(),0,0])
    translate([0,0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)+FrameMajorRodOffset()])
    rotate([0,-90,0])
    Bolt(bolt=frame, length=length, capOrientation=true, hex=true, clearance=cutter);
    
    translate([BreechRearX()-ManifoldGap(),0,0])
    translate([0,0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)-FrameMajorRodOffset()])
    rotate([0,90,0])
    Bolt(bolt=frame, length=length-lengthStandoff-0.5, cap=false, clearance=cutter);
  }
  
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  translate([BreechRearX()-lengthMinorStandoff-ManifoldGap(),Y*PipeInnerRadius(pipe),wallLower])
  rotate([0,-90,0])
  Bolt(bolt=frameMinorBolt,
       length=lengthMinorStandoff+BreechPlateThickness()+ManifoldGap(2),
       capOrientation=true, hex=true, clearance=cutter);
}

module FrameMajorStandoff(pipe=DEFAULT_RECEIVER_PIPE,
                      frame=DEFAULT_FRAME_BOLT,
                      length=DEFAULT_LENGTH_FRAME_STANDOFFS,
                      wallLower=DEFAULT_WALL_LOWER, 
                      frameWall=DEFAULT_WALL_FRAME, debug=false) {
  color("OliveDrab")
  DebugHalf(enabled=debug)
  difference() {
    hull() {
      
      // Receiver Pipe
      translate([BreechRearX(),0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)])
      rotate([0,-90,0])
      Pipe(pipe=pipe,
           clearance=undef,
           length=length,
           hollow=false);
      
      // Frame Rod Standoffs
      translate([BreechRearX(),0,0])
      translate([0,0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)+FrameMajorRodOffset()])
      rotate([0,-90,0])
      cylinder(r=FrameMajorRodRadius()+frameWall, h=length, $fn=Resolution(10,30));
    }
    
    PipeLugCenter(pipe=pipe, wall=wallLower, cutter=true);
    
    Frame(cutter=true);
      
    translate([BreechRearX()+ManifoldGap(),0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)])
    rotate([0,-90,0])
    Pipe(pipe=pipe,
         clearance=PipeClearanceSnug(),
         length=length+ManifoldGap(2),
         hollow=false);
  }
}

module FrameMinorStandoff(pipe=DEFAULT_RECEIVER_PIPE,
                      frame=DEFAULT_FRAME_BOLT,
                      length=DEFAULT_LENGTH_FRAME_MINOR,
                      wallLower=DEFAULT_WALL_LOWER, 
                      frameWall=DEFAULT_WALL_FRAME, debug=false, alpha=1) {
length=2;
  color("Olive",alpha)
  DebugHalf(enabled=debug)
  difference() {
    hull() {
      
      // Pipe Lug Center
      translate([LowerMaxX()-ManifoldGap(),-(2/2),0])
      mirror([1,0,0])
      cube([length-ManifoldGap(2), 2, ReceiverCenter()-0.25]);
    }
    
    PipeLugCenter(pipe=pipe, wall=wallLower, cutter=true);
    
    Frame(cutter=true);
      
    translate([LowerMaxX()+ManifoldGap(),0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)])
    rotate([0,-90,0])
    Pipe(pipe=pipe,
         clearance=PipeClearanceSnug(),
         length=length+ManifoldGap(2),
         hollow=false);
  }
}

PositionedFiringPinAssembly();
Frame();
FrameMajorStandoff(debug=true);
FrameMinorStandoff();
Breech(debug=true);


PipeLugFront(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER);
PipeLugRear(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER);
PipeLugCenter(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER);
PipeLugPipe(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER, cutter=false);

Lower(showTrigger=true,alpha=1,
      searLength=SearLength()+DEFAULT_WALL_LOWER+PipeWall(DEFAULT_RECEIVER_PIPE)+0.25);

*!scale(25.4)
PipeLugPlater(front=true, rear=true, center=true);
