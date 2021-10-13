include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Math/Circles.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

use <../Receiver.scad>;
/* [What to Render] */

// Assembly is not for printing.
_RENDER = ""; // ["Sightpost"]

// Cut assembly view in half
_CUTAWAY_ASSEMBLY = false;

SIGHTPOST_DIAMETER = 1.0001;
SIGHTPOST_CLEARANCE = 0.005;

// Set Screw and Sight Bead
SIGHTPOST_BOLT = "#8-32";   // ["M4", "#8-32"]
SIGHTPOST_BOLT_CLEARANCE = 0.005;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function SightpostBolt() = BoltSpec(SIGHTPOST_BOLT);
assert(SightpostBolt(), "SightpostBolt() is undefined. Unknown SIGHTPOST_BOLT?");

function SightZ() = ReceiverTopZ()+0.5;

module SightpostBolts(height=SightZ(), radius=SIGHTPOST_DIAMETER/2, length=2, cutter=false, clearance=SIGHTPOST_BOLT_CLEARANCE) {
  
  // Bead
  translate([radius,0,0.1875])
  rotate([0,90,0])
  NutAndBolt(bolt=SightpostBolt(),
             boltLength=height-radius+ManifoldGap(2),
             head="socket",
             nut="heatset-long",  nutBackset=0.5, nutHeightExtra=(cutter?radius+0.5:0),
             teardrop=cutter, teardropAngle=180,
             clearance=cutter?-clearance:0,
             doRender=!cutter);
  
  // Set Screw
  translate([radius,0,length-0.5])
  rotate([0,90,0])
  NutAndBolt(bolt=SightpostBolt(),
             boltLength=0.5+ManifoldGap(2),
             head="none",
             nut="heatset", nutHeightExtra=(cutter?radius:0),
             teardrop=cutter, teardropAngle=180,
             clearance=cutter?clearance:0,
             doRender=!cutter);
}

module Sightpost(height=SightZ(), length=2, radius=SIGHTPOST_DIAMETER/2, wall=0.125, clearance=SIGHTPOST_CLEARANCE, doRender=true) {
  CR=1/16;
  
  color("Tan") RenderIf(doRender)
  difference() {
    union() {
      ChamferedCylinder(r1=radius+wall, r2=CR,
                        h=length, $fn=Resolution(40,80));
      
      translate([0,-0.375/2,0])
      ChamferedCube([radius+0.5, 0.375, length], r=CR);
      
      hull() {
        translate([0,-0.375/2,0])
        ChamferedCube([height, 0.375, 0.375], r=CR);
        
        ChamferedCylinder(r1=0.375, r2=CR,
                          h=length, $fn=Resolution(40,80));
      }
    }
    
    ChamferedCircularHole(h=length, r1=radius+clearance, r2=CR);
    
    SightpostBolts(height=height, radius=radius, length=length, cutter=true);
  }
}

scale(25.4)
if ($preview) {
  Sightpost();
  SightpostBolts();
} else {
  Sightpost();
}