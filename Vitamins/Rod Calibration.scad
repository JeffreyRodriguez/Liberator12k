include <Rod.scad>;

$fn=60;


scale([25.4,25.4,25.4]) {

  // 1/8" Rod
  translate([-1,0,0])
  difference() {
    cylinder(r=1/4, h=1/4);
    1_8_rod(cutter=true);
  }

  // 1/4" Rod
  difference() {
    cylinder(r=1/4, h=1/4);
    1_4_rod(cutter=true);
  }

  // 5/16" Rod
  translate([1,0,0])
  difference() {
    cylinder(r=1/4, h=1/4);
    5_16_rod(cutter=true);
  }

}
