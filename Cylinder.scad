include <Components.scad>;

module revolver_cylinder(debug=false) {

  echo("Cylinder OD:", revolver_cylinder_od);
  echo("Cylinder Circ:", cylinder_circumference);
  echo("Rotation Arc:", rotation_arc);
  echo("ZigZag Height:", zigzag_height);
  echo("Cylinder Height:", revolver_cylinder_height);

zigzag_cutter_width = zigzag_width + revolver_zigzag_pin_diameter/2.5; // ???: Eyeballed this one

union() {
  difference() {

    // Body
    color("LightGrey")
    cylinder(r=revolver_cylinder_od/2, h=revolver_cylinder_height, $fn=120);

    for (i=[0:revolver_shots-1]) {
      rotate([0,0,rotation_angle*i]) {

        // Pins
        if (debug)
        translate([revolver_cylinder_od/2 - revolver_zigzag_depth,0,revolver_zigzag_pin_diameter/2])
        rotate([0,90,0])
        %cylinder(r=revolver_zigzag_pin_diameter/2, h=revolver_zigzag_depth*2);

        // Chamber Holes
        translate([3_4_pipe_od + revolver_cylinder_wall,0,-0.1])
        3_4_pipe(hollow=false, cutter=true, length=revolver_cylinder_height + 0.2);

        // Chamber Mocks
        if (debug)
        translate([
          3_4_pipe_od + revolver_cylinder_wall,
          0,
          -chamber_length/2 + revolver_cylinder_height/2])
        %3_4_pipe(length=chamber_length);

        // Zig (push)
        translate([0,0,bottom_slot_height])
        difference() {
          linear_extrude(height = zigzag_height,
                         center = false,
                         convexity = 1,
                         slices=23,
                         twist = rotation_angle/2 + 360/(1*(cylinder_circumference/zigzag_width)))
          translate([revolver_cylinder_od/2 -revolver_zigzag_depth,-zigzag_width/2, 0])
          square([revolver_zigzag_depth*2, zigzag_cutter_width]);

          // Chop off the top tip
          rotate([0,0,-rotation_angle/2  +  360/(4*(cylinder_circumference/zigzag_width))])
          translate([revolver_cylinder_od/2 - revolver_zigzag_depth*2,
                     -zigzag_cutter_width*1.5,
                     zigzag_height - top_slot_height + zigzag_clearance])
          cube([revolver_zigzag_depth*4,
                zigzag_cutter_width*1.5,
                top_slot_height]);

          // Chop off the bottom tip
          translate([revolver_cylinder_od/2 - revolver_zigzag_depth*2,
                     zigzag_width/2,
                     -revolver_zigzag_pin_diameter/2])
          cube([revolver_zigzag_depth*4,
                zigzag_cutter_width,
                revolver_zigzag_pin_diameter*2]);
        }

        // Zag (pull)
        rotate([0,0,rotation_angle])
        translate([0,0,revolver_zigzag_pin_diameter])
        difference() {
          linear_extrude(height = zigzag_height,
                          center = false,
                          convexity = 3,
                          slices=23,
                          twist = -rotation_angle/2 -360/(1*(cylinder_circumference/zigzag_width)))
          translate([revolver_cylinder_od/2-revolver_zigzag_depth, -(zigzag_cutter_width) + zigzag_width/2, 0])
          square([revolver_zigzag_depth*2, zigzag_cutter_width]);

          // Chop off the top tip
          rotate([0,0,rotation_angle/2 + 360/(1.8*(cylinder_circumference/zigzag_width))])
          translate([revolver_cylinder_od/2 - revolver_zigzag_depth*2,
                     0,
                     zigzag_height-top_slot_height + zigzag_clearance])
          cube([revolver_zigzag_depth*4,
                zigzag_cutter_width,
                top_slot_height]);

          // Chop off the bottom tip
          translate([revolver_cylinder_od/2 - revolver_zigzag_depth*2,
                     -zigzag_cutter_width + zigzag_width/2 - zigzag_clearance,
                     -revolver_zigzag_pin_diameter/2])
          cube([revolver_zigzag_depth*4,
                zigzag_cutter_width,
                revolver_zigzag_pin_diameter*3]);
        }

        // Vertical slot top
        rotate([0,0,rotation_angle/2])
        translate([
          revolver_cylinder_od/2 - revolver_zigzag_depth + 0.001,
          -zigzag_width/2,
          revolver_cylinder_height - top_slot_height - zigzag_clearance*2])
        cube([revolver_zigzag_depth*2, zigzag_width, top_slot_height + zigzag_clearance*3]);

        // Vertical slot bottom
        translate([
          revolver_cylinder_od/2 - revolver_zigzag_depth + 0.001,
          -zigzag_width/2,
          -zigzag_clearance])
        cube([revolver_zigzag_depth*2, zigzag_width, bottom_slot_height + zigzag_clearance*2]);
      }
    }

    // Spindle
    translate([0,0,-2])
    cylinder(r=cylinder_spindle_diameter/2, h=7);

    // Gas Sealing Pipe
    translate([revolver_center_offset,0,revolver_cylinder_height])
    *%1_pipe(length=1);
  }

}


  // Support Material
  color("Black")
  for (i=[0:revolver_shots-1]) {
    rotate([0,0,rotation_angle*i])
    translate([revolver_cylinder_od/2 - revolver_zigzag_depth - 0.008,zigzag_width/2,revolver_zigzag_pin_diameter])
    cube([revolver_zigzag_depth, 0.01, revolver_zigzag_pin_diameter * 1.75]);
  }
}

//revolver_cylinder();
