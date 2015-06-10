include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;

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

scale([25.4, 25.4, 25.4])
striker_guide_center();