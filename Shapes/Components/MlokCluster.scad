use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../Chamfer.scad>;
use <../MLOK.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "ReceiverFront", "Forend", "BarrelCollar", "Extractor", "Latch", "LatchTab", "Foregrip", "BarrelSleeveFixture"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_CLUSTER = true;
_SHOW_BOLTS = true;

/* [Transparency] */
_ALPHA_CLUSTER = 1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_CLUSTER = false;

/* [Vitamins] */
BARREL_DIAMETER = 1.35;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32"]


function BarrelRadius() = BARREL_DIAMETER/2;

function MlokClusterLength() = 2;

module MlokClusterBolts(radius=BarrelRadius(), boltSpec=BoltSpec(MLOK_BOLT), headType="none", nutType="none", length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  
  assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");
  
  color("Silver") RenderIf(!cutter)
  for (Z = [-UnitsMetric(10),UnitsMetric(10)])
  translate([radius,0,MlokClusterLength()/2-Z])
  rotate([0,90,0])
  NutAndBolt(bolt=boltSpec,
             boltLength=0.75+ManifoldGap(2),
             head=headType,
             nut=nutType,
             teardrop=cutter&&teardrop, teardropAngle=90,
             clearance=cutter?clearance:0);
}

module MlokCluster(boltSpec=BoltSpec(MLOK_BOLT),
                  radius=BarrelRadius(), width=0.75,
                  wall=0.1875, extension=0.25,
                  length=MlokClusterLength(),
                  slots=[0,-90,90,180],
                  cutaway=false,
                  alpha=1, $fn=Resolution(20,100)) {

assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");

  color("Tan", alpha) render()
  difference() {
    hull() {
      ChamferedCylinder(r1=radius+wall, r2=1/16, h=length);
    
      for (R = [0,90,-90,180]) rotate(R)  
      translate([-width/2,-radius-extension,0])
      ChamferedCube([width, extension, length], r=1/16);
    }
    
    ChamferedCircularHole(r1=radius, r2=1/16, h=length);
    
    //for (R = [0,90,-90,180]) rotate(R)
    MlokClusterBolts(radius=radius, cutter=true, teardrop=true);
    
    // Slot
    for (R = slots) rotate(R)
    translate([0, -radius-extension, 0.25])
    rotate([0,-90,0])
    rotate([90,0,0]) {
      MlokSlot(length-0.5);
      MlokSlotBack(length-0.5);
    }
  }
}
if ($preview) {

  if (_SHOW_CLUSTER)
  MlokCluster(alpha=_ALPHA_CLUSTER, cutaway=_CUTAWAY_CLUSTER);
} else {
  
  MlokCluster(cutaway=false);
}