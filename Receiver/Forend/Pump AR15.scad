include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Math/Circles.scad>;
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


chamferClearance = 0.01;
firingPinExtension = 0.55;      // From the back of the bolt
barrelRearWall = 0.125;
boltCarrierDiameter = AR15BarrelExtensionDiameter();
boltCarrierRadius = boltCarrierDiameter/2;
boltCarrierRearWall=0.1875;
boltCarrierRearExtension=0.125;

boltCarrierLength=BarrelMinX()
      +ReceiverFrontLength()
      -barrelRearWall
      +boltCarrierRearExtension;

boltCarrierTrackRadius = boltCarrierRadius+AR15_CamPinSquareHeight()+0.05;

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
              cutter=false, clearance=undef,
              alpha=1, debug=false) {
  translate([BarrelMinX(),0,0])
  rotate([0,90,0])
  rotate(180)
  AR15_Barrel();
}

module BoltCarrierCamTrackSupport(cutter=false, clearance=0.008) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  trackRadius = boltCarrierTrackRadius;
  trackLength = ReceiverFrontLength()
              + AR15_CamPinDiameter()
              + boltCarrierRearExtension
              + 1.08
              + 0.25;
  
  translate([-ReceiverFrontLength()-boltCarrierRearExtension,0,0])
  rotate([0,90,0])
  intersection() {
    linear_extrude(height=trackLength)
    hull() {
      rotate(180+11.25)
      semicircle(od=(boltCarrierTrackRadius+clear)*2,
                angle=90-AR15_CamPinAngle() +(cutter?1:0), center=true, $fn=50);
      
      circle(r=ArcLength(90-AR15_CamPinAngle(),
                         (boltCarrierDiameter/2)+AR15_CamPinSquareHeight())/2,
           $fn=50);
    }
    
    ChamferedCylinder(r1=boltCarrierTrackRadius+clear,
                      r2=boltCarrierTrackRadius/2,
                       h=trackLength,
                      teardropTop=true, chamferBottom=false, $fn=50);
  }
}

