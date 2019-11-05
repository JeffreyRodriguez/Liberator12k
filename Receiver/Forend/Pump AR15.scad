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
  !difference() {
    ReceiverFront(frameLength=length ) {
      
      hull() {
        
        translate([0,0,-0.5])
        AR15_Magwell(cut=false,
                     wallFront=0.375);
          
        translate([0,-(AR15BarrelExtensionLipRadius()+WallBarrel()),0])
        ChamferedCube([length,
                       (AR15BarrelExtensionLipRadius()+WallBarrel())*2,
                       FrameBoltZ()],
                       r=1/16);
      }
      
      // Around the barrel
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverOR()+0.125,
                        r2=1/16,
                        h=length,
                       $fn=Resolution(30,60));
    }
    
    // Action rod and pin
    ChargingRod(cutter=true);
    
    translate([-ReceiverFrontLength(),
               -(ChargingRodWidth()/2)-0.01,
               0])
    cube([1.25+ReceiverFrontLength(),
          ChargingRodWidth()+0.02,
          ChargingRodOffset()]);
    
    
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
    ChamferedCube([BarrelMinX()-0.125,
                   AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                   0.5], r=1/16);
                   
    // Ejection slot forward bevel
    rotate([-AR15_CamPinAngle(),0,0])
    translate([BarrelMinX()-0.25,
                -AR15_BoltHeadRadius(),
                -0.5/2])
    mirror([0,1,0])
    rotate(40)
    ChamferedCube([BarrelMinX()-0.125,
                   AR15BarrelExtensionLipRadius()+WallBarrel()+1,
                   0.5], r=1/16);
    
    // Blend the magwell shape into the rounded interior
    hull() {
      translate([-0.5+0.125,0,-0.5])
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
                      h=BarrelMinX()+ReceiverFrontLength()-0.125+ManifoldGap(),
                      chamferBottom=false, teardropTop=true,
                      $fn=40);
  }
}

translate([-1,0,0])
HammerAssembly(insertRadius=0.75, alpha=0.5);

FrameBolts(length=10);
                       
Charger();

ActionRodAssembly();

*ChargingPumpAssembly();


Barrel();

module BoltCarrier(radius=0.5, clearance=0.01, chamferRadius=1/16) {
  chamferClearance = 0.01;
  barrelExtensionLandingHeight = 0.3;
  firingPinExtension = 0.55;      // From the back of the bolt
    
  boltSleeveDiameter = AR15BarrelExtensionDiameter();
  boltSleeveRadius = boltSleeveDiameter/2;

  length=BarrelMinX()+ReceiverFrontLength()-0.125;
  
  render()
  difference() {
    
    union() {
      translate([-ReceiverFrontLength(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=boltSleeveRadius,
                        r2=AR15BarrelExtensionDiameter()-AR15_BoltHeadDiameter(),
                        h=length,
                        teardropTop=true, chamferBottom=false,
                        $fn=50);
    }
    
    // Magazine clearance
    translate([BarrelMinX(),0,0])
    rotate([0,-90,0])
    linear_extrude(height=length)
    rotate(180)
    rotate(45)
    semidonut(major=ActionRodOffset()*2,
              minor=AR15_BoltHeadDiameter(),
              angle=90, $fn=50);
    
    translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
    rotate([0,-90,0])
    AR15_Bolt(firingPinRetainer=false);
    
    *rotate([0,90,0])
    rotate(180)
    translate([0,0,0.125])
    HelixSegment(radius=boltSleeveRadius, angle=-AR15_CamPinAngle());
  }
}

BoltCarrier();

translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
rotate([0,-90,0])
AR15_Bolt(teardrop=false,
          firingPinRetainer=false,
          extraFiringPin=0,
          clearance=0);

AR15Forend(debug=false);

*PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  debug=false);
                  
*!scale(25.4)
rotate([0,-90,0])
AR15Forend();