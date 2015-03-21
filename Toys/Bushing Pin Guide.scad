include <../Components.scad>;
include <../Vitamins/Pipe.scad>;
include <../Tee Housing.scad>;
include <../TriggerAssembly.scad>;



module hammer_end(height=1, od=0.8, id=35/128, rope_width = 1/8, rope_depth=1/16) {
  difference() {

    // Body
    cylinder(r=od/2, h=height, $fs=10);

    // Hammer Hole
    translate([0,0,-0.1])
    cylinder(r=id/2, h=height+0.2, $fs=10);

    // Rope Track
    translate([0,-rope_width/2,-0.1])
    #cube([(id/2) + rope_depth, rope_width, height + 0.2]);
  }
}




scale([25.4, 25.4, 25.4])
hammer_end();