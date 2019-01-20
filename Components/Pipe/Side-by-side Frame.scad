include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;


DEFAULT_WALL_LOWER = 0.25;
DEFAULT_WALL_FRAME = 0.1875;

DEFAULT_RECEIVER_PIPE = Spec_OnePointFiveSch40ABS();
DEFAULT_FRAME_BOLT    = Spec_BoltOneHalf();

DEFAULT_LENGTH_FRAME = 12;
DEFAULT_LENGTH_FRAME_STANDOFFS = abs(ReceiverLugRearMaxX())+LowerMaxX();

// Settings: Vitamins
function FrameRod() = Spec_RodOneHalfInch();//Spec_RodFiveSixteenthInch();

// Calculated: Positions
function FrameRodOffsetY(frameBolt=DEFAULT_FRAME_BOLT) = PipeOuterRadius(DEFAULT_RECEIVER_PIPE)
                                                       + BoltRadius(frameBolt)
                                                       + DEFAULT_WALL_FRAME;
function FrameRodOffsetX() = LowerMaxX()
                           - DEFAULT_LENGTH_FRAME_STANDOFFS
                           - BoltNutHeight(DEFAULT_FRAME_BOLT);

// Shorthand: Measurements
function FrameRodRadius(frameBolt=DEFAULT_FRAME_BOLT, clearance=false) = BoltRadius(frameBolt, clearance=clearance);
function FrameRodDiameter(frameBolt=DEFAULT_FRAME_BOLT, clearance=false) = BoltDiameter(frameBolt, clearance=clearance);

module FrameIterator(pipe=DEFAULT_RECEIVER_PIPE,
              frame=DEFAULT_FRAME_BOLT, wallLower=DEFAULT_WALL_LOWER) {
  for (Y = [-1,1])
  translate([0,0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)])
  rotate([-0*Y,0,0])
  translate([0,FrameRodOffsetY()*Y,0])
  children();
}

module Frame(pipe=DEFAULT_RECEIVER_PIPE,
              frame=DEFAULT_FRAME_BOLT,
              length=DEFAULT_LENGTH_FRAME,
              wallLower=DEFAULT_WALL_LOWER, 
              frameWall=DEFAULT_WALL_FRAME,
              debug=false, cutter=false) {
  color("Silver")
  DebugHalf(enabled=debug)
  translate([FrameRodOffsetX(),0,0])
  FrameIterator()
  rotate([0,90,0])
  Bolt(bolt=frame, length=length, cap=false, clearance=false);
}

module FrameStandoffs(pipe=DEFAULT_RECEIVER_PIPE,
                      frame=DEFAULT_FRAME_BOLT,
                      length=DEFAULT_LENGTH_FRAME_STANDOFFS,
                      wallLower=DEFAULT_WALL_LOWER, 
                      frameWall=DEFAULT_WALL_FRAME, debug=false) {
  color("LightGrey")
  DebugHalf(enabled=debug)
  difference() {
    hull() {
      
      // Pipe Lug Center
      translate([LowerMaxX()-ManifoldGap(),-(1.25/2)-0.0625,0])
      mirror([1,0,0])
      cube([length-ManifoldGap(2), 1.25+0.125, ManifoldGap()]);
      
      // Receiver Pipe
      translate([LowerMaxX(),0,PipeLugPipeOffsetZ(pipe=pipe, wall=wallLower)])
      rotate([0,-90,0])
      Pipe(pipe=pipe,
           clearance=undef,
           length=length,
           hollow=false);
      
      // Frame Rod Standoffs
      translate([LowerMaxX(),0,0])
      FrameIterator(pipe=pipe, frame=frame)
      rotate([0,-90,0])
      cylinder(r=FrameRodRadius()+frameWall, h=length, $fn=Resolution(10,30));
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

Frame();
FrameStandoffs();

PipeLugFront(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER);
PipeLugRear(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER);
PipeLugCenter(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER);
PipeLugPipe(pipe=DEFAULT_RECEIVER_PIPE, wall=DEFAULT_WALL_LOWER, cutter=false);

Lower(showTrigger=true,alpha=1,
      searLength=SearLength()+DEFAULT_WALL_LOWER+PipeWall(DEFAULT_RECEIVER_PIPE)+0.25);

*!scale(25.4)
PipeLugPlater(front=true, rear=true, center=true);
