include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <AR15 Grip Mount.scad>;

front_block_seal_length = 1;
front_block_overlap = 3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth;
front_rim_overlap = tee_overlap; // 3_4_tee_center_z - 3_4_tee_rim_width - 3_4_tee_rim_od/2;
front_block_length = 3_4_tee_rim_width + front_block_overlap;
front_block_x_offset = -3_4_tee_rim_width/2;
front_block_width = 3_4_tee_rim_od + (tee_overlap*2);
front_block_spindle_sleeve_width = cylinder_spindle_diameter + cylinder_spindle_wall*2;


bottom_block_wall = 3_4_tee_width/2 - 3_4_tee_rim_od/2 - 3_4_tee_rim_width;
module bottom_tee_housing(debug=false) {

  if (debug)
  translate([0,0,0])
  %3_4_tee();

  difference() {
    union() {

      // Front Tee Block Holder
      translate([3_4_tee_rim_od/2,-front_block_spindle_sleeve_width/2 - tee_overlap,-1/8])
      cube([(3_4_tee_width - 3_4_tee_rim_od)/2 + front_block_overlap + tee_overlap*2, front_block_spindle_sleeve_width + tee_overlap*2, 3_4_tee_rim_width  + 1/8]);

      // Rim Wall
      color("LightBlue")
      cylinder(r=3_4_tee_rim_od/2 + bottom_block_wall, h=3_4_tee_rim_width);
    }

    // Front Tee Block Hole
    translate([3_4_tee_rim_od/2 + bottom_block_wall,-front_block_spindle_sleeve_width/2,-1/8 -0.1])
    cube([front_block_length, front_block_spindle_sleeve_width, 3_4_tee_rim_width + 1/8 + 0.2]);

    // Tee Rim
    translate([0,0,-0.1])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.2);

    // Cylinder Spindle Hole
    translate([
      3_4_tee_rim_od/2 + bottom_block_wall,
      0,
      centerline_z - revolver_center_offset])
    rotate([0,90,0])
    cylinder(r=cylinder_spindle_diameter/2, h=(3_4_tee_width - 3_4_tee_rim_od)/2 + front_block_overlap + tee_overlap*2);
  }

}

module front_tee_housing(debug=false) {
  if (debug) {
    translate([-3_4_tee_width/2 + 3_4_tee_rim_width,0,0])
    %3_4_tee();
  }

  difference() {
    union() {

      // Backstrap
      translate([0,0,centerline_z + backstrap_offset])
      rotate([180,-90,0])
      difference() {
        backstrap(length = front_block_length);


        translate([-3_4_angle_stock_width + tee_overlap + 0.01,0,-0.1])
        cylinder(r=rope_od/2, h=back_block_length + 0.2);
      }

      // Main Body and Gas Sealing Pipe Holder
      translate([0,0,centerline_z])
      rotate([0,90,0])
      cylinder(r=3_4_tee_rim_od/2 + front_rim_overlap, h=front_block_length);

      // Spindle Block
      translate([0,
                 -cylinder_spindle_diameter/2 - cylinder_spindle_wall,
                 -1/8])
      cube([front_block_length,
            cylinder_spindle_diameter + cylinder_spindle_wall*2,
            centerline_z + 1/8]);

      // Bottom Block Bumper
      translate([0,-front_block_spindle_sleeve_width/2 - tee_overlap,3_4_tee_rim_width])
      cube([front_block_length, front_block_spindle_sleeve_width + tee_overlap*2,1]);
    }

    // Front Tee Rim
    translate([-0.1,0,centerline_z])
    rotate([0,90,0])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.1);

    // Gas Sealing Pipe Hole
    translate([3_4_tee_rim_width - 0.1,0,3_4_tee_center_z])
    rotate([0,90,0])
    1_pipe(length=front_block_overlap + 0.2, hollow=false, cutter=true);

    // Cylinder Spindle Hole
    translate([
      - 0.1,
      0,
      centerline_z - revolver_center_offset])
    rotate([0,90,0])
    cylinder(r=cylinder_spindle_diameter/2, h=front_block_length + 0.2);

