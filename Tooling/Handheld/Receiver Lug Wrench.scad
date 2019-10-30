use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;

use <../Vitamins/Nuts And Bolts.scad>;

use <../Receiver/Lower/Receiver Lugs.scad>;
WALL = 0.25;
BOLT = Spec_BoltM4();

module ReceiverLugFrontWrench(width=1) {
  difference() {
    
    translate([ReceiverLugFrontMinX()-WALL,0,-ManifoldGap()])
    mirror([0,0,1])
    cube([ReceiverLugFrontLength()+WALL*2, width/2, 3]);
    
    ReceiverLugFront();
    
    translate([WALL + (0.75/2),0,-0.75])
    translate([ReceiverLugFrontMinX()-WALL,width/2,-ManifoldGap()])
    rotate([90,0,0])
    translate([0,0,-NutHexHeight(BOLT)-ManifoldGap()])
    NutAndBolt(bolt=BOLT, boltLength=UnitsMetric(30));
  }
}

ReceiverLugFront();
ReceiverLugRear();
ReceiverLugFrontWrench();