include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;
include <AR15 Grip Mount.scad>;

function teeHousingPinRod() = RodOneEighthInch;

module front_tee_housing_pins(rod=teeHousingPinRod(), clearance=RodClearanceSnug, debug=false) {

    if (debug)
    %3_4_tee();

    // Top Pin
    translate([3_4_tee_width/2-3_4_tee_rim_width/2,0,3_4_tee_rim_width])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);

    // Bottom Pin
    translate([3_4_tee_width/2 + 3_4_tee_rim_width/2,0,0])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);
}

module back_tee_housing_pins(rod=teeHousingPinRod(), clearance=RodClearanceSnug, debug=false) {

    if (debug)
    %3_4_tee();

    // Back-Top Pin
    translate([-3_4_tee_width/2,0,3_4_tee_rim_width])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);
    // Back-Bottom Pin
    translate([-3_4_tee_width/2 - back_block_length/2,0,0])
    rotate([90,0,0])
    Rod(rod=rod, length=3_4_tee_rim_od + 0.2,
        center=true, clearance=clearance);
}

front_block_seal_length = 1;
front_block_overlap = 3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth;
front_rim_overlap = tee_overlap; // 3_4_tee_center_z - 3_4_tee_rim_width - 3_4_tee_rim_od/2;
front_block_length = 3_4_tee_rim_width + front_block_overlap;
front_block_x_offset = -3_4_tee_rim_width/2;
front_block_width = grip_width;
front_block_spindle_sleeve_width = cylinder_spindle_diameter + cylinder_spindle_wall*2;


bottom_block_wall = 3_4_tee_width/2 - 3_4_tee_rim_od/2 - 3_4_tee_rim_width;
bottom_block_height = 3_4_tee_rim_width*3;
bottom_block_width = 1.45;
module bottom_tee_housing(front_slot_width=grip_width +0.05,
                          front_slot_length=front_block_length +1,
                          back_slot_width=grip_width + 0.05,
                          back_slot_length=back_block_length + 1,
                          debug=false) {

  triggerPin = RodOneEighthInch;

  if (debug)
  translate([0,0,0])
  %3_4_tee();

  body_length = 3_4_tee_width + front_block_length + back_block_length -(3_4_tee_rim_width*2);

  difference() {
    intersection() {
      union() {

      // Tee Rim
      color("LightBlue")
      translate([0,0,-3_4_tee_rim_width])
      cylinder(r=3_4_tee_rim_od/2 + bottom_block_wall, h=bottom_block_height);

      // Body
      color("Orange")
        translate([-3_4_tee_width/2 - back_block_length + 3_4_tee_rim_width,
                   -bottom_block_width/2,
                   -3_4_tee_rim_width])
        cube([body_length,
             bottom_block_width,
            bottom_block_height]);
      }

      // Chamber the bottom and top of the body
      translate([-3_4_tee_width/2 - back_block_length + 3_4_tee_rim_width,0,-3_4_tee_rim_width*3])
      rotate([45,0,0])
      cube([body_length,1.55,1.55]);

      // Chamfer the front and back of the body
      translate([-3_4_tee_width/2 - back_block_length + 3_4_tee_rim_width -0.65,0,-3_4_tee_rim_width])
      rotate([0,0,-45])
      cube([body_length - 0.35, body_length - 0.35, bottom_block_height]);

      // Shave off the sides of the tee rim
      translate([-3_4_tee_width/2 - back_block_length + 3_4_tee_rim_width,
                 -(3_4_tee_rim_od/2) -(tee_overlap*1.5/2),
                 -3_4_tee_rim_width])
      cube([body_length, 3_4_tee_rim_od + tee_overlap*1.5, bottom_block_height]);
    }

    // Trigger Pin
    translate([0,0,-lookup(RodRadius, triggerPin)])
    rotate([90,0,0])
    #Rod(rod=triggerPin, length=3_4_tee_rim_od,
         center=true,clearance=RodClearanceSnug);
    translate([-lookup(RodRadius, triggerPin),-3_4_tee_rim_od/2,-lookup(RodRadius, triggerPin)])
    cube([lookup(RodDiameter, triggerPin), 3_4_tee_rim_od, 1/2]);

    // Trigger clearance
    // TODO: Cube or cylinder?
    translate([-3_4_tee_id/2,-3_4_tee_id/2,-3_4_tee_rim_width - 0.1])
    cube([3_4_tee_id, 3_4_tee_id,3_4_tee_rim_width + 0.2]);

    rotate([90,0,0])
    cylinder(r=3_4_tee_id/2, h=3_4_tee_id, center=true);

    // Front Pins
    front_tee_housing_pins();

    // Back Pins
    back_tee_housing_pins();

    // Front Slot
    translate([3_4_tee_rim_od/2 + bottom_block_wall,-front_slot_width/2,-3_4_tee_rim_width-0.1])
    cube([front_slot_length + 0.1, front_slot_width, bottom_block_height + 0.2]);

    // Back Slot
    rotate([0,0,180])
    translate([3_4_tee_width/2 - 3_4_tee_rim_width,-back_slot_width/2,-3_4_tee_rim_width-0.1])
    cube([back_slot_length, back_slot_width, 3_4_tee_center_z + 0.2]);

    // Side Tee Rims
    translate([-3_4_tee_rim_width,0,3_4_tee_center_z])
    rotate([0,90,0])
    cylinder(r=3_4_tee_rim_od/2 + tee_overlap,
              h=3_4_tee_width + front_block_length + back_block_length + 0.1,
              center=true,
              $fn=360);

    // Bottom Tee Rim
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_center_z);

    // Cylinder Spindle Hole
    translate([0,
               0,
               centerline_z - revolver_center_offset])
    rotate([0,90,0])
    Rod(rod=spindleRod, length=2, clearance=RodClearanceSnug);

    // AR15 Grip Bolt
    translate([-3_4_tee_width/2 +3_4_tee_rim_width,0,-3_4_tee_rim_width])
    ar15_grip_bolt(nut_offset=0, nut_angle=90);
  }

}

