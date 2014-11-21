include <Components.scad>;
include <Pipe.scad>;

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

  union() {
    color("Fuchsia")
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
    color("Purple")
    cube([slot_length,grip_width,mount_height]);

    // Horizontal Mounting Block
    translate([0,-grip_width/2,-grip_height])
    color("Indigo")
    cube([mount_length,grip_width,grip_height + mount_height]);
  }

  translate([-1.766,0])
  rotate([180,0,-90])
  scale([1/25.4, 1/25.4, 1/25.4])
  %import("AR15_grip.stl");
}

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

module tee_housing_block_bottom() {
  bottom_block_width = 3_4_tee_rim_od + (tee_overlap*2);
  bottom_block_length = 3_4_tee_width;
  bottom_block_height = 3_4_tee_rim_width + (tee_overlap*2);

  difference() {

    // The block
    translate([
      -bottom_block_length/2,
      -bottom_block_width/2,
      -tee_overlap])
    cube([
      bottom_block_length,
      bottom_block_width,
      bottom_block_height]);


    // Sear hole
    translate([0,0,-0.1])
    cylinder(r=(sear_diameter + sear_rod_clearance)/2, h=bottom_block_height + 0.1);

    // Tee slot
    3_4_tee();
  }
}

module tee_housing_block_back() {
  back_block_height = 3_4_tee_height + 1/4;
  back_block_overlap = 5/8;
  back_block_width = 3_4_tee_rim_width + (tee_overlap*2) + back_block_overlap;

  difference() {
    translate([
      (-3_4_tee_width/2) - tee_overlap - back_block_overlap,
      -(3_4_tee_rim_od/2)-tee_overlap,
      -tee_overlap])
    cube([
      back_block_width,
      3_4_tee_rim_od + (tee_overlap*2),
      back_block_height]);

    3_4_tee_and_pipe();
  }
}

module tee_housing_block_front() {
  front_block_height = 3_4_tee_height + 1/4;
  front_block_overlap = 1_pipe_thread_length;
  front_block_length = 3_4_tee_rim_width + (tee_overlap*2) + front_block_overlap;
  front_block_width = 3_4_tee_rim_od + (tee_overlap*2);
  front_block_x_offset = (3_4_tee_width/2) -3_4_tee_rim_width -tee_overlap;
  front_block_screw_block_hole_diameter = 5/16; // M8 threaded rod in in my case
  front_block_screw_block_overlap = 1/4;
  front_block_screw_block_length = front_block_screw_block_hole_diameter + front_block_screw_block_overlap*2;
  front_block_screw_block_width = front_block_screw_block_hole_diameter + front_block_screw_block_overlap;
  front_block_screw_block_height = front_block_screw_block_hole_diameter + front_block_screw_block_overlap*2;


  difference() {
    translate([
      front_block_x_offset,
      -(3_4_tee_rim_od/2)-tee_overlap,
      -tee_overlap])
    union() {
      // Main Block
      cube([
        front_block_length,
        front_block_width,
        front_block_height]);

      // Left Screw Block
      translate([front_block_length/2 - front_block_screw_block_length/2,-front_block_screw_block_width + front_block_width,front_block_height])
      cube([front_block_screw_block_length, front_block_screw_block_width, front_block_screw_block_height]);

      // Right Screw Block
      translate([front_block_length/2 - front_block_screw_block_length/2,0,front_block_height])
      cube([front_block_screw_block_length, front_block_screw_block_width, front_block_screw_block_height]);
    }

    3_4_tee();

    // Tapered trunnion socket
    translate([3_4_tee_width/2,0,3_4_tee_center_z])
    1_pipe_tapered(length=front_block_width);

    // Upper screw block hole
    translate([
      front_block_length/2 + front_block_x_offset,
      0,
      front_block_height + front_block_screw_block_height/2 -tee_overlap])
    rotate([90,0,0])
    cylinder(r=front_block_screw_block_hole_diameter/2, h=front_block_width + 0.2, center=true);

    // Lower screw hole
    translate([
      front_block_length/2 + front_block_x_offset,
      0,
      front_block_screw_block_overlap])
    rotate([90,0,0])
    cylinder(r=front_block_screw_block_hole_diameter/2, h=front_block_width + 0.2, center=true);
  }
}

module ar_tee_housing(v = 0, h = 0, mount_length = 0, mount_height=0, tee_overlap, tee_clearance, sear_hole_diameter) {

  union() {

        // Bottom Rim Block
        tee_housing_block_bottom();

        // Frront Rim Block
        tee_housing_block_front();

        // Back Rim Block
        tee_housing_block_back();

      // TODO: Clean up the backside of the housing
      translate([-3_4_tee_width/2 - h/2,0,0])
      *circle_cutter(diameter=grip_width, length = 1.5, width = 2, height=1/2, xp=1.5);

    translate([h,0,v])
    translate([0,0,0])
    ar15_grip(mount_height=mount_height,mount_length=mount_length);
  }
}

*ar_tee_housing(
  v = 0,
  h = 0,
  tee_overlap         = 1/16,
  tee_clearance       = 1/64,
  sear_hole_diameter       = 1/4);
