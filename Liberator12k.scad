include <Vitamins/Pipe.scad>;

include <Components.scad>;
use <TriggerAssembly.scad>;
use <Cylinder.scad>;
use <Forend.scad>;
use <Tee Housing.scad>;
use <Striker.scad>;
use <Stock Spacer.scad>;
use <Spring Cap.scad>;
use <Shell.scad>;
use <New Trigger.scad>;

rotate([0,0,360*$t])
scale([25.4, 25.4, 25.4]) {
  tee_housing_reference();

  translate([0,-3/16,0])
  rotate([0,90,90])
  new_trigger();

  translate([3_4_tee_width/2 +3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth+1/8,0,1/8])
  rotate([0,90,0]) {
    color("Gold")
    revolver_cylinder(debug=true);

    color("White")
    for (i=[0:6-1])
    rotate([0,0,360/6*i])
    translate([3_4_pipe_od + revolver_cylinder_wall, 0,-1/8])
    shell();
  }

  color("Purple")
  translate([6.8+1/8,0,3_4_tee_center_z])
  rotate([0,-90,0])
  forend();

  color("Red")
  translate([0,0,3_4_tee_center_z])
  rotate([0,-90,0])
  striker();

  color("White")
  translate([-7,0,3_4_tee_center_z])
  rotate([0,-90,0])
  stock_spacer(length=6);

  color("Black")
  translate([-4,0,3_4_tee_center_z])
  rotate([0,-90,0])
  spring_cap();

  color("Black")
  translate([-7,0,3_4_tee_center_z])
  rotate([0,90,0])
  spring_cap();

  color("CornflowerBlue")
  translate([-3_4_tee_width/2 -12,0,-1/8])
  striker_guide_side();

  // Stock
  union() {

    // Tee
    translate([-12,0,3_4_tee_center_z])
    rotate([0,-90,0])
    %3_4_tee();
  
    // Stock Pipe
    translate([-3_4_tee_width/2,0,3_4_tee_center_z])
    rotate([0,-90,0])
    %3_4_pipe(length=12);
  }
}