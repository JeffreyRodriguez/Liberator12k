include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Lower/Trigger.scad>;
use <../../../Lower/Trigger.scad>;

use <../../../Reference.scad>;

function SearBoltSpec() = Spec_BoltM3();
function SearBoltOffset() = ReceiverIR()-BoltRadius(SearBoltSpec());

module SearBolts(boltLength=UnitsMetric(30), nutAngle=90,
                 teardrop=true, teardropAngle=90, cutter=false) {

  nutOffsetZ = -RodRadius(StrikerRod(), RodClearanceLoose())-0.08;

  // M3 Nut and Screw Hole
  translate([0,0,nutOffsetZ])
  union() {

    color("SteelBlue")
    for (i = [-1,1])
    translate([i*SearBoltOffset(),0,0]) {
      mirror([0,0,1])
      rotate([0,0,nutAngle])
      NutAndBolt(bolt=SearBoltSpec(), boltLength=boltLength,
                 nutHeightExtra=(cutter?abs(nutOffsetZ):0),
                 clearance=cutter, teardrop=teardrop, teardropAngle=teardropAngle);
    }
  }
}

//SearBolts(cutter=($t%2==0));
%SearBolts(cutter=true);
SearBolts(cutter=false);
