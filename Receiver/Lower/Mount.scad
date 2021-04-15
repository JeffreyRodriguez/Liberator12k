use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../Receiver.scad>;

use <Lugs.scad>;
use <Lower.scad>;
use <Trigger.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "LowerMount_Front", "LowerMount_Rear"]

/* [Assembly] */
_CUTAWAY_RECEIVER = false;
_SHOW_RECEIVER = true;
_SHOW_LOWER = true;

// Settings: Positions
function LowerOffsetZ() = ReceiverBottomZ();

//**********
//* Shapes *
//**********
module ReceiverBottomSlotInterface(length=0.75, height=abs(LowerOffsetZ()), clearance=0.005) {
  difference() {
    union() {
      translate([-length,-1/2,-height+WallTensionRod()+clearance])
      ChamferedCube([length, 1, height-WallTensionRod()], r=1/32, teardropFlip=[true,true,true]);
      
      translate([-length,-0.75/2,-height])
      ChamferedCube([length, 0.75, height], r=1/32, teardropFlip=[true,true,true]);
    }
  }
}

//*****************
//* Printed Parts *
//*****************
module LowerMount_Front(id=ReceiverID(), alpha=1, debug=false) {
  mountLength = 1.75-0.01;
  
  color("Chocolate")
  render() DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      translate([0,0,LowerOffsetZ()])
      ReceiverLugFront(extraTop=-LowerOffsetZ());
      
      translate([ReceiverLugFrontMaxX(),0,0])
      ReceiverBottomSlotInterface(length=mountLength);
    }
    
    difference() {
      
      // Receiver ID
      translate([ReceiverLugFrontMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=id/2, r2=1/8, h=mountLength, $fn=80,
                            teardropBottom=true,
                            teardropTop=true);
      // Sear support
      hull() {
        translate([0.125,-0.3125/2,-(id/2)-0.3125])
        ChamferedCube([0.25, 0.3125, id/2], r=1/16, teardropFlip=[true,true,true]);
        
        translate([LowerMaxX()-1.25,-0.3125/2,-(id/2)-0.25])
        ChamferedCube([0.25, 0.3125, 0.25], r=1/16, teardropFlip=[true,true,true]);
      }
    }
    
    translate([-0.01,0,0])
    SearCutter();
  }
}

module LowerMount_Rear(id=ReceiverID(), alpha=1, debug=false) {
  mountLength = ReceiverLength()
              - abs(ReceiverLugRearMaxX())
              - LowerMaxX()
              - ManifoldGap();
  
  color("Chocolate")
  render() DebugHalf(enabled=debug)
  translate([-LowerMaxX(),0,0])
  difference() {
    union() {
      
      translate([0,0,LowerOffsetZ()])
      ReceiverLugRear(extraTop=-LowerOffsetZ());
      
      translate([ReceiverLugRearMaxX(),0,0])
      ReceiverBottomSlotInterface(length=mountLength);
    }
    
    difference() {
      
      // Receiver ID
      translate([ReceiverLugRearMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=id/2, r2=1/8, h=mountLength, $fn=80,
                            teardropBottom=true,
                            teardropTop=true);
      
      // Hammer Guide
      translate([ReceiverLugRearMaxX(),-0.3125/2,-(id/2)-0.375])
      mirror([1,0,0])
      ChamferedCube([mountLength, 0.3125, id/2], r=1/16, teardropFlip=[true,true,true]);
    }
  }
}

//**************
//* Assemblies *
//**************
module LowerMount(id=ReceiverID(), alpha=1, debug=false) {
  LowerMount_Front();
  
  LowerMount_Rear();
}


//*************
//* Rendering *
//*************


echo("Sear length: ", SearLength()+abs(LowerOffsetZ()));
*!scale(25.4)
translate([0.125,abs(LowerOffsetZ()),0.125])
rotate([90,0,0])
Sear(length=SearLength()+abs(LowerOffsetZ()));

if ($preview) {
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
  
  LowerMount();

  if (_SHOW_LOWER)
  translate([-LowerMaxX(),0,LowerOffsetZ()])
  Lower(showTrigger=true,
        showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
        searLength=SearLength()+abs(LowerOffsetZ())+SearTravel()-(0.25/2));
} else scale(25.4) {
  if (_RENDER == "LowerMount_Front") {
    rotate([0,90,0])
    translate([0.5,0,-LowerOffsetZ()])
    LowerMount_Front();
    
  } else if (_RENDER == "LowerMount_Rear") {
    rotate([0,90,0])
    translate([LowerMaxX()-ReceiverLugRearMaxX(),0,-LowerOffsetZ()])
    LowerMount_Rear();
  }
}