module BoltCarrierMagazineTrack(length=boltCarrierLength, clearance=0, clearanceAngle=0) {
    translate([-ReceiverFrontLength()-boltCarrierRearExtension,0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    rotate(45+AR15_CamPinAngle()+(clearanceAngle/2))
    semidonut(major=ReceiverID(),
              minor=AR15_BoltHeadDiameter()+clearance,
              angle=95+AR15_CamPinAngle()+clearanceAngle, $fn=50);
}
    
  

module BoltCarrier(clearance=0.01, chamferRadius=1/16, alpha=1) {

  color("Tan", alpha) render()
  difference() {
    
    union() {
      translate([-ReceiverFrontLength()-boltCarrierRearExtension,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=boltCarrierRadius,
                        r2=AR15BarrelExtensionDiameter()-AR15_BoltHeadDiameter(),
                        h=boltCarrierLength,
                        teardropTop=true, chamferBottom=false,
                        $fn=50);
      
      BoltCarrierCamTrackSupport();
    }
    
    BoltCarrierMagazineTrack();
    
    translate([BarrelMinX()+AR15_BoltLockLengthDiff(),0,0])
    rotate([0,-90,0])
    AR15_Bolt(clearance=0.005,
              extraCamPinSquareHeight=1,
              extraCamPinSquareLength=1,
              firingPinRetainer=false);
    
    translate([0.625,0,0]) 
    rotate([0,-90,0])
    rotate(-AR15_CamPinAngle())
    HelixSegment(radius=boltCarrierTrackRadius,
                  width=ActionRodWidth()+0.02, depth=0.1875,
                  top=0, bottom=0.125,
                  angle=-AR15_CamPinAngle());
  }
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
        
        translate([0,0,-0.5-0.1875])
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
    
    
    // Action rod main hole
    ActionRod(cutter=true);
    
    // Action rod pin travel slot
    hull() for (Z = [0, -ActionRodOffset()]) translate([0,0,Z])
    ActionRod(length=2, cutter=true);
    
    
    // Bolt Carrier Track (linear)
    BoltCarrierCamTrackSupport(cutter=true);
    
    // Bolt Carrier Track (rotary)
    rotate([-AR15_CamPinAngle(),0,0])
    BoltCarrierCamTrackSupport(cutter=true);
    
    Barrel(cutter=true);
    
    translate([-0.5,0,-0.5-0.1875])
    AR15_MagwellInsert(catch=false,
                       extraTop=0.1875);
    
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
module ReceiverBoltTrack(length=2.5, alpha=0.5) {

  color("OliveDrab", alpha) render()
  difference() {
    union() {
      translate([-ReceiverFrontLength(),0,0])
      mirror([1,0,0])
      ReceiverGuide(length=length);

      translate([-ReceiverFrontLength(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=ReceiverIR()-0.005, r2=1/32,
                         h=length,
                        teardropTop=true,
                        $fn=Resolution(30,60));
    }
    
    // Action rod slot
    hull() for (Z = [0,-ActionRodOffset()])
    translate([-FrameUpperRearExtension(),0,Z])
    ActionRod(cutter=true);
    
    // Bolt Carrier Cam Track (linear)
    for (X = [0,-1.5,-3]) translate([X,0,0])
    BoltCarrierCamTrackSupport(cutter=true);
    
    // Bolt Carrier Cam Track (rotary)
    rotate([-AR15_CamPinAngle(),0,0])
    BoltCarrierCamTrackSupport(cutter=true);
    
    // Bolt Carrier Linear
    difference() {
      
      // Bolt carrier hole
      rotate([0,-90,0])
      cylinder(r=0.51, h=FrameUpperRearExtension(), $fn=50);
      
      // Magazine clearance
      translate([ReceiverFrontLength()-FrameUpperRearExtension()+boltCarrierRearExtension,0,0])
      BoltCarrierMagazineTrack(length=FrameUpperRearExtension(),
                               clearance=0.02, clearanceAngle=-3);
    }
    
    // Bolt Carrier Rotary
    rotate([-AR15_CamPinAngle(),0,0])
    difference() {
      
      // Bolt carrier hole
      translate([-ReceiverFrontLength(),0,0])
      rotate([0,-90,0])
      cylinder(r=0.51, h=boltCarrierRearExtension, $fn=50);
      
      // Magazine clearance
      BoltCarrierMagazineTrack(length=boltCarrierRearExtension,
                               clearance=0.01, clearanceAngle=-1);
    }
  }
}




translate([-1-2,0,0])
*HammerAssembly(insertRadius=0.75, alpha=0.5);

*FrameBolts(length=10);

animate_unlock1 = SubAnimate(ANIMATION_STEP_UNLOCK, end=0.25)
               - SubAnimate(ANIMATION_STEP_LOCK, start=0.75);

animate_unlock2 = SubAnimate(ANIMATION_STEP_UNLOCK, start=0.25)
               - SubAnimate(ANIMATION_STEP_LOCK, end=0.75);

// Motion-coupled: Bolt carrier and action rod
translate([(-BarrelMinX()-1)*animate_unlock2,0,0]) {
  
  translate([-0.5*animate_unlock1,0,0]) {
    translate([1.25+0.1,0,0])
    ActionRod(length=11);

    translate([1.25+0.1,0,0])
    ActionRodBolt(angle=180,
                 length=ActionRodOffset()
                       -(ActionRodWidth()/2)
                       -AR15_BoltHeadRadius()
                       -AR15_CamPinSquareOffset()
                       +AR15_CamPinSquareHeight()+0.1875);

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

ReceiverBoltTrack();
color("DimGrey") render()
Barrel();

AR15Forend(debug=true);

*PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12);
                  

*!scale(25.4)
rotate([0,-90,0])
AR15Forend();

*!scale(25.4)
rotate([0,-90,0])
translate([ReceiverFrontLength(),0,0])
ReceiverBoltTrack();

*!scale(25.4)
rotate([0,-90,0])
BoltCarrier();
