include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Math/Circles.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;

use <../../Vitamins/AR15/Barrel.scad>;

use <../Lower.scad>;
use <../Receiver.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "AR15_Trunnion", "AR15_TrunnionCap"]

// Cut assembly view in half
_DEBUG_ASSEMBLY = false;

function AR15_TrunnionLength() = AR15BarrelExtensionLength()+AR15BarrelExtensionLipLength();

module AR15_Trunnion(doRender=true) {
  length = AR15_TrunnionLength();
  
  color("Brown")
  RenderIf(doRender)
  translate([length,0,0])
  difference() {
    Receiver_Segment(length=length);
    
    translate([-length,0,0])
    rotate([0,90,0])
    rotate(180)
    AR15_Barrel(cutter=true);
    
    Receiver_TensionBolts(cutter=true, nutType="none");
  }
}

module AR15_TrunnionCap(doRender=true) {
  length = 0.25;
  
  color("Burlywood")
  RenderIf(doRender)
  translate([AR15_TrunnionLength()+length,0,0])
  difference() {
    Receiver_Segment(length=length);
    
    translate([-length,0,0])
    rotate([0,90,0])
    rotate(180)
    AR15_Barrel(cutter=true);
    
    Receiver_TensionBolts(cutter=true, nutType="none");
  }
}

module AR15_TrunnionAssembly() {
  rotate([0,90,0])
  rotate(180)
  AR15_Barrel(cutter=true);
  
  AR15_Trunnion();
  
  AR15_TrunnionCap();
  ReceiverAssembly();
  
  Lower();
  LowerMount();
}

scale(25.4) {
  if (_RENDER == "Assembly")
  AR15_TrunnionAssembly();
  
  if (_RENDER == "Bolt Carrier")
    BoltCarrier_print();

  if (_RENDER == "AR15_Trunnion")
    translate([0,0,0])
    rotate([0,90,0])
    AR15_Trunnion();
  
  if (_RENDER == "AR15_TrunnionCap")
    rotate([0,-90,0])
    translate([-AR15_TrunnionLength(),0,0])
    AR15_TrunnionCap();
  
  if (_RENDER == "Bolt Carrier Track")
  rotate([0,90,0])
  ReceiverBoltTrack();
}


