use <Debug.scad>;

include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Angle Stock.scad>;

use <Reference.scad>;
use <Frame.scad>;
use <Tee Housing.scad>;

use <Forend.scad>;

use <Trigger.scad>;
use <Trigger Guard.scad>;
use <Striker.scad>;

use <Ammo/Magazines/Box Magazine.scad>;
use <Ammo/Cartridges/Cartridge_12GA.scad>;

use <Cylinder.scad>;

use <Single Breech.scad>;

module Liberator12k() {

  //render() DebugHalf(dimension=30)
  ForendRevolver();

  *render() DebugHalf(dimension=30)
  Forend(showLugs=true);

  Grip(showTrigger=true);

  Reference_TeeHousing();

  color("HotPink")
  FiringPinGuide(debug=true);

  color("Grey", .7)
  %Frame();

  color("White", 0.2)
  Reference();
}

//rotate([0,0,360*$t])
//scale([25.4, 25.4, 25.4])
{
  render()
  translate([BushingExtension(BreechBushing())+(TeeWidth(ReceiverTee())/2)+WallFrameFront(),0,-CylinderChamberOffset()])
  rotate([0,90,0])
  RevolverCylinder();
  
  DoubleStackBreech();
  
  color("Gold")
  translate([(TeeWidth(ReceiverTee())/2)+WallFrameFront(),+(1/16)+(0.87/2),-(0.87*6)])
  rotate(-90)
  *BoxMagazine(cartridge=Spec_Cartridge_12GAx3(), capacity=5, angle=0,
                   wallSide=1/16, wallFront=1/8, wallBack=1/8,
                   floorHeight=1/8)
  
  *translate([TeeWidth(ReceiverTee())/2,-GripWidth()/2,-6])
  #cube([1.25,GripWidth(), 6]);
  
  Liberator12k();
}
