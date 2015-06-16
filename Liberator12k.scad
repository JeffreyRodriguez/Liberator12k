include <Vitamins/Pipe.scad>;
include <Vitamins/Angle Stock.scad>;

include <Components.scad>;
use <TriggerAssembly.scad>;
use <Cylinder.scad>;
use <Forend.scad>;
use <Forend_Single.scad>;
use <Tee Housing.scad>;
use <Firing Pin Guide.scad>;
use <Striker.scad>;
use <Striker Guide.scad>;
use <Stock Spacer.scad>;
use <Spring Cap.scad>;
use <Ammo/Shell Slug.scad>;
use <New Trigger.scad>;

module Liberator12k_Base() {

  tee_housing_reference();

  translate([0,-3/16,0])
  rotate([0,90,90])
  new_trigger();

  translate([0,0,3_4_tee_center_z])
  rotate([0,-90,0])
  striker();

  color("Orange")
  translate([(3_4_tee_width/2) - 3_4_x_1_8_bushing_depth,0,3_4_tee_center_z])
  rotate([0,-90,0])
  firing_pin_guide();

  color("White")
  translate([-9.4,0,3_4_tee_center_z])
  rotate([0,-90,0])
  stock_spacer(length=3.5);

  color("Green")
  translate([-4,0,3_4_tee_center_z])
  rotate([0,-90,0])
  SpringCartridge();

  color("Green")
  translate([-4-3,0,3_4_tee_center_z])
  rotate([0,-90,0])
  SpringCartridge();

  color("CornflowerBlue")
  translate([-3_4_tee_width/2 -12,0,-1/8])
  striker_guide_side();

  // Stock
  union() {

    // Tee
    translate([-12,0,3_4_tee_center_z])
    rotate([0,-90,0])
    %3_4_tee();
    
    translate([(3_4_tee_width/2) + lookup(BushingHeight, BushingThreeQuarterInch) - lookup(BushingDepth, BushingThreeQuarterInch),0,3_4_tee_center_z])
    rotate([0,-90,0])
    %Bushing(spec=BushingThreeQuarterInch);
  
    // Stock Pipe
    translate([-3_4_tee_width/2,0,3_4_tee_center_z])
    rotate([0,-90,0])
    %3_4_pipe(length=12);
  }
}


module Liberator12k_Single() {
  Liberator12k_Base();

  color("Purple")
  render()
  translate([4.3+1/8,0,3_4_tee_center_z])
  rotate([0,-90,0])
  forend_single();
}


module Liberator12k_Revolver() {
  Liberator12k_Base();
  
  translate([3_4_tee_width/2 +3_4_x_1_8_bushing_height - 3_4_x_1_8_bushing_depth+1/8,0,1/8])
  rotate([0,90,0]) {
    revolver_cylinder(debug=true);

    color("Red")
    for (i=[0:6-1])
    rotate([0,0,360/6*i])
    translate([3_4_pipe_od + revolver_cylinder_wall, 0,-1/8])
    ShellSlug();
  }

  color("Purple")
  render()
  translate([6.15+1/8,0,3_4_tee_center_z])
  rotate([0,-90,0])
  forend();
}

//rotate([0,0,360*$t])
scale([25.4, 25.4, 25.4]) {
  Liberator12k_Single();
  //Liberator12k_Revolver();
}