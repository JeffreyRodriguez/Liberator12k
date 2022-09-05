include <../Vitamins/Rod.scad>;

$fn=50;

scale([25.4, 25.4, 25.4]) {

  // Spring Block
  difference() {
    union() {
      translate([-1/8,-1/8,0])
      cube([1/4, 1/4, 1/4]);

      // Cap
      translate([0,0,1/4])
      cylinder(r1=1/8, r2=5/64, h=1/16);
    }

    Rod(rod=RodOneEighthInch, clearance=RodClearanceSnug, center=true);
  }
}