    // Cylinder Spindle Shaft Collar Hole
    translate([
      -0.1,
      0,
      centerline_z - revolver_center_offset])
    rotate([0,90,0])
    cylinder(r=spindle_collar_diameter/2, h=spindle_collar_height + 0.1);

    // Spindle Shaft Collar Set Screw Hole
    translate([-0.1,-1/8,centerline_z - revolver_center_offset - spindle_collar_height*1.5])
    cube([spindle_collar_height + 0.1,1/4,spindle_collar_diameter/2]);
  }
}


back_block_overlap = slot_length;
back_block_x_offset = 3_4_tee_width/2 + back_block_overlap;
back_block_length = back_block_overlap + .25;
module back_tee_housing(debug=true) {

  if (debug) {
    translate([-3_4_tee_width/2 + 3_4_tee_rim_width,0,0])
    %3_4_tee();
  }

  difference() {
    union() {

      // Backstrap
      translate([0,0,centerline_z + backstrap_offset])
      rotate([180,-90,0])
      difference() {
        backstrap(length = back_block_length);

        translate([-3_4_angle_stock_width + tee_overlap + rope_od/2,0,-0.1])
        cylinder(r=rope_od/2, h=back_block_length + 0.2);
      }

      // Main Body and Stock Pipe Holder
      translate([0,0,centerline_z])
      rotate([0,90,0])
      cylinder(r=3_4_tee_rim_od/2 + tee_overlap, h=back_block_length);

      // AR15 Grip
      translate([0,0,3/16])
      rotate([0,0,180])
      #ar15_grip(mount_height=3_4_tee_center_z,mount_length=0, debug=debug);

      // AR15 Grip Support
      translate([slot_length,-slot_width/2,-.5])
      difference() {
        cube([.25,slot_width,1]);

        #translate([.01,slot_width*.1,.1])
        cube([.25,slot_width*.8,.8]);
      }
    }

    // Back Tee Rim
    translate([-0.5,0,centerline_z])
    rotate([0,90,0])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.5);

    // Stock Sleeve
    translate([-0.1,0,3_4_tee_center_z])
    rotate([0,90,0])
    3_4_pipe(length=back_block_length + 0.2, hollow=false, cutter=true, loose=true);
  }
}


module tee_housing_plater() {
  color("HotPink")
  rotate([0,90,0])
  translate([-front_block_length,1,-centerline_z])
  front_tee_housing();

  color("LightBlue")
  translate([-2.5,0,3_4_tee_rim_width])
  rotate([180,0,90])
  bottom_tee_housing();

  color("Orange")
  translate([0,-1.35,0])
  rotate([0,90,0])
  translate([-back_block_length,0,-centerline_z])
  back_tee_housing();
}

module tee_housing_reference() {
  translate([3_4_tee_width/2 - 3_4_tee_rim_width,0,0])
  front_tee_housing(debug=false);

  bottom_tee_housing(debug=true);

  rotate([0,0,180])
  translate([-3_4_tee_rim_width + 3_4_tee_width/2,0,0])
  back_tee_housing(debug=false);

  // Spindle
  %translate([
    3_4_tee_width/2 - 3_4_tee_rim_width,
    0,
    centerline_z - revolver_center_offset])
  rotate([0,90,0])
  cylinder(r=cylinder_spindle_diameter/2, h=10);

  // Spindle Shaft Collar
  translate([3_4_tee_width/2 - 3_4_tee_rim_width,0,0])
  %translate([
    -0.1,
    0,
    centerline_z - revolver_center_offset])
  rotate([0,90,0])
  cylinder(r=spindle_collar_diameter/2, h=spindle_collar_height + 0.1);

  // Backstrap
  translate([-3_4_tee_width/2 - back_block_overlap,0,centerline_z + backstrap_offset])
  rotate([0,90,0])
  rotate([0,0,-45])
  %3_4_angle_stock(length=12);

  // Gas Sealing Pipe
  translate([3_4_tee_width/2,0,3_4_tee_center_z])
  rotate([0,90,0])
  %1_pipe(length=front_block_length + chamber_protrusion);
}

//tee_housing_reference();
tee_housing_plater();
