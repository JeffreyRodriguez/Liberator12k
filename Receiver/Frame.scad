use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/FlipMirror.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <Receiver.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Frame_Receiver"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_RODS = true;

_CUTAWAY_RECEIVER = false;

_ALPHA_FRAME = 1;  // [0:0.1:1]

/* [Vitamins] */
FRAME_BOLT = "1/2\"-13"; // ["1/2\"-13", "M12"]


/* [Fine Tuning] */
FRAME_BOLT_Y = 1.25;
FRAME_BOLT_Z = 0.875;
FRAME_RECEIVER_LENGTH = 3;
FRAME_SPACER_LENGTH = 4.5;
FRAME_WALL = 0.18751;
CHAMFER_RADIUS = 0.0625;

/* [Branding] */
FRAME_BRANDING_TEXT = "#Liberator12k";

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Settings: Lengths
function FrameBoltLength() = 10;
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
module Frame_BoltIterator() {
    for (M = [0,1]) mirror([0,M,0])
    translate([0, FrameBoltY(), FrameBoltZ()])
    children();
}

module Frame_Bolts(length=FrameBoltLength(), nut="hex", cutaway=false, cutter=false, clearance=0.01, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha) RenderIf(!cutter)
  Cutaway(cutaway) {
    translate([-FrameReceiverLength()-ManifoldGap(),0,0])
    Frame_BoltIterator()
    rotate([0,-90,0])
    rotate(-11)
    NutAndBolt(bolt=FrameBolt(), boltLength=length,
         head="hex",
         nut=nut, clearance=clear,
         capOrientation=true);
  }
}

// **********
// * Shapes *
// **********
module Frame_Support(length=1, extraBottom=0, chamferFront=false, chamferBack=false, chamferRadius=CHAMFER_RADIUS, , teardropFront=false, teardropBack=false) {
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

module Frame_Receiver_Segment(length=1, highTop=false, chamferFront=true, chamferBack=true, teardropFront=true, teardropBack=true) {
  union() {
    
    if (highTop)
    hull() {
      mirror([1,0,0])
      ReceiverTopSegment(length=length, chamferFront=chamferFront);
      
      Frame_Support(length=length,
                   chamferFront=chamferFront, teardropFront=teardropFront,
                   chamferBack=chamferBack, teardropBack=teardropBack);
    }
    
    Frame_Support(length=length,
                 chamferFront=chamferFront, teardropFront=teardropFront,
                 chamferBack=chamferBack, teardropBack=teardropBack);
    
    mirror([1,0,0])
    Receiver_Segment(length=length, highTop=highTop,
                    chamferFront=chamferFront,
                    chamferBack=chamferBack);
    
    // Fillet receiver-to-frame joint
    for (M = [0, 1]) mirror([0,M,0])
    translate([length,ReceiverOR(),FrameBottomZ()])
    rotate([0,-90,0])
    Fillet(h=length,
           r=FrameBottomZ(), r2=CHAMFER_RADIUS,
           chamferBottom=chamferBack, chamferTop=chamferFront,
           teardropBottom=teardropBack, teardropTop=teardropFront,
           inset=true);
  }
}

// ****************
// * Printed Parts*
// ****************
module Frame_Spacer(length=FRAME_SPACER_LENGTH, cutaway=false, alpha=1) {
  color("Tan", alpha)
  Cutaway(cutaway) render()
  difference() {
    hull()
    Frame_Support(length=length);

    Frame_Bolts(cutter=true);
  }
}

module Frame_Spacer_print() {
  rotate([0,-90,0]) translate([0,0,-FrameBoltZ()])
  Frame_Spacer();
}

module Frame_Receiver(doRender=true, cutaway=false, alpha=1) {
  
  topCoverHeight = 1;
  
  // Branding text
  color("DimGrey")
  RenderIf(doRender) Cutaway(cutaway)
  FlipMirror([-FrameReceiverLength()/2, (FrameWidth()/2), FrameBoltZ()])
  rotate([90,0,0])
  linear_extrude(height=LogoTextDepth(), center=true)
  text(FRAME_BRANDING_TEXT, size=LogoTextSize(), font="Impact", halign="center", valign="center");
  
  color("Tan", alpha)
  RenderIf(doRender) Cutaway(cutaway)
  difference() {
    Receiver(doRender=false) {
      
      mirror([1,0,0])
      Frame_Receiver_Segment(FrameReceiverLength(), teardropFront=true);
      
      hull() {
        mirror([1,0,0])
        Frame_Support(FrameReceiverLength(),
        chamferBack=true, chamferFront=true);

        ReceiverTopSegment(length=FrameReceiverLength());
      }
      
      // Bolt head support
      hull() {
        translate([-FrameReceiverLength(),0,0])
        Frame_BoltIterator()
        rotate([0,-90,0])
        ChamferedCylinder(r1=0.5+(1/16), r2=CHAMFER_RADIUS,
                          h=0.3125,
                          teardropBottom=false);
    
        translate([-FrameReceiverLength(),0,0])
        Frame_Support(length=0.1875,
                     chamferFront=false, 
                     chamferBack=false);
        
        translate([-FrameReceiverLength()-0.3125,0,0])
        mirror([1,0,0])
        ReceiverTopSegment(length=0.5);
      }
  }
    
    ReceiverMlokSlot();
    Receiver_MlokBolts(cutter=true, teardrop=true);
    ReceiverTopSlot(length=ReceiverLength());
    
    Frame_Bolts(cutter=true);
  }
}

// **************
// * Assemblies *
// **************
module Frame_ReceiverAssembly(length=FrameBoltLength(), frameBolts=true, cutaway=_CUTAWAY_RECEIVER, alpha=1) {
  
  if (frameBolts)
  Frame_Bolts(length=length, cutaway=cutaway, alpha=alpha);
  
  Frame_Receiver(cutaway=cutaway, alpha=_ALPHA_FRAME);
}

scale(25.4)
if ($preview) {
  
  if (_SHOW_RECEIVER_RODS)
  Receiver_TensionBolts();

  if (_SHOW_RECEIVER) {
    Frame_ReceiverAssembly();
    Receiver_MlokBolts();
  }
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Frame_Receiver")
    if (!_RENDER_PRINT)
      Frame_Receiver();
    else
      rotate([0,90,0])
      Frame_Receiver(doRender=false);
      
  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Frame_Bolts")
  Frame_Bolts();
}