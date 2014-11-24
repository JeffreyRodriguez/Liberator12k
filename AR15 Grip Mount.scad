include <Components.scad>;

module ar15_grip(mount_height=1, mount_length=1) {
  slot_width = .34;
  slot_height = .975;
  slot_length = 1.25;
  slot_angle  = 30;
  slot_angle_offset = -0.41;

  grip_width = 0.85;
  grip_height = 1.26;
  grip_bolt_diameter = 1/4;

  // TODO: Calculate this instead of specifying
  grip_bolt_length = 2;
  grip_bolt_offset_x = -slot_length/2 - grip_bolt_diameter/2 - 3/64; // Why?

  difference() {

    union() {

      // Mount body
      translate([-slot_length,-slot_width/2,-slot_height])
      color("Fuchsia")
      cube([slot_length,slot_width,slot_height]);

      // TODO: Clean up
      // Vertical Mounting Block
      translate([-slot_length,-grip_width/2,0])
      color("Purple")
      cube([slot_length,grip_width,mount_height]);

      // Horizontal Mounting Block
      translate([0,-grip_width/2,-grip_height])
      color("Indigo")
      cube([mount_length,grip_width,grip_height + mount_height]);
    }

    // Angle cutter
    translate([-slot_length,0,slot_angle_offset])
    rotate([0,slot_angle,0])
    translate([0,-slot_width/2 - 0.1,-1])
    cube([1.2, slot_width + 0.2, 1]);


    // Mounting Hole Cutter
    translate([grip_bolt_offset_x,0,-grip_bolt_length/2])
    rotate([0,30,0])
    #cylinder(r=grip_bolt_diameter/2, h=grip_bolt_length);
  }

  translate([-1.766,0])
  rotate([180,0,-90])
  scale([1/25.4, 1/25.4, 1/25.4])
  *%import("AR15_grip.stl");
}


// Test Print
*scale([25.4,25.4,25.4]) {
  rotate([0,90,0])
  ar15_grip(mount_height = 1/8, mount_length = 1/8);
}
