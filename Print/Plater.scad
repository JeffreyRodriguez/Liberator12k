include <Upper Receiver.scad>;
include <Forend.scad>;
include <Cylinder.scad>;

scale([25.4, 25.4, 25.4]) {

  color("Lime2")
  translate([3,0,0])
  rotate([0,0,-90])
  forend();

  tee_housing_plater();

  color("Gold")
  translate([0,4.5,0])
  revolver_cylinder();

}
