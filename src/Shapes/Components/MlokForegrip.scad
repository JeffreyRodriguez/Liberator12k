include <../../Meta/Common.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Chamfer.scad>;

// Picatinny rail mounts on top of receiver w/ M-LOK
MLOK_BOLT           = "#8-32";   // ["M4", "#8-32"]


// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function MlokForegripLength() = 2.5;
function MlokForegripBoltLength() = 1.5;
function MlokForegripBoltExtension() = 0.375+(1/16);

module MlokForegripBolts(boltSpec=BoltSpec(MLOK_BOLT), headType="flat", nutType="none", length=MlokForegripBoltLength(), cutter=false, clearance=0.005, teardrop=false) {

  assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");

  color("Silver") RenderIf(!cutter)
  for (Y = [-Millimeters(10),Millimeters(10)])
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
                  cutaway=false,
                  alpha=1) {

assert(boltSpec, "boltSpec is undefined. Unknown MLOK_BOLT?");

  color("Tan", alpha) render()
  difference() {
    union() {

      hull()
      for (Y = [1,-1]) translate([0,Y*Millimeters(10),0])
      ChamferedCylinder(r1=0.5, r2=1/8, h=length);

      translate([-0.125,-Millimeters(10)-0.1875,0])
      ChamferedCube([0.25, Millimeters(20)+0.375, length+(1/16)], r=1/32);
    }

    MlokForegripBolts(cutter=true);
  }
}

ScaleToMillimeters()
if ($preview) {
  MlokForegripBolts();

  MlokForegrip(cutaway=false);
} else {

  MlokForegrip(cutaway=false);
}
