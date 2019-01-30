include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Firing Pin.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Lugs.scad>;
use <Frame.scad>;


module Beltclip() {
  
  od=0.5;
  radius = od/2;
  color("Olive")
  DebugHalf(enabled=false)
  rotate([-90,0,0])
  difference() {
    
    translate([-3,-ReceiverIR()/2,-ReceiverOR()-0.25])
    ChamferedCube([2, ReceiverIR(), ReceiverIR()], r=1/16);
    
    translate([-2.5,
               -ReceiverOR(),
               -ReceiverIR()-0.25])
    ChamferedCube([2, ReceiverOD(), ReceiverIR()+ManifoldGap(2)], teardrop=false, r=1/16);
    
    translate([-3,0,0])
    PipeLugPipe(cutter=true);
  }
  
}

//scale(25.4) translate([3,0,ReceiverOR()+0.25]) rotate([90,0,0])
Beltclip();