
use <Lugs.scad>;
use <Lower.scad>;
use <Trigger.scad>;


use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../Receiver.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "LowerLugs", "LowerLug_Front", "LowerLug_Rear"]

_CUTAWAY_RECEIVER = false;

// Settings: Positions
function LowerLugHeight() = 0.0;

module ReceiverBottomSlotInterface(length=0.75, height=abs(LowerOffsetZ()+LowerLugHeight())) {
  difference() {
    union() {
      translate([-length,-1/2,-height+0.1875+0.005])
      ChamferedCube([length, 1, height], r=1/32);
      
      translate([-length,-0.75/2,-height+0.005])
      ChamferedCube([length, 0.75, height], r=1/32);
    }
  }
}

module LowerMount(id=1.25-0.02, alpha=1, debug=false) {
  color("Tan")
  render() DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      translate([0,0,LowerOffsetZ()])
      ReceiverLugFront(extraTop=-LowerOffsetZ()+LowerLugHeight());
      
      translate([0,0,LowerOffsetZ()])
      ReceiverLugRear(extraTop=-LowerOffsetZ()+LowerLugHeight());
      
      translate([ReceiverLugFrontMaxX(),0,0])
      ReceiverBottomSlotInterface(length=3.5+0.5);
    }
    
    // Receiver ID
    difference() {
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      cylinder(r=(id/2), h=4.5, $fn=80);
      
      // Sear Support
      hull() {
        translate([0.125,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, id/2], r=1/32);
        
        translate([LowerMaxX()-1.25,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, 0.25], r=1/32);
      }
      
      // Hammer Guide
      translate([LowerMaxX()-1.25-1,-0.3125/2,-(id/2)-0.25])
      mirror([1,0,0])
      ChamferedCube([2.25, 0.3125, (id/2)], r=1/32);
    }
    
    translate([-0.01,0,0])
    SearCutter();
  }
}

module LowerLugs_print() {
  rotate([0,90,0])
  translate([0.5,0,-LowerOffsetZ()])
  LowerMount();
}

module LowerLug_Front(id=1.25-0.02, alpha=1, debug=false) {
  color("Tan")
  render() DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      translate([0,0,LowerOffsetZ()])
      ReceiverLugFront(extraTop=-LowerOffsetZ()+LowerLugHeight());
      
      translate([ReceiverLugFrontMaxX(),0,0])
      ReceiverBottomSlotInterface(length=1.75);
    }
    
    // Receiver ID
    difference() {
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      cylinder(r=(id/2), h=4.5, $fn=80);
      
      hull() {
        translate([0.125,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, id/2], r=1/32);
        
        translate([LowerMaxX()-1.25,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, 0.25], r=1/32);
      }
    }
    
    translate([-0.01,0,0])
    SearCutter();
  }
}

module LowerLug_Rear(id=1.25-0.02, alpha=1, debug=false) {
  color("Tan")
  render() DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      
      translate([0,0,LowerOffsetZ()])
      ReceiverLugRear(extraTop=-LowerOffsetZ()+LowerLugHeight());
      
      translate([ReceiverLugRearMaxX(),0,0])
      ReceiverBottomSlotInterface(length=0.75+0.75);
    }
    
    difference() {
      
      // Receiver ID
      translate([LowerMaxX(),0,0])
      rotate([0,-90,0])
      cylinder(r=id/2, h=4.5, $fn=80);
      
      // Hammer Guide
      translate([ReceiverLugRearMaxX(),-0.3125/2,-(id/2)-0.25])
      mirror([1,0,0])
      ChamferedCube([0.75, 0.3125, id/2], r=1/32);
    }
  }
}

if (_RENDER == "Assembly") {
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  LowerMount();

  translate([-LowerMaxX(),0,LowerOffsetZ()])
  Lower(showTrigger=true,
        showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
        searLength=SearLength()+abs(LowerOffsetZ())+SearTravel()-(0.25/2));
}

scale(25.4) {
  if (_RENDER == "LowerLugs") {
    LowerLugs_print();
  } else if (_RENDER == "LowerLug_Front") {
    rotate([0,90,0])
    translate([0.5,0,-LowerOffsetZ()])
    LowerLug_Front();
    
  } else if (_RENDER == "LowerLug_Rear") {
    rotate([0,90,0])
    translate([LowerMaxX()-ReceiverLugRearMaxX(),0,-LowerOffsetZ()])
    LowerLug_Rear();
  }
}