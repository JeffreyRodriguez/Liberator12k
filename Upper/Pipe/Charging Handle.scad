include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Components/Pipe/Frame.scad>;
use <../../Components/Pipe/Linear Hammer.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Shapes/Semicircle.scad>;

use <Pipe Upper.scad>;
use <Fixed Breech.scad>;


// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneQuarterInch();
function ChargingRod() = Spec_RodOneHalfInch();
function ChargingExtensionRod() = Spec_RodOneHalfInch();
function IndexLockRod() = Spec_RodOneQuarterInch();

// Settings: Lengths
function LatchExtension() = 0.375;
function LatchWidth() = 0.5;
function LatchHeight() = 0.5; //ReceiverIR()/2;

// Settings: Angles

// Calculated: Measurements
function ChargingHandleHeight() = 0.5;
function ChargingHandleTravel() = LinearHammerTravel()+0.125;
function ChargingHandleWidth() = 0.375;

function ChargingHandleLength() = (ChargingHandleTravel()*2);

// Calculated: Positions
function FrameFrontMinX() = BreechFrontX()+3;
function ReceiverLength() = 6;
function LatchWidth() = 0.375;

module PipeChargingHandleHousing(wall=0.125, alpha=1) {
  color("Purple", alpha) render()
  difference() {
    rotate([90,0,0])
    translate([BreechRearX()-ManifoldGap(),
               -ReceiverIR()/2,
               -ReceiverIR()-ChargingHandleWidth()-wall])
    mirror([1,0,0])
    ChamferedCube([ChargingHandleLength(),
                   ReceiverIR(),
                   ReceiverIR()] , r=1/32);
    
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    PipeLugPipe(cutter=true);
    
    PipeChargingHandle(cutter=true);
  }
  
}

module PipeChargingHandle(travelFactor=0,
                          cutter=false) {
  translate([-ChargingHandleTravel()*travelFactor,0,0])
  color("Orange") render()
  difference() {
    translate([BreechRearX(),
               (ReceiverIR()/2),
               -ChargingHandleHeight()/2]) {
      mirror([1,0,0])
      ChamferedCube([ChargingHandleLength()+(cutter?ChargingHandleTravel()+BreechPlateThickness():0),
                     (ReceiverIR()/2)+ChargingHandleWidth(),
                     ChargingHandleHeight()], r=1/32);
      
      // Handle
      translate([BreechRearX(),(ReceiverIR()/2),0])
      mirror([1,0,0])
      ChamferedCube([0.375+(cutter?ChargingHandleTravel():0),
                     ChargingHandleWidth()*2,
                     ChargingHandleHeight()], r=1/32);
    }
    
    if (!cutter)
    translate([LowerX(),0,0])
    PipeLugPipe(cutter=true);
  }
}

$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=$t);

FixedBreechPipeUpperAssembly(frame=true, debug=false);

//!scale(25.4) translate([-BreechRearX(),0,ReceiverOR()+0.5]) rotate([-90,0,0])
PipeChargingHandle(handle=false, bolt=false, latch=true);

//!scale(25.4) translate([-BreechRearX(),0,ReceiverOR()+0.5]) rotate([-90,0,0])
PipeChargingHandleHousing(alpha=0.5);
