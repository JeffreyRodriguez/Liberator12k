include <Components.scad>;

module revolver_cylinder() {

//  echo("Cylinder OD:", revolver_cylinder_od);
//  echo("Cylinder Circ:", cylinder_circumference);
//  echo("Rotation Arc:", rotation_arc);
//  echo("ZigZag Height:", zigzag_height);
//  echo("Cylinder Height:", revolver_cylinder_height);

  difference() {

    // Body
    cylinder(r=revolver_cylinder_od/2, h=revolver_cylinder_height, $fn=60);

    // Chamber Holes
    for (i=[0:revolver_shots-1]) {
      translate([0,0,-0.1])
      rotate([0,0,rotation_angle*i])
      translate([cylinder_hole_diameter + revolver_cylinder_wall*2,0,0])
      3_4_pipe(hollow=false, cutter=true, length=chamber_length, $fn=20);
      //cylinder(r=cylinder_hole_diameter/2, h=chamber_length, $fn=20);

      rotate([0,0,rotation_angle*i])
      translate([cylinder_hole_diameter + revolver_cylinder_wall*2,0,- chamber_length/2 + revolver_cylinder_height/2])
      %3_4_pipe(length=chamber_length);
    }

    // ZigZag
    for (i=[0:revolver_shots-1]) {
      rotate([0,0,rotation_angle*i]) {

        // Zig (push)
        translate([0,0,zigzag_offset_z + revolver_zigzag_pin_diameter])
        linear_extrude(height = zigzag_height, center = false, convexity = 10, twist = rotation_angle/2, slices=10)
        translate([revolver_cylinder_od/2 - revolver_zigzag_pin_diameter/2 + zigzag_clearance, zigzag_clearance/2, 0])
        square([zigzag_width, zigzag_width], center=true);

        // Zig (push - lower section. How can I do this better?)
        translate([0,0,zigzag_offset_z + revolver_zigzag_pin_diameter/2])
        linear_extrude(height = zigzag_height, center = false, convexity = 10, twist = rotation_angle/2, slices=10)
        translate([revolver_cylinder_od/2 - revolver_zigzag_pin_diameter/2 + zigzag_clearance, zigzag_clearance/2, 0])
        square([zigzag_width, zigzag_width], center=true);

        // Zag (pull)
        rotate([0,0,rotation_angle])
        translate([0,0,zigzag_offset_z - revolver_zigzag_pin_diameter])
        linear_extrude(height = zigzag_height, center = false, convexity = 10, twist = -rotation_angle/2, slices=10)
        translate([revolver_cylinder_od/2 - revolver_zigzag_pin_diameter/2 + zigzag_clearance, zigzag_clearance/2, 0])
        square([zigzag_width, zigzag_width], center=true);

        // Zag (pull - upper section, how can I do this better?)
        rotate([0,0,rotation_angle])
        translate([0,0,zigzag_offset_z - revolver_zigzag_pin_diameter/2])
        linear_extrude(height = zigzag_height, center = false, convexity = 10, twist = -rotation_angle/2, slices=10)
        translate([revolver_cylinder_od/2 - revolver_zigzag_pin_diameter/2 + zigzag_clearance, zigzag_clearance/2, 0])
        square([zigzag_width, zigzag_width], center=true);

        // Vertical slot top
        rotate([0,0,rotation_angle/2])
        translate([revolver_cylinder_od/2 - revolver_zigzag_pin_diameter + zigzag_clearance/2, -revolver_zigzag_pin_diameter/2, revolver_cylinder_height - top_slot_height])
        cube([zigzag_width, zigzag_width, top_slot_height + zigzag_clearance]);

        // Vertical slot bottom
        translate([revolver_cylinder_od/2 - revolver_zigzag_pin_diameter + zigzag_clearance/2, -revolver_zigzag_pin_diameter/2, -zigzag_clearance])
        cube([zigzag_width, zigzag_width, bottom_slot_height + zigzag_clearance]);
      }
    }

    // Center Hole
    translate([0,0,-0.1])
    cylinder(r=cylinder_hole_diameter/2, h=3, $fn=20);

    translate([0,0,-2])
    %3_4_pipe(length=7);
  }

}

*scale([25.4, 25.4, 25.4])
revolver_cylinder();