module front_tee_housing(debug=false) {
  if (debug) {
    translate([-3_4_tee_center_z,0,3_4_tee_width/2 + front_block_length - 3_4_tee_rim_width])
    rotate([0,90,0])
    %3_4_tee();
  }

  difference() {
    union() {

      // Backstrap
      color("Red")
      translate([backstrap_offset,0,0])
//      rotate([180,-90,0])
      backstrap(length = front_block_length);

      // Tee Rim Block
      color("LightBlue")
      cylinder(r=3_4_tee_rim_od/2 + front_rim_overlap, h=front_block_length);

      // Spindle Block
      color("Orange")
      translate([-3_4_tee_center_z-3_4_tee_rim_width,
                 -front_block_width/2,
                 0])
      cube([3_4_tee_center_z,
            front_block_width,
            front_block_length]);
    }

    // Pins
    translate([-3_4_tee_center_z,0,3_4_tee_width/2 + front_block_length - 3_4_tee_rim_width])
    rotate([0,90,0])
    front_tee_housing_pins(debug=false);

    // Front Tee Rim
    translate([0,0,front_block_length - 3_4_tee_rim_width])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width+0.1);

    // Gas Sealing Pipe Hole
    translate([0,0,-0.1])
    1_pipe(length=front_block_overlap + 0.2, hollow=false, cutter=true);

    // Cylinder Spindle Hole
    translate([-revolver_center_offset,
                0,
                -0.1])
    Rod(rod=spindleRod, length=2, clearance=RodClearanceSnug);
  }
}


back_block_length = slot_length + 8/32;
module back_tee_housing(debug=false) {

  if (debug) {
    translate([3_4_tee_center_z,0,3_4_tee_width/2 + back_block_length - 3_4_tee_rim_width])
    rotate([0,-90,0])
    %3_4_tee();
  }

