include <Components.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;
include <TriggerAssembly.scad>;
include <Cylinder.scad>;

module housing() {
  receiver();

  vertical_spacing = trigger_housing_internal_top + sear_block_padding*2 - sear_block_clearance*2;

  // Housing and trigger
  union() {

    // 3/4 Tee Housing with AR-15 Grip
    ar_tee_housing(
      v =  -trigger_housing_height+grip_height,
      h = trigger_housing_x_back,
      mount_height = trigger_housing_height-grip_height,
      mount_length = 0,
      tee_overlap         = tee_overlap,
      tee_clearance       = 1/64,
      sear_hole_diameter  = sear_diameter + sear_rod_clearance);
  }
}

module housing_left() {
  rotate([-90,0,0])
  union() {
    difference() {
      housing();

      translate([0,-1,0])
      cube([10,2,10], center=true);
    }

    // Trigger
    trigger_housing_left();
  }
}

module housing_right() {
  rotate([90,0,0])
  union() {
    difference() {
      housing();

      translate([0,1,0])
      cube([10,2,10], center=true);
    }

    // Trigger
    trigger_housing_right();
  }
}

rotate([90,0,0])
*housing_left();

rotate([-90,0,0])
*housing_right();



// Scale up to metric for printing
scale([25.4,25.4,25.4]) {

  housing();
  trigger_housing();

  translate([breech_face_x  + chamber_protrusion,0,-cylinder_hole_diameter - revolver_cylinder_wall*2 + 3_4_tee_center_z])
  rotate([0,90,0])
  revolver_cylinder(hole=cylinder_hole_diameter, wall=revolver_cylinder_wall, height=2);

  // Position the sear block
  translate([1.5,0,0])
  *sear_block();

  // Position the trigger
  translate([-2.7,0,0])
  rotate([180,0,0])
  *trigger();

  // Position the left and right housing
  *translate([0,0,3_4_tee_rim_od/2 + tee_overlap]) {
    translate([0,-1.9,0])
    housing_right();

    translate([0,1.9,0])
    housing_left();
  }
}