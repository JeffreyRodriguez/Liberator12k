include <Components/Animation.scad>;

use <Components/Manifold.scad>;
use <Components/Units.scad>;
use <Vitamins/Nuts And Bolts.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

use <Reference.scad>;

function SearBoltSpec() = Spec_BoltM3();
function SearBoltOffset() = ReceiverIR()-BoltRadius(SearBoltSpec());

module SearBolts(boltLength=UnitsMetric(30), nutMinorRadius=0.11+0.015,
                 cutter=false) {

  // M3 Nut and Screw Hole
  translate([0,0,-RodRadius(StrikerRod(), RodClearanceLoose())-0.0255])
  union() {
    
    if (cutter==false)
    for (i = [1,0])
    mirror([i,0,0])
    translate([SearBoltOffset(),0,0]) {
      
      // Bolt
      color("White")
      mirror([0,0,1])
      cylinder(r=BoltRadius(SearBoltSpec()), h=boltLength, $fn=5);
      
      // Nut
      color("Silver")
      translate([0,0,-BoltNutHeight(SearBoltSpec())+ManifoldGap()])
      cylinder(r=BoltNutRadius(SearBoltSpec()), h=BoltNutHeight(SearBoltSpec()), $fn=6);
    }
    
    
    if (cutter)      
    for (i = [1,0])
    mirror([i,0,0]) {
      
      // Bolt Slot
      translate([SearBoltOffset()-(BoltRadius(SearBoltSpec())*1.1),-BoltRadius(SearBoltSpec()),-ManifoldGap()])
      mirror([0,0,1])
      cube([BoltDiameter(SearBoltSpec())*1.2, BoltDiameter(SearBoltSpec()), boltLength]);
      
      // Nut Slot
      translate([SearBoltOffset()-BoltNutRadius(SearBoltSpec()),-nutMinorRadius,-BoltNutHeight(SearBoltSpec())+ManifoldGap()])
      cube([BoltNutDiameter(SearBoltSpec()), nutMinorRadius*2, BoltNutHeight(SearBoltSpec())+RodRadius(SearRod())]);
    }
  }
}

//SearBolts(cutter=($t%2==0));
%SearBolts(cutter=true);
SearBolts(cutter=false);
