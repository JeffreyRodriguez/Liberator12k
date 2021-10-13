use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32"]
function MlokForegripLength() = 2.5;
function MlokForegripBoltLength() = 1.5;
function MlokForegripBoltExtension() = 0.375+(1/16);

module MlokForegripBolts(boltSpec=BoltSpec(MLOK_BOLT), headType="flat", nutType="none", length=MlokForegripBoltLength(), cutter=false, clearance=0.005, teardrop=false) {
  
  assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");
  
  color("Silver") RenderIf(!cutter)
  for (Y = [-UnitsMetric(10),UnitsMetric(10)])
  translate([0,Y,MlokForegripLength()+MlokForegripBoltExtension()])
  mirror([0,0,1])
  NutAndBolt(bolt=boltSpec,
             boltLength=length+ManifoldGap(2),
             head=headType, capHeightExtra=(cutter?MlokForegripLength():0),
             nut=nutType, nutHeightExtra=(cutter?0.25:0),
             teardrop=cutter&&teardrop, teardropAngle=90,
             clearance=cutter?clearance:0);
}

module MlokForegrip(boltSpec=BoltSpec(MLOK_BOLT),
                  length=MlokForegripLength(),
                  debug=false,
                  alpha=1, $fn=Resolution(20,100)) {

assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");

  color("Tan", alpha) render()
  difference() {
    union() {
      
      hull()
      for (Y = [1,-1]) translate([0,Y*UnitsMetric(10),0])
      ChamferedCylinder(r1=0.5, r2=1/8, h=length);
    
      translate([-0.125,-UnitsMetric(10)-0.1875,0])
      ChamferedCube([0.25, UnitsMetric(20)+0.375, length+(1/16)], r=1/32);
    }
    
    MlokForegripBolts(cutter=true);
  }
}

scale(25.4)
if ($preview) {
  MlokForegripBolts();

  MlokForegrip(debug=false);
} else {
  
  MlokForegrip(debug=false);
}