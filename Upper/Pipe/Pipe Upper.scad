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
use <../../Components/Pipe/Frame.scad>;
use <../../Components/Pipe/Tailcap.scad>;
use <../../Components/Pipe/Buttstock.scad>;
use <../../Components/Pipe/Linear Hammer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

// Settings: Lengths
function FrameLength() = 10;

DEFAULT_LENGTH_FRAME_MAJOR_TOP = 8;
DEFAULT_LENGTH_FRAME_MAJOR_BOTTOM = 5;
DEFAULT_OFFSET_FRAME_MAJOR = 3;
DEFAULT_OFFSET_FRAME_MINOR = 1.125;

// Settings: Walls
function WallFrame() = 0.1875;

// Settings: Vitamins
function FrameMajorBolt() = Spec_BoltOneHalf();
function FrameMinorBolt() = Spec_BoltM5();
function FrameMajorRod() = Spec_RodOneHalfInch();//Spec_RodFiveSixteenthInch();
function FrameMinorRod() = Spec_RodFiveSixteenthInch();

function LowerX() = -LowerMaxX();
function FrameMajorRodOffset() = ReceiverOR()
                               + BoltRadius(FrameMajorBolt())
                               + WallFrame();
function FrameMajorRodOffsetX() = BreechRearX()
                                - DEFAULT_OFFSET_FRAME_MAJOR;

// Shorthand: Measurements
function FrameMajorWall() = WallFrame();
function FrameMajorRodRadius(frameBolt=FrameMajorBolt(), clearance=false) = BoltRadius(frameBolt, clearance=clearance);
function FrameMajorRodDiameter(frameBolt=FrameMajorBolt(), clearance=false) = BoltDiameter(frameBolt, clearance=clearance);

module PipeUpperAssembly(receiver=Spec_PipeThreeQuarterInch(),
                         receiverLength=ReceiverLength(),
                         pipeAlpha=1,
                         frame=true, stock=false, tailcap=false,
                         debug=true) {
                   
  translate([LowerX(),0,0]) {
    PipeLugAssembly(length=receiverLength,
                    stock=stock, tailcap=tailcap,
                    center=false,
                    debug=debug);
    
    if (frame) {
      FrameBolts();
      FrameBolts(flip=true);

      FrameAssembly();
    }
    
  }
               
  if (tailcap)
  translate([-ReceiverLength(),0,0])
  Tailcap();
  
  if (stock)
  translate([-12,0,0])
  Buttstock();
  
              
}

PipeUpperAssembly(receiverLength=12, stock=true, tailcap=false,
                  debug=true);