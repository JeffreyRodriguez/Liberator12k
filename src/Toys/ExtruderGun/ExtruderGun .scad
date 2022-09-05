//$t=0.7267;

use <../../Meta/Debug.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

use <../../Receiver/Lower/Receiver Lugs.scad>;
use <../../Receiver/Lower/Trigger.scad>;
use <../../Receiver/Lower/Lower.scad>;

use <Battery Socket.scad>;

use <Tri18650.scad>;

//echo($vpr);

//$vpr = [80, 0, 360*$t];
module NEMA17() {
  translate([0, 0, -UnitsMetric(42)/2])
  union() {
    
    cube([UnitsMetric(42), UnitsMetric(42), UnitsMetric(42)]);
    
    translate([UnitsMetric(42)/2, UnitsMetric(10), UnitsMetric(42)/2])
    for (i = [180, -90])
    rotate([0,i,0])
    translate([UnitsMetric(31)/2, UnitsMetric(4.5), UnitsMetric(31)/2])
    rotate([90,0,0])
    NutAndBolt(bolt=Spec_BoltM3(), boltLength=UnitsMetric(30),
         clearance=true, teardrop=false, teardropAngle=-90);
  }
}

module E3Dv6(cutter=false, linerHeight=UnitsMetric(25.4), $fn=50) {
  clearance = cutter ? UnitsMetric(0.3) : 0;
  
  render()
  #union() {
    
    // Mounting Head Top
    mirror([0,0,1])
    cylinder(r=(UnitsMetric(16)/2)+clearance, h=UnitsMetric(3.7)+clearance);
    
    // Mounting Head Middle
    translate([0,0,-ManifoldGap()])
    mirror([0,0,1])
    cylinder(r=(UnitsMetric(12)/2)+clearance, h=UnitsMetric(12.7)-ManifoldGap(2));
    
    // Mounting Head Bottom
    translate([0,0,-UnitsMetric(12.7)-UnitsMetric(4)])
    cylinder(r=(UnitsMetric(16)/2)+clearance, h=UnitsMetric(3)+UnitsMetric(4)+clearance);
    
    // Heatsink
    translate([0,0,-UnitsMetric(42.7)])
    cylinder(r=UnitsMetric(22.3)/2, h=UnitsMetric(26));
    
    // PTFE liner catch
    cylinder(r=(UnitsMetric(7)/2)+clearance, h=UnitsMetric(3));
    
    // PTFE liner
    cylinder(r=(UnitsMetric(4)/2)+clearance, h=linerHeight);
  }
}


module GrooveMount(extruderOffsetX=LowerMaxX()-UnitsMetric(12.7)) {
  render()
  difference() {
    translate([]) {
      
      // Bottom
      union() {
        translate([ReceiverLugFrontMinX()-0.25,-0.625,0])
        cube([LowerMaxX()-ReceiverLugFrontMinX()+0.25, 1.25, 0.995]);
      }
    
      // Top
      union() {
        translate([LowerMaxX()-UnitsMetric(12.7),-0.625-ManifoldGap(),1.005])
        cube([UnitsMetric(12.7), 1.25+ManifoldGap(2),1.0]);
        
        translate([LowerMaxX()-UnitsMetric(12.7)-0.5,-0.625-ManifoldGap(),1.005])
        cube([UnitsMetric(12.7)+0.5, 1.25+ManifoldGap(2),1.0]);
      }
    }
    
    translate([extruderOffsetX-UnitsMetric(2.9)-ManifoldGap(),-0.25,(UnitsMetric(11)/2)+UnitsMetric(25.4)])
    mirror([1,0,0])
    NEMA17();
    
    ReceiverLugFront(extraTop=0.39, clearance=0.002, cutter=true);
    
    translate([extruderOffsetX,0,0]) {
      translate([-ManifoldGap(),0,UnitsMetric(25.4)])
      rotate([0,-90,0])
      E3Dv6(cutter=true);
      
      for (m = [0,1])
      mirror([0,m,0])
      #translate([UnitsMetric(6),UnitsMetric(12),1.5+ManifoldGap(2)])
      NutAndBolt(bolt=Spec_BoltM4(), boltLength=UnitsMetric(30),
           capOrientation=true, capHeightExtra=1,
           clearance=true, nutBackset=0.02, nutHeightExtra=0.125, nutSideExtra=1);
    }
    
  }
}

module BatteryPack() {
  render()
  union() {
    translate([ReceiverLugRearMaxX(),0,UnitsMetric(25.4)])
    rotate([0,-90,0])
    scale(1/25.4)
    Tri18650();
    
    ReceiverLugRear(extraTop=0.27, cutter=false);
        
    // Match the top of the lower-receiver
    linear_extrude(height=0.28)
    hull()
    intersection() {
      translate([ReceiverLugRearMinX()-1,-1])
      square([ReceiverLugRearLength()+1, 2]);
      
      projection(cut=true)
      translate([0,0,ManifoldGap()])
      Lower(showTrigger=false);
    }
  }
}

module ExtruderGun() {
  
  BatteryPack();
  
  ReceiverLugFront(extraTop=0.38, cutter=false);
  
  color("Gold", 0.5)
  GrooveMount();
  
  // Lower
  %translate([0,0,0]) {
    ReceiverLugBoltHoles(clearance=false);
    GuardBolt(clearance=false);
    HandleBolts(clearance=false);
    Lower(showTrigger=true);
  }
  
  translate([-2.875,0,-4.1875])
  scale(1/25.4)
  rotate([0,90,0])
  BatterySocket();
}

scale(25.4)
ExtruderGun();
