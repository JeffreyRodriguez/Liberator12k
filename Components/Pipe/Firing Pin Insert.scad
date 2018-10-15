include <../../Meta/Animation.scad>;

use <../../Shapes/Semicircle.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Debug.scad>;

use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Pipe.scad>;

use <Insert.scad>;
use <../Firing Pin Retainer.scad>;

//Spec_TubingThreeQuarterByFiveEighthInch
//Spec_PipeThreeQuarterInchSch80
//Spec_PipeOneInchSch80
module FiringPinPipeInsert(pipeSpec=Spec_PipeThreeQuarterInchSch80Stainless(), id=0.17,
                           rodSpec=Spec_RodOneEighthInch(), rimfireOffset=0.11) {
  baseLength = 0.4;
  springLength = 0.3;
  nailHeadLength = 0.4;
  length = baseLength+springLength+nailHeadLength;

  render()
  difference() {
    linear_extrude(height=length)
    PipeInsert2d(pipeSpec=pipeSpec)
    translate([rimfireOffset,0])
    circle(r=id/2, $fn=8);

    translate([rimfireOffset,0,baseLength]) {
      translate([0,0,springLength+nailHeadLength/2])
      rotate([0,90,0])
      FiringPinRetainer(gap=0.14);
    }
  }
}

scale(25.4)
FiringPinPipeInsert(rimfireOffset=0);
