include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

module StrikerGuide(disc_thickness=1/8, rope_width = 1/4, pin=1/8, top_pin_extension=3/8) {

  difference() {
  union() {

    // Rim Disc
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=disc_thickness);

    translate([0,0,disc_thickness]) {
      // Main Body
      difference() {

        // Body
        cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeWidth(receiverTee) + top_pin_extension);

        // Rope Track
        translate([-rope_width,-rope_width/2,(TeeWidth(receiverTee)/2) - rope_width])
        cube([(TeeInnerDiameter(receiverTee)/2) + rope_width + 0.1, rope_width, TeeWidth(receiverTee)]);

        // Stock Rope Pin
        #translate([0,-(TeeInnerDiameter(receiverTee)/2) - 0.1,(TeeWidth(receiverTee)/2) + rope_width])
        rotate([-90,0,0])
        cylinder(r=pin/2, h=TeeInnerDiameter(receiverTee) + 0.2, $fn=12);
      }

    }
  }

    // Body Center Rope Track
    translate([-rope_width,-rope_width/2,-0.1])
    cube([rope_width,rope_width,TeeWidth(receiverTee) + disc_thickness + top_pin_extension + 0.2]);

    // Side Cutters
    translate([0,0,TeeWidth(receiverTee) + top_pin_extension + disc_thickness]) {

      // Rope Track
      translate([-rope_width,-rope_width/2,- rope_width])
      cube([(TeeInnerDiameter(receiverTee)/2) + rope_width + 0.1, rope_width, rope_width + 0.1]);

      // Rope Pin
      #translate([0,-(TeeInnerDiameter(receiverTee)/2) - 0.1,-rope_width])
      rotate([-90,0,0])
      cylinder(r=pin/2, h=TeeInnerDiameter(receiverTee) + 0.2, $fn=12);
    }
  }

}

scale([25.4, 25.4, 25.4])
StrikerGuide();