  difference() {
    union() {

      // Backstrap
      color("Red")
      rotate([0,0,180])
      translate([backstrap_offset,0,0])
      backstrap(length = back_block_length);

      // Main Body and Stock Sleeve
      color("LightBlue")
      cylinder(r=3_4_tee_rim_od/2 + tee_overlap, h=back_block_length);

      // AR15 Grip
      translate([3_4_tee_center_z+3_4_tee_rim_width,0,back_block_length])
      rotate([0,-90,0])
      ar15_grip(mount_height=3_4_tee_center_z + 3_4_tee_rim_width,mount_length=0, top_extension=0, extension=0, debug=true);

      // Grip Mount Support Block
//      translate([body_offset + 6/16,-1/4,0])
      translate([3_4_tee_center_z + 11/16,-1/4,0])
      cube([3/4, 1/2,1/4]);
    }

    // Pins
    translate([3_4_tee_center_z,0,3_4_tee_width/2 + back_block_length - 3_4_tee_rim_width])
    rotate([0,-90,0])
    back_tee_housing_pins(debug=false);

    // Back Tee Rim
    translate([0,0,back_block_length - 3_4_tee_rim_width])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.1);

    // Stock Sleeve
    translate([0,0,-0.1])
    3_4_pipe(length=back_block_length + 0.2, hollow=false, cutter=true, loose=true);

    translate([-2,-4,-2])
    *cube([4,4,4]);
  }
}



module tee_housing_plater(debug=false) {
  color("HotPink")
  translate([0,2,0])
  front_tee_housing(debug=debug);

  color("LightBlue")
  translate([0,0,3_4_tee_rim_width])
  bottom_tee_housing(debug=debug);

  color("Orange")
  translate([0,-2,0])
  back_tee_housing(debug=debug);
}

!scale([25.4, 25.4, 25.4])
rotate([0,0,90])
tee_housing_plater();

module tee_housing_reference() {

  // Bottom insert
  color("Green")
  translate([0,0,-3_4_tee_rim_width])
  *cylinder(r=3_4_tee_id/2, h=3_4_tee_center_z);

  // Center Backstrap
  color("Yellow")
  difference() {
    translate([(3_4_tee_width/2) - 3_4_tee_rim_width,0,3_4_tee_center_z + backstrap_offset])
    rotate([0,-90,0])
    backstrap(length=3_4_tee_width - (3_4_tee_rim_width*2), infill_length = 0.5);

    // Tee Body Clearance
    translate([0,0,3_4_tee_center_z])
    rotate([0,90,0])
    cylinder(r=3_4_tee_diameter/2, h=3_4_tee_width, center=true);
  }

  color("HotPink")
  translate([3_4_tee_width/2 - 3_4_tee_rim_width + front_block_length,0,3_4_tee_center_z])
  rotate([0,-90,0])
  front_tee_housing(debug=false);

  color("White")
  bottom_tee_housing(debug=false);

  color("Olive")
  translate([-back_block_length -3_4_tee_width/2 +3_4_tee_rim_width,0,3_4_tee_center_z])
  rotate([0,90,0])
  back_tee_housing(debug=false);

  // Spindle
  %translate([
    3_4_tee_width/2 - 3_4_tee_rim_width,
    0,
    centerline_z - revolver_center_offset])
  rotate([0,90,0])
  cylinder(r=cylinder_spindle_diameter/2, h=10);

  // Backstrap
  translate([-3_4_tee_width/2 -back_block_length + 3_4_tee_rim_width,0,centerline_z + backstrap_offset])
  rotate([0,90,0])
  rotate([0,0,-45])
  %3_4_angle_stock(length=12);

  // Barrel
  translate([3_4_tee_width/2+0.5,0,3_4_tee_center_z])
  rotate([0,90,0])
  %3_4_pipe(length=barrel_length);
}

scale([25.4, 25.4, 25.4])
tee_housing_reference();
