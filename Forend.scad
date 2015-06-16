include <Vitamins/Pipe.scad>;
include <Components.scad>;
use <Cylinder.scad>;
use <AR15 Grip Mount.scad>;

module forend(spindleRod=RodOneQuarterInch, actuatorRod=RodOneEighthInch, gasSealingPipe=PipeOneInch) {
  forend_extra = 0.4;
  
  echo("Forend Height", forend_length + forend_extension + revolver_cylinder_height + forend_extra);

  pipe_diameter    = lookup(PipeOuterDiameter, gasSealingPipe);
  pipe_radius      = lookup(PipeOuterDiameter, gasSealingPipe)/2;
  spindle_diameter = lookup(RodDiameter, spindleRod);
  spindle_radius   = lookup(RodDiameter, spindleRod)/2;

  difference() {
    union() {

      // Backstrap
      translate([backstrap_offset,0,0])
      backstrap(length=forend_length + forend_extension + revolver_cylinder_height + forend_extra);

      // Barrel Sleeve
      cylinder(r=pipe_radius + forend_wall_thickness, h=forend_length);

      // Spindle-Barrel Infill
      translate([-revolver_center_offset, -spindle_radius-cylinder_spindle_wall,0])
      cube([pipe_radius + cylinder_spindle_wall,spindle_diameter+cylinder_spindle_wall*2, forend_length+forend_extension]);

      // Spindle Sleeve
      translate([-revolver_center_offset, 0,0])
      cylinder(r=cylinder_spindle_diameter/2 + cylinder_spindle_wall, h=forend_length + forend_extension);

      // AR15 Grip Mount
      // HACK: This whole thing is just eye-balled
      *intersection() {
        rotate([0,0,-30])
        translate([-revolver_center_offset,.25,.692])
        rotate([0,45,0])
        ar15_grip(mount_height = 1.5, mount_length=1.5);

        translate([-3,-3,0])
        cube([6,6,forend_length]);
      }
    }

     // Actuator Rod
    translate([backstrap_offset - lookup(RodDiameter,backstrapRod) ,0,forend_length + forend_extension + revolver_cylinder_height])
    rotate([0,-90,0])
    Rod(rod=actuatorRod, length=1);

    // Barrel/Gas-Sealing Pipe Hole
    translate([0,0,-0.1])
    Pipe(pipe=gasSealingPipe, clearance=PipeClearanceSnug, length=forend_length +forend_extension+ 0.2);

    // Spindle Hole
    translate([-revolver_center_offset, 0,-0.1])
    Rod(rod=spindleRod, clearance=RodClearanceLoose, length=forend_length + forend_extension + 0.2);

    // Revolver Cylinder Clearance
    translate([-revolver_center_offset,0,forend_length + forend_extension])
    cylinder(r=revolver_cylinder_od/2 + actuator_cylinder_clearance,
             h=revolver_cylinder_height + chamber_protrusion*2 + 1/4 + 0.1);
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend();

  translate([-revolver_center_offset,0,forend_length + forend_extension + revolver_cylinder_height])
  rotate([0,180,0])
  *revolver_cylinder();

  // Gas Sealing Pipe
  %1_pipe(length=forend_length + forend_extension);

  // Barrel
  translate([0,0,-barrel_length + forend_length])
  *%3_4_pipe(length=barrel_length);
}
