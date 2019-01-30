use <../../Finishing/Chamfer.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;


use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

// Settings: Walls
function WallLower()      = 0.1875;

// Settings: Lengths
function ReceiverLength() = 6;

// Settings: Vitamins
function ReceiverPipe()  = Spec_OnePointFiveSch40ABS();

// Calculated: Measurements
function ReceiverID()     = PipeInnerDiameter(ReceiverPipe());
function ReceiverIR()     = PipeInnerRadius(ReceiverPipe());
function ReceiverOD()     = PipeOuterDiameter(ReceiverPipe());
function ReceiverOR()     = PipeOuterRadius(ReceiverPipe());
function ReceiverPipeWall() = PipeWall(ReceiverPipe());

// Calculated: Positions
function ReceiverCenter() = ReceiverOR()+WallLower();
function LowerOffsetZ() = -ReceiverOR()-WallLower();

module PipeLugPipe(length=ReceiverLength(),
                   debug=false, cutter=false, alpha=1) {
  color("DimGrey", alpha)
  DebugHalf(enabled=debug)
  translate([LowerMaxX(),0,0])
  rotate([0,-90,0])
  Pipe(pipe=ReceiverPipe(),
       length=length,
       hollow=!cutter, clearance=cutter?PipeClearanceSnug():undef);
}


module PipeLugFront(alpha=1, cutter=false) {
  color("DarkOrange", alpha=alpha) render()
  difference() {
    translate([0,0,LowerOffsetZ()])
    ReceiverLugFront(extraTop=WallLower()+ReceiverPipeWall()+(cutter?WallLower():0),
                     cutter=cutter, clearVertical=true);

    if (cutter==false)
    PipeLugPipe(cutter=true);
  }
}

module PipeLugRear(alpha=1, cutter=false) {
  color("DarkOrange", alpha=alpha) render()
  difference() {
    translate([0,0,LowerOffsetZ()])
    ReceiverLugRear(extraTop=WallLower()+ReceiverPipeWall()+(cutter?WallLower():0),
                    cutter=cutter, clearVertical=true);

    if (cutter==false)
    PipeLugPipe(cutter=true);
  }
}

module PipeLugCenter(cutter=false, clearance=0.002, alpha=1) {
  color("Burlywood", alpha=alpha) render()
  difference() {
    union() {
      translate([0,0,LowerOffsetZ()])
      translate([0,0,-ManifoldGap()])
      linear_extrude(height=WallLower()+ReceiverIR()+ManifoldGap(2))
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
      PipeLugPipe(cutter=true);

      PipeLugFront(cutter=true);
      PipeLugRear(cutter=true);

      SearCutter(length=SearLength()+LowerOffsetZ());
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

module PipeLugAssembly(length=ReceiverLength(), pipeAlpha=1,
                       front=true, rear=true, center=true,
                       triggerAnimationFactor=0, debug=false) {

  translate([0,0,LowerOffsetZ()])
  Lower(showTrigger=true,alpha=1, triggerAnimationFactor=triggerAnimationFactor,
        showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
        searLength=SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());

  if (front)
  PipeLugFront(debug=debug);

  if (rear)
  PipeLugRear(debug=debug);

  if (center)
  PipeLugCenter(debug=debug);

  if (length > 0)
  PipeLugPipe(alpha=pipeAlpha, length=length, debug=debug, cutter=false);
}

PipeLugAssembly(pipeAlpha=0.5);

*!scale(25.4)
PipeLugPlater(front=true, rear=true, center=true);

echo ("Pipe Lug Sear Length: ", SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());
