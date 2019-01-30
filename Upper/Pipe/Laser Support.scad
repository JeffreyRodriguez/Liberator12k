include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Pipe/Lugs.scad>;
use <../../Components/Firing Pin.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Frame.scad>;

module LaserSupport(od=0.52, length=1) {
  radius = od/2;
  
  color("Olive")
  DebugHalf(enabled=false)
  difference() {
    rotate([0,90,0]) rotate(90)
    hull() {
      translate([ReceiverOR()+radius,0,0])
      cylinder(r=radius+0.125, h=length, $fn=20);
      
      translate([ReceiverOR()-radius,-od+0.125,0])
      cube([od, od+0.25, length]);
    }

    rotate([0,90,0]) rotate(90)
    translate([ReceiverOR()+radius,0,0])
    cylinder(r=radius+0.01, h=length, $fn=20);
    
    PipeLugPipe(cutter=true);
  }
}

scale(25.4)
LaserSupport();