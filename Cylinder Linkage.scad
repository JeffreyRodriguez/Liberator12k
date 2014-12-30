include <Vitamins/Rod.scad>;
include <Components.scad>;

module cylinder_linkage() {
  difference() {
    // Body
    translate([0,-cylinder_linkage_width/2,0])
    cube([cylinder_linkage_length, cylinder_linkage_width, cylinder_linkage_height]);

    // Body Front-Top Angle Cutter
    translate([0,0,cylinder_linkage_height - cylinder_linkage_height/4])
    rotate([0,45,0])
    translate([-cylinder_linkage_width,-cylinder_linkage_width/2 - 0.1,0])
    cube([cylinder_linkage_width,cylinder_linkage_width + 0.2,cylinder_linkage_height]);

    // Body Side Angle Cutter - Y POS
    translate([0,cylinder_linkage_width/4,-0.1])
    rotate([0,0,45])
    cube([cylinder_linkage_width,cylinder_linkage_width,cylinder_linkage_height + 0.2]);

    // Body Side Angle Cutter - Y NEG
    translate([0,-cylinder_linkage_width/4,-0.1])
    rotate([0,0,-45])
    translate([0,-cylinder_linkage_width,0])
    cube([cylinder_linkage_width,cylinder_linkage_width,cylinder_linkage_height + 0.2]);

    // Rod Hole
    translate([cylinder_linakge_rod_offset,0,0]) {
      translate([0,0,-0.1])
      1_4_rod(length=1, cutter=true);
      %1_4_rod(length=1/4 + cylinder_linkage_height);
    }
  }
}

scale([25.4, 25.4, 25.4])
*cylinder_linkage();
