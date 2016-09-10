include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Reference.scad>;
use <../../Lower/Trigger.scad>;

function SearBoltSpec() = Spec_BoltM3();
function SearBoltOffset() = ReceiverIR()-BoltRadius(SearBoltSpec());

module SearBolts(boltLength=UnitsMetric(30), nutMinorRadius=BoltNutMinor(SearBoltSpec(), true)/2,
                 cutter=false) {

  // M3 Nut and Screw Hole
  translate([0,0,-RodRadius(StrikerRod(), RodClearanceLoose())-0.0255])
  union() {
    
    if (cutter==false)
    color("SteelBlue")
    for (i = [1,0])
    mirror([i,0,0])
    translate([SearBoltOffset(),0,0]) {
      mirror([0,0,1])
      NutAndBolt(bolt=SearBoltSpec(), boltLength=boltLength);
    }
    
    
    if (cutter)
    for (i = [1,0])
    mirror([i,0,0])
    translate([SearBoltOffset(),0,0]) {
      
      // Bolt Slot
      translate([-BoltRadius(SearBoltSpec(), clearance=true),
                 -BoltRadius(SearBoltSpec(), clearance=true),
                 -ManifoldGap()])
      mirror([0,0,1])
      cube([BoltDiameter(SearBoltSpec(), clearance=true),
            BoltDiameter(SearBoltSpec(), clearance=true), boltLength]);
      
      // Nut Slot
      translate([-BoltNutRadius(SearBoltSpec(), clearance=true),
                 -nutMinorRadius,
                 -BoltNutHeight(SearBoltSpec())+ManifoldGap()])
      cube([BoltNutDiameter(SearBoltSpec(), clearance=true),
           nutMinorRadius*2,
           BoltNutHeight(SearBoltSpec())+RodRadius(SearRod())]);
    }
  }
}

//SearBolts(cutter=($t%2==0));
%SearBolts(cutter=true);
SearBolts(cutter=false);
