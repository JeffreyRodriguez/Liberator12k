include <Components.scad>;
include <Pipe.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;

tee_overlap = 1/16;

trigger_travel = 3/8;
sear_tee_clearance = 2/16;
sear_diameter = 1/4;
sear_length = 2.5;
sear_rod_clearance = 1/64;
sear_block_clearance = 1/128;
trigger_clearance    = 1/128;
sear_block_padding = 1/8;
trigger_width = sear_diameter + (sear_block_padding*2);
sear_block_width = sear_diameter + (sear_block_padding*3);
sear_block_length = sear_diameter + (sear_block_padding*2);
sear_top_clearance = 1/64;
sear_block_height_extra = sear_block_padding;
sear_block_height = trigger_travel + sear_block_height_extra + sear_block_padding;
sear_x = -((3_4_tee_id/2) - (sear_diameter/2) - sear_tee_clearance);

trigger_height = trigger_travel * 2;
trigger_rear_height = 1/4;
sear_hole_width = sear_diameter + sear_rod_clearance;
sear_hole_length = trigger_travel + sear_diameter + sear_rod_clearance;
trigger_protrousion = 5/8;
trigger_length = sear_hole_length + trigger_protrousion;
trigger_angle_cutter_width = trigger_width * 1.1;
trigger_angle_cutter_length = 2;
trigger_angle_cutter_height = 2;
trigger_rear_cutter_height = trigger_height - trigger_rear_height;
trigger_vertical_offset = 0;
trigger_x_extended = -sear_diameter;
trigger_x_compressed = trigger_x_extended - trigger_travel + (sear_diameter/2);

grip_width = 0.85;
grip_height = 1.27;
trigger_track_extra = 1/8;
trigger_housing_height = max(grip_height,
                             trigger_height + sear_block_height + sear_block_padding);
trigger_housing_length = sear_block_length
                       + (sear_block_padding*2)
                       + trigger_track_extra;
trigger_housing_width = max(
  sear_block_width + (sear_block_padding*2),
  grip_width);

module trigger() {
  translate([0,0,-trigger_height])
  difference() {

    // Trigger
    translate([0,-trigger_width/2,0])
    cube([trigger_length, trigger_width, trigger_height]);

    // Sear Hole
    translate([-0.01, -sear_hole_width/2,-0.01])
    color("Red")
    cube([sear_hole_length + 0.01,
           sear_hole_width,
           trigger_height + 0.02]);

    // Angle cutter
    difference() {
      translate([0,0,trigger_height])
      rotate([0,45,0])
      translate([0,-trigger_angle_cutter_width/2,-2])
      color("Blue")
      cube([
        trigger_angle_cutter_length,
        trigger_angle_cutter_width,
        2]);

      translate([
        sear_hole_length,
        -0.1-trigger_angle_cutter_width/2,
        -0.1])
      cube([2,trigger_angle_cutter_width + 0.2,2]);
    }


    // Shave the point off the back
    translate([
      -trigger_travel-0.5,
      -(trigger_width/2)-0.1,
      sear_block_height - sear_block_padding])
    cube([1, trigger_width+0.2, 1]);
  }
}


module sear_block() {
  difference() {

    // Sear block body
    translate([
      -sear_block_length/2,
      -sear_block_width/2,
      -sear_block_height])
    difference() {
      cube([sear_block_length, sear_block_width, sear_block_height]);

       // Sear Block Angle Cutter
      translate([0,-0.1,sear_block_height])
      rotate([0,45,0])
      translate([-0.1,0,0])
      cube([2, sear_block_width + 0.2, 1]);

      // Shave the point off the top
      translate([-0.1,-0.1,sear_block_height - sear_block_padding])
      cube([1, sear_block_width + 0.2, 1]);
    }

    // Sear Hole
    translate([0,0,-sear_block_height-0.1])
    cylinder(r=sear_diameter/2, h=sear_block_height + 0.2);
  }
}

module trigger_housing() {
  trigger_cutter_height = trigger_height + (trigger_clearance*2);
  sear_cutter_height    = trigger_height + sear_block_height_extra + (sear_block_clearance*2);

  difference() {

    // Housing
    color("Brown", 0.3)
    translate([
      -sear_block_length + sear_block_padding,
      -trigger_housing_width/2,
      -trigger_housing_height])
    cube([
      trigger_housing_length,
      trigger_housing_width,
      trigger_housing_height]);

    // Tracks
    color("White")
    translate([0,0,-trigger_vertical_offset])
    union() {

      // Trigger Track
      translate([
        -sear_block_length/2 - sear_block_padding - 0.01,
        -(trigger_width/2) - trigger_clearance,
        -trigger_height-trigger_clearance])

      difference() {

        // Main cutter for the trigger path
        cube([
          2,
          trigger_width + (trigger_clearance*2),
          trigger_cutter_height]);

        // Leave a notch to keep the sear track whole
        translate([
          -1 + sear_block_padding + sear_block_clearance,
          -0.1,
          -1.01 + (trigger_height/2) + sear_block_padding])
        cube([1, trigger_width + 0.2,1]);
      }

      // Sear Block Track
      translate([
        -sear_block_length/2 - sear_block_clearance,
        -(sear_block_width/2) - sear_block_clearance,
        -sear_cutter_height + sear_block_clearance])
      cube([
        sear_block_length + (sear_block_clearance*2),
        sear_block_width + (sear_block_clearance*2),
        sear_cutter_height]);
      }

      // Sear Track
      translate([0,0,-(trigger_travel*3) - sear_block_padding])
      cylinder(r=sear_diameter/2 + sear_rod_clearance, h=trigger_travel*2);
  }

}



translate([0,0,-tee_overlap]) {
  color("Yellow")
  translate([0, 0, - trigger_height/2 + sear_block_padding -trigger_vertical_offset])
  sear_block();

  color("Red")
  translate([trigger_x_compressed,0,-trigger_vertical_offset])
  trigger();

  color("Purple", 0.25)
  trigger_housing();
}






// Sear Rod
translate([0,0,-sear_length/2])
%cylinder(r=(sear_diameter/2), h=sear_length, $fn=20);

ar_tee_housing(
  v =  -1/4 + sear_block_clearance*2,
  h = 1/2,
  tee_overlap         = tee_overlap,
  tee_clearance       = 1/64);


%receiver();
