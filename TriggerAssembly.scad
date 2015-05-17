//$t=1;

include <Vitamins/Rod.scad>;
include <Vitamins/Pipe.scad>;

// Centerline for firing pin and tee body
centerline_z  = 3_4_tee_center_z; // OK

breech_face_x = (3_4_tee_width/2) + 3_4_x_1_8_bushing_depth;



// Configurable Settings
sear_block_padding      = 5/32;
sear_collar_padding     = 1/16; // Between the bottom of the sear collar and top of the tracks
trigger_padding         = 1/8;
trigger_wing_height     = 1/8;
trigger_wing_width      = 1/4;
trigger_wing_length     = 1/2;
trigger_protrousion     = 1/2;
trigger_overtravel      = 1/16;
sear_spring_height      = 1/4;

trigger_housing_padding_back = 1/16;
trigger_housing_padding_front = 12/32;
trigger_housing_padding_sides = 1/16;
trigger_housing_padding_top = 1/16;
trigger_housing_padding_bottom = 1/8;

// Configurable: Components
firingPin = RodOneEighthInch;
searPin   = RodOneEighthInch;

// Clearances
firing_pin_collar_clearance = 1/64;  // Adds to the trigger travel
alignment_pin_clearance     = 2/128; // Housing pin socket
sear_rod_clearance          = 1/64;  // Sear rod path
sear_collar_clearance       = 1/64;  // Sear collar pocket
sear_block_clearance        = 1/128; // Sear block path
sear_block_rod_clearance    = 1/64;  // Widens the hole in the sear block
trigger_clearance           = 1/128; // Trigger path

// Vitamin measurements
firing_pin_diameter        = 1/4;
firing_pin_collar_diameter = 1/2;
firing_pin_collar_height   = 1/4;
sear_diameter              = 1/8;
sear_collar_diameter       = 1/2;
sear_collar_height         = 0.27;
grip_width                 = 0.85;
grip_height                = 1.27;

// Calculated: Trigger Geometry
trigger_travel           = (firing_pin_collar_diameter - firing_pin_diameter)/2 + trigger_overtravel;
sear_block_width         = sear_diameter + (sear_block_padding*2);
sear_block_height        = trigger_travel + sear_block_padding;
trigger_height           = sear_block_height + trigger_travel;

// Calculated: Trigger
trigger_sear_slot_width  = sear_diameter + sear_rod_clearance;
trigger_sear_slot_length = trigger_travel + sear_diameter + sear_rod_clearance;
trigger_width            = trigger_sear_slot_width + trigger_padding;
trigger_wing_span        = trigger_width + trigger_wing_width;
trigger_wing_x_offset    = sear_block_padding;
trigger_track_height     = trigger_height + trigger_clearance*2;
trigger_track_width      = trigger_width + (trigger_clearance*2);

// Calculated: Sear block
sear_collar_pocket_height        = sear_collar_height + (sear_collar_clearance*2);
sear_collar_pocket_radius        = (sear_collar_diameter + sear_collar_clearance)/2;
sear_block_length                = sear_diameter + (sear_block_padding*2);
sear_block_hole_radius           = sear_diameter/2 + sear_block_rod_clearance/2;
sear_block_track_width           = sear_block_width + (sear_block_clearance*2);
sear_block_track_length          = sear_block_length + (sear_block_clearance*2);
sear_block_track_height          = sear_block_height + trigger_travel + sear_block_clearance;

// Calculated: Trigger Housing
trigger_housing_internal_top     = trigger_housing_padding_top         // Top collar pocket, top padding
                                 + sear_collar_pocket_height           // Collar pocket
                                 + sear_collar_padding;                // Top collar pocket, bottom padding
trigger_housing_x_back         = - trigger_housing_padding_back
                                 - max(-sear_collar_diameter/2 - sear_collar_clearance, sear_diameter/2 + sear_block_padding);
trigger_housing_length         = max(sear_block_length,trigger_wing_length/2 + trigger_travel)
                                 + trigger_housing_padding_back
                                 + trigger_housing_padding_front;
trigger_housing_width          = max(trigger_wing_span + trigger_housing_padding_sides,
                                     grip_width);
trigger_housing_height                 = max(grip_height,
                                             trigger_housing_internal_top                        // Top collar pocket
                                             + max(trigger_track_height,sear_block_track_height) // Sear or trigger cutter, whichever is larger
                                             + trigger_travel
                                             + sear_spring_height
                                             + trigger_housing_padding_top
                                             + trigger_housing_padding_bottom);
