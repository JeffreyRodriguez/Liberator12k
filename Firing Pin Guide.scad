include <Vitamins/Rod.scad>;

module firing_pin_guide(od=0.65, minor_height = 3/4, major_height = 1/2) {

  // 1/8" Rod on 1/4" Rod
  difference() {
    cylinder(r=od/2, h=major_height + minor_height, $fn=20);

    translate([0,0,-0.1])
    1_8_rod(length=minor_height + 0.2, cutter=true);

    translate([0,0,minor_height])
    1_4_rod(length = major_height + 0.1, cutter=true);
  }
}

scale([25.4, 25.4, 25.4])
firing_pin_guide();