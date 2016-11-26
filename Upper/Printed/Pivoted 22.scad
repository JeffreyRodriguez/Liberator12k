use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Lower Plater.scad>;

use <../../Components/Firing Pin Retainer.scad>;

use <../../Components/Cylinder.scad>;
use <Pivoted Lower Middle.scad>;
use <Pivot Arms.scad>;
use <Printed Upper.scad>;

//Spec_PipeThreeQuarterInchSch80()
//Spec_PipeOneInch()
//Spec_PipeOneInchSch80()
//Spec_Tubing1628x1125()
//Spec_TubingThreeEighthsInch()
//Spec_PointFiveSix9mmBarrel()

DEFAULT_STRIKER = Spec_RodFiveSixteenthInch();
BARREL_PIPE = Spec_PointFiveSix9mmBarrel();
WALL = 0.25;
BARREL_OFFSET_X = LowerMaxX();
BARREL_OFFSET_Z = FiringPinZ();//+0.0625;


frameFrontLength = (LowerPivotX()-LowerMaxX())+(0.75/2)-0.005;
frameFrontOffsetX = LowerMaxX()+0.005;

function PivotLockZ() = 0.5;
function PivotLockRod() = Spec_RodOneQuarterInch();

module PivotLockRods2D(clearance=undef, extraRadius=0) {
  for(m = [0,1])
  mirror([0,m,0])
  translate([PivotLockZ(),LowerMaxY()])
  circle(r=RodRadius(PivotLockRod(), clearance)+extraRadius,
            h=LowerMaxX()+frameFrontLength+ManifoldGap(2), $fn=20);
}


module PivotLockRods(clearance=undef, extraRadius=0) {
  mirror([1,0,0])
  rotate([0,-90,0])
  linear_extrude(height=LowerMaxX()+frameFrontLength+ManifoldGap(2))
  PivotLockRods2D(clearance=clearance, extraRadius=extraRadius);
}

module PivotLockBlock2D() {
  hull() {
    
    // Simple cube body
    translate([0,-LowerMaxY()])
    square([1,LowerMaxWidth()]);
    
    PivotLockRods2D(clearance=undef, extraRadius=PivotWall());
  }
}
module PivotedFrameFront() {
  
  color("Purple")
  render()
  difference() {
    union() {
      translate([frameFrontOffsetX+frameFrontLength,0,0])
      rotate([0,-90,0])
      linear_extrude(height=frameFrontLength)
      difference() {
        union() {
          
          PivotLockBlock2D();
          
          // Spacer and lug support for pivot arms
          translate([0,-0.25])
          mirror([1,0])
          square([FiringPinZ()+abs(PivotArmLugZ()), 0.5]);
        }
        
        PivotLockRods2D(clearance=RodClearanceLoose());
            
        // Barrel
        translate([BARREL_OFFSET_Z,0])
        Pipe2d(pipe=BARREL_PIPE, clearance=PipeClearanceLoose(),
             length=frameFrontLength+ManifoldGap(3));
        
      }
        
      PivotArmLug();
    }
        
    PivotLugBolt(cutter=true, teardrop=true);
  }
}

module Pivoted22PivotArms(sides=[0,1]) {
  render()
  difference() {
    PivotArms(sides=sides) {
      union() {
        PivotArm(wall=0.375, height=LowerGuardHeight()-0.005)
        PivotArmLug();
        
        translate([frameFrontOffsetX, 0.25, -GripCeiling()])
        cube([frameFrontLength, LowerMaxY()-0.25, GripCeiling()-0.005]);
      }
    }
    
    PivotLugBolt(cutter=true);
  }
}

module PivotLugBolt(cutter=true, teardrop=false) {
  color("Grey")
  translate([LowerPivotX(),
             -LowerMaxY()+0.07,
             -0.5])
  rotate([90,0,0])
  NutAndBolt(bolt=Spec_BoltM4(), boltLength=UnitsMetric(30),
             capOrientation=true, nutBackset=0.05, nutHeightExtra=cutter ? 1 : 0,
             clearance=cutter,
             teardrop=(cutter && teardrop), teardropAngle=180);
}

module PivotArmPlater() {
  scale(25.4)
  translate([0,0,-0.25]) {
    rotate([90,0,0])
    Pivoted22PivotArms(sides=[0]);
    
    rotate([-90,0,0])
    Pivoted22PivotArms(sides=[1]);
  }
}

//!scale(25.4) rotate([0,-90,0]) translate([-ReceiverLugFrontMinX(),0,0])
render()
difference() {
  union() {
    
    translate([LowerMaxX(),0,0])
    rotate([0,-90,0])
    linear_extrude(height=LowerMaxX()-ReceiverLugFrontMinX())
    PivotLockBlock2D();
    
    PrintedUpperFront();
  }
        
  translate([LowerMaxX()+ManifoldGap(),0,0])
  rotate([0,-90,0])
  linear_extrude(height=LowerMaxX()-ReceiverLugFrontMinX()+ManifoldGap(2))
  PivotLockRods2D(clearance=RodClearanceLoose());
  
  PrintedUpperFiringPinCutter();
  
}

LowerPivoted();

for (m = [0,1]) mirror([0,m,0])
LowerPivotBearing(cutter=false);
PivotNutAndBolt(cutter=false);
PivotLugBolt(cutter=false);

// Barrel
color("Silver")
translate([BARREL_OFFSET_X,0,BARREL_OFFSET_Z])
rotate([0,90,0])
Pipe(pipe=BARREL_PIPE, length=26,
     hollow=true, clearance=undef);

Pivoted22PivotArms();

PivotLockRods(clearance=undef);

// Pivot arms
//PivotArmPlater();


//!scale(25.4) rotate([0,90,0])
PivotedFrameFront();