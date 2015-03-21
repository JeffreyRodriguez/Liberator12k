include <Vitamins/Pipe.scad>;
include <Components.scad>;
include <Cylinder.scad>;
include <Cylinder Linkage.scad>;

module forend() {

  echo("Forend Height", forend_length+revolver_cylinder_height + chamber_protrusion*2);

  difference() {
    union() {

      // Barrel and Gas Sealing Pipe Sleeve
      cylinder(r=1_pipe_od/2 + forend_wall_thickness, h=forend_length);

      // Backstrap Sleeve
      translate([backstrap_offset,0,0])
      backstrap(loose=true, length=forend_length+revolver_cylinder_height + chamber_protrusion*2);

      // Spindle-Barrel Infill
      translate([-revolver_center_offset, -cylinder_spindle_diameter/2-cylinder_spindle_wall,0])
      cube([1,cylinder_spindle_diameter+cylinder_spindle_wall*2, forend_length]);

      // Spindle Sleeve
      translate([-revolver_center_offset, 0,0])
      cylinder(r=cylinder_spindle_diameter/2 + cylinder_spindle_wall, h=forend_length);
    }

    // Gas Sealing Pipe Clearance
    translate([0,0,forend_length - forend_depth])
    1_pipe(hollow=false, cutter=true, loose=false, length=forend_length + 0.1);

    // Barrel Hole
    translate([0,0,-0.1])
    3_4_pipe(cutter=true, hollow=false, length=forend_length + 0.2);

    // Spindle Hole
    translate([-revolver_center_offset, 0,-0.1])
    cylinder(r=cylinder_spindle_diameter/2, h=forend_length + 0.2);

    // Spindle Hole
    translate([-revolver_center_offset, 0,-0.1])
    cylinder(r=cylinder_spindle_diameter/2, h=forend_length + 0.2);

    // Revolver Cylinder Clearance
    translate([-revolver_center_offset,0,forend_length])
    cylinder(r=revolver_cylinder_od/2 + actuator_cylinder_clearance,
             h=revolver_cylinder_height + chamber_protrusion*2 + 1/4 + 0.1);

    // Actuator Rod Hole
    #translate([-revolver_center_offset + revolver_cylinder_od/2 + actuator_pin_depth,0,forend_length+revolver_cylinder_height + chamber_protrusion*2 - 1/2])
    rotate([0,-90,0])
    1_4_rod(length=actuator_collar_offset + 0.1, cutter=true);
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend();

  translate([-revolver_center_offset,0,revolver_cylinder_height + forend_depth + forend_seal_length - chamber_protrusion])
  mirror([0,0,1])
  %revolver_cylinder();

  // Gas Sealing Pipe
  translate([0,0,forend_length - forend_depth])
  %1_pipe(length=2);

  // Barrel
  translate([0,0,-barrel_length + forend_length])
  %3_4_pipe(length=barrel_length);
}
