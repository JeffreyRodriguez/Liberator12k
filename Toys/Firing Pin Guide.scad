include <../Vitamins/Rod.scad>;
include <../Vitamins/Pipe.scad>;

module firing_pin_guide(od=3_4_tee_id, minor_height = 1/4, major_height = 1/2) {

  // 1/8" Rod on 1/4" Rod
  difference() {
    union() {
      cylinder(r=od/2, h=major_height + minor_height, $fn=20);

      translate([-3_4_tee_rim_od/2,-3_4_tee_id/2,-1/4])
      *cube([3_4_tee_rim_od,3_4_tee_id,1/4]);
    }

    translate([0,0,-0.5])
    Rod(rod=RodOneEighthInch, length=minor_height + 1, clearance=RodClearanceLoose);

    translate([0,0,minor_height])
    #cylinder(r=0.4/2, h=major_height + 0.1, $fn=20);
  }
}

scale([25.4, 25.4, 25.4])
firing_pin_guide();