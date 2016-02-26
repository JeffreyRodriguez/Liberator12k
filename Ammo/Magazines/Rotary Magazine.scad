use <../Cartridges/Cartridge.scad>;
use <../Cartridges/Cartridge_22LR.scad>;

module RotaryMagazine(cartridge=Spec_Cartridge_22LR(), capacity=3,
                   wallSide=1/16, wallFront=1/8, wallBack=1/8,
                   floorHeight=1/32) {

  majorWidth  = CartridgeRimDiameter(cartridge)+0.03;
  minorWidth  = CartridgeBulletDiameterMax(cartridge)+0.03;
  shellLength = CartridgeOverallLength(cartridge)+0.03;

  widthDiff = majorWidth - minorWidth;
  halfDiff  = widthDiff/2;

  union() {
    difference() {
      linear_extrude(height=floorHeight+(majorWidth*capacity))
      polygon([
        [0,0],
        [halfDiff,wallBack+shellLength+wallFront],
        [halfDiff+wallSide+minorWidth+wallSide, wallBack+shellLength+wallFront],
        [wallSide+majorWidth+wallSide, 0]
      ]);

      translate([0,0,floorHeight])
      linear_extrude(height=(majorWidth*capacity)+0.1)
      polygon([
        [wallSide,wallBack],
        [halfDiff+wallSide,wallBack+shellLength],
        [halfDiff+wallSide+minorWidth, wallBack+shellLength],
        [wallSide+majorWidth, wallBack]
      ]);
    }
  }
}

scale([25.4, 25.4, 25.4]) {
  //translate([-1/8, -1/8,0])
  RotaryMagazine();
}
