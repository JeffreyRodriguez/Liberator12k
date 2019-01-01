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

use <Frame.scad>;

DEFAULT_WALL_LOWER = 0.25;
DEFAULT_WALL_FRAME = 0.1875;

DEFAULT_RECEIVER_PIPE = Spec_OnePointFiveSch40ABS();
DEFAULT_FRAME_BOLT    = Spec_BoltOneHalf();
DEFAULT_FRAME_MINOR_BOLT    = Spec_BoltM5();

DEFAULT_LENGTH_FRAME = 12;
DEFAULT_OFFSET_FRAME_MAJOR = 3;
DEFAULT_OFFSET_FRAME_MINOR = 2;

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

function BreechFrontX() = 0;
function BreechRearX()  = BreechFrontX()-BreechPlateThickness();


// Settings: Vitamins
function FrameMajorRod() = Spec_RodOneHalfInch();//Spec_RodFiveSixteenthInch();
function FrameMinorRod() = Spec_RodFiveSixteenthInch();

// Calculated: Positions
function FrameMajorRodOffset(frameBolt=DEFAULT_FRAME_BOLT,
                           receiverPipe=DEFAULT_RECEIVER_PIPE,
                           wallFrame=DEFAULT_WALL_FRAME)
                           = PipeOuterRadius(DEFAULT_RECEIVER_PIPE)
                           + BoltRadius(frameBolt)
                           + DEFAULT_WALL_FRAME;
function FrameMajorRodOffsetX() = BreechRearX()
                                - DEFAULT_OFFSET_FRAME_MAJOR;

module FrameMajorStandoff(pipe=DEFAULT_RECEIVER_PIPE,
                      frame=DEFAULT_FRAME_BOLT,
                      length=DEFAULT_OFFSET_FRAME_MAJOR,
                      wallLower=DEFAULT_WALL_LOWER, 
                      frameWall=DEFAULT_WALL_FRAME, debug=false) {
  color("OliveDrab")
  DebugHalf(enabled=debug)
  difference() {
    hull() {
      
      // Receiver Pipe
      translate([BreechRearX(),0,0])
      rotate([0,-90,0])
      Pipe(pipe=pipe,
           clearance=undef,
           length=length,
           hollow=false);
      
      // Frame Rod Standoffs
      translate([BreechRearX(),0,0])
      translate([0,0,FrameMajorRodOffset()])
      rotate([0,-90,0])
      cylinder(r=FrameMajorRodRadius()+frameWall, h=length, $fn=Resolution(10,30));
    }
    
    PipeLugCenter(pipe=pipe, wall=wallLower, cutter=true);
    
    Frame(offsetMajor=DEFAULT_OFFSET_FRAME_MAJOR, cutter=true);
      
    translate([BreechRearX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    Pipe(pipe=pipe,
         clearance=PipeClearanceSnug(),
         length=length+ManifoldGap(2),
         hollow=false);
  }
}

module FrameMinorStandoff(pipe=DEFAULT_RECEIVER_PIPE,
                      frame=DEFAULT_FRAME_BOLT,
                      length=DEFAULT_OFFSET_FRAME_MINOR,
                      wallLower=DEFAULT_WALL_LOWER, 
                      frameWall=DEFAULT_WALL_FRAME, debug=false, alpha=1) {
  length=2;
  color("Olive",alpha)
  DebugHalf(enabled=debug)
  difference() {
      
    // Pipe Lug Center
    translate([BreechRearX()-ManifoldGap(),-(2/2),LowerOffsetZ()])
    mirror([1,0,0])
    cube([length-ManifoldGap(2), 2, ReceiverCenter()-0.25]);
    
    translate([BreechRearX()-LowerMaxX(),0,0])
    PipeLugCenter(pipe=pipe, wall=wallLower, cutter=true);
    
    translate([BreechRearX(),0,0])
    Frame(cutter=true);
      
    translate([BreechRearX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    Pipe(pipe=pipe,
         clearance=PipeClearanceSnug(),
         length=length+ManifoldGap(2),
         hollow=false);
  }
}

module FramePipeStandoffs(debug=false) {
  FrameMajorStandoff(debug=debug);
  FrameMinorStandoff(debug=debug);
}

FramePipeStandoffs(debug=true);

module StandoffFrameAssembly(debug=true) {
  FrameAssembly(majorTopCap=true,
                offsetMinor=DEFAULT_OFFSET_FRAME_MINOR,
                offsetMajor=DEFAULT_OFFSET_FRAME_MAJOR,
                debug=debug);
}

translate([-LowerMaxX()-BreechPlateThickness(),0,0])
PipeLugAssembly(debug=true);

StandoffFrameAssembly();