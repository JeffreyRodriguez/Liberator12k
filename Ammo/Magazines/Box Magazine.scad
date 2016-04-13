use <../Cartridges/Cartridge.scad>;
use <../Cartridges/Cartridge_22LR.scad>;
use <../Cartridges/Cartridge_12GA.scad>;


module BoxMagazineSkew(angle) {
  multmatrix([
     [1, 0, 0,    0],
     [0, 1, sin(angle), 0],
     [0, 0, 1,    0],
     [0, 0, 0,    1]
   ])
   children();
}

module BoxMagazine(cartridge=Spec_Cartridge_22LR(), capacity=15, angle=10,
                   wallSide=1/16, wallFront=1/8, wallBack=1/8,
                   floorHeight=1/8) {

  majorWidth  = CartridgeRimDiameter(cartridge)+0.05;
  minorWidth  = CartridgeBulletDiameterMax(cartridge)+0.05;
  shellLength = CartridgeOverallLength(cartridge)+0.04;

  widthDiff = majorWidth - minorWidth;
  halfDiff  = widthDiff/2;

  union() {
    BoxMagazineSkew(angle)
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





module BoxMagazineFollower(cartridge=Spec_Cartridge_22LR(),
                           baseHeight=1, angle=30) {


  majorWidth  = CartridgeRimDiameter(cartridge);
  minorWidth  = CartridgeBulletDiameterMax(cartridge);
  length      = CartridgeOverallLength(cartridge);
  cutLength   = 0.1;

  widthDiff = majorWidth - minorWidth;
  halfDiff  = widthDiff/2;

  BoxMagazineSkew(angle)
  difference() {
    intersection() {
      linear_extrude(height=baseHeight + (tan(angle)*length))
      polygon([
        [0,0],
        [halfDiff,length],
        [halfDiff+minorWidth, length],
        [majorWidth, 0]
      ]);


      rotate([90,0,90])
      linear_extrude(height=majorWidth)
      polygon([
        [0,0],
        [0,baseHeight],
        [length-cutLength,(tan(angle)*(length-cutLength)) + baseHeight],
        [length,(tan(angle)*(length-cutLength)) + baseHeight],
        [length,0]
      ]);
    }

    // Round cutout
    *translate([majorWidth/2,length+0.1,(tan(angle)*length) + (minorWidth/2)])
    rotate([90,0,0])
    cylinder(r=minorWidth/2, h=length, $fn=36);
  }
}

scale([25.4, 25.4, 25.4])
{
  //translate([-1/8, -1/8,0])
  BoxMagazine();

  translate([-1/2,0,0])
  BoxMagazineFollower();
}
