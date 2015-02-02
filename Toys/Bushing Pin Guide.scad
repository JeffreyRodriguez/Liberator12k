include <Components.scad>;
include <Vitamins/Pipe.scad>;
include <Tee Housing.scad>;
include <Receiver.scad>;
include <TriggerAssembly.scad>;



height = 1;
hole = 1/8 + 1/32;
wall = 1/16;
difference() {
  cylinder(r=hole/2+wall, h=height, $fs=10);
  translate([0,0,-0.1])
  #cylinder(r=hole/2, h=height+0.2, $fs=10);
}
