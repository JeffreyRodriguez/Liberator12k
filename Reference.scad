include <Tee Housing.scad>;
include <Cylinder.scad>;
include <Forend.scad>;

module reference() {
  color("Silver")
  union() {

    // Backstrap
    translate([-3_4_tee_width,0,backstrap_offset])
    rotate([0,-90,180])
    rotate([0,0,135])
    3_4_angle_stock(length=12);

    // Tee
    translate([-3_4_tee_width/2,0,-centerline_z])
    3_4_tee();

    // Breech Bushing
    translate([3_4_x_1_8_bushing_depth,0,0])
    rotate([0,-90,0])
    bushing(id=3_4_x_1_8_bushing_id,
            od=3_4_x_1_8_bushing_od,
            height=3_4_x_1_8_bushing_height,
            head_major_width=3_4_x_1_8_bushing_head_od,
            head_height=3_4_x_1_8_bushing_head_height);

    // Tee Gas Sealing Pipe
    rotate([0,90,0])
    1_pipe(length=front_block_seal_length);

    // Barrel Sealing Pipe
    translate([chamber_length - chamber_protrusion,0,0])
    rotate([0,90,0])
    1_pipe(length=forend_seal_length);

    // Barrel
    translate([chamber_length,0,0])
    rotate([0,90,0])
    3_4_pipe(length=barrel_length);

    // Spindle
    translate([-3_4_tee_width/2 + 3_4_tee_rim_od/2,0,-revolver_center_offset])
    rotate([0,90,0])
    1_4_rod(length=10);
  }

  // Front Tee Housing
  translate([0,0,-centerline_z])
  rotate([0,0,180])
  front_tee_housing();

  // Revolver Cylinder
  color("Yellow")
  translate([3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth + chamber_protrusion,0,-revolver_center_offset])
  rotate([0,90,0])
  revolver_cylinder();

  // Forend
  color("Green")
  translate([3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth + chamber_length + forend_length,0,0])
  rotate([0,-90,0])
  forend();
}

scale([25.4, 25.4, 25.4])
reference();
