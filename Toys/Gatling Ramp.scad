use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Components/Semicircle.scad>;

rotation_angle = 360/6;
pipe = Spec_TubingZeroPointSevenFive();
firingPin = Spec_RodOneEighthInch();
ramp_height=0.5;

$fn=100;

difference() {
  union() {
    cylinder(r=PipeOuterDiameter(pipe)+0.125, h=3/8);

    translate([0,0,3/8])
    for (i=[0:5])
    rotate([0,0,rotation_angle*i])
    hull() {
      linear_extrude(twist=rotation_angle-15, height=ramp_height, slices=10)
      translate([PipeOuterDiameter(pipe)-0.125,0])
      square([0.25, 0.025]);

      linear_extrude(height=0.001)
      semidonut(major=(PipeOuterDiameter(pipe)+0.125)*2,
                minor=(PipeOuterDiameter(pipe)-0.125)*2,
                angle=rotation_angle-15);
    }
  }
  
  Pipe(pipe, center=true);
  
  // Firing Pins
  for (i=[0:5])
  rotate([0,0,rotation_angle*i])
  rotate(7.5)
  translate([PipeOuterDiameter(pipe),0])
  Rod(firingPin, center=true);
}
  
// Chambers
%for (i=[0:5])
rotate([0,0,(rotation_angle*i)+7.5]) {
  translate([PipeOuterDiameter(pipe),0,-1])
  Pipe(pipe=pipe, clearance=PipeClearanceSnug());
}
