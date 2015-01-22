include <Vitamins/Pipe.scad>;
include <Components.scad>;

scale([25.4, 25.4, 25.4]) {
  union() {
    cylinder(r=3_4_tee_id/2, h=centerline_z + 1/8);

    cylinder(r=3_4_tee_rim_od/2, h=1/8, $fn=6);
  }
}