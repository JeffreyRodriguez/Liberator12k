include <../Components.scad>;


pin_d = 1_8_rod_d + 1_8_rod_clearance_loose*2;

thickness = 1/4;

scale([25.4, 25.4, 25.4]) {

  translate([0,0,0])
  difference() {
    cylinder(r=1,h=thickness);

    translate([3/4,-1/4,-0.1])
    cylinder(r=1,h=thickness + 0.2);
  }

  *difference() {
    union() {
      cylinder(r=pin_d, h=thickness);

      translate([-1.5,-1/8,0])
      cube([3,1/4,thickness]);
    }

    translate([0,0,-0.1])
    cylinder(r=pin_d/2, h=thickness + 0.2);
  }
}