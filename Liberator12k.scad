include <Components.scad>;
include <Pipe.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;

// Configurable Settings
tee_overlap             = 1/16;
housing_pin_diameter    = 3/16;
housing_pin_length      = 3/16;
sear_block_padding      = 5/32;
sear_collar_padding     = 1/16;
trigger_padding         = 1/4;
trigger_wing_height     = 1/8;
trigger_wing_width      = 1/8;
trigger_wing_length     = 5/16;
trigger_protrousion     = 0;
trigger_overtravel      = 1/32;
sear_spring_height      = 1/8;
trigger_housing_length_extra = 1/4;

// Vitamin measurements
firing_pin_diameter        = 1/4;
firing_pin_collar_diameter = 1/2;
firing_pin_collar_height   = 1/4;
sear_diameter              = 1/4;
sear_collar_diameter       = 1/2;
sear_collar_height         = 0.277;
grip_width                 = 0.85;
grip_height                = 1.27;

// Clearances
firing_pin_collar_clearance = 1/64;  // Adds to the trigger travel
housing_pin_clearance       = 1/32;  // Housing pin socket
sear_rod_clearance          = 1/32;  // Sear rod path
sear_collar_clearance       = 1/64;  // Sear collar pockets
sear_block_clearance        = 1/128; // Sear block path
sear_block_rod_clearance    = 1/64;  // Widens the hole in the sear block
trigger_clearance           = 1/128; // Trigger path

// Calculated: Trigger Geometry
trigger_travel           = (firing_pin_collar_diameter - firing_pin_diameter)/2 + trigger_overtravel;
sear_block_width         = sear_diameter + (sear_block_padding*2);
sear_block_height        = trigger_travel + (sear_block_padding*2);
trigger_height           = sear_block_height + trigger_travel;
trigger_width            = sear_block_width;

// Calculated: Trigger
trigger_sear_slot_width  = sear_diameter + sear_rod_clearance;
trigger_sear_slot_length = trigger_travel + sear_diameter + sear_rod_clearance;
trigger_wing_span        = trigger_width + trigger_wing_width;
trigger_track_height     = trigger_height + trigger_clearance;
trigger_track_width      = trigger_width + (trigger_clearance*2);

// Calculated: Sear block
sear_collar_pocket_height        = sear_collar_height + (sear_collar_clearance*2);
sear_collar_pocket_radius        = (sear_collar_diameter + sear_collar_clearance)/2;
sear_block_length                = sear_diameter + (sear_block_padding*2);
sear_block_hole_radius           = sear_diameter/2 + sear_block_rod_clearance/2;
sear_block_track_width           = sear_block_width + (sear_block_clearance*2);
sear_block_track_length          = sear_block_length + (sear_block_clearance*2);
sear_block_track_height          = sear_block_height + trigger_travel;
trigger_housing_internal_top     = sear_collar_padding         // Top collar pocket, top padding
                                   + sear_collar_pocket_height // Collar pocket
                                   + sear_collar_padding;      // Top collar pocket, bottom padding
trigger_housing_internal_bottom  = trigger_housing_internal_top + sear_block_track_height;

// Calculated: Trigger Housing
trigger_housing_length       = trigger_housing_length_extra
                               + max(sear_block_length + (sear_block_padding*2), // Sear track and padding

                                   // OR
                                   trigger_wing_length + trigger_travel // Track for the trigger wings
                                   + sear_block_padding*2)              // Front and rear walls

					  // AND
                                 + trigger_housing_length_extra;
trigger_housing_width        = max(trigger_wing_span + sear_block_padding,
                                   grip_width);
trigger_housing_height       = max(grip_height,
                                   sear_collar_pocket_height + sear_collar_padding*2 // Top collar pocket
                                 + max(trigger_track_height,sear_block_track_height) // Sear or trigger cutter, whichever is larger
                                 + sear_collar_pocket_height + sear_collar_padding // Bottom collar pocket
                                 + trigger_travel
                                 + sear_spring_height);

// Calculated:
trigger_rear_height        = 1/4;
trigger_length             = trigger_housing_length + trigger_protrousion;
trigger_angle_cutter_width = trigger_width * 1.1;
trigger_rear_cutter_height = trigger_height - trigger_rear_height;
trigger_x_extended         = -sear_diameter;
trigger_x_compressed       = -sear_diameter -trigger_travel;

module trigger() {

  // Trigger
  translate([0,0,-trigger_height])
  difference() {

    union() {
      difference() {
        // Trigger Main body
        translate([0,-trigger_width/2,0])
        cube([trigger_length, trigger_width, trigger_height]);


        // Angle cutter
        translate([0,0,trigger_height])
        rotate([0,45,0])
        translate([0,-trigger_width/2 - 0.1,-trigger_height-trigger_width])
        color("Blue")
        cube([
          1,
          trigger_width + 0.2,
          trigger_height+trigger_width]);
      }

      // Trigger Wings
      translate([
        0,
        -trigger_wing_span/2,
        trigger_height - trigger_wing_height])
       cube([
        trigger_wing_length,
        trigger_wing_span,
          trigger_wing_height]);
    }

    // Sear Slot
    translate([-0.1, -trigger_sear_slot_width/2,-0.1])
    color("Red")
    cube([trigger_sear_slot_length + 0.1,
           trigger_sear_slot_width,
           trigger_height + 0.2]);
  }
}

