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
  translate([0,0,-ReceiverCenter()])
  difference() {
    ReceiverInsert(topFactor=0.6);
    
    // Sear hole
    translate([0,0,-0.5-ManifoldGap()])
    cylinder(r=RodRadius(SearRod(), RodClearanceLoose()),
             length=ReceiverLength()+0.5,
             $fn=RodFn(SearRod()));
    
    translate([0,0,ReceiverCenter()])
    SearBolts(cutter=true);
  }
}

scale([25.4, 25.4, 25.4])
{
  %Sear();
  
  //DebugHalf(3)
  
  SearGuide();
  
  
  *Reference();
}
