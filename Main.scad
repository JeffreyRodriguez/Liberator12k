include <Vitamins/Pipe.scad>;
include <Components.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;
include <Cylinder.scad>;
include <Cylinder Linkage.scad>;
include <Linkage Mount.scad>;

module forend() {

    translate([-revolver_center_offset,0,revolver_cylinder_height + linkage_mount_height + chamber_protrusion])
    rotate([180,0,0])
    %revolver_cylinder();

    // Cylinder Linkage
    %translate([
      linkage_mount_linkage_offset + cylinder_linkage_height,
      0,
      -1])
    rotate([0,-90,0])
    cylinder_linkage();

    // Gas Sealing Pipe
    translate([0,0,linkage_mount_height])
    %1_pipe(length=linkage_mount_pipe_length);

  forend_travel = 3;
  forend_length = forend_travel  + 1/4;
  forend_length = 1;
  forend_width  = 1_pipe_od + forend_wall_thickness*2;
  forend_height = backstrap_offset + 3_4_pipe_od;

  translate([0,0,linkage_mount_height-forend_length]) {

    difference() {


    union() {

      translate([
        -forend_height + backstrap_offset - 3_4_angle_stock_height - 8/32,
        -forend_width/2,
        0])
      cube([forend_height,forend_width,forend_length]);

      // Angle Iron Sleeve
      translate([backstrap_offset,0,0])
      rotate([0,0,135])
      difference() {
        cube([
          3_4_angle_stock_width + forend_wall_thickness*3.5,
          3_4_angle_stock_width + forend_wall_thickness*3.5,
          forend_length]);

        translate([forend_wall_thickness,forend_wall_thickness,-0.1])
        #3_4_angle_stock(
          length=10,
          cutter=true);
      }

    }

      // Linkage Track
      #translate([0,0,forend_length - forend_travel]) {
        1_pipe(cutter=true, hollow=false, length=forend_travel+0.1);

        translate([
          revolver_center_offset - cylinder_linkage_height,
          -cylinder_linkage_width/2 - forend_clearance,
          0])
        cube([
          cylinder_linkage_height + forend_clearance*2,
          cylinder_linkage_width + forend_clearance*2,
          forend_travel + 0.1]);
      }

      // Barrel Hole
      translate([0,0,-0.1])
      3_4_pipe(hollow=false, cutter=true, length=forend_length + 0.2);


      // Cylinder Mounting Hole
      translate([-revolver_center_offset,0,-0.1])
      3_4_pipe(hollow=false, cutter=true, length=forend_length + 0.2);
    }
  }
}


// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  //rotate([0,-90,0])
  forend();
}
