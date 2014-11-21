//$t=1;

include <Components.scad>;
include <Receiver.scad>;


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
    #cylinder(r=sear_block_hole_radius, h=sear_block_height + 2);
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
        -trigger_housing_height])
      cube([
        sear_block_track_length,
        sear_block_track_width - sear_block_clearance,
        trigger_housing_spring_block_height + sear_block_clearance]);

    }
  }
}

*union() {
  %receiver();
  trigger_housing_right();
}

*!trigger_housing_left();
*!trigger_housing_right();

// Trigger Housing Printable Prototype: Scale up to metric for printing
*scale([25.4,25.4,25.4]) {
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
