use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/FlipMirror.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <Receiver.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = "Frame_Receiver"; // ["Frame_Receiver"]

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_RODS = true;

_CUTAWAY_RECEIVER = false;

_ALPHA_FRAME = 1;  // [0:0.1:1]

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
    for (M = [0,1]) mirror([0,M,0])
    translate([-FrameReceiverLength()-FrameBackLength()-ManifoldGap(),
               FrameBoltY(), FrameBoltZ()])
    rotate([0,-90,0])
    children();
}

module FrameBolts(length=FrameBoltLength(), debug=false, cutter=false, clearance=0.008, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha) RenderIf(!cutter)
  DebugHalf(enabled=debug) {
    translate([0.25,0,0])
    FrameBoltIterator()
    rotate(-11)
    NutAndBolt(bolt=FrameBolt(), boltLength=length,
         head="hex", capHeightExtra=(cutter?FrameBackLength()*2:0),
         nut=(cutter?"none":"hex"), clearance=clear,
         capOrientation=true);
  }
}

// **********
// * Shapes *
// **********
module FrameSupport(length=1, extraBottom=0, chamferFront=false, chamferBack=false, chamferRadius=1/16, , teardropFront=false, teardropBack=false, $fn=Resolution(20,60)) {
  cr = 1/4;
  height = (FrameBoltRadius()+WallFrameBolt())*2;
  width=(FrameBoltY()+FrameBoltRadius()+WallFrameBolt())*2;
  
  translate([0,0,FrameBoltZ()])  
  hull() {
    for (M = [0,1]) mirror([0,M,0]) {
      translate([0,(width/2)-cr,(FrameBoltRadius()+WallFrameBolt())-cr])
      rotate([0,90,0])
      ChamferedCylinder(h=length, r1=cr, r2=chamferRadius,
                        chamferBottom=chamferFront, teardropBottom=teardropFront,
                        chamferTop=chamferBack,     teardropTop=teardropBack);
      
      translate([0,(width/2)-cr,cr-(FrameBoltRadius()+WallFrameBolt())-extraBottom])
      rotate([0,90,0])
      ChamferedCylinder(h=length, r1=cr, r2=chamferRadius,
                        chamferBottom=chamferFront, teardropBottom=teardropFront,
                        chamferTop=chamferBack,     teardropTop=teardropBack);
    }
  }
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

module Receiver_LargeFrame(doRender=true, debug=false, alpha=1) {
  
  topCoverHeight = 1;
  
  // Branding text
  color("DimGrey")
  RenderIf(doRender) DebugHalf(enabled=debug)
  FlipMirror([-FrameReceiverLength()/2, (FrameWidth()/2), FrameBoltZ()])
  rotate([90,0,0])
  linear_extrude(height=LogoTextDepth(), center=true)
  text(FRAME_BRANDING_TEXT, size=LogoTextSize(), font="Impact", halign="center", valign="center");
  
  color("Tan", alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    Receiver(doRender=false) {
      hull() {
        
        mirror([1,0,0])
        FrameSupport(length=FrameReceiverLength()+FrameBackLength(),
                     chamferFront=true, teardropFront=true,
                     chamferBack=true);

        ReceiverTopSegment(length=FrameReceiverLength());
      }
      
      // Bolt head support
      hull() {
        FrameBoltIterator()
        mirror([0,0,1])
        ChamferedCylinder(r1=0.5+(1/32), r2=1/16,
                          h=0.3125, $fn=50,
                          teardropBottom=false);
    
        translate([-FrameReceiverLength()+0.125,0,0])
        mirror([1,0,0])
        FrameSupport(length=FrameBackLength()+0.125,
                     chamferFront=true, 
                     chamferBack=true);
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
  
  if (frameBolts)
  FrameBolts(length=length, debug=debug, alpha=alpha);
  
  Receiver_LargeFrame(debug=debug, alpha=_ALPHA_FRAME);
}

scale(25.4)
if ($preview) {
  
  if (_SHOW_RECEIVER_RODS)
  TensionBolts();

  if (_SHOW_RECEIVER) {
    Receiver_LargeFrameAssembly();
    ReceiverMlokBolts();
  }
} else {
  Receiver_LargeFrame_print();
}