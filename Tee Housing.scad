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


module ar15_grip() {
  slot_width = .35;
  slot_height = .98;
  slot_length = 1.28;
  slot_angle  = 30;
  slot_angle_offset = -0.415;

  difference() {
    color("Green")
    translate([-slot_length,-slot_width/2,-slot_height])
    cube([slot_length,slot_width,slot_height]);

    translate([-slot_length,0,slot_angle_offset])
    rotate([0,slot_angle,0])
    translate([0,-slot_width/2 - 0.1,-2])
    cube([2, slot_width + 0.2, 2]);
  }

  translate([-1.766,0])
  rotate([180,0,-90])
  scale([1/25.4, 1/25.4, 1/25.4])
  %import("AR15_grip.stl");
}

module ar_tee_housing(v = 0, h = 0, tee_overlap, tee_clearance) {
  bottom_block_width = 3_4_tee_rim_od + (tee_overlap*2);
  bottom_block_length = (3_4_tee_width/2) + (3_4_tee_rim_od/2) + tee_overlap * 2;
  back_block_height = 3_4_tee_height - (3_4_tee_rim_od/2);
  back_block_overlap = 5/8;
  back_block_width = 3_4_tee_rim_width + (tee_overlap*2) + back_block_overlap;

  union() {

    difference() {
      union() {

        // Bottom
        translate([(-3_4_tee_width/2) - tee_overlap,-bottom_block_width/2,-tee_overlap])
        cube([
          bottom_block_length,
          bottom_block_width,
          3_4_tee_rim_width + (tee_overlap*2)]);

        // Back
        translate([
          (-3_4_tee_width/2) - tee_overlap - back_block_overlap,
          -(3_4_tee_rim_od/2)-tee_overlap,
          -tee_overlap])
        cube([back_block_width,
          3_4_tee_rim_od + (tee_overlap*2),
          back_block_height]);
      }



      // TODO: Clean up the backside of the housing
      translate([-3_4_tee_width/2 - h/2,0,0])
      *circle_cutter(diameter=grip_width, length = 1.5, width = 2, height=1/2, xp=1.5);

      3_4_tee_and_pipe();
    }

    translate([-h,0,v])
    translate([0,0,-tee_overlap])
    ar15_grip();
  }
}

*ar_tee_housing(
  v = 0,
  h = 1/4,
  tee_overlap         = 1/8,
  tee_clearance       = 1/64);