module sear_block() {
  difference() {

    // Sear block body
    translate([0,
      -sear_block_width/2,
      0])
    difference() {

      // Sear block main body
      translate([-sear_block_length/2,0,0])
      cube([sear_block_length, sear_block_width, sear_block_height]);

      // Sear Block Angle Cutter
      translate([sear_block_padding,-0.1,sear_block_height/2])
      rotate([0,45,0])
      translate([-pyth_A_B(sear_block_width, sear_block_height)/2,0,0])
      cube([pyth_A_B(sear_block_width, sear_block_height), sear_block_width + 0.2, 1]);
    }

    // Sear Hole
    translate([0,0,-0.1])
    cylinder(r=sear_block_hole_radius, h=sear_block_height + 0.2);
  }
}

module trigger_housing() {

  difference() {

    // Housing
    color("LightGreen")
    translate([
      -trigger_housing_length/2,
      -trigger_housing_width/2,
      -trigger_housing_height])
    cube([
      trigger_housing_length,
      trigger_housing_width,
      trigger_housing_height]);

    // Top sear collar pocket
    translate([0,0,-sear_collar_pocket_height/2  -sear_collar_padding])
    cylinder(r=sear_collar_pocket_radius,
              h=sear_collar_pocket_height,
              center=true);


    // Sear Block Track
    translate([
      0,
      -sear_block_clearance,
      -trigger_housing_internal_top - sear_block_track_height/2])
    cube([
      sear_block_track_length,
      sear_block_track_width,
      sear_block_track_height], center=true);

    // Trigger Track
    translate([
      trigger_x_compressed,
      -(trigger_width/2) - trigger_clearance,
      -trigger_height - trigger_housing_internal_top])
    union() {

        // Main cutter for the trigger path
        translate([0,-trigger_clearance,0])
        cube([
          trigger_housing_length + 0.1,
          trigger_track_width,
          trigger_track_height]);

      // Trigger Wings Track
      translate([
        0,
        -trigger_wing_span/2 + trigger_width/2,
        trigger_height - trigger_wing_height - trigger_clearance])
      cube([
        trigger_wing_length + trigger_travel + trigger_clearance*2,
        trigger_wing_span + trigger_clearance*2,
        trigger_wing_height + trigger_clearance]);
    }

    // Sear Track
    translate([0,0,-trigger_housing_height + sear_block_padding])
    cylinder(r=sear_diameter/2 + sear_rod_clearance, h=trigger_housing_height + 0.1);
  }

  color("Yellow")
  translate([0, 0, -trigger_housing_internal_top - sear_block_height - trigger_travel])
  %sear_block();

  color("Red")
  translate([trigger_x_compressed,0,-trigger_housing_internal_top])
  %trigger();

  color("Red")
  translate([trigger_x_extended,0,-trigger_housing_internal_top])
  *%trigger();
}


module housing() {
  *%receiver();

  vertical_spacing = trigger_housing_internal_top + sear_block_padding*2 - sear_block_clearance*2;

  // Housing and trigger
  union() {

    // 3/4 Tee Housing with AR-15 Grip
    ar_tee_housing(
      v =  -trigger_housing_height + grip_height,
      h = -7/16,
      mount_height = trigger_housing_height - grip_height,
      mount_length = 0,
      tee_overlap         = tee_overlap,
      tee_clearance       = 1/64,
      sear_hole_diameter  = sear_diameter + sear_rod_clearance);

    // Trigger
    translate([0,0,0])
    trigger_housing();
  }
}

module housing_pin(male=true) {
  rotate([90,0,0])
  if (male) {
    cube([housing_pin_diameter,housing_pin_diameter,housing_pin_length], center=true);
  } else {
    cube([
      housing_pin_diameter+housing_pin_clearance,
      housing_pin_diameter+housing_pin_clearance,
      housing_pin_length + housing_pin_clearance], center=true);
  }
}

module housing_left() {
  rotate([-90,0,0])
  union() {
    difference() {
      housing();

      translate([0,-1,0])
      cube([10,2,10], center=true);

      // Top back housing pin socket
      translate([-3_4_tee_width/2,0,3_4_tee_rim_z_min - housing_pin_diameter/2 - tee_overlap])
      #housing_pin(male=false);
    }

    // Bottom front housing pin
    translate([
      sear_diameter/2 + sear_block_padding + housing_pin_diameter/2,
      0,
      -trigger_housing_height + housing_pin_diameter])
    housing_pin(male=true);
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
      #housing_pin(male=false);
    }

    // Top back housing pin
    translate([-3_4_tee_width/2,0,3_4_tee_rim_z_min - housing_pin_diameter/2 - tee_overlap])
    housing_pin(male=true);
  }
}


// Scale up to metric for printing
scale([25.4,25.4,25.4]) {

  // Position the sear block
  translate([1.5,0,0])
  sear_block();

  // Position the trigger
  translate([-2.7,0,0])
  rotate([180,0,0])
  trigger();

  // Position the left and right housing
  translate([0,0,3_4_tee_rim_od/2 + tee_overlap]) {
//  translate([0,0,trigger_housing_width/2]) {
    translate([0,-1.9,0])
    rotate([0,0,-30])
    housing_right();

    translate([0,1.9,0])
    rotate([0,0,30])
    housing_left();
  }
}
