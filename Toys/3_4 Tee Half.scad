include <../Vitamins/Pipe.scad>;

wall = 1/4;

scale([25.4, 25.4, 25.4])
rotate([-90,0,0])
translate([0,-3_4_tee_rim_od/2 -wall,wall])
difference() {
  translate([-3_4_tee_width/2 - wall,0,-wall])
  cube([3_4_tee_width + wall*2,3_4_tee_rim_od/2 + wall,3_4_tee_height + (3_4_tee_rim_od - 3_4_tee_diameter)/2 + wall*2]);

  3_4_tee();
}