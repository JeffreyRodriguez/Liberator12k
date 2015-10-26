include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Angle Stock.scad>;

use <Cylinder.scad>;
use <Forend.scad>;
use <Forend_Single.scad>;
use <Tee Housing.scad>;
use <Reference.scad>;
use <Firing Pin Guide.scad>;
use <Striker.scad>;
use <Striker Guide.scad>;
use <Stock Spacer.scad>;
use <Spring Cap.scad>;
use <Ammo/Shell Slug.scad>;
use <Trigger.scad>;

module Liberator12k_Base(receiverTee=TeeThreeQuarterInch) {

  %Reference();

  Reference_TeeHousing();

  color("Red")
  render()
  translate([-1/4,-1/8,-1/16])
  rotate([0,90,90])
  trigger();

  color("Gold")
  rotate([0,-90,0])
  striker();

  color("HotPink")
  translate([(TeeWidth(receiverTee)/2) - BushingDepth(breechBushing),0,0])
  rotate([0,-90,0])
  firing_pin_guide();

  translate([-4.1,0,0])
  rotate([0,-90,0])
  SpringCartridge(debug=false);

  translate([-4.3-3,0,0])
  rotate([0,-90,0])
  SpringCartridge(debug=false);

  color("CornflowerBlue")
  translate([-TeeWidth(receiverTee)/2 -12,0,-(1/8)-TeeCenter(receiverTee)])
  StrikerGuide();

}


module Liberator12k_Single() {
  Liberator12k_Base();

  color("Purple")
  render()
  translate([2,0,0 ])
  rotate([0,-90,180])
  forend_single(length=6);
}

//rotate([0,0,360*$t])
scale([25.4, 25.4, 25.4]) {
  Liberator12k_Single();
  //Liberator12k_Revolver();
}
