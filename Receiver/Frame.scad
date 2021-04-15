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

use <Receiver.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = "Receiver_Frame"; // ["Reciever_Frame"]

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_RODS = true;

_CUTAWAY_RECEIVER = false;

/* [Vitamins] */
FRAME_BOLT = "1/2\"-13"; // ["1/2\"-13"]
FRAME_BOLT_Y = 1.25;
FRAME_BOLT_Z = 0.875;


/* [Fine Tuning] */
FRAME_RECEIVER_LENGTH = 3;
FRAME_SPACER_LENGTH = 4.5;
FRAME_WALL = 0.18751;

/* [Branding] */
FRAME_BRANDING_TEXT = "#Liberator12k";

// Settings: Lengths
function FrameBoltLength() = 10;
function FrameBackLength() = 0.5;
function FrameReceiverLength() = FRAME_RECEIVER_LENGTH;
function LogoTextSize() = 11/32;
function LogoTextDepth() = 1/32;

// Settings: Walls
function WallFrameBolt() = FRAME_WALL;

// Settings: Vitamins
function FrameBolt() = BoltSpec(FRAME_BOLT);

// Shorthand: Measurements
function FrameBoltRadius(clearance=0)
    = BoltRadius(FrameBolt(), clearance);

function FrameBoltDiameter(clearance=0)
    = BoltDiameter(FrameBolt(), clearance);

// Settings: Positions
function FrameBoltY() = FRAME_BOLT_Y;
function FrameBoltZ() = FRAME_BOLT_Z;
function FrameWidth() = (FrameBoltY()
                       + FrameBoltRadius()
                       + WallFrameBolt()) * 2;
function FrameTopZ() = FrameBoltZ()
                     + FrameBoltRadius()
                     + WallFrameBolt();
function FrameBottomZ() = FrameBoltZ()
                        - FrameBoltRadius()
                        - WallFrameBolt();

function FrameExtension(length=FrameBoltLength()) = length
                                                  - FrameReceiverLength()
                                                  - NutHexHeight(FrameBolt());

// ************
// * Vitamins *
// ************
module FrameBoltIterator() {
    for (Y = [FrameBoltY(),-FrameBoltY()])
    translate([-FrameReceiverLength()-FrameBackLength()-ManifoldGap(),
               Y, FrameBoltZ()])
    rotate([0,-90,0])
    children();
}

module FrameBolts(length=FrameBoltLength(), debug=false, cutter=false, clearance=0.008, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha) RenderIf(!cutter)
  DebugHalf(enabled=debug) {
    FrameBoltIterator()
    NutAndBolt(bolt=FrameBolt(), boltLength=length,
         head=(cutter?"none":"hex"), nut=(cutter?"none":"hex"), clearance=clear,
         capOrientation=true);
  }
}

// **********
// * Shapes *
// **********
module FrameSupport(length=1, width=(FrameBoltY()+FrameBoltRadius()+WallFrameBolt())*2, height=(FrameBoltRadius()+WallFrameBolt())*2, extraBottom=0, $fn=Resolution(20,60)) {
  translate([0, -width/2, FrameBoltZ()-(height/2)-extraBottom])
  rotate([90,0,90])
  linear_extrude(height=length)
  ChamferedSquare(xy=[width,height+extraBottom], r=1/4,
                  teardropBottom=false,
                  teardropTop=false);
}

// ****************
// * Printed Parts*
// ****************
module FrameSpacer(length=FRAME_SPACER_LENGTH, debug=false, alpha=1) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    hull()
    FrameSupport(length=length);

    FrameBolts(cutter=true);
  }
}

module FrameSpacer_print() {
  rotate([0,-90,0]) translate([0,0,-FrameBoltZ()])
  FrameSpacer();
}

module Receiver_LargeFrame(doRender=true, debug=false) {
  
  topCoverHeight = 1;
  
  // Branding text
  color("DimGrey")
  RenderIf(doRender) DebugHalf(enabled=debug) {
      
    // Right-side text
    translate([-FrameReceiverLength()+0.0625,-FrameWidth()/2,FrameBoltZ()-(LogoTextSize()/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text("Liberator12k", size=LogoTextSize(), font="Impact");

    // Left-side text
    translate([-0.0625,FrameWidth()/2,FrameBoltZ()-(LogoTextSize()/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text("Liberator12k", size=LogoTextSize(), font="Impact");
  }
  
  color("Tan")
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    Receiver(doRender=false) {
      hull() {
        
        mirror([1,0,0])
        FrameSupport(length=FrameReceiverLength()+FrameBackLength());

        ReceiverTopSegment(length=FrameReceiverLength());
      }
    }
    
    ReceiverMlokSlot();
    ReceiverMlokBolts(cutter=true, teardrop=true);
    ReceiverTopSlot(length=ReceiverLength());
    
    FrameBolts(cutter=true);
  }
}

module Receiver_LargeFrame_print() {
  rotate([0,90,0])
  Receiver_LargeFrame();
}

// **************
// * Assemblies *
// **************
module Receiver_LargeFrameAssembly(length=FrameBoltLength(), frameBolts=true, debug=_CUTAWAY_RECEIVER, alpha=1) {
  Receiver_LargeFrame(debug=debug);
  
  if (frameBolts)
  FrameBolts(length=length, debug=debug, alpha=alpha);
}

if ($preview) {
  
  if (_SHOW_RECEIVER_RODS)
  TensionBolts();

  if (_SHOW_RECEIVER) {
    Receiver_LargeFrameAssembly();
    ReceiverMlokBolts();
  }
} else {
  scale(25.4)
  Receiver_LargeFrame_print();
}