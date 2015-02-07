include <Components.scad>;

height = 1 + 7/8;
slot_height = 1 + 2/8;
center_hole_r = 3/32;

scale([25.4, 25.4, 25.4]) {

  color("Chartreuse")
  difference() {
    cylinder(r=(3_4_pipe_id)/2, h=height);

    // Main Hole
    translate([0,0,1/4])
    cylinder(r=0.43/2, h=slot_height);

    // Firing Pin Hole
    translate([0,0,-0.1])
    cylinder(r=center_hole_r, h=3);

    // Trigger Slot
    translate([center_hole_r + 5/128,-9/64,0.8])
    cube([3_4_tee_id, 18/64, height]);

    // Collar Slot
    translate([-3_4_tee_id,-0.2,1/4])
    cube([3_4_tee_id, 0.4, slot_height]);
  }

  // Spring
  %translate([0,0,1/4])
  linear_extrude(height = 1.1, twist = 360*12)
  translate([.373/2,0,0])
  circle(r=0.041/2, h=1);

  // Firing Pin
  translate([0,0,-3/8])
  %cylinder(r=1/8/2, h=3);

  // Firing Pin Sear
  translate([0,0,1/4 + slot_height - 1/4])
  %cylinder(r=.38/2, h=1/4);

  // Breech
  translate([0,0,height])
  translate([0,0,3_4_x_1_8_bushing_height])
  rotate([180,0,0])
  %3_4_x_1_8_bushing();
}