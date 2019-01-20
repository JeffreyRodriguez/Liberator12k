include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;

use <../../../Components/Pipe/Beltclip.scad>;
use <../../../Components/Pipe/Cap.scad>;
use <../../../Components/Pipe/Charging Handle.scad>;
use <../../../Components/Pipe/Laser Support.scad>;
use <../../../Components/Pipe/Lugs.scad>;
use <../../../Components/Pipe/Frame.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Shapes/Semicircle.scad>;

use <../../../Ammo/Shell Slug.scad>;

use <../Pipe Upper.scad>;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
//function BarrelCollarDiameter() = 1.25;

function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
//function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneQuarterInch();
function ChargingRod() = Spec_RodOneHalfInch();
function ChargingExtensionRod() = Spec_RodOneHalfInch();
function IndexLockRod() = Spec_RodOneQuarterInch();

// Settings: Lengths
function BarrelLength() = 18-BarrelX();
function BarrelX() = 0;
function LatchExtension() = 0.375;
function LatchWidth() = 0.5;
function LatchHeight() = 0.5; //ReceiverIR()/2;

// Settings: Angles

// Calculated: Measurements

// Calculated: Positions
function FrameFrontMinX() = BreechFrontX()+4.75;
function ReceiverLength() = 6;

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([BarrelX()+ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth(), $fn=40);
    
    Barrel(hollow=false, cutter=true);
  }
}

