include <../Vitamins/Pipe.scad>;
include <../Components.scad>;

base_thickness = grip_height;
base_thickness = 1/4; // For testing

column_height = 0.95;

overall_height = column_height + base_thickness;

module peg(column_height=column_height) {
  union() {
    translate([0,0,base_thickness])
    cylinder(r=3_4_tee_id/2, h=column_height);

    translate([-3_4_tee_rim_od/2,-3_4_tee_id/2,0])
    cube([3_4_tee_rim_od,3_4_tee_id,base_thickness]);
  }
}

module peg_slotted_with_offset_holes(offset=0) {
  difference() {
    peg();

    translate([offset,0,0])
    for (i=[0:4]) {
      translate([0,0,(4/16 * i) + 1/8])
      rotate([90,0,0])
      #1_8_rod(cutter=true, loose=true, length = 3_4_tee_rim_id + 0.2, center=true);
    }

    translate([-3_4_tee_id/2 - 0.01,-1_4_rod_r - 1_4_rod_clearance_loose,-0.1])
    #cube([3_4_tee_id + 0.02, 1_4_rod_d + 1_4_rod_clearance_loose*2, overall_height + 0.2]);
  }
}

module peg_with_center_hole() {
  difference() {
    peg();

    translate([0,0,-0.1])
    #1_4_rod(cutter=true, loose=true, length = overall_height + 0.2);
  }
}


module peg_with_offset_hole(offset=0) {
  difference() {
    peg();

    translate([offset,0,-0.1])
    #1_4_rod(cutter=true, loose=true, length = overall_height + 0.2);
  }
}

scale([25.4, 25.4, 25.4]) {

  translate([-2,0,0])
  *peg_with_center_hole();

  translate([0,0,0])
  *peg_with_offset_hole(offset=1/8);

  translate([2,0,0])
  *peg_with_offset_hole(offset=1/4);

  translate([-2,2,0])
  *peg_slotted_with_offset_holes();

  translate([0,2,0])
  *peg_slotted_with_offset_holes(offset=1/8);

  translate([2,2,0])
  *peg_slotted_with_offset_holes(offset=1/4);
}