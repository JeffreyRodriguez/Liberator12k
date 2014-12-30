include <Vitamins/Pipe.scad>;
include <Components.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;
include <Cylinder.scad>;
include <Cylinder Linkage.scad>;
include <Reference.scad>;





module linkage_mount() {

    translate([-revolver_center_offset,0,chamber_length - chamber_protrusion + linkage_mount_height + linkage_mount_pipe_length - chamber_protrusion])
    rotate([180,0,0])
    %revolver_cylinder();

    // Cylinder Linkage
    translate([
      linkage_mount_linkage_offset + cylinder_linkage_height,
      0,
      cylinder_linkage_length])
    rotate([180,90,0])
    %cylinder_linkage();

    // Gas Sealing Pipe
    translate([0,0,linkage_mount_height])
    %1_pipe(length=linkage_mount_pipe_length);

    // Barrel
    translate([0,0,-barrel_length + linkage_mount_height + linkage_mount_pipe_length - chamber_protrusion])
    %3_4_pipe(length=barrel_length);

  difference() {
      union() {

      // Body
      3_4_pipe_sleeve(
        length=linkage_mount_height,
        wall=1_pipe_wall);

      // Linkage Block
      translate([linkage_mount_offset_x, linkage_mount_offset_y, 0])
      cube([linkage_mount_block_height,linkage_mount_block_width,linkage_mount_block_length]);

    }

    // Gas Sealing Pipe Clearance
    translate([0,0,linkage_mount_height])
    1_pipe(hollow=false, cutter=true, loose=false, length=linkage_mount_pipe_length + 0.1);

    // Linkage Block Hole
    translate([
      linkage_mount_offset_x + linkage_mount_block_height - cylinder_linkage_height - linkage_mount_wall_thickness - linkage_mount_block_clearance*2,
      -(cylinder_linkage_width/2) - linkage_mount_block_clearance,
      -0.1])
    cube([
      cylinder_linkage_height + linkage_mount_block_clearance*2,
      cylinder_linkage_width + linkage_mount_block_clearance*2,
      linkage_mount_block_length + 0.2]);
  }
}


// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  //rotate([0,-90,0])
  linkage_mount();
}
