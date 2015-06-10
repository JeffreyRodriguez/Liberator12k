include <Vitamins/Pipe.scad>;
include <Vitamins/Angle Stock.scad>;
include <Components/Backstrap.scad>;
include <Components.scad>;

module forend_single(wall=1/4, length=2, $fn=50,
                     pipe=PipeThreeQuartersInch,
                     spindle=RodOneEighthInch) {

  pipe_diameter    = lookup(PipeOuterDiameter, pipe);
  pipe_radius      = lookup(PipeOuterDiameter, pipe)/2;
  spindle_diameter = lookup(RodDiameter, spindleRod);
  spindle_radius   = lookup(RodDiameter, spindleRod)/2;

  difference() {
    union() {

      // Backstrap
      translate([backstrap_offset,0,0])
      backstrap(length=length);

      // Barrel Sleeve
      cylinder(r=pipe_radius + wall, h=length);

      // Spindle-Barrel Infill
      translate([-revolver_center_offset, -spindle_radius-cylinder_spindle_wall,0])
      cube([pipe_radius + cylinder_spindle_wall,spindle_diameter+cylinder_spindle_wall*2, length]);

      // Spindle Sleeve
      translate([-revolver_center_offset, 0,0])
      cylinder(r=cylinder_spindle_diameter/2 + cylinder_spindle_wall, h=length);
    }

    // Barrel/Gas-Sealing Pipe Hole
    translate([0,0,-0.1])
    Pipe(pipe=pipe, clearance=PipeClearanceSnug, length=length + 0.2);

    // Spindle Hole
    translate([-revolver_center_offset, 0,-0.1])
    Rod(rod=spindleRod, clearance=RodClearanceLoose, length=forend_length + forend_extension + 0.2);
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend_single();
}
