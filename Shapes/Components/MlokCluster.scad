use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32"]

function MlokClusterLength() = 1.375;

module MlokClusterBolts(innerRadius=1.35/2, boltSpec=BoltSpec(MLOK_BOLT), headType="none", nutType="heatset", length=0.5, cutter=false, clearance=0.005, teardrop=false) {
  
  assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");
  
  color("Silver") RenderIf(!cutter)
  for (Z = [-UnitsMetric(10),UnitsMetric(10)])
  translate([0,-innerRadius,MlokClusterLength()/2-Z])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec,
             boltLength=0.75+ManifoldGap(2),
             head=headType,
             nut=nutType, nutHeightExtra=(cutter?innerRadius:0),
             teardrop=cutter&&teardrop, teardropAngle=90,
             clearance=cutter?clearance:0);
}

module MlokCluster(boltSpec=BoltSpec(MLOK_BOLT),
                  innerRadius=1.35/2, width=0.75,
                  wall=0.1875, extension=0.375+(3/32),
                  length=MlokClusterLength(),
                  debug=false, doRender=false,
                  alpha=1, $fn=Resolution(20,100)) {

assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");

  color("Tan", alpha)
  RenderIf(doRender)
  difference() {
    hull() {
      ChamferedCylinder(r1=innerRadius+wall, r2=1/16, h=length);
    
      for (R = [0,90,-90,180]) rotate(R)  
      translate([-width/2,-innerRadius-extension,0])
      ChamferedCube([width, extension, length], r=1/16);
    }
    
    ChamferedCircularHole(r1=innerRadius, r2=1/16, h=length);
    
    for (R = [0,90,-90,180]) rotate(R)
    MlokClusterBolts(innerRadius=innerRadius, cutter=true, teardrop=true);
    
    // Slot
    mlokSlotWidth = UnitsMetric(7)+0.005;
    mlokSlotDepth = 0.0625;
    for (R = [0,-90,90,180]) rotate(R)
    translate([-(mlokSlotWidth/2), -innerRadius-extension, 0])
    cube([mlokSlotWidth, mlokSlotDepth, length]);
  }
}
if ($preview) {
  MlokClusterBolts();

  MlokCluster(doRender=true, debug=false);
} else {
  
  MlokCluster(doRender=true, debug=false);
}