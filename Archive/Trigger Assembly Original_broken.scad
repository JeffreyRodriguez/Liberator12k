include <Pipe.scad>;
include  <Components.scad>;


module trigger_assembly() {

  // Settings

  pipe_cap_od = 0.635;
  pipe_cap_height = 0.538;
  pipe_cap_depth = 0.444;

  spring_length = 1.36;
  spring_od = 0.22;
  bushing_height = 1.0;

  // Sear pin
  color("Red", 1)
  translate([0,0,0])
sear(top=centerline_z,
     diameter=sear_diameter,
     length=sear_length,
     pin_diameter=sear_pin_diameter,
     pin_length=sear_pin_length,
     pin_offset=sear_pin_offset);

  // Pipe in bushing
  color("Green", 0.1)
  translate([0,0,centerline_z])
  pipe(id=0.265, od=0.415, length=3.63);

  // Pipe cap
  color("Yellow", .5)
  translate([0,0,centerline_z - pipe_cap_height + pipe_cap_depth])
  cylinder(r=pipe_cap_od/2, h=pipe_cap_height, $fn=6);

  // Bushing
  color("Yellow", .5)
  bushing();
}

translate([0,0,-0.5])
trigger_assembly();
