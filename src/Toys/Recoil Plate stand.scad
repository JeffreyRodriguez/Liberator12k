use <../Shapes/Chamfer.scad>;
use <../Receiver/FCG.scad>;
use <../Meta/Units.scad>;

boxWidth = Millimeters(70);

module RecoilPlateStand() {
  height = 0.26;

  render()
  difference() {

    hull() {

      // Mounting face
      for (Y = [1,-1])
      translate([0,0.5*Y, 0])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.375, r2=1/16, h=0.25);

      // Base
      translate([-0.125,-(boxWidth/2),-(boxWidth/2)-0.25])
      rotate([0,-15,0])
      ChamferedCube([1/8, boxWidth, boxWidth],
                     r=1/16, teardropFlip=[true,true,true]);
    }

    RecoilPlateCenterBolts(cutter=true, boltLength=0.5);
  }
}

if ($preview) {
  RecoilPlateCenterBolts(boltLength=0.5);
  RecoilPlateStand();
  RecoilPlate(alpha=0.5);
} else {
  scale(25.4) rotate([0,-90+15,0])
  RecoilPlateStand();
}
