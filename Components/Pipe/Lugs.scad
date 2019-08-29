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
function ReceiverPipe()  = Spec_OnePointSevenFivePCTube();

// Calculated: Measurements
function ReceiverID()     = 1.5;
function ReceiverIR()     = ReceiverID()/2;
function ReceiverOD()     = 1.75;
function ReceiverOR()     = ReceiverOD()/2;
function ReceiverPipeWall() = ReceiverOR()-ReceiverIR();

// Calculated: Positions
//function ReceiverCenter() = ReceiverOR()+WallLower();
function LowerOffsetZ() = -1.25;

module ReceiverTube(length=ReceiverLength(), clearance=0.002,
                   debug=false, cutter=false, alpha=1, $fn=60) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("DimGrey", alpha)
  DebugHalf(enabled=debug)
  difference() {
    translate([LowerMaxX(),0,0])
    rotate([0,-90,0])
    difference() {
      cylinder(r=ReceiverOR(), h=length);
      
      if (!cutter)
      cylinder(r=ReceiverIR(), h=length);
    }
    
    if (!cutter)
    translate([0,0,LowerOffsetZ()])
    SearCutter(length=SearLength()+abs(LowerOffsetZ()));
  }
}


module PipeLugFront(alpha=1, cutter=false) {
  color("DarkOrange", alpha=alpha) render()
  difference() {
    translate([0,0,LowerOffsetZ()])
    ReceiverLugFront(extraTop=-LowerOffsetZ(),
                     cutter=cutter, clearVertical=true);

    if (cutter==false)
    ReceiverTube(cutter=true);
  }
}

module PipeLugRear(alpha=1, cutter=false) {
  color("DarkOrange", alpha=alpha) render()
  difference() {
    translate([0,0,LowerOffsetZ()])
    ReceiverLugRear(extraTop=-LowerOffsetZ(),
                    cutter=cutter, clearVertical=true);

    if (cutter==false)
    ReceiverTube(cutter=true);
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
      ReceiverTube(cutter=true);

      PipeLugFront(cutter=true);
      PipeLugRear(cutter=true);

      translate([0,0,LowerOffsetZ()])
      SearCutter(length=SearLength()+abs(LowerOffsetZ()));
    }
  }
}

module PipeLugAssembly(length=ReceiverLength(), pipeAlpha=1, pipeOffsetX=0,
                       front=true, rear=true, center=true,
                       debug=false) {

  if (front)
  PipeLugFront(debug=debug);

  if (rear)
  PipeLugRear(debug=debug);

  if (center)
  PipeLugCenter(debug=debug);

  if (length > 0)
  translate([pipeOffsetX,0,0])
  ReceiverTube(alpha=pipeAlpha, length=length, debug=debug, cutter=false);
}

PipeLugAssembly(pipeAlpha=0.5);

translate([0,0,LowerOffsetZ()])
Lower(showTrigger=true,alpha=1, triggerAnimationFactor=$t,
      showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
      searLength=SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());


/*
 * Plated parts
 */

// Front Lug
*!scale(25.4)
rotate([0,-90,0])
translate([-ReceiverLugFrontMinX(),0,ReceiverLugFrontMinX()])
PipeLugFront();

// Rear Lug
*!scale(25.4)
rotate([0,90,0])
translate([-ReceiverLugRearMaxX(),0,-ReceiverLugRearMaxX()])
PipeLugRear();

// NOTE: Developer Part
// Center Lug Housing
*!scale(25.4)
PipeLugCenter();

echo ("Pipe Lug Sear Length: ", SearLength()+WallLower()+ReceiverPipeWall()+SearTravel());
