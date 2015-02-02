include <../Vitamins/Pipe.scad>;
include <../Vitamins/Rod.scad>;


wall = 1/8;
floor = 1;

scale([25.4, 25.4, 25.4])
difference() {
  cylinder(r=3_4_x_1_8_bushing_head_od/2 + wall, h=3_4_x_1_8_bushing_head_height + floor, $fn=6);

  translate([0,0,floor])
  cylinder(r=(3_4_x_1_8_bushing_head_od/2) + 3_4_x_1_8_bushing_head_clearance, h=3_4_x_1_8_bushing_head_height + 0.1, $fn=6);

  translate([0,0,-0.1])
  1_8_rod(cutter=true, loose=false, length=floor + 3_4_x_1_8_bushing_head_height + 0.2);

  translate([0,0,floor])
  mirror([0,0,0])
  %3_4_x_1_8_bushing();
}