module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([BarrelX(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

module RemovableBarrelTrunnion(debug=false) {
  
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {
    translate([FrameFrontMinX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=PipeInnerRadius(pipe=ReceiverPipe(),
                               clearance=PipeClearanceLoose()),
             h=FrameFrontMinX()-BarrelCollarWidth(),
             $fn=PipeFn(ReceiverPipe()));
    Barrel(clearance=PipeClearanceLoose(), hollow=false, cutter=true);
  }
}

module RemovableBarrelPivot(debug=false) {
  color("RoyalBlue")
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([0,0, -FrameMajorRodOffset()])
      rotate([0,90,0])
      cylinder(r=FrameMajorRodOffset()
                -PipeOuterRadius(ReceiverPipe())
                +FrameMajorWall(),
               h=FrameFrontMinX()-0.01, $fn=Resolution(30,60));
      
      translate([FrameFrontMinX(),0,0])
      translate([-BreechRearX(),0,0])
      rotate([180,0,0])
      FrameMajorStandoff(length=FrameFrontMinX()-0.01);
    }
    
    translate([-ManifoldGap(),0, -FrameMajorRodOffset()])
    rotate([0,90,0])
    cylinder(r=FrameMajorRodOffset()
              -PipeOuterRadius(ReceiverPipe())
              +0.01,
             h=FrameFrontMinX()+ManifoldGap(2), $fn=Resolution(30,60));
    
    rotate([0,90,0])
    Pipe(ReceiverPipe(), PipeClearanceLoose(), length=FrameFrontMinX());
  }
}

module RemovableFrameFront(debug=false) {
  color("Khaki")
  DebugHalf(enabled=debug)
  difference() {
    translate([FrameFrontMinX()+ManifoldGap(),0,0])
    difference() {
      translate([-BreechRearX()+BreechPlateThickness(),0,0])
      hull()
      for (R = [0,180]) rotate([R,0,0])
      FrameMajorStandoff(length=FrameFrontMinX()+BreechPlateThickness());
      
      Frame(minorBolts=false,
             offsetMajor=5, offsetMajorBottom=5,
             length=10,cutter=true);
      
      translate([-ManifoldGap(),0, -FrameMajorRodOffset()])
      rotate([0,90,0])
      linear_extrude(height=BreechPlateThickness()+ManifoldGap(2))
      rotate(180)
      semidonut(minor=(FrameMajorRodOffset()
                       -PipeOuterRadius(BarrelPipe()))*2,
                major=(FrameMajorRodOffset()
                       +PipeOuterRadius(BarrelPipe()))*2,
                angle=180, $fn=90);
      
      translate([-FrameFrontMinX()-ManifoldGap(),0, -FrameMajorRodOffset()])
      rotate([0,90,0])
      linear_extrude(height=FrameFrontMinX()+ManifoldGap(2))
      rotate(180) {
        semidonut(minor=(FrameMajorRodOffset()
                         -PipeOuterRadius(ReceiverPipe()))*2,
                  major=(FrameMajorRodOffset()
                         +PipeOuterRadius(ReceiverPipe()))*2,
                  angle=180, $fn=90);
          
        semidonut(minor=(FrameMajorRodOffset()
                         -PipeOuterRadius(ReceiverPipe()))*2,
                  major=(FrameMajorRodOffset()*sqrt(2))*2,
                  angle=360, $fn=90);
      }
      
      translate([-FrameFrontMinX()-ManifoldGap(),0, PipeOuterRadius(ReceiverPipe())/2])
      rotate([0,90,0])
      linear_extrude(height=FrameFrontMinX()+ManifoldGap(2))
      translate([0,-(BreechPlateWidth()/2)-ManifoldGap(),0])
      square([PipeOuterRadius(ReceiverPipe()),
              BreechPlateWidth()]);
    }
    
    Barrel(hollow=false, cutter=true);
    
    rotate([0,90,0])
    Pipe(ReceiverPipe(), PipeClearanceLoose(), length=FrameFrontMinX());
  }
}

module RemovableShotgunAssembly(pipeAlpha=1, debug=false) {
  
  hammerTravelFactor = Animate(ANIMATION_STEP_FIRE)
                     - SubAnimate(ANIMATION_STEP_CHARGE, start=0.275, end=0.69);

  PipeChargingHandle(travelFactor=Animate(ANIMATION_STEP_CHARGE));
  
  PipeChargingHandleHousing();

  FixedBreechPipeUpperAssembly(pipeAlpha=pipeAlpha, receiverLength=ReceiverLength(),
                    receiverLength=10, stock=true, tailcap=false,
                    hammerTravelFactor=hammerTravelFactor,
                    frame=true, debug=debug);
  
  FrameAssembly(offsetMajor=0,
                lengthMajorTop=FrameFrontMinX()+1,
                lengthMajorBottom=FrameFrontMinX()+1,
                debug=debug);
  
  Beltclip();
  
  translate([2,0,0])
  LaserSupport();

  Barrel(debug=false);
  BarrelCollar(debug=false);

  color("DimGrey")
  DebugHalf(enabled=debug)
  translate([FrameFrontMinX(),0,0])
  rotate([0,-90,0])
  Pipe(ReceiverPipe(), PipeClearanceLoose(),
       length=FrameFrontMinX()-BarrelCollarWidth());
}

//!scale(25.4) rotate([0,-90,0]) translate([-BarrelX()-1.6875,0,0])
RemovableBarrelTrunnion();

//!scale(25.4) rotate([0,90,0]) translate([-FrameFrontMinX(),0,0])
RemovableFrameFront();

//!scale(25.4) rotate([0,90,0]) translate([-FrameFrontMinX(),0,0])
RemovableBarrelPivot();

//AnimateSpin()translate([-2.5,0,0])
RemovableShotgunAssembly(pipeAlpha=1, debug=true);

$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=$t);
//$t=0.37;
//$t=0;




// Toying with an idea, cocking lever again? Get some mechanical advantage, maybe.
*translate([0,ReceiverOD(),0]) {
  translate([-0.125,0,0])
  cube([0.25,0.25, 2]);
  
  rotate([-90,0,0])
  cylinder(r=0.25, h=0.25, $fn=20);
}

use <../../../Shapes/Teardrop.scad>;

module LineLauncher(od=0.95, headLength=0.75, tailLength=2,
                    length=5.43+0.125, debug=false, $fn=30) {
  
  DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Head
      ChamferedCylinder(r1=od/2, r2=3/16, h=headLength, teardropTop=true);
      
      translate([0,0,headLength])
      HoleChamfer(r1=0.28125, r2=0.0625);
      
      // Body
      cylinder(r=(0.3125/2)+0.125,
               h=length);
      
      // Tail
      translate([0,0,length-tailLength])
      ChamferedCylinder(r1=od/2, r2=0.4375, h=tailLength, chamferTop=false);
    }
    
    // Large bottom hole
    translate([0,0,length-0.125])
    difference() {
      cylinder(r=0.625/2, h=length);
      
      CircularOuterEdgeChamfer(r1=0.625/2, r2=0.125, teardrop=false);
    }
    
    // Bolt hole
    translate([0,0,-ManifoldGap(2)])
    mirror([0,0,1])
    NutAndBolt(bolt=Spec_BoltFiveSixteenths(),
               boltLength=length-0.25, nutHeightExtra=1,
               capOrientation=true, cutter=true);
    
    // Gas Checks
    for (Z = [length-1:0.1875:length-0.5]) translate([0,0,Z])
    render()
    rotate_extrude()
    translate([od/2,0])
    rotate(90)
    Teardrop(r=0.0625/2, $fn=10);
  }
}

// Rimfire offset template
rimfireCaliber = 0.27;
*!difference() {
  cylinder(r=PipeOuterRadius(BarrelPipe())+0.25, h=0.25, $fn=50);
  
  translate([0,0,0.03])
  cylinder(r=PipeOuterRadius(BarrelPipe(), PipeClearanceSnug()),
           h=0.25, $fn=50);
  
  translate([rimfireCaliber/2,0,-ManifoldGap()])
  cylinder(r=0.06/2, h=0.5, $fn=8);
}

*!scale(25.4)
LineLauncher();
