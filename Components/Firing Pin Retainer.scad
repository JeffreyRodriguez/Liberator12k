include <../Components/Animation.scad>;

use <Semicircle.scad>;
use <Manifold.scad>;
use <Debug.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;

module FiringPinRetainer(rodSpec=Spec_RodOneEighthInch(), gap=0.16, length=1) {
  color("SteelBlue")
  render()
  for (i=[1,-1])
  translate([0,0, gap*i])
  rotate([90,0,0])
  Rod(rodSpec, RodClearanceLoose(), length=length, center=true);
}

FiringPinRetainer();

!scale(25.4) {
  
  translate([0,0,0.6])
  #cylinder(r=0.12, h=0.5, $fn=9);
  
  translate([0,0,0.9])
  #cylinder(r=0.18, h=1, $fn=12);
  
  translate([0,0,1.1])
  rotate([0,90,0])
  #FiringPinRetainer();
}