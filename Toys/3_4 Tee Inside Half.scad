include <../Vitamins/Pipe.scad>;

wall = 0;

scale([25.4, 25.4, 25.4])
rotate([-90,0,0])
translate([0,-3_4_tee_rim_od/2 - wall,wall])
difference() {

  translate([-3_4_tee_width/2 - wall,0,+0.001])
  #cube([3_4_tee_width + wall*2,
         3_4_tee_rim_od/2 + wall,
         3_4_tee_height + (3_4_tee_rim_od - 3_4_tee_diameter)/2 + wall*2]);

  #union() {
    translate([-3_4_tee_width/2 - wall - 0.1,0,3_4_tee_center_z])
    rotate([0,90,0])
    cylinder(r=3_4_tee_id/2, h=3_4_tee_width + wall*2 + 0.2, $fn=30);

    translate([0,0,-0.1])
    cylinder(r=3_4_tee_id/2, h=3_4_tee_height - 3_4_tee_diameter/2 + 0.1, $fn=30);
  }

  translate([-3_4_tee_rim_od/2 - wall -1, - 0.1,3_4_tee_center_z - 3_4_tee_rim_od/2 - wall -1])
  #cube([1,1,1]);

  translate([3_4_tee_rim_od/2 + wall, - 0.1,3_4_tee_center_z - 3_4_tee_rim_od/2 - wall -1])
  #cube([1,1,1]);

  %3_4_tee();
}