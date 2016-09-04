include <../Components/Animation.scad>;

use <Semicircle.scad>;
use <Manifold.scad>;
use <Debug.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;

use <Pipe Insert.scad>;
use <Firing Pin Retainer.scad>;

//Spec_TubingThreeQuarterByFiveEighthInch
//Spec_PipeThreeQuarterInchSch80
//Spec_PipeOneInchSch80
module FiringPinPipeInsert(pipeSpec=Spec_PipeThreeQuarterInchSch80Stainless(),
                           rodSpec=Spec_RodOneEighthInch(), rimfireOffset=0.11) {
  baseLength = 0.4;
  springLength = 0.3;
  nailHeadLength = 0.4;
  length = baseLength+springLength+nailHeadLength;
  
  render()
  difference() {
    linear_extrude(height=length)
    PipeInsert2d()
    translate([rimfireOffset,0])
    circle(r=0.085, $fn=8);
    
    translate([rimfireOffset,0,baseLength]) {
      cylinder(r=0.18, h=length, $fn=12);
      
      translate([0,0,springLength+nailHeadLength/2])
      rotate([0,90,0])
      FiringPinRetainer(gap=0.14);
    }
  }
}

scale(25.4)
FiringPinPipeInsert(rimfireOffset=0);
