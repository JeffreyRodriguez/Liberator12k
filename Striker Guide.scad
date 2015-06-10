include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;

module striker_guide(disc_thickness=1/8, rope_width = 1/4, pin=1/8, top_pin_extension=3/8) {

  difference() {
  union() {

    // Rim Disc
    cylinder(r=3_4_tee_rim_od/2, h=disc_thickness);

    translate([0,0,disc_thickness]) {
      // Main Body
      difference() {

        // Body
        cylinder(r=3_4_tee_id/2, h=3_4_tee_width + top_pin_extension);

        // Rope Track
        translate([-rope_width,-rope_width/2,(3_4_tee_width/2) - rope_width])
        cube([(3_4_tee_id/2) + rope_width + 0.1, rope_width, 3_4_tee_width]);

        // Stock Rope Pin
        #translate([0,-(3_4_tee_id/2) - 0.1,(3_4_tee_width/2) + rope_width])
        rotate([-90,0,0])
        cylinder(r=pin/2, h=3_4_tee_id + 0.2, $fn=12);
      }

    }
  }

    // Body Center Rope Track
    translate([-rope_width,-rope_width/2,-0.1])
    cube([rope_width,rope_width,3_4_tee_width + disc_thickness + top_pin_extension + 0.2]);

    // Side Cutters
    translate([0,0,3_4_tee_width + top_pin_extension + disc_thickness]) {

      // Rope Track
      translate([-rope_width,-rope_width/2,- rope_width])
      cube([(3_4_tee_id/2) + rope_width + 0.1, rope_width, rope_width + 0.1]);

      // Rope Pin
      #translate([0,-(3_4_tee_id/2) - 0.1,-rope_width])
      rotate([-90,0,0])
      cylinder(r=pin/2, h=3_4_tee_id + 0.2, $fn=12);
    }
  }

}

scale([25.4, 25.4, 25.4])
striker_guide();
