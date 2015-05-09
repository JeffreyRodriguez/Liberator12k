include <../Vitamins/Pipe.scad>;
include <../Vitamins/Rod.scad>;

module breech_jig(wall=1/8, floor=1, $fn=50) {
  difference() {
    cylinder(r=3_4_x_1_8_bushing_head_od/2 + wall,
             h=3_4_x_1_8_bushing_head_height + floor,
             $fn=6);

    translate([0,0,floor])
    cylinder(r=(3_4_x_1_8_bushing_head_od/2) + 3_4_x_1_8_bushing_head_clearance, h=3_4_x_1_8_bushing_head_height + 0.1, $fn=6);

    translate([0,0,-0.1])
    Rod(rod=RodOneEighthInch, clearance=RodClearanceSnug, length=floor + 3_4_x_1_8_bushing_head_height + 0.2);

    translate([0,0,floor])
    mirror([0,0,0])
    %3_4_x_1_8_bushing();
  }
}

scale([25.4, 25.4, 25.4])
breech_jig();