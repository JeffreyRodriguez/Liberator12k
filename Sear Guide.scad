//$t=0.999999999;
//$t=0;
include <Components/Animation.scad>;

use <Components/Manifold.scad>;
use <Components/Debug.scad>;
use <Components/Receiver Insert.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Spring.scad>;

use <Reference.scad>;

use <Sear Bolts.scad>;

use <Trigger.scad>;

module SearGuide() {
  
  %SearBolts();
  
  color("LightSeaGreen", 0.5)
  render(convexity=4)
  difference() {
    translate([0,0,-ReceiverCenter()])
    ReceiverInsert(topFactor=0.6);
    
    SearCutter();
    
    SearBolts(cutter=true);
  }
}

scale([25.4, 25.4, 25.4])
{
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
