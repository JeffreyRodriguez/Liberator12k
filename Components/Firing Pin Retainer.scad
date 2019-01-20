include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Debug.scad>;

use <../Shapes/Teardrop.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Pipe.scad>;

function FiringPinHeadLength() = 0.4;

module FiringPinRetainerPins(rodSpec=Spec_RodOneEighthInch(),
                             springLength=0.3, gap=0.15, teardrop=false,
                             retainingPinLength=1) {

  color("SteelBlue")
  render()
  translate([springLength+(FiringPinHeadLength()/2),0,0])
  rotate([0,-90,0])
  translate([0,0,springLength+(FiringPinHeadLength()/2)])
  for (i=[1,-1])
  translate([gap*i,0,0])
  rotate([90,0,0])
  if (teardrop) {
    linear_extrude(height=retainingPinLength, center=true)
    Teardrop(r=RodRadius(rodSpec, RodClearanceLoose()), rotation=90);
  } else {
    Rod(rod=rodSpec,
        clearance=RodClearanceLoose(),
        length=retainingPinLength,
        center=true);
  }


}

module FiringPinRetainer(springLength=0.3, retainingPinLength=1, teardrop=false, showPins=true) {

  // Retaining Pins
  if (showPins)
  FiringPinRetainerPins(springLength=springLength,retainingPinLength=retainingPinLength, teardrop=teardrop);

  translate([springLength+(FiringPinHeadLength()/2),0,0])
  rotate([0,-90,0]) {

    // Firing Pin Hole
    color("SteelBlue")
    translate([0,0,ManifoldGap()])
    mirror([0,0,1])
    cylinder(r=0.085, h=3-FiringPinHeadLength(), $fn=8);

    // Nail head hole
    cylinder(r=0.18, h=springLength+(FiringPinHeadLength()*1.25), $fn=12);
  }
}

FiringPinRetainer(teardrop=true);
