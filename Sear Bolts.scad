include <Components/Animation.scad>;

use <Components/Manifold.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;

use <Reference.scad>;

module SearBolts(boltDiameter = 0.116+0.03, boltLength=(30/25.4), nutHeight=0.11,
                 nutDiameter=0.247+0.04, nutMinorRadius=0.11+0.015,
                 cutter=false) {
  boltRadius = boltDiameter/2;
  nutRadius = nutDiameter/2;
  searBoltOffset = ReceiverIR()-boltRadius;

  // M3 Nut and Screw Hole
  translate([0,0,-RodRadius(StrikerRod(), RodClearanceLoose())-0.0255])
  union() {
    
    if (cutter==false)
    for (i = [1,0])
    mirror([i,0,0])
    translate([searBoltOffset,0,0]) {
      
      // Bolt
      color("White")
      mirror([0,0,1])
      cylinder(r=boltRadius, h=boltLength, $fn=5);
      
      // Nut
      color("Silver")
      translate([0,0,-nutHeight+ManifoldGap()])
      cylinder(r=nutRadius, h=nutHeight, $fn=6);
    }
    
    
    if (cutter)      
    for (i = [1,0])
    mirror([i,0,0]) {
      
      // Bolt Slot
      translate([searBoltOffset-(boltRadius*1.1),-boltRadius,-ManifoldGap()])
      mirror([0,0,1])
      cube([boltDiameter*1.2, boltDiameter, boltLength]);
      
      // Nut Slot
      translate([searBoltOffset-nutRadius,-nutMinorRadius,-nutHeight+ManifoldGap()])
      cube([nutDiameter, nutMinorRadius*2, nutHeight+RodRadius(SearRod())]);
    }
  }
}

//SearBolts(cutter=($t%2==0));
%SearBolts(cutter=true);
SearBolts(cutter=false);
