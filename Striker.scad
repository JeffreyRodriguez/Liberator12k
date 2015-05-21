include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;

module striker(length=3, od=0.75, id=0.53,
               firing_pin_diam=0.14, firing_pin_depth=0.44, firing_pin_pad = 3/8,
               rope_width = 1/8, rope_depth=1/4,
               mocks=true, $fn=30) {

  difference() {

    union() {

      // Body
      cylinder(r=od/2, h=length);

      // Cap
      translate([0,0,length])
      *cylinder(r1=od/2, r2=firing_pin_diam*1.5, h=od/4);
    }

    // Line Hole
    translate([0,0,firing_pin_depth + firing_pin_pad])
    cylinder(r=id/2, h=length);

    // Line Pin Hole
    translate([0,od/2 + 0.1,length - rope_depth])
    rotate([90,0,0])
    cylinder(r=firing_pin_diam/2, h=od + 0.2, $fn=10);

    // Firing Pin Hole
    translate([0,0,-0.1])
    cylinder(r=firing_pin_diam/2, h=firing_pin_depth+0.2, $fn=12);

    // Mocks
    %if (mocks == true) {

      // Firing Pin
      translate([0,0,-1])
      cylinder(r=firing_pin_diam/2, h=1 + firing_pin_depth);

      // Line Pin
      translate([0,od/2 + 0.025,length - rope_depth])
      rotate([90,0,0])
      cylinder(r=firing_pin_diam/2, h=od + 0.05);

      // Line
      translate([0,0,line_pin_offset])
      cylinder(r=rope_width/2, h=12);

      // Spring
      translate([0,0,length])
      linear_extrude(height=3, twist=360 * 12)
      translate([od/2 - 1/16,0,0])
      circle(r=1/32);
    }
  }
}

module striker_guide_center(wall = 1/8, overlap=1/4, side_overlap = 3/8, pin = 1/8) {
  difference() {
    union() {
      translate([0,0,overlap])
      *%3_4_tee();

      // Center Rim
      cylinder(r=3_4_tee_rim_od/2 + wall, h=3_4_tee_rim_width+overlap);

      // Center Block
      translate([0,-3_4_tee_id/2,0])
      cube([3_4_tee_width/2 + overlap,3_4_tee_id,3_4_tee_rim_width+overlap]);

      // Side Block
      translate([3_4_tee_width/2 - 3_4_tee_rim_width,-3_4_tee_id/2,0])
      cube([3_4_tee_rim_width +side_overlap,3_4_tee_id,overlap + 3_4_tee_center_z - (3_4_tee_id/2)]);
    }

    // Cutaway View
    translate([-5,0,-5])
    *cube([10,10,10]);

    // Center Rim Hole
    translate([0,0,overlap])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_center_z);

    // Pipe Hole
    translate([0,0,-0.1])
    cylinder(r=(3_4_pipe_od+3_4_pipe_clearance)/2, h=3_4_tee_rim_width + overlap + 0.3);

    // Side Rim
    translate([(3_4_tee_width/2)-3_4_tee_rim_width -0.1,0,3_4_tee_center_z+overlap])
    rotate([0,90,0])
    union() {
      cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width +0.1);
      cylinder(r=3_4_tee_id/2, h=3_4_tee_rim_width+side_overlap+0.2);
    }

    // Tee Body
    translate([-3_4_tee_width/2,0,3_4_tee_center_z + overlap])
    rotate([0,90,0])
    cylinder(r=3_4_tee_diameter/2, h=3_4_tee_width-3_4_tee_rim_width + 0.1);

    // Center Pin
    translate([3_4_tee_rim_od/2 + overlap,3_4_tee_id/2 +0.1,overlap])
    rotate([90,0,0])
    #1_8_rod(length=3_4_tee_id + 0.2);

    // Center Pin Track
    translate([3_4_tee_rim_od/2 + overlap - pin,0,-0.1])
    cylinder(r=pin, h=overlap + pin + 0.1);

    // Side/Center Rope Track
    translate([3_4_tee_rim_od/2 + 0.01,-pin,overlap + pin + 0.01])
    rotate([0,53,0])
    cube([pin*3.4,pin*2,2]);

    // Side Tip Rope Track
    translate([3_4_tee_width/2, -pin,3_4_tee_center_z -(3_4_tee_id/2) +overlap - pin])
    cube([side_overlap + 0.1, pin*2,1]);

    // Side Pin
    translate([3_4_tee_width/2 + side_overlap - pin,
               3_4_tee_id/2 +0.1,
               3_4_tee_center_z - (3_4_tee_rim_od - 3_4_tee_id)/2])
    rotate([90,0,0])
    #1_8_rod(length=3_4_tee_id + 0.2);
  }
}

module striker_guide_side(disc_thickness=1/8, rope_width = 1/4, pin=1/8, top_pin_extension=3/8) {

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

*scale([25.4, 25.4, 25.4])
striker_guide_center();

scale([25.4, 25.4, 25.4])
striker_guide_side();

!scale([25.4, 25.4, 25.4])
//translate([0,2,0])
striker();
