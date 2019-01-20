include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <../Firing Pin.scad>;

use <Lugs.scad>;
use <Linear Hammer.scad>;

// Calculated: Measurements
function ChargingHandleHeight() = 0.5;
function ChargingHandleTravel() = LinearHammerTravel()+0.125;
function ChargingHandleWidth() = 0.375;

function ChargingHandleLength() = (ChargingHandleTravel()*2);
function LatchTravel() = LinearHammerTravel();
function LatchWidth() = 0.375;


module ChargingHandleHousing(wall=0.125) {
  color("Purple") render()
  difference() {
    rotate([90,0,0])
    translate([-ManifoldGap(),
               -ReceiverIR()/2,
               -ReceiverIR()-ChargingHandleWidth()-wall])
    mirror([1,0,0])
    ChamferedCube([ChargingHandleLength(),
                   ReceiverIR(),
                   ReceiverIR()] , r=1/32);
    
    PipeLugPipe(cutter=true, hollow=false);
    
    ChargingHandle(cutter=true);
  }
  
}

module ChargingHandle(travelFactor=0,
                          cutter=false) {
  translate([-ChargingHandleTravel()*travelFactor,0,0])
  color("Orange") render()
  difference() {
    translate([0,
               (ReceiverIR()/2),
               -ChargingHandleHeight()/2]) {
                 
      mirror([1,0,0])
      ChamferedCube([ChargingHandleLength()+(cutter?ChargingHandleTravel():0),
                     (ReceiverIR()/2)+ChargingHandleWidth(),
                     ChargingHandleHeight()], r=1/32);
      
      translate([0,(ReceiverIR()/2),0])
      mirror([1,0,0])
      ChamferedCube([0.375+(cutter?ChargingHandleTravel():0),
                     ChargingHandleWidth()*2,
                     ChargingHandleHeight()], r=1/32);
    }
    
    if (!cutter)
    rotate([0,-90,0]) {
      Pipe(ReceiverPipe(), PipeClearanceLoose(),
            length=ChargingHandleLength()+0.125);
      
      translate([0,0,-0.5])
      Pipe(ReceiverPipe(), PipeClearanceLoose(), hollow=true,
            length=ChargingHandleLength()+0.125);
    }
  }
}

LinearHammerAssembly();

ChargingHandle(travelFactor=Animate(ANIMATION_STEP_CHARGE));

ChargingHandleHousing();

$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=$t);

*!scale(25.4)
ChargingHandle();

*!scale(25.4) translate([0,0,ReceiverOR()+0.5]) rotate([-90,0,0])
ChargingHandleHousing();