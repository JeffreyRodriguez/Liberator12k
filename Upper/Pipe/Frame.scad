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
function FrameLength() = 0.875;
function FrameBoltExtension() = 0.5;
function FrameExtension() = 0.5;

// Settings: Vitamins
function FrameBolt() = Spec_BoltM5();
function FrameRod() = Spec_RodFiveSixteenthInch();

module FrameBolts(teardrop=false, flip=false,
              debug=false, cutter=false) {
  
  color("CornflowerBlue")
  DebugHalf(enabled=debug)
  for (Y = [-1,1])
  mirror([0,0,flip?180:0])
  translate([LowerMaxX()+FrameBoltExtension()+FrameExtension()+ManifoldGap(),
             Y*ReceiverIR(),
             -ReceiverIR()-ReceiverPipeWall()])
  rotate([0,-90,0])
  FlatHeadBolt(length=2, //FrameLength()+FrameExtension()+FrameBoltExtension()+ManifoldGap(2),
               teardrop=cutter&&teardrop, cutter=cutter);
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
    
    FrameBolts(cutter=true);
    
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
      translate([FrameExtension(),0,0])
      FrameMount(length=FrameExtension()+length, cutCenter=false);
      
      PipeLugCenter(cutter=false);
    }
    
    FrameBolts(cutter=true);
    
    PipeLugFront(wall=wallLower, cutter=true);
      
    translate([0,0,LowerOffsetZ()])
    SearCutter(length=SearLength()+abs(LowerOffsetZ()));
  }
}

module FrameAssembly() {
  *FrameBolts();
  LowerPipeFrame();
}

AnimateSpin() {
  FrameAssembly();
  PipeLugAssembly(pipeOffsetX=FrameExtension(),
                  center=false, debug=false, pipeAlpha=0.5);
}


// Plated lower pipe frame
*!scale(25.4) translate([0,0,-LowerOffsetZ()])
LowerPipeFrame();