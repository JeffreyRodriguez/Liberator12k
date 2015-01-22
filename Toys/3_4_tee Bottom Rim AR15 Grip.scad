include <Vitamins/Pipe.scad>;
include <../AR15 Grip Mount.scad>;

wall = 3_4_tee_width/2 - 3_4_tee_rim_od/2 - 3_4_tee_rim_width;

scale([25.4, 25.4, 25.4])
union() {
  translate([0,0,3_4_tee_rim_width])
  rotate([0,180,0])
  %3_4_tee();


  difference() {
    union() {

      // Rim Wall
      color("LightBlue")
      cylinder(r=3_4_tee_rim_od/2 + wall, h=3_4_tee_rim_width);

      // AR15 Grip
      translate([3_4_tee_width/2,0,3_4_tee_rim_width])
      rotate([180,0,180])
      ar15_grip(mount_height=3_4_tee_rim_width,mount_length=3_4_tee_width/2 - 3_4_tee_rim_od/2);
    }

    // Tee Rim
    translate([0,0,-0.1])
    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 0.2);
  }
}
