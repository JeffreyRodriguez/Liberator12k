include <Components.scad>;
include <Pipe.scad>;

module 3_4_tee_and_pipe(pipe_length_pos=1, pipe_length_neg=1) {
  union() {
    // 3/4" Tee
    3_4_tee(id=0);

    translate([(3_4_tee_width/2) - 0.01,0,3_4_tee_center_z])
    rotate([0,90,0])
    pipe(id=0,
         od=3_4_pipe_od+0.05,
         length=pipe_length_pos);

    translate([(-3_4_tee_width/2) + 0.01,0,3_4_tee_center_z])
    rotate([0,-90,0])
    pipe(id=0,
         od=3_4_pipe_od+0.05,
         length=pipe_length_neg);
  }
}


module ar15_grip(mount_height=1, mount_length=1) {
  slot_width = .35;
  slot_height = .98;
  slot_length = 1.28;
  slot_angle  = 30;
  slot_angle_offset = -0.415;

  grip_width = 0.85;
  grip_height = 1.27;
  grip_bolt_diameter = 1/4;

  // TODO: Calculate this instead of specifying
  grip_bolt_length = 2;
  grip_bolt_offset_x = -slot_length/2 - grip_bolt_diameter/2 - 1/32; // TODO: Why 1/32?

  color("Green")
  union() {
    difference() {
      // Mount body
      translate([-slot_length,-slot_width/2,-slot_height])
      cube([slot_length,slot_width,slot_height]);

      // Angle cutter
      translate([-slot_length,0,slot_angle_offset])
      rotate([0,slot_angle,0])
      translate([0,-slot_width/2 - 0.1,-2])
      cube([2, slot_width + 0.2, 2]);

      // Mounting Hole Cutter
      translate([grip_bolt_offset_x,0,-grip_bolt_length/2])
      rotate([0,30,0])
      cylinder(r=grip_bolt_diameter/2, h=grip_bolt_length);
    }

    // TODO: Clean up
    // Vertical Mounting Block
    translate([-slot_length,-grip_width/2,0])
    cube([slot_length,grip_width,mount_height]);

    // Horizontal Mounting Block
    translate([0,-grip_width/2,-grip_height])
    cube([mount_length,grip_width,grip_height + mount_height]);
  }

  translate([-1.766,0])
  rotate([180,0,-90])
  scale([1/25.4, 1/25.4, 1/25.4])
  %import("AR15_grip.stl");
}

module ar_tee_housing(v = 0, h = 0, mount_length = 0, mount_height=0, tee_overlap, tee_clearance, sear_hole_diameter) {
  bottom_block_width = 3_4_tee_rim_od + (tee_overlap*2);
  bottom_block_length = (3_4_tee_width/2) + (3_4_tee_rim_od/2) + tee_overlap * 2;
  back_block_height = 3_4_tee_height - (3_4_tee_rim_od/2);
  back_block_overlap = 5/8;
  back_block_width = 3_4_tee_rim_width + (tee_overlap*2) + back_block_overlap;

  color("Green", 0.5)
  union() {

    difference() {
      union() {

        // Bottom Rim Block
        translate([(-3_4_tee_width/2) - tee_overlap,-bottom_block_width/2,-tee_overlap])
        cube([
          bottom_block_length,
          bottom_block_width,
          3_4_tee_rim_width + (tee_overlap*2)]);

        // Back Rim Block
        translate([
          (-3_4_tee_width/2) - tee_overlap - back_block_overlap,
          -(3_4_tee_rim_od/2)-tee_overlap,
          -tee_overlap])
        cube([back_block_width,
          3_4_tee_rim_od + (tee_overlap*2),
          back_block_height]);
      }

      // Sear hole
      cylinder(r=sear_hole_diameter/2, h=tee_overlap + 0.1, center=true);

      // TODO: Clean up the backside of the housing
      translate([-3_4_tee_width/2 - h/2,0,0])
      *circle_cutter(diameter=grip_width, length = 1.5, width = 2, height=1/2, xp=1.5);

      3_4_tee_and_pipe();
    }

    translate([h,0,v])
    translate([0,0,0])
    ar15_grip(mount_height=mount_height,mount_length=mount_length);
  }
}

*ar_tee_housing(
  v = -1,
  h = 1/4,
  tee_overlap         = 1/16,
  tee_clearance       = 1/64,
  sear_hole_diameter       = 1/4);
