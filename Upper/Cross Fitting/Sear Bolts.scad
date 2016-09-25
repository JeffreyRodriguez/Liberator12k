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

module SearBolts(boltLength=UnitsMetric(30), nutMinorRadius=BoltNutMinor(SearBoltSpec(), true)/2,
                 cutter=false) {
                   
  nutOffsetZ = RodRadius(StrikerRod(), RodClearanceLoose())+0.0255;

  // M3 Nut and Screw Hole
  translate([0,0,-RodRadius(StrikerRod(), RodClearanceLoose())-0.0255])
  union() {
    
    color("SteelBlue")
    for (i = [1,0])
    mirror([i,0,0])
    translate([SearBoltOffset(),0,0]) {
      mirror([0,0,1])
      NutAndBolt(bolt=SearBoltSpec(), boltLength=boltLength,
                 nutHeightExtra=nutOffsetZ, clearance=cutter);
    }
  }
}

//SearBolts(cutter=($t%2==0));
%SearBolts(cutter=true);
//SearBolts(cutter=false);
