//$t=0.8;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Semicircle.scad>;

use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;

use <../../../Ammo/Cartridges/Cartridge.scad>;
use <../../../Ammo/Cartridges/Cartridge_12GA.scad>;

use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Lower.scad>;
use <../../../Lower/Trigger.scad>;

use <../Reference.scad>;

use <../Frame.scad>;

function ForendX() = ReceiverLugFrontMaxX()+FrameCouplingNutLength()+ManifoldGap();
function ForendBreechGap() = ForendX()-BreechFrontX();

module Forend(barrelSpec=BarrelPipe(), length=1,
              wall=WallTee(), wallTee=0.7, scallopAngles=[90,-90],
              $fn=40) {
  color("DimGrey")
  render(convexity=4)
  translate([ForendX(),0,0])
  difference() {
    union() {
      rotate([0,90,0])
      linear_extrude(height=length) {
          Quadrail2d(scallopAngles=scallopAngles,
                     wall=wall,
                     wallTee=wallTee);
      }

      children();
    }

    Frame(cutter=true);

    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel(barrel=barrelSpec,cutter=true);
  }
}

module ForendFront(length=0.25) {

  color("DimGrey")
  render()
  Forend(length=length) {

    // Front bead sight
    hull() {
      mirror([1,0])
      translate([0,-0.125])
      square([ReceiverCenter()+0.5,0.25]);

      mirror([1,0])
      translate([0,-ReceiverOR()])
      square([ReceiverCenter(),ReceiverOD()]);
    }
  }
}

Forend();

translate([FrameRodLength()-ForendX(),0,0])
ForendFront();

Frame();
Receiver();
Breech();
