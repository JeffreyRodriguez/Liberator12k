include <Rod.scad>;

$fn=60;

module RodCalibration(rod, clearance, wall=1/8, height=1/2) {
  linear_extrude(height=height)
  difference() {
    circle(r=lookup(RodRadius, rod) + wall);
    Rod2d(rod=rod, clearance=clearance);
  }
}


scale([25.4,25.4,25.4]) {

  // 1/8" Rod
  *translate([-1,0,0])
  difference() {
    cylinder(r=1/4, h=1/4);
    1_8_rod(cutter=true);
  }

  // 1/4" Rod
  *difference() {
    cylinder(r=1/4, h=1/4);
    1_4_rod(cutter=true);
  }

  // 5/16" Rod
  *translate([1,0,0])
  difference() {
    cylinder(r=1/4, h=1/4);
    5_16_rod(cutter=true);
  }

  // 3/4" Tubing
  RodCalibration(rod=RodFiveSixteenthInch, clearance=RodClearanceLoose, height=2);

}
