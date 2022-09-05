use <Dewalt 20v Battery.scad>;
use <../Receiver/Receiver.scad>;
use <../Shapes/Chamfer.scad>;
use <../Meta/Manifold.scad>;


module Dewalt20vBatteryReceiverSegment(length=72) {
  offsetZ = -(ReceiverOR()*25.4)-18;
  render()
  difference() {
    union() {
      scale(25.4)
      mirror([1,0,0])
      ReceiverSegment(length=length/25.4);
      
      translate([0,-30,offsetZ])
      ChamferedCube([length, 60, 19.75], r=1/16*25.4);
    }
    
    rotate([0,90,0])
    cylinder(r=1.75/2*25.4, h=length+ManifoldGap());
    
    translate([5,0,offsetZ]) {
      Dewalt20vBatteryCutter();
      Dewalt20vBatteryTerminals(extend=5);
    }
    
    mirror([1,0,0])
    scale(25.4)
    TensionBolts(length=length/25.4, cutter=true,
                 nutType="none", headType="none");
  }
}

rotate([0,-90,0])
Dewalt20vBatteryReceiverSegment();