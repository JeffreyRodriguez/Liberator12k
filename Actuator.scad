include <Vitamins/Pipe.scad>;
include <Vitamins/Rod.scad>;
include <Components.scad>;
include <Cylinder.scad>;

module actuator() {
  difference() {
    // Backstrap Sleeve
    translate([backstrap_offset,0,0])
    backstrap(loose=true, length=actuator_length);

    // Actuator Pin
    translate([-revolver_center_offset + revolver_cylinder_od/2 + actuator_pin_depth,0,actuator_pin_offset])
    rotate([0,-90,0])
    1_4_rod(length=actuator_pin_depth + 0.1, cutter=true);

    // Actuator Rod Hole
    translate([-revolver_center_offset + revolver_cylinder_od/2 + actuator_pin_depth - 1/8,0,-0.1])
    1_4_rod(length=actuator_collar_offset + 0.1, cutter=true);

    // Actuator Collar
    *translate([-revolver_center_offset + revolver_cylinder_od/2 + actuator_pin_depth - 1/8,
               0,
               actuator_collar_offset - 1_4_rod_collar_width]) {

      // Collar hole
      1_4_rod_collar();

      // Access hole
      translate([-1_4_rod_collar_d,-1_4_rod_collar_d/2,0])
      cube([1_4_rod_collar_d, 1_4_rod_collar_d,1_4_rod_collar_width]);
    }

    // Revolver Cylinder Clearance
    translate([-revolver_center_offset,0,-0.1])
    cylinder(r=revolver_cylinder_od/2 + actuator_cylinder_clearance,
             h=actuator_length + 0.2);
  }
}


// Scale up to metric for printing
*scale([25.4,25.4,25.4]) {
  color("White")
  actuator();

  translate([-revolver_center_offset,0,actuator_length - actuator_pin_offset])
  mirror([0,0,1])
  %revolver_cylinder();
}
