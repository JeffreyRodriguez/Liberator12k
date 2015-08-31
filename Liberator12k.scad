include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Angle Stock.scad>;

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
use <Trigger.scad>;

module Liberator12k_Base(receiverTee=TeeThreeQuarterInch) {

  tee_housing_reference(debug=true);

  color("Red")
  render()
  translate([-1/4,-1/8,-1/16])
  rotate([0,90,90])
  trigger();

  color("Gold")
  translate([0,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  striker();

  color("HotPink")
  translate([(TeeWidth(receiverTee)/2) - BushingDepth(breechBushing),0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  firing_pin_guide();

  color("Green")
  translate([-9.4,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  stock_spacer(length=3.5);

  translate([-4,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  SpringCartridge(debug=true);

  translate([-4-3,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  SpringCartridge(debug=true);

  color("CornflowerBlue")
  translate([-TeeWidth(receiverTee)/2 -12,0,-1/8])
  StrikerGuide();

  // Stock
  union() {

    // Tee
    translate([-12,0,TeeCenter(receiverTee)])
    rotate([0,-90,0])
    %Tee(receiverTee);

    translate([(TeeWidth(receiverTee)/2) + lookup(BushingHeight, breechBushing) - lookup(BushingDepth, breechBushing),0,TeeCenter(receiverTee)])
    rotate([0,-90,0])
    %Bushing(spec=breechBushing);

    // Stock Pipe
    translate([-TeeWidth(receiverTee)/2,0,TeeCenter(receiverTee)])
    rotate([0,-90,0])
    %Pipe(stockPipe, length=12);
  }
}


module Liberator12k_Single() {
  Liberator12k_Base();

  color("Purple")
  translate([2,0,TeeCenter(receiverTee)])
  rotate([0,-90,180])
  forend_single(length=6);
}


module Liberator12k_Revolver() {
  Liberator12k_Base();

  translate([TeeWidth(receiverTee)/2 +BushingHeight(breechBushing) - BushingDepth(breechBushing)+1/8,0,1/8])
  rotate([0,90,0]) {
    revolver_cylinder(debug=true);

    color("Red")
    for (i=[0:6-1])
    rotate([0,0,360/6*i])
    translate([PipeOuterDiameter(PipeThreeQuartersInch) + revolver_cylinder_wall, 0,-1/8])
    ShellSlug();
  }

  color("Purple")
  render()
  translate([6.15+1/8,0,TeeCenter(receiverTee)])
  rotate([0,-90,0])
  forend();
}

//rotate([0,0,360*$t])
scale([25.4, 25.4, 25.4]) {
  Liberator12k_Single();
  //Liberator12k_Revolver();
}
