include <Components.scad>;

ar15_grip_POSITION_FRONT   = 0; // Default
ar15_grip_POSITION_REAR    = 1;
  slot_width = .34;
  slot_height = .975;
  slot_length = 1.25;
  slot_angle  = 30;
  slot_angle_offset = -0.41;
  slot_overlap = 1/4;

  grip_width = 0.85;
  grip_height = 1.26;
  grip_bolt_diameter = 1/4;

    // TODO: Calculate this instead of specifying
    grip_bolt_length = 2;
    grip_bolt_offset_x = -slot_length/2 - grip_bolt_diameter/2 - 3/64; // Why?

module ar15_grip(mount_height=1, mount_length=1, position=0, debug=false) {

  // Positioning options
  x_offset = position == ar15_grip_POSITION_REAR ? slot_length : 0;

  translate([x_offset, 0,0])
  difference() {

    union() {

      // Mount body
      translate([-slot_length,-slot_width/2,-slot_height])
      color("Fuchsia")
      cube([slot_length,slot_width,slot_height]);

      // Vertical Mounting Block
      intersection() {
        translate([-slot_length - slot_overlap,-grip_width/2,0])
        color("Purple")
        cube([slot_length + slot_overlap,grip_width,mount_height]);

        union() {
          translate([-slot_length - slot_overlap + grip_width/2,0,-0.1])
          cylinder(r=grip_width/2, h=mount_height + 0.2);

          translate([-slot_length - slot_overlap + grip_width/2,-grip_width/2,0])
          color("Purple")
          cube([slot_length,grip_width,mount_height]);
        }
      }

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
    cylinder(r=grip_bolt_diameter/2, h=grip_bolt_length);
  }

}


// Test Print
*scale([25.4,25.4,25.4]) {
  //rotate([0,90,0])
  ar15_grip(mount_height = 1/4, mount_length = 1/4);
}
