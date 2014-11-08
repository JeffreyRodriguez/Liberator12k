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
    cylinder(r=sear_block_hole_radius, h=sear_block_height + 0.2);
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
      -trigger_housing_internal_top - sear_block_track_height/2 + sear_block_clearance])
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

    // Top alignment pins
    translate([0,0,-alignment_pin_diameter]) {

      // Back
      translate([-trigger_housing_length/2 + alignment_pin_diameter, 0, 0])
      alignment_pin(male=true);

      // Front
      translate([trigger_housing_length/2 - alignment_pin_diameter, 0, 0])
      alignment_pin(male=true);
    }

    // Bottom alignment pins
    translate([0,0,-trigger_housing_height + alignment_pin_diameter]) {

        // Front
        translate([-sear_diameter/2 - alignment_pin_diameter,0,0])
        alignment_pin(male=true);

        // Back
        translate([sear_diameter/2 + alignment_pin_diameter,0,0])
        alignment_pin(male=true);
    }

    // Spring Block
    difference() {
      translate([
        -sear_diameter/2 - sear_block_padding,
        -sear_diameter/2 - sear_block_padding - sear_block_clearance,
        -trigger_housing_height])
      cube([
        sear_diameter + sear_block_padding*2,
        sear_diameter + sear_block_padding*2 ,
        sear_spring_height + trigger_housing_padding + trigger_travel + max(sear_block_clearance, trigger_clearance)]);

      // Sear Hole
      translate([0,0,-trigger_housing_height + trigger_housing_padding])
      cylinder(r=sear_diameter/2 + sear_rod_clearance, h=trigger_housing_height + trigger_housing_padding);
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

      // Top alignment sockets
      translate([0,0,-alignment_pin_diameter]) {

        // Back
        translate([-trigger_housing_length/2 + alignment_pin_diameter, 0, 0])
        alignment_pin(male=false);

        // Front
        translate([trigger_housing_length/2 - alignment_pin_diameter, 0, 0])
        alignment_pin(male=false);
      }

      // Bottom alignment sockets
      translate([0,0,-trigger_housing_height + alignment_pin_diameter]) {

        // Front
        translate([-sear_diameter/2 - alignment_pin_diameter,0,0])
        alignment_pin(male=false);

        // Back
        translate([sear_diameter/2 + alignment_pin_diameter,0,0])
        alignment_pin(male=false);
      }

      // Spring Block Socket
      translate([
        -sear_diameter/2 - sear_block_clearance - sear_block_padding,
        -sear_diameter/2 - sear_block_padding,
        -trigger_housing_height])
      #cube([
        sear_diameter + sear_block_clearance*2 + sear_block_padding*2,
        sear_diameter + sear_block_padding*2,
        sear_spring_height + trigger_housing_padding + trigger_travel + max(sear_block_clearance, trigger_clearance)*2]);

    }
  }
}

*union() {
  %receiver();
  trigger_housing_right();
}


// Trigger Housing Printable Prototype: Scale up to metric for printing
*scale([25.4,25.4,25.4]) {
  translate([-trigger_housing_height/2,trigger_housing_height + 1,trigger_housing_width/2])
  rotate([-90,0,])
  trigger_housing_left();

  translate([-trigger_housing_height/2,-trigger_housing_height - 1,trigger_housing_width/2])
  rotate([90,0,0])
  trigger_housing_right();

  rotate([0,180,0])
  trigger();

}