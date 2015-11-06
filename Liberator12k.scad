use <Debug.scad>;

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
use <Frame.scad>;
use <Trigger Guard.scad>;

module Liberator12k_Base(receiverTee=TeeThreeQuarterInch) {

  Reference_TriggerGuard(debug=true);

  Reference_TeeHousing();

  color("HotPink")
  translate([(TeeWidth(receiverTee)/2) - BushingDepth(breechBushing),0,0])
  rotate([0,-90,0])
  firing_pin_guide();

  render() {
    translate([-4.5,0,0])
    rotate([0,-90,0])
    SpringCartridge(debug=true);

    translate([-4.55-3,0,0])
    rotate([0,-90,0])
    SpringCartridge(debug=true);
  }
  
  color("Gold")
  translate([-TeeWidth(receiverTee)/2 -12,0,-(1/8)-TeeCenter(receiverTee)])
  StrikerGuide();
  
  color("Grey", 1)
  *Frame();
  
  color("White", 0.2)
  *Reference();
}


module Liberator12k_Single() {

  color("Olive")
  render()
  translate([3,0,0 ])
  forend_single(length=3.5);
  
  Liberator12k_Base();
}

//rotate([0,0,360*$t])
scale([25.4, 25.4, 25.4]) {
  Liberator12k_Single();
  //Liberator12k_Revolver();
}
