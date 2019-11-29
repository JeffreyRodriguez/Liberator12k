use <../Shapes/Chamfer.scad>;

use <Lower/Receiver Lugs.scad>;
use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;


use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;


/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Center", "Front", "Rear"]

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.75;
RECEIVER_TUBE_ID = 1.5;

// Settings: Walls
function WallLower()      = 0.1875;

// Calculated: Positions
function LowerOffsetZ() = -1.25;

module ReceiverTube(od=RECEIVER_TUBE_OD,
                    id=RECEIVER_TUBE_ID,
                    length=6, clearance=0.002,
                   debug=false, cutter=false, alpha=1, $fn=60) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("DimGrey", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    translate([LowerMaxX(),0,0])
    rotate([0,-90,0])
    difference() {
      cylinder(r=od/2, h=length);

      if (!cutter)
      cylinder(r=id/2, h=length);
    }

    if (!cutter)
    translate([0,0,LowerOffsetZ()])
    SearCutter(length=SearLength()+abs(LowerOffsetZ()));
  }
}


module PipeLugFront(od=RECEIVER_TUBE_OD,
                    id=RECEIVER_TUBE_ID,
                    alpha=1, cutter=false, debug=false) {
  color("Gray", alpha=alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    translate([0,0,LowerOffsetZ()])
    ReceiverLugFront(extraTop=-LowerOffsetZ(),
                     cutter=cutter, clearVertical=true);

    if (cutter==false)
    ReceiverTube(od=od, id=id, cutter=true);
  }
}

module PipeLugRear(od=RECEIVER_TUBE_OD,
                   id=RECEIVER_TUBE_ID,
                   alpha=1, cutter=false, debug=false) {
  color("Gray", alpha=alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    translate([0,0,LowerOffsetZ()])
    ReceiverLugRear(extraTop=-LowerOffsetZ(),
                    cutter=cutter, clearVertical=true);

    if (cutter==false)
    ReceiverTube(od=od, id=id, cutter=true);
  }
}

module PipeLugCenter(od=RECEIVER_TUBE_OD,
                     id=RECEIVER_TUBE_ID,
                     cutter=false, clearance=0.002,
                    alpha=1, debug=false) {
  color("DarkGray", alpha=alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    union() {
      translate([0,0,LowerOffsetZ()])
      translate([0,0,-ManifoldGap()])
      linear_extrude(height=abs(LowerOffsetZ()))
      offset(r=(cutter?clearance:0))
      intersection() {
        projection(cut=true)
        translate([0,0,0.001])
        TriggerGuard();

        translate([ReceiverLugRearMaxX()-1.375,-1])
        square([LowerMaxX()-ReceiverLugRearMaxX()+1.375-0.5,2]);
      }
    }

    if (cutter == false) {
      ReceiverTube(od=od, id=id, cutter=true);

      PipeLugFront(od=od, id=id, cutter=true);
      PipeLugRear(od=od, id=id, cutter=true);

      translate([0,0,LowerOffsetZ()])
      SearCutter(length=SearLength()+abs(LowerOffsetZ()));
    }
  }
}

module PipeLugAssembly(od=RECEIVER_TUBE_OD,
                       id=RECEIVER_TUBE_ID,
                       length=6, pipeAlpha=1, pipeOffsetX=0,
                       front=true, rear=true, center=true, debug=false) {

  if (front)
  PipeLugFront(od=od, id=id, debug=debug);

  if (rear)
  PipeLugRear(od=od, id=id, debug=debug);

  if (center)
  PipeLugCenter(od=od, id=id, debug=debug);

  if (length > 0)
  translate([pipeOffsetX,0,0])
  ReceiverTube(od=od, id=id, alpha=pipeAlpha, length=length, debug=debug);
}

module PipeLugFront_print(od=RECEIVER_TUBE_OD,
                          id=RECEIVER_TUBE_ID)
rotate([0,-90,0])
translate([-ReceiverLugFrontMinX(),0,ReceiverLugFrontMinX()])
PipeLugFront(od=od, id=id);


module PipeLugRear_print(od=RECEIVER_TUBE_OD,
                       id=RECEIVER_TUBE_ID)
rotate([0,90,0])
translate([-ReceiverLugRearMaxX(),0,-ReceiverLugRearMaxX()])
PipeLugRear(od=od, id=id);

module PipeLugCenter_print(od=RECEIVER_TUBE_OD,
                       id=RECEIVER_TUBE_ID)
translate([0,0,-LowerOffsetZ()])
PipeLugCenter(od=od, id=id);


scale(25.4) {

  if (_RENDER == "Assembly") {
    translate([0,0,LowerOffsetZ()])
    Lower(showTrigger=true,alpha=1, triggerAnimationFactor=$t,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+abs(LowerOffsetZ())+SearTravel());

    PipeLugAssembly(pipeAlpha=0.5);
  }

  if (_RENDER == "Center")
    PipeLugCenter_print();

  if (_RENDER == "Front")
    PipeLugFront_print();

  if (_RENDER == "Rear")
    PipeLugRear_print();
}