trigger_housing_top_pin_height      = sear_collar_height;
trigger_housing_spring_block_height = trigger_housing_height - trigger_housing_internal_top - sear_block_track_height;
trigger_housing_pin_width    = trigger_width;
trigger_housing_pin_length   = trigger_housing_padding_front/2;

trigger_housing_internal_bottom = trigger_housing_internal_top - sear_block_track_height;

// Calculated:
trigger_rear_height        = 1/4;
trigger_length             = trigger_housing_length/2 + sear_diameter + trigger_protrousion;
trigger_x_extended         = -sear_diameter + trigger_travel;
trigger_x_compressed       = -sear_diameter;

// Calculated: Sear Collar Pocket
sear_collar_alignment_pin_height = sear_collar_height + sear_collar_padding*2 + sear_collar_clearance*2;


module sear_block(rod=searRod) {
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
    cylinder(r=sear_block_hole_radius, h=sear_block_height + 2);
  }
}

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
        translate([-1/2,-trigger_width/2 - 0.1,-trigger_height-trigger_width])
        color("Blue")
        cube([
          2,
          trigger_width + 0.2,
          trigger_height+trigger_width]);
      }

      // Trigger Wings
      translate([
        trigger_wing_x_offset,
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

module trigger_housing() {

  difference() {

    // Housing
    color("LightGreen")
    translate([
      trigger_housing_x_back,
      -trigger_housing_width/2,
      -trigger_housing_height])
    cube([
      trigger_housing_length,
      trigger_housing_width,
      trigger_housing_height]);


    // Sear collar pocket
    translate([0,0,-sear_collar_pocket_height/2 - trigger_housing_padding_top])
    cylinder(r=sear_collar_pocket_radius,
              h=sear_collar_pocket_height,
              center=true);


    // Sear Block Track
    translate([
      -sear_block_track_length/2,
      -sear_block_track_width/2 - sear_block_clearance,
      -trigger_housing_internal_top -sear_block_track_height])
    cube([
      sear_block_track_length,
      sear_block_track_width,
      sear_block_track_height]);

    // Trigger Track
    translate([
      trigger_x_compressed - trigger_clearance,
      -(trigger_width/2) - trigger_clearance,
      -trigger_height - trigger_housing_internal_top - trigger_clearance])
    union() {

        // Main cutter for the trigger path
        translate([0,0,-trigger_clearance])
        cube([
          trigger_housing_length + 0.1,
          trigger_track_width,
          trigger_track_height]);

      // Trigger Wings Track
      translate([
        trigger_wing_x_offset,
        -trigger_wing_span/2 + trigger_width/2,
        trigger_height - trigger_wing_height - trigger_clearance])
      cube([
        trigger_wing_length + trigger_travel + trigger_clearance*2,
        trigger_wing_span + trigger_clearance*2,
        trigger_wing_height + trigger_clearance * 2]);
    }

    // Sear Track
    translate([0,0,-trigger_housing_height + sear_block_padding])
    cylinder(r=sear_diameter/2 + sear_rod_clearance, h=trigger_housing_height + 0.1);
  }

  color("Yellow")
  translate([0, 0, -trigger_housing_internal_top - sear_block_height - (trigger_travel*$t)])
  %sear_block();

  color("Red")
  translate([trigger_x_extended - (trigger_travel*$t),0,-trigger_housing_internal_top])
  %trigger();
}

module trigger_housing_right() {
  union() {
    difference() {
      trigger_housing();

      // Cut off the left side
      translate([0,1,0])
      cube([10,2,10], center=true);

    }

    // Top alignment pin
    translate([
      sear_collar_diameter/2,
      -trigger_housing_pin_width/2,
      -trigger_housing_top_pin_height - trigger_housing_padding_top - alignment_pin_clearance])
    cube([
      trigger_housing_pin_length,
      trigger_housing_pin_width,
      trigger_housing_top_pin_height]);

    // Bottom alignment pin
    translate([
      sear_diameter/2 + sear_block_padding - alignment_pin_clearance,
      -trigger_housing_pin_width/2,
      -trigger_housing_height + trigger_housing_padding_bottom])
    cube([
      trigger_housing_pin_length + alignment_pin_clearance,
      trigger_housing_pin_width,
      sear_spring_height]);

    // Spring Block
    difference() {
      translate([
        -sear_block_track_length/2 + alignment_pin_clearance,
        -sear_block_track_width/2 - alignment_pin_clearance,
        -trigger_housing_height])
      cube([
        sear_block_track_length - alignment_pin_clearance*2,
        sear_block_track_width,
        trigger_housing_spring_block_height]);

      // Sear Hole
      translate([0,0,-trigger_housing_height + trigger_housing_padding_bottom])
      cylinder(r=sear_diameter/2 + sear_rod_clearance, h=trigger_housing_height + trigger_housing_padding_bottom);
    }
  }
}

module trigger_housing_left() {
  union() {
    difference() {
      trigger_housing();

      // Cut off the right side
      translate([0,-1,0])
      cube([10,2,10], center=true);

      // Top alignment socket
      translate([
        sear_collar_diameter/2 - alignment_pin_clearance,
        -trigger_housing_pin_width/2-alignment_pin_clearance,
        -trigger_housing_top_pin_height - trigger_housing_padding_top - alignment_pin_clearance*2])
      cube([
        trigger_housing_pin_length + alignment_pin_clearance*2,
        trigger_housing_pin_width + alignment_pin_clearance*2,
        trigger_housing_top_pin_height + alignment_pin_clearance*2]);

      // Bottom alignment socket
      translate([
        sear_diameter/2 + sear_block_padding - alignment_pin_clearance,
        -trigger_housing_pin_width/2 - alignment_pin_clearance,
        -trigger_housing_height + trigger_housing_padding_bottom - alignment_pin_clearance])
      cube([
        trigger_housing_pin_length + alignment_pin_clearance*2,
        trigger_housing_pin_width + alignment_pin_clearance*2,
        sear_spring_height + alignment_pin_clearance*2]);

      // Spring Block Socket
      translate([
        -sear_block_track_length/2,
        -sear_block_track_width/2,
        -trigger_housing_height - 0.1])
      cube([
        sear_block_track_length,
        sear_block_track_width - sear_block_clearance,
        trigger_housing_spring_block_height + sear_block_clearance + 0.1]);

    }
  }
}

function trigger_angle() = 90;
function sear_travel() = ((3/4) - (1/8))/2;
function trigger_travel() = sin(90 - trigger_angle()) * sear_travel();

function sear_rod() = RodOneEighthInch;

function sear_side() = 3/8;

function trigger_travel_ratio(angle=trigger_angle()) = sin(90 - angle);

module sear(rod=sear_rod(),
            searTravel=sear_travel(),
            angle=trigger_angle()) {
  difference() {
    linear_extrude(height=3/8)
    polygon(points=[
            [0,0],
            [sear_side(),0],
            [sear_side(),(sear_side()-(sin(angle) * sear_side()))],
            [0, sear_side()]]);

    translate([3/16,-1,3/16])
    rotate([-90,0,0])
    Rod(rod=RodOneEighthInch, length=3, $fn=12);
  }
}

module searTrack(rod=sear_rod(),
            searTravel=sear_travel(),
            side=sear_side(),
            angle=trigger_angle()) {

  slopeHeight = (sin(angle) * side);

    polygon(points=[
            [0,0],
            [side + (trigger_travel_ratio()*side),0],
            [side + (trigger_travel_ratio()*side),(side-slopeHeight)+sear_travel()],
            [0, side+searTravel]]);
}



!scale([25.4, 25.4, 25.4]) {

  difference() {
    translate([0,5/16,0])
    %sear();


    translate([-1/16,0,0])
    cube([1,2,1/16 + 3/16]);

    #translate([0,0,1/16])
    linear_extrude(height=3/8)
    searTrack();
  }
  
}

*union() {
  %receiver();
  trigger_housing_right();
}

*trigger_housing_left();
*trigger_housing_right();

// Trigger Housing Printable Prototype: Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  translate([-trigger_housing_height/2,trigger_housing_height + 1,trigger_housing_width/2])
  rotate([-90,0,])
  trigger_housing_left();

  translate([-trigger_housing_height/2,-trigger_housing_height - 1,trigger_housing_width/2])
  rotate([90,0,0])
  trigger_housing_right();

  translate([-1,0,0])
  rotate([0,180,0])
  trigger();

  sear_block();

}
