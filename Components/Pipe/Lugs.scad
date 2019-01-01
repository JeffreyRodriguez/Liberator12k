use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Finishing/Chamfer.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

WALL=0.1875;
PIPE = Spec_OnePointFiveSch40ABS();
PIPE_LENGTH = LowerMaxX()-ReceiverLugRearMinX()+0.75+ManifoldGap(2);

function LowerOffsetZ(pipe=PIPE, wall=WALL) = -(PipeOuterRadius(pipe)+wall);
function ReceiverCenter(receiverPipe=PIPE, wallLower=WALL) = PipeOuterRadius(receiverPipe)+wallLower;


module PipeLugPipe(pipe=PIPE, wall=WALL, length=PIPE_LENGTH, debug=false, cutter=false, alpha=1) {
  color("DimGrey", alpha)
  DebugHalf(enabled=debug)
  translate([LowerMaxX(),0,0])
  rotate([0,-90,0])
  Pipe(pipe=PIPE,
       length=length,
       hollow=!cutter, clearance=PipeClearanceLoose());
}
  

module PipeLugFront(pipe=PIPE, wall=WALL, alpha=1, cutter=false) {
  color("DarkGoldenrod", alpha=alpha) render()
  difference() {
    translate([0,0,LowerOffsetZ(pipe=pipe, wall=wall)])
    ReceiverLugFront(extraTop=WALL+PipeWall(PIPE), cutter=cutter);
    
    PipeLugPipe(pipe=pipe, wall=wall, cutter=true);
  }
}

module PipeLugRear(pipe=PIPE, wall=WALL, alpha=1, cutter=false) {
  color("DarkGoldenrod", alpha=alpha) render()
  difference() {  
    translate([0,0,LowerOffsetZ(pipe=pipe, wall=wall)])
    ReceiverLugRear(extraTop=WALL+PipeWall(PIPE), cutter=cutter);
    
    PipeLugPipe(pipe=pipe, wall=wall, cutter=true);
  }
}

module PipeLugCenter(pipe=PIPE, wall=WALL, cutter=false, clearance=0.002, alpha=1) {
  color("Burlywood", alpha=alpha) render()
  difference() {
    union() {
      translate([0,0,LowerOffsetZ(pipe=pipe, wall=wall)])
      translate([0,0,-ManifoldGap()])
      linear_extrude(height=wall+PipeInnerRadius(pipe)+ManifoldGap(2))
      offset(r=(cutter?clearance:0))
      intersection() {
        projection(cut=true)
        translate([0,0,0.001])
        TriggerGuard();
        
        translate([ReceiverLugRearMaxX()-1.375,-1])
        square([LowerMaxX()-ReceiverLugRearMaxX()+1.375,2]);
      }
    }
    
    if (cutter == false) {
      PipeLugPipe(pipe=pipe, wall=wall, cutter=true);
      
      PipeLugFront(cutter=true);
      PipeLugRear(cutter=true);
      
      SearCutter(length=SearLength()+LowerOffsetZ(pipe=pipe, wall=wall));
    }
  }
}

module PipeLugPlater(front=true, rear=true, center=true) {
  
  if (front)
  rotate([0,-90,0])
  translate([-ReceiverLugFrontMinX(),1.5,-ReceiverLugFrontMinX()])
  PipeLugFront();

  if (rear)
  rotate([0,90,0])
  translate([-ReceiverLugRearMaxX(),1.5,ReceiverLugRearMaxX()])
  PipeLugRear();

  if (center)
  PipeLugCenter();
}

module PipeLugAssembly(length=PIPE_LENGTH, debug=false) {
  PipeLugFront(debug=debug);
  PipeLugRear(debug=debug);
  PipeLugCenter(debug=debug);
  PipeLugPipe(length=length, debug=debug, cutter=false);

  translate([0,0,LowerOffsetZ()])
  Lower(showTrigger=true,alpha=1,
        searLength=SearLength()+WALL+PipeWall(PIPE)+0.25);
}

PipeLugAssembly();

*!scale(25.4)
PipeLugPlater(front=true, rear=true, center=true);
