//$t=0.999999999;
//$t=0;
include <../../Meta/Animation.scad>;

use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Spring.scad>;

use <../../Components/Receiver Insert.scad>;

use <../../Reference.scad>;

use <../../Lower/Trigger.scad>;

use <Sear Bolts.scad>;

module SearGuide() {
  
  %SearBolts();
  
  color("LightSeaGreen", 0.5)
  render(convexity=4)
  difference() {
    translate([0,0,-ReceiverCenter()])
    ReceiverInsert(topFactor=0.6);
    
    translate([0,0,-ReceiverCenter()])
    SearCutter();
    
    SearBolts(cutter=true);
  }
}

scale([25.4, 25.4, 25.4])
{
    translate([0,0,-ReceiverCenter()])
  %Sear();
  
  //DebugHalf(3)
  
  SearGuide();
  
  *Reference();

  *render()
  rotate([90,0,0])
  difference() {
    SearSupportTab();
    
    for (i = [0,1])
    mirror([i,0,0])
    translate([SearBoltOffset()-0.125,-0.5,-ReceiverCenter()-0.15])
    cube([0.25, 1, 0.3]);
  }
}
