include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Helix.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/AR15/Barrel.scad>;
use <../../Vitamins/AR15/Bolt.scad>;

use <../Magwells/AR15 Magwell.scad>;

use <../Receiver.scad>;
use <../Linear Hammer.scad>;
use <../Frame.scad>;
use <../Action Rod.scad>;
use <../Charging Pump.scad>;

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
function BarrelLength() = 16;
function BarrelMinX() = 2.16;
function WallBarrel() = 0.25;

// Settings: Angles
barrelRearWall = 0.125;

// Calculated: Positions
function FrameFrontMinX() = BreechFrontX()+3;

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([BarrelMinX()+ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth()*3, $fn=40);

    Barrel(hollow=false, cutter=true);
  }
}

module Barrel(barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  translate([BarrelMinX(),0,0])
  rotate([0,90,0])
  rotate(180)
  AR15_Barrel();
}

module AR15Forend(debug=false, alpha=0.5) {
  length = ReceiverFrontLength()
         + BarrelMinX()
         + AR15BarrelExtensionLipLength()
         + AR15BarrelExtensionLength();
  
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    ReceiverFront(frameLength=length ) {
      
      hull() {
        
        translate([0,0,-0.5])
        AR15_Magwell(cut=false,
                     wallFront=0.375);
          
        translate([0,-(AR15BarrelExtensionLipRadius()+WallBarrel()),0])
        ChamferedCube([length,
                       (AR15BarrelExtensionLipRadius()+WallBarrel())*2,
                       FrameBoltZ()],
                       r=1/16,
                       $fn=70);
      }
      
      // Around the barrel
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverOR()+barrelRearWall,
                        r2=1/16,
                        h=length,
                       $fn=Resolution(30,60));
    }
    
    // Action rod  
    ChargingRod(cutter=true);
    
    
    translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
    rotate([0,-90,0])
    AR15_BoltCamPinTrack();
    
    Barrel(cutter=true);
    
    translate([-0.5,0,-0.5])
    AR15_MagwellInsert(catch=false,
                       extraTop=0);
    
    // Ejection slot
    rotate([-AR15_CamPinAngle(),0,0])
    mirror([0,1,0])
    translate([0,0,-0.5/2])
    ChamferedCube([BarrelMinX()-barrelRearWall,
                   AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                   0.5], r=1/16);
                   
    // Ejection slot forward bevel
    rotate([-AR15_CamPinAngle(),0,0])
    translate([BarrelMinX()-0.25,
                -AR15_BoltHeadRadius(),
                -0.5/2])
    mirror([0,1,0])
    rotate(40)
    ChamferedCube([BarrelMinX()-barrelRearWall,
                   AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                   0.5], r=1/16);
    
    // Blend the magwell shape into the rounded interior
    hull() {
      translate([-0.5+barrelRearWall,0,-0.5])
      linear_extrude(height=0.125)
      AR15_MagwellTemplate();
      
      
      translate([-ReceiverFrontLength(),0,0])
      rotate([0,90,0])
      cylinder(r=AR15_BoltHeadRadius()+0.01,
               h=BarrelMinX()+ReceiverFrontLength(),
               $fn=30);
    }
    
    // Bolt carrier hole; taper towards the top
    translate([-ReceiverFrontLength()-ManifoldGap(),0,0])
    rotate([0,90,0])
    ChamferedCylinder(r1=AR15BarrelExtensionRadius()+0.01,
                      r2=AR15BarrelExtensionDiameter()-AR15_BoltHeadDiameter(),
                      h=BarrelMinX()+ReceiverFrontLength()-barrelRearWall+ManifoldGap(),
                      chamferBottom=false, teardropTop=true,
                      $fn=40);
  }
}

module BoltCarrier(radius=0.5, clearance=0.01, chamferRadius=1/16, alpha=1) {
  chamferClearance = 0.01;
  barrelExtensionLandingHeight = 0.3;
  firingPinExtension = 0.55;      // From the back of the bolt
    
  boltCarrierDiameter = AR15BarrelExtensionDiameter();
  boltCarrierRadius = boltCarrierDiameter/2;
  boltCarrierRearWall=0.1875;
  boltCarrierRearExtension=0;
  
  length=BarrelMinX()
        +ReceiverFrontLength()
        -barrelRearWall
        +boltCarrierRearExtension;
  
  
  color("Tan", alpha) render()
  difference() {
    
    union() {
      translate([-ReceiverFrontLength()-boltCarrierRearExtension,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=boltCarrierRadius,
                        r2=AR15BarrelExtensionDiameter()-AR15_BoltHeadDiameter(),
                        h=length,
                        teardropTop=true, chamferBottom=false,
                        $fn=50);
      
      translate([-ReceiverFrontLength()-boltCarrierRearExtension,0,0])
      ReceiverGuide(length=ReceiverFrontLength()+boltCarrierRearExtension);
      
      *translate([-ReceiverFrontLength()-boltCarrierRearExtension,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverIR()-clearance,
                        r2=1/16,
                        h=boltCarrierRearExtension,
                        teardropTop=true,
                        $fn=50);
    }
    
    // Magazine clearance
    translate([-ReceiverFrontLength(),0,0])
    rotate([0,90,0])
    linear_extrude(height=ReceiverFrontLength()+BarrelMinX())
    rotate(45)
    semidonut(major=ActionRodOffset()*2,
              minor=AR15_BoltHeadDiameter(),
              angle=90, $fn=50);
    
    translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
    rotate([0,-90,0])
    AR15_Bolt(firingPinRetainer=false);
    
    translate([1.5-0.75,0,0])
    rotate([0,-90,0])
    rotate(-AR15_CamPinAngle())
    #HelixSegment(radius=boltCarrierRadius,
                 width=ActionRodWidth(),
                 top=(ActionRodWidth()/2)+0.5,
                 bottom=(ActionRodWidth()/2),
                 angle=-AR15_CamPinAngle());
  }
}


animate_unlock1 = SubAnimate(ANIMATION_STEP_UNLOCK, end=0.25)
               - SubAnimate(ANIMATION_STEP_LOCK, start=0.75);

animate_unlock2 = SubAnimate(ANIMATION_STEP_UNLOCK, start=0.25)
               - SubAnimate(ANIMATION_STEP_LOCK, end=0.75);

translate([-1-2,0,0])
*HammerAssembly(insertRadius=0.75, alpha=0.5);

*FrameBolts(length=10);

translate([(-BarrelMinX()-1+0.125)*animate_unlock2,0,0]) {
  
  translate([-0.5*animate_unlock1,0,0]) {
    translate([1.5,0,0])
    ActionRod(length=11);

    translate([1.5,0,0])
    ActionRodBolt(angle=180, length=0);

    *ChargingPump();
  }

  rotate([-AR15_CamPinAngle()*(1-animate_unlock1),0,0]) {
    translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
    rotate([0,-90,0])
    color("DimGrey") render()
    AR15_Bolt(teardrop=false,
              firingPinRetainer=false,
              extraFiringPin=0,
              clearance=0);
    
    BoltCarrier(alpha=0.5);
  }
}


color("DimGrey") render()
Barrel();

AR15Forend(debug=true);

PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12);
                  

*!scale(25.4)
rotate([0,-90,0])
AR15Forend();

*!scale(25.4)
rotate([0,-90,0])
BoltCarrier();
