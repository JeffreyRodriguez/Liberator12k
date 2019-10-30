include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Components/Pipe/Cap.scad>;
use <../../Components/Pipe/Frame.scad>;
use <../../Components/Pipe/Frame Standoffs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/AR15/Barrel.scad>;

use <../../Shapes/Semicircle.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Receiver.scad>;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarDiameter() = 1.25;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function ReceiverPipe()  = Spec_OnePointFiveSch40ABS();
function ReceiverPipe()  = Spec_OnePointSevenFivePCTube();
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneQuarterInch();
function ChargingRod() = Spec_RodOneHalfInch();
function ChargingExtensionRod() = Spec_RodOneHalfInch();
function IndexLockRod() = Spec_RodOneQuarterInch();

// Settings: Lengths
function BarrelLength() = 6-BarrelX();
function BarrelX() = 0;

// Settings: Angles

// Calculated: Positions
function FrameFrontMinX() = BreechFrontX()+3;
function ReceiverLength() = 7;


module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([BarrelX()+ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth()*3, $fn=40);

    Barrel(hollow=false, cutter=true);
  }
}

module Barrel(barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  translate([BreechFrontX(),0,0])
  rotate([0,90,0])
  AR15_Barrel();
}

module RemovableForendAssembly(receiver=Spec_PipeThreeQuarterInch(),
                 hollowReceiver=true,
                 butt=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                 debug=true) {
}

module RemovableShotgunAssembly(pipeAlpha=1, debug=false) {

  hammerTravelFactor = Animate(ANIMATION_STEP_FIRE)
                     - SubAnimate(ANIMATION_STEP_CHARGE, start=0.275, end=0.69);

  RemovableForendAssembly(debug=debug);

  FixedBreechPipeUpperAssembly(pipeAlpha=pipeAlpha, receiverLength=ReceiverLength(),
                    hammerTravelFactor=hammerTravelFactor,
                    frame=true, debug=debug);

  FrameAssembly(offsetMajor=0,
                lengthMajorTop=FrameFrontMinX()+1,
                lengthMajorBottom=FrameFrontMinX()+1,
                debug=debug);

  Barrel(debug=false);
  BarrelCollar(debug=false);

  Tailcap();

  color("DimGrey", 0.5)
  DebugHalf(enabled=debug)
  rotate([0,90,0])
  ReceiverTube(cutter=true, length=FrameFrontMinX());

  color("LightSteelBlue")
  render()
  *difference() {
    translate([BarrelX()+0.5+BreechPlateThickness(),0,0])
    hull()
    Breech();

    Barrel(hollow=false, cutter=true);
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
                -ReceiverOR()
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
              -ReceiverOR()
              +0.01,
             h=FrameFrontMinX()+ManifoldGap(2), $fn=Resolution(30,60));

    rotate([0,90,0])
    ReceiverTube(cutter=true, length=FrameFrontMinX());
  }
}

RemovableBarrelPivot();

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
                         -ReceiverOR())*2,
                  major=(FrameMajorRodOffset()
                         +ReceiverOR())*2,
                  angle=180, $fn=90);

        semidonut(minor=(FrameMajorRodOffset()
                         -ReceiverOR())*2,
                  major=(FrameMajorRodOffset()*sqrt(2))*2,
                  angle=360, $fn=90);
      }

      translate([-FrameFrontMinX()-ManifoldGap(),0, ReceiverOR()/2])
      rotate([0,90,0])
      linear_extrude(height=FrameFrontMinX()+ManifoldGap(2))
      translate([0,-(BreechPlateWidth()/2)-ManifoldGap(),0])
      square([ReceiverOR(),
              BreechPlateWidth()]);
    }

    Barrel(hollow=false, cutter=true);

    rotate([0,90,0])
    ReceiverTube(cutter=true, length=FrameFrontMinX());
  }
}

//AnimateSpin()translate([-2.5,0,0])
RemovableShotgunAssembly(pipeAlpha=0.5, debug=false);

//$t=AnimationDebug(ANIMATION_STEP_FIRE, T=$t);
//$t=0.37;

module Tailcap(debug=false) {
  DebugHalf(enabled=debug)
  translate([BreechRearX()-0.25-ReceiverLength(),0,0])
  rotate([0,90,0])
  difference() {
    PrintablePipeCap(
        pipeDiameter=ReceiverOD(),
        base=0.25,
        $fn=Resolution(30,60));

    ChamferedCircularHole(r1=0.35/2, r2=1/16, $fn=20, h=0.25);
  }
}



module AR15BarrelTrunnion(debug=false, $fn=60) {

  color("Olive")
  DebugHalf(enabled=debug)
  difference() {
    translate([BarrelX(),0,0])
    rotate([0,90,0])
    cylinder(r=ReceiverIR(),
             h=AR15BarrelExtensionLength()
              +AR15BarrelExtensionLipLength());

    translate([0,0,0])
    Barrel(clearance=PipeClearanceLoose(), hollow=false, cutter=true);
  }
}

//!scale(25.4) rotate([0,-90,0]) translate([-BarrelX(),0,0])
AR15BarrelTrunnion();

//*!scale(25.4) rotate([0,90,0]) translate([-FrameFrontMinX(),0,0])
RemovableFrameFront();

//!scale(25.4) rotate([0,90,0]) translate([-FrameFrontMinX(),0,0])
RemovableBarrelPivot();

//!scale(25.4) rotate([0,-90,0]) translate([ReceiverLength(),0,0])
//Tailcap();
