//$t=0.999999999;
//$t=0;
include <../../../Meta/Animation.scad>;

use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;

use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Spring.scad>;

use <../../../Components/Tee Insert.scad>;

use <../Reference.scad>;

use <../../../Lower/Trigger.scad>;
use <../../../Lower/Lower.scad>;

use <Sear Bolts.scad>;

module SearGuide() {

  %SearBolts(teardrop=false);

  color("LightSeaGreen", 0.5)
  render(convexity=4)
  difference() {
    translate([0,0,-ReceiverCenter()])
    TeeInsert(tee=ReceiverTee(), topFactor=0.7);

    translate([0,0,-ReceiverCenter()])
    SearCutter();

    SearBolts(teardrop=false, cutter=true);
  }
}


module SearSupportTabWithBoltCutouts() {
  render()
  difference() {
    SearSupportTab();

    for (i = [0,1])
    mirror([i,0,0])
    translate([SearBoltOffset()-0.125,-0.5,-0.15])
    cube([0.25, 1, 0.3]);

    HandleBolts(clearance=true);
  }
}

translate([0,0,-ReceiverCenter()])
%Sear();

//!scale(25.4)
SearGuide();

*!scale(25.4) rotate([90,0,0])
translate([0,0,-ReceiverCenter()])
SearSupportTabWithBoltCutouts();
