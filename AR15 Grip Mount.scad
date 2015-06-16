include <Components.scad>;

ar15_grip_POSITION_FRONT   = 0; // Default
ar15_grip_POSITION_REAR    = 1;
  slot_width = .35;
  slot_height = .983;
  slot_length = 1.28;
  slot_angle  = 30.1;
  slot_angle_offset = -0.413;
  slot_overlap = 1/4;

  grip_width = 0.85;
  grip_height = 1.26;
  grip_bolt_diameter = 1/4;

    // TODO: Calculate this instead of specifying
    grip_bolt_length = 2;
    grip_bolt_offset_x = -slot_length/2 - grip_bolt_diameter/2 - 0.04; // Why?


module ar15_grip_bolt(od=grip_bolt_diameter, length=4, nut_od=0.5, nut_height=0.25, nut_offset=2, nut_angle=0) {
    translate([grip_bolt_offset_x,0,-length/4])
    rotate([0,30,0])
    union() {
      cylinder(r=od/2, h=length);

      // Nut
      if (nut_offset)
      rotate([0,0,nut_angle])
      translate([0,0,nut_offset])
      cylinder(r=nut_od/2, h=nut_height, $fn=6);
    }
}

module ar15_grip(mount_height=1, mount_length=1, position=0, top_extension = 0, extension=0, debug=true) {

  // Positioning options
  x_offset = position == ar15_grip_POSITION_REAR ? slot_length : 0;

  translate([x_offset, 0,0])
  difference() {

    union() {

      // Mount body
      translate([-slot_length,-slot_width/2,-slot_height])
      color("Fuchsia")
      cube([slot_length + extension,slot_width,slot_height]);

      // Vertical Mounting Block
      if (mount_height > 0)
      //intersection() {
        translate([-slot_length - slot_overlap,-grip_width/2,0])
        color("Purple")
        cube([slot_length + slot_overlap + top_extension,grip_width,mount_height]);

//        union() {
//          translate([-slot_length - slot_overlap + grip_width/2,0,-0.1])
//          cylinder(r=grip_width/2, h=mount_height + 0.2);
//
//          translate([-slot_length - slot_overlap + grip_width/2,-grip_width/2,0])
//          color("Purple")
//          cube([slot_length+top_extension,grip_width,mount_height]);
//        }
//      }

      // Horizontal Mounting Block
      if (mount_length > 0)
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
    ar15_grip_bolt(nut_offset=undef);


  if(debug)
  translate([-1.766,0])
  rotate([180,0,-90])
  scale([1/25.4, 1/25.4, 1/25.4])
  %import("Vitamins/Grip.stl");
  }

}


// Test Print
scale([25.4,25.4,25.4]) {
  translate([0,0,1/4])
  rotate([0,180,0])
  ar15_grip(mount_height = 1/4, mount_length = 0);
}
