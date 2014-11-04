include <Components.scad>;
include <Pipe.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;

tee_overlap = 1/16;

trigger_travel = 3/8;
sear_tee_clearance = 2/16;
sear_diameter = 1/4;
sear_rod_clearance = 1/64;
sear_block_rod_clearance = 1/64;
sear_block_clearance = 1/128;
trigger_clearance    = 1/128;
sear_block_padding = 1/8;
trigger_width = sear_diameter + (sear_block_padding*2);
sear_block_width = trigger_width;
sear_block_length = sear_diameter + (sear_block_padding*2);
sear_top_clearance = 1/64;
sear_block_height_extra = sear_block_padding;
sear_block_height = trigger_travel + sear_block_height_extra + sear_block_padding;
sear_x = -((3_4_tee_id/2) - (sear_diameter/2) - sear_tee_clearance);


sear_hole_width = sear_diameter + sear_rod_clearance;
sear_hole_length = trigger_travel + sear_diameter + sear_rod_clearance;


grip_width = 0.85;
grip_height = 1.27;
trigger_height = trigger_travel * 2;
trigger_vertical_offset = 1/8;
trigger_housing_length_extra = trigger_travel - sear_block_padding;
trigger_housing_length = sear_block_length
                       + (sear_block_padding*2)
                       + trigger_housing_length_extra;
trigger_housing_width = max(
  sear_block_width + (sear_block_padding*2),
  grip_width);
trigger_housing_height = max(grip_height,
                             trigger_height + sear_block_height + sear_block_padding + trigger_vertical_offset);


sear_rod_length = trigger_travel*2 + trigger_vertical_offset + 3_4_tee_center_z + trigger_height;

trigger_rear_height = 1/4;
trigger_protrousion = 1/4;
trigger_length = trigger_housing_length + sear_block_padding + trigger_protrousion;
trigger_angle_cutter_width = trigger_width * 1.1;
trigger_angle_cutter_length = 2;
trigger_angle_cutter_height = 2;
trigger_rear_cutter_height = trigger_height - trigger_rear_height;
trigger_x_extended = -sear_diameter;
trigger_x_compressed = trigger_x_extended - trigger_travel + (sear_diameter/2);

trigger_wing_length = trigger_travel;
trigger_wing_width  = trigger_width + 3/16; // <- Half of this fraction on each side
trigger_wing_height = 1/8;

module trigger() {

  // Trigger
  translate([0,0,-trigger_height])
  difference() {

    union() {
      // Trigger Main body
      translate([0,-trigger_width/2,0])
      cube([trigger_length, trigger_width, trigger_height]);

      // Trigger Wings
      translate([
        sear_block_padding,
        -trigger_wing_width/2,
        trigger_height - trigger_wing_height])
       cube([
        trigger_wing_length,
        trigger_wing_width,
          trigger_wing_height]);
    }

    // Sear Hole
    #translate([-0.01, -sear_hole_width/2,-0.01])
    color("Red")
    cube([sear_hole_length + 0.01,
           sear_hole_width,
           trigger_height + 0.02]);

    // Angle cutter
    translate([0,0,trigger_height])
    difference() {
      rotate([0,45,0])
      translate([0,-trigger_angle_cutter_width/2,-2])
      color("Blue")
      cube([
        trigger_angle_cutter_length,
        trigger_angle_cutter_width,
        2]);

      translate([-0.1,-trigger_width/2 - 0.1,-sear_block_padding])
      cube([sear_block_padding + 0.2, trigger_width + 0.2,sear_block_padding]);
    }


    // Shave the point off the back
    #translate([
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
    cylinder(r=sear_diameter/2 + sear_rod_clearance/2, h=sear_block_height + 0.2);
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

      union() {
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

        // Trigger Wings Track
        translate([
          trigger_clearance,
          -trigger_wing_width/2 + trigger_width/2,
          trigger_height - trigger_wing_height])
        cube([
          trigger_wing_length*2 + trigger_clearance*2,
          trigger_wing_width + trigger_clearance*2,
          trigger_wing_height + trigger_clearance*2]);
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
  }

  color("Yellow")
  translate([0, 0, - trigger_height/2 + sear_block_padding -trigger_vertical_offset])
  %sear_block();

  color("Red")
  translate([trigger_x_compressed,0,-trigger_vertical_offset])
  %trigger();

}

module housing() {
  %receiver();

  vertical_spacing = trigger_vertical_offset + sear_block_padding*2 - sear_block_clearance*2;

  // Housing and trigger
  difference() {
  union() {

    // 3/4 Tee Housing with AR-15 Grip
    ar_tee_housing(
      v =  -vertical_spacing,
      h = -7/16,
      mount_height = vertical_spacing,
      mount_length = 1/8,
      tee_overlap         = tee_overlap,
      tee_clearance       = 1/64);

    // Trigger
    translate([0,0,-tee_overlap])
    trigger_housing();
  }

    // Sear Track
    translate([0,0,-(trigger_travel*3) - sear_block_padding*2 - trigger_vertical_offset])
    cylinder(r=sear_diameter/2 + sear_rod_clearance, h=sear_rod_length);
  }
}

housing_pin_diameter = 1/4;
housing_pin_length   = 1/8;
housing_pin_clearance = 1/128;

module housing_pin(male=true) {
  rotate([90,0,0])
  if (male) {
    cylinder(
      r=housing_pin_diameter/2,
      h=housing_pin_length + housing_pin_clearance,
      center=true);
  } else {
    cylinder(
      r=housing_pin_diameter/2 + housing_pin_clearance,
      h=housing_pin_length + housing_pin_clearance,
      center=true);
  }

}

module housing_left() {
  rotate([-90,0,0])
  union() {
    difference() {
      housing();

      translate([0,-1,0])
      cube([10,2,10], center=true);

      // Bottom front housing pin
      translate([
        sear_diameter/2 + sear_block_padding + housing_pin_diameter/2,
        0,
        -trigger_housing_height + housing_pin_diameter])
      housing_pin(male=false);
    }

    // Top back housing pin socket
    translate([-3_4_tee_width/2,0,3_4_tee_rim_z_min - housing_pin_diameter/2 - tee_overlap])
    housing_pin();
  }
}

module housing_right() {
  rotate([90,0,0])
  union() {
    difference() {
      housing();

      translate([0,1,0])
      cube([10,2,10], center=true);

      // Bottom front housing pin socket
      translate([
        sear_diameter/2 + sear_block_padding + housing_pin_diameter/2,
        0,
        -trigger_housing_height + housing_pin_diameter])
      housing_pin(male=false);
    }

    // Top back housing pin
    translate([-3_4_tee_width/2,0,3_4_tee_rim_z_min - housing_pin_diameter/2 - tee_overlap])
      housing_pin(male=false);
  }
}



scale([25.4,25.4,25.4]) {

sear_block();

rotate([180,0,0])
trigger();

translate([0,2,0])
housing_right();

translate([0,-2,0])
housing_left();
}
