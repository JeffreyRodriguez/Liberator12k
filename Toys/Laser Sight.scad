include <Components.scad>;

laser_od = 0.532 + 0.02;
laser_button_width = 0.227 + 0.015;

laser_button_height = 0.615 - laser_od;

laser_button_height_pressed = 0.592 - laser_od;

wall = 1/4;
height = 1.75;

scale([25.4, 25.4, 25.4]) {
  union() {
      translate([backstrap_offset + laser_od,0,0])
  difference() {
    union() {
      cylinder(r=laser_od/2 + wall, h=height, $fn=40);
    }

    translate([0,0,-0.1])
    cylinder(r=laser_od/2, h=height + 0.2, $fn=40);

    translate([0,0,-0.1])
    cylinder(r=laser_button_width/2, h=height + 0.2, $fn=40);

    translate([0,-laser_button_width/2,0])
    *cube([(laser_od/2) + laser_button_height,laser_button_width,height]);

    translate([laser_button_height,laser_button_height,height - laser_button_width])
    cylinder(r=(laser_od + laser_button_height + 0.02)/2, h=laser_button_width + 0.1, $fn=40);
  }

  difference() {
    translate([backstrap_offset,0,0])
    backstrap(length=height);

    translate([0,0,-0.1])
    cylinder(r=TeeRimDiameter(receiverTee)/2,h=height+0.2);
  }
}



}
