include <../../Meta/Common.scad>;

use <../../Meta/Math/Circles.scad>;
use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Components/Pump Grip.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = ""; // ["Prints/Sightpost"]

/* [Assembly] */
_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_VERTICAL_GRIP = true;
_SHOW_VERTICAL_GRIP_HARDWARE = true;

/* [Transparency] */
_ALPHA_VERTICAL_GRIP = 1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_VERTICAL_GRIP = false;

/* [Vitamins] */
GRIP_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"]
GRIP_BOLT_CLEARANCE = -0.05;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Settings: Vitamins
function VerticalGripBolt() = BoltSpec(GRIP_BOLT);
assert(VerticalGripBolt(), "VerticalGripBolt() is undefined. Unknown GRIP_BOLT?");
function VerticalGripPinRadius() = Millimeters(2.5/2);
function VerticalGripRadius() = 0.625;

module VerticalGripBolt(bolt=VerticalGripBolt(), headType="flat", nutType="heatset", length=3.5, cutter=false, clearance=0.005, teardrop=true) {
  translate([0,0,-length])
  mirror([0,0,1])
  NutAndBolt(bolt=bolt, boltLength=length+ManifoldGap(2),
             capOrientation=true,
             head=headType, capHeightExtra=(cutter?1:0),
             nut=nutType, nutHeightExtra=(cutter?0.5:0),
             teardrop=cutter && teardrop, teardropAngle=180,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}

module VerticalGripPin(r=VerticalGripPinRadius(), length=Inches(0.5), cutter=false, clearance=0.005, teardrop=true) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter)
  translate([Inches(0.375),0,-length])
  mirror([0,0,1])
  cylinder(r=r+clear, h=length);
}

module VerticalGripSupport(lowerExtension = Inches(0.75), forwardExtension=VerticalGripRadius()) {
  CR=1/16;

  hull() {

    // Lower vertical extension
    translate([0,0,-lowerExtension])
    ChamferedCylinder(r1=VerticalGripRadius()+CR, r2=CR,
                       h=lowerExtension);

    // Flat front for lower extension (printability)
    translate([0,-(VerticalGripRadius()+CR)*(0.705/2),-lowerExtension/2])
    ChamferedCube([max(VerticalGripRadius()+CR+(lowerExtension*0.705), forwardExtension), (VerticalGripRadius()+CR)*0.705, lowerExtension/2], r=0.125,
                  teardropFlip=[false,true,true]);
  }
}


module VerticalGrip(cutaway=false, alpha=1) {
  CR = 1/16;

  color("Tan", alpha) render()
  difference() {
    translate([0,0,-0.75])
    mirror([0,0,1])
    rotate(360/6/2)
    PumpGrip(r=VerticalGripRadius(), h=3, channelRadius=0.125);

    VerticalGripBolt(cutter=true, teardrop=false);
    VerticalGripPin(cutter=true, teardrop=false);
  }
}

ScaleToMillimeters()
if ($preview) {

  if (_SHOW_HARDWARE && _SHOW_VERTICAL_GRIP_HARDWARE) {
    VerticalGripBolt();
    VerticalGripPin();
  }

  if (_SHOW_PRINTS && _SHOW_VERTICAL_GRIP)
  VerticalGrip(cutaway=_CUTAWAY_VERTICAL_GRIP, alpha=_ALPHA_VERTICAL_GRIP);

  color("Purple", 0.5) render()
  VerticalGripSupport();
} else {
  if (_RENDER == "Prints/VerticalGrip")
    if (!_RENDER_PRINT)
      VerticalGrip();
    else
      mirror([0,0,1])
      translate([0,0,0.75])
      VerticalGrip();
}
