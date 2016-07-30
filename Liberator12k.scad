use <Components/Debug.scad>;

//include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Angle Stock.scad>;

use <Reference.scad>;
use <Frame.scad>;
use <Tee Housing.scad>;

use <Forend.scad>;

use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Striker.scad>;
use <Firing Pin Guide.scad>;

use <Ammo/Magazines/Box Magazine.scad>;
use <Ammo/Cartridges/Cartridge_12GA.scad>;

use <Cylinder.scad>;

use <Single Breech.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];


module Liberator12k() {

  //color("White", 0.2)
  Reference();

  //render() DebugHalf(dimension=30)
  //for(i=[0,1]) translate([(2.01)*i,0,0])
  ForendRevolver();

  Grip(showTrigger=true);
  
  TeeHousingFront();
  TeeHousingBack();

  FiringPinGuide(debug=true);

  color("Grey")
  Frame();

  color("Grey")
  CylinderSpindle();
}

//rotate([0,0,360*$t])
//scale([25.4, 25.4, 25.4])
{
  color("Gold")
  render()
  translate([BushingExtension(BreechBushing())+(TeeWidth(ReceiverTee())/2)+WallFrameFront(),0,-CylinderChamberOffset()])
  rotate([0,90,0])
  RevolverCylinder();

  *DoubleStackBreech();

  color("Gold")
  translate([(TeeWidth(ReceiverTee())/2)+WallFrameFront(),+(1/16)+(0.87/2),-(0.87*6)])
  rotate(-90)
  *BoxMagazine(cartridge=Spec_Cartridge_12GAx3(), capacity=5, angle=0,
                   wallSide=1/16, wallFront=1/8, wallBack=1/8,
                   floorHeight=1/8);

  Liberator12k();
}
