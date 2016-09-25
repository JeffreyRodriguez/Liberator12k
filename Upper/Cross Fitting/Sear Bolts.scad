include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Trigger.scad>;
use <../../Lower/Trigger.scad>;

use <../../Reference.scad>;

function SearBoltSpec() = Spec_BoltM3();
function SearBoltOffset() = ReceiverIR()-BoltRadius(SearBoltSpec());

module SearBolts(boltLength=UnitsMetric(30),
                 cutter=false) {
                   
  nutOffsetZ = -RodRadius(StrikerRod(), RodClearanceLoose())-0.05;

  // M3 Nut and Screw Hole
  translate([0,0,nutOffsetZ])
  union() {
    
    color("SteelBlue")
    for (i = [-1,1])
    translate([i*SearBoltOffset(),0,0]) {
      mirror([0,0,1])
      NutAndBolt(bolt=SearBoltSpec(), boltLength=boltLength,
                 nutHeightExtra=(cutter?abs(nutOffsetZ):0),
                 clearance=cutter, teardrop=true, teardropAngle=180);
    }
  }
}

//SearBolts(cutter=($t%2==0));
%SearBolts(cutter=true);
SearBolts(cutter=false);
