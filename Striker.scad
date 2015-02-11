include <Components.scad>;


breech_offset = 9/16;
height = 1 + 7/8;
slot_height = 1 + 1/16;
center_hole_r = 15/128;

collar_height = 1/4;
collar_d = 0.38;
collar_r = collar_d/2;

spring_od = 0.43;
spring_or = spring_od/2;

spring_height = .562;

charging_slot_width = 5/32;

trigger_hole_d = 19/128;
trigger_hole_r = trigger_hole_d/2;
trigger_hole_offset = breech_offset + collar_height;

scale([25.4, 25.4, 25.4])
//translate([0,0,height])
//rotate([0,180,0])
color("Chartreuse") {


  difference() {

    // Striker Body
    cylinder(r=(3_4_pipe_id)/2, h=height);

    // Firing Pin Hole
    translate([0,0,-0.1])
    cylinder(r=center_hole_r, h=3);

    // Charging Slot
    translate([0,-charging_slot_width/2,-0.1])
    mirror([1,0,0])
    cube([3_4_tee_id, charging_slot_width, breech_offset + 0.2]);

    // Trigger Hole
    #translate([spring_or * 0.9,0,trigger_hole_offset])
    rotate([0,90,0])
//    cylinder(r=trigger_hole_r, h=3_4_pipe_id);
    cylinder(r1=trigger_hole_r, r2=trigger_hole_d, h=(3_4_pipe_id/2) - (spring_or * 0.80));

    translate([0,0,breech_offset]) {

      // Collar/Spring Track
      cylinder(r=spring_or, h=slot_height);

      // Collar/Spring Slot
      translate([-3_4_tee_id,-0.2,0])
      cube([3_4_tee_id, 0.4, slot_height]);
    }
  }

  %color("Green") {

  // Spring
  translate([0,0,breech_offset + collar_height*2 + 1/16])
  linear_extrude(height = spring_height, twist = 360*10)
  translate([.373/2,0,0])
  circle(r=0.041/2, h=1);

  // Firing Pin
  translate([0,0,-3_4_x_1_8_bushing_height - 3/32])
  cylinder(r=1/8/2, h=3);

  // Firing Pin Sear Discharged Position
  translate([0,0,breech_offset])
  cylinder(r=.38/2, h=1/4);

  // Firing Pin Sear Charged Position
  translate([0,0,breech_offset + collar_height + 1/16])
  cylinder(r=.38/2, h=1/4);

  // Breech
  translate([0,0,-3_4_x_1_8_bushing_height])
  3_4_x_1_8_bushing();

  // Rear Depth Gauge
  translate([0,0,3_4_tee_width])
  mirror([0,0,1])
  *3_4_x_1_8_bushing();

  // Receiver
  translate([0,0,-3_4_x_1_8_bushing_depth])
  rotate([0,-90,0])
  translate([3_4_tee_width/2,0,-3_4_tee_center_z])
  *3_4_tee();

  }
}