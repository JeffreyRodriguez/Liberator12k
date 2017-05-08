//$t=0.8;
use <../../../../Meta/Manifold.scad>;
use <../../../../Meta/Resolution.scad>;

use <../../../../Components/Semicircle.scad>;

use <../../../../Vitamins/Pipe.scad>;
use <../../../../Vitamins/Rod.scad>;
use <../../../../Vitamins/Double Shaft Collar.scad>;

use <../../../../Ammo/Cartridges/Cartridge.scad>;
use <../../../../Ammo/Cartridges/Cartridge_12GA.scad>;

use <../../../../Lower/Receiver Lugs.scad>;
use <../../../../Lower/Lower.scad>;
use <../../../../Lower/Trigger.scad>;

use <../../Reference.scad>;

use <../../Frame.scad>;
use <../../Cross Upper.scad>;
use <../Forend.scad>;


module ForendBaseplate(length=ForendX()-ReceiverLugFrontMaxX()-ManifoldGap()) {
  color("DimGrey")
  render()
  translate([LowerMaxX()-LowerWallFront()+ManifoldGap(),0,0])
  difference() {
    translate([-ForendX(),0,0])
    Forend(length=length);

    Frame();

    // Larger center hole for the hex plug
    translate([-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=(BushingCapWidth(Spec_BushingThreeQuarterInch())/2)+0.1,
             h=length*2, $fn=30);
  }
}

ForendBaseplate();
CrossUpperFront();
translate([0,0,-ReceiverCenter()])
Lower();

Frame();
Receiver();
Breech();