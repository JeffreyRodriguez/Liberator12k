include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Debug.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;

function FiringPinSpringLength() = 0.3;
function FiringPinHeadLength() = 0.4;

module FiringPinRetainerPins(rodSpec=Spec_RodOneEighthInch(), gap=0.15, retainingPinLength=1) {
  color("SteelBlue")
  render()
  translate([FiringPinSpringLength()+(FiringPinHeadLength()/2),0,0])
  rotate([0,-90,0])
  translate([0,0,FiringPinSpringLength()+(FiringPinHeadLength()/2)])
  for (i=[1,-1])
  translate([gap*i,0,0])
  rotate([90,0,0])
  Rod(rodSpec, RodClearanceLoose(), length=retainingPinLength, center=true);

}

module FiringPinRetainer(rimfireOffset=0.11) {

  // Retaining Pins
  FiringPinRetainerPins();

  translate([FiringPinSpringLength()+(FiringPinHeadLength()/2),0,0])
  rotate([0,-90,0]) {

    // Firing Pin Hole
    translate([0,0,ManifoldGap()])
    mirror([0,0,1])
    cylinder(r=0.085, h=3, $fn=8);

    // Nail head hole
    cylinder(r=0.18, h=FiringPinSpringLength()+FiringPinHeadLength(), $fn=12);
  }
}

FiringPinRetainer();

!scale(25.4) render() {
  FiringPinRetainer();
}
