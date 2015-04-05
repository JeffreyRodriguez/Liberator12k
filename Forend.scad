include <Vitamins/Pipe.scad>;
include <Components.scad>;
include <Cylinder.scad>;
include <Cylinder Linkage.scad>;

module forend() {

  echo("Forend Height", forend_length+revolver_cylinder_height + chamber_protrusion*2);

  difference() {
    union() {

      // Backstrap Sleeve
      translate([backstrap_offset,0,0])
      backstrap(loose=true, length=forend_length + forend_extension);

      // Backstrap-Barrel Infill
      translate([0, -1_pipe_od/2,0])
      cube([backstrap_offset -.75,1_pipe_od, forend_length]);

      // Barrel Sleeve
      cylinder(r=1_pipe_od/2 + forend_wall_thickness, h=forend_length);

      // Spindle-Barrel Infill
      translate([-revolver_center_offset, -cylinder_spindle_diameter/2-cylinder_spindle_wall,0])
      cube([1_pipe_od + cylinder_spindle_wall,cylinder_spindle_diameter+cylinder_spindle_wall*2, forend_length]);

      // Spindle Sleeve
      translate([-revolver_center_offset, 0,0])
      cylinder(r=cylinder_spindle_diameter/2 + cylinder_spindle_wall, h=forend_length);
    }
    // Actuator Connecting Rod hole
    translate([3_4_angle_stock_width + tee_overlap + rope_od/2,0,-0.1])
    cylinder(r=rope_od/2, h=forend_length +forend_extension + 0.2);

    // Barrel Hole
    translate([0,0,-0.1])
    1_pipe(hollow=false, cutter=true, loose=false, length=forend_length +forend_extension+ 0.2);

    // Spindle Hole
    translate([-revolver_center_offset, 0,-0.1])
    cylinder(r=cylinder_spindle_diameter/2, h=forend_length + 0.2);

    // Revolver Cylinder Clearance
    *translate([-revolver_center_offset,0,forend_length])
    cylinder(r=revolver_cylinder_od/2 + actuator_cylinder_clearance,
         h=revolver_cylinder_height + chamber_protrusion*2 + 1/4 + 0.1);

  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend();

  translate([-revolver_center_offset,0,forend_length + forend_extension + revolver_cylinder_height])
  mirror([0,0,1])
  *%revolver_cylinder();

  // Gas Sealing Pipe
  %1_pipe(length=2);

  // Barrel
  translate([0,0,-barrel_length + forend_length])
  *%3_4_pipe(length=barrel_length);
}
