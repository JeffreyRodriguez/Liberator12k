include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;


// Settings: Lengths
function FrameLength() = 1.125;
function FrameExtension() = 0.375;

// Settings: Vitamins
function FrameBolt() = Spec_BoltM5();
function FrameRod() = Spec_RodFiveSixteenthInch();

module FrameBolts(teardrop=false, flip=false,
              debug=false, cutter=false) {
  
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  mirror([0,0,flip?180:0])
  translate([LowerMaxX()+FrameExtension()+ManifoldGap(),
             Y*ReceiverIR(),
             -ReceiverIR()-ReceiverPipeWall()])
  rotate([0,-90,0])
  Bolt(bolt=FrameBolt(),
       length=FrameLength()+FrameExtension()+ManifoldGap(2), teardrop=cutter&&teardrop,
       clearance=cutter);
}

module FrameMount(pipe=ReceiverPipe(),
                      length=FrameLength(),
                      wallLower=WallLower(),
                      teardropBolts=false,
                      debug=false, alpha=1) {
  color("Olive",alpha)
  DebugHalf(enabled=debug)
  difference() {
      
    // Pipe Lug Center
    translate([LowerMaxX(),-(2/2),LowerOffsetZ()])
    mirror([1,0,0])
    ChamferedCube([length-ManifoldGap(2), 2, ReceiverCenter()-(ReceiverIR()/2)],
                  r=1/16, chamferXYZ=[1,0,0]);
    
    FrameBolts(offsetMinor=length, cutter=true);
    
    PipeLugPipe(cutter=true);
  }
}

module LowerPipeFrame(pipe=ReceiverPipe(),
                      length=FrameLength(),
                      wallLower=WallLower(),
                      cut=true, debug=false, alpha=1) {
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {
    union() {
      FrameMount(length=length, cutCenter=false);
      
      PipeLugCenter(cutter=false);
    }
    
    PipeLugFront(wall=wallLower, cutter=true);
      
    translate([0,0,LowerOffsetZ()])
    SearCutter(length=SearLength()+abs(LowerOffsetZ()));
  }
}

module UpperPipeFrame(length=FrameLength(),
                      cut=true, debug=false, alpha=1) {
  color("Olive")
  DebugHalf(enabled=debug)
  rotate([180,0,0])
  FrameMount(length=length);
}

module FrameAssembly(upper=true, lower=true) {
  
  if (lower) {
    FrameBolts();
    LowerPipeFrame();
  }

  if (upper) {
    FrameBolts(flip=true);
    UpperPipeFrame();
  }
}

AnimateSpin() {
  FrameAssembly();
  PipeLugAssembly(center=false, debug=false, pipeAlpha=0.5);
}


// Plated lower pipe frame
*!scale(25.4) translate([0,0,-LowerOffsetZ()])
LowerPipeFrame();

// Plated upper pipe frame
*!scale(25.4) rotate([0,90,0]) translate([-LowerMaxX(),0,0])
UpperPipeFrame();