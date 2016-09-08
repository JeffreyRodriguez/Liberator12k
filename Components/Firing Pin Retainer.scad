include <../Components/Animation.scad>;

use <Semicircle.scad>;
use <Manifold.scad>;
use <Debug.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;

module FiringPinRetainer(rodSpec=Spec_RodOneEighthInch(), gap=0.16, retainingPinLength=1,
                         rimfireOffset=0.11) {
  springLength = 0.3;
  nailHeadLength = 0.4;
  
  translate([springLength+(nailHeadLength/2),0,0])
  rotate([0,-90,0]) {
                           
    // Retaining Pins
    color("SteelBlue")
    render()
    translate([0,0,springLength+(nailHeadLength/2)])
    for (i=[1,-1])
    translate([gap*i,0,0])
    rotate([90,0,0])
    Rod(rodSpec, RodClearanceLoose(), length=retainingPinLength, center=true);
  
    // Firing Pin Hole
    translate([0,0,ManifoldGap()])
    mirror([0,0,1])
    cylinder(r=0.085, h=3, $fn=8);
    
    // Nail head hole
    cylinder(r=0.18, h=springLength+nailHeadLength, $fn=12);
  }
}

FiringPinRetainer();

!scale(25.4) render() {
  FiringPinRetainer();
}