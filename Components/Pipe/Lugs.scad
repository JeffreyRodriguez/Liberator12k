use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Finishing/Chamfer.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

WALL=0.1875;
PIPE = Spec_OnePointFiveSch40ABS();
PIPE_LENGTH = LowerMaxX()-ReceiverLugRearMinX()+0.75+ManifoldGap(2);

function PipeLugPipeOffsetZ(pipe, wall) = PipeOuterRadius(pipe)+wall;

module PipeLugPipe(pipe=PIPE, wall=WALL, length=PIPE_LENGTH, cutter=false, alpha=1) {
  color("DimGrey", alpha) render()
    translate([ReceiverLugRearMinX()-0.75,0,PipeLugPipeOffsetZ(pipe=pipe, wall=wall)])
    rotate([0,90,0])
    Pipe(pipe=PIPE,
         length=length,
         hollow=!cutter, clearance=PipeClearanceLoose());
}
  

module PipeLugFront(pipe=PIPE, wall=WALL, alpha=1, cutter=false) {
  color("DarkGoldenrod", alpha=alpha) render()
  difference() {
    ReceiverLugFront(extraTop=WALL+PipeWall(PIPE), cutter=cutter);
    
    PipeLugPipe(pipe=pipe, wall=wall, cutter=true);
  }
}

module PipeLugRear(pipe=PIPE, wall=WALL, alpha=1, cutter=false) {
  color("DarkGoldenrod", alpha=alpha) render()
  difference() {  
    ReceiverLugRear(extraTop=WALL+PipeWall(PIPE), cutter=cutter);
    
    PipeLugPipe(pipe=pipe, wall=wall, cutter=true);
  }
}

module PipeLugCenter(pipe=PIPE, wall=WALL, alpha=1) {
  color("Burlywood", alpha=alpha) render()
  difference() {
    union() {
      linear_extrude(height=WALL+PipeWall(PIPE)+0.125)
      intersection() {
        projection(cut=true)
        translate([0,0,0.001])
        TriggerGuard();
        
        translate([ReceiverLugRearMaxX()-1.375,-1])
        square([LowerMaxX()-ReceiverLugRearMaxX()+1.375,2]);
      }
    }
    
    PipeLugPipe(pipe=pipe, wall=wall, cutter=true);
    
    PipeLugFront(cutter=true);
    PipeLugRear(cutter=true);
    
    SearCutter(length=SearLength()+PipeLugPipeOffsetZ(pipe=pipe, wall=wall));
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


PipeLugFront();
PipeLugRear();
PipeLugCenter();
PipeLugPipe(cutter=false);

Lower(showTrigger=true,alpha=1,
      searLength=SearLength()+WALL+PipeWall(PIPE)+0.25);

*!scale(25.4)
PipeLugPlater(front=true, rear=true, center=true);
