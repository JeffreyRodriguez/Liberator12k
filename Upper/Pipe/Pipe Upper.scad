include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Frame.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

// Measured: Vitamins
function BarrelCollarSteelDiameter() = 1.75;
function BarrelCollarSteelRadius() = BarrelCollarSteelDiameter()/2;
function BarrelCollarSteelWidth() = 5/8;

// Settings: Walls
function WallLower()      = 0.25;
function WallFrameSide() = 0.1875;
function WallFrameFront() = 0.215;
function WallFrameBack()  = 0.3;

// Settings: Lengths
function ReceiverLength() = 12;
function BarrelLength() = 18;
function FrameLength() = 10;
function HammerBoltLength() = 2.5;
function HammerSpringLength() = 3;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
function ButtTee()    = Spec_AnvilForgedSteel_OneInch();
function ReceiverPipe()  = Spec_OnePointFiveSch40ABS();
function StrikerRod() = Spec_RodOneHalfInch();
function HammerBolt() = Spec_BoltOneHalf();

// Calculated: Positions
function LowerX() = LowerMaxX()-BreechRearX();
function ButtTeeCenterX() = -ReceiverLength()
                          - (TeePipeEndOffset(ButtTee(),ReceiverPipe())*2);

// Shorthand: Measurements
function ReceiverID()     = PipeInnerDiameter(ReceiverPipe());
function ReceiverIR()     = PipeInnerRadius(ReceiverPipe());
function ReceiverOD()     = PipeOuterDiameter(ReceiverPipe());
function ReceiverOR()     = PipeOuterRadius(ReceiverPipe());

function SearRadius(clearance)   = RodRadius(SearRod(), clearance);
function SearDiameter(clearance) = RodDiameter(SearRod(), clearance);

// Linear Hammer
function HammerTravel() = LowerMaxX()-1.0625;

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  DebugHalf(enabled=debug)
  difference() {
    translate([0,
               0,ReceiverCenter()])
    rotate([0,90,0])
    cylinder(r=BarrelCollarSteelRadius()+clear,
             h=BarrelCollarSteelWidth(), $fn=40);
    
    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel(hollow=false, cutter=true);
  }
}

module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([BreechFrontX(),0,ReceiverCenter()])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

module Receiver(ReceiverLength=ReceiverLength(), hollow=true, alpha=1, debug=false) {
  color("DimGrey", alpha) DebugHalf(enabled=debug)
  translate([BreechRearX(),0,ReceiverCenter()])
  rotate([0,-90,0])
  Pipe(pipe=ReceiverPipe(),
       clearance=undef,
       length=ReceiverLength+0.02,
       hollow=hollow);
}

module Butt(hollow=true, alpha=1, debug=false) {
  translate([ButtTeeCenterX()+TeeWidth(ButtTee()),0,ReceiverCenter()]) {

      color("DarkSlateGray", alpha) DebugHalf(enable=debug)
      rotate([0,-90,0])
      Tee(ButtTee(), hollow=hollow);
  }
}

module LinearHammer() {
  translate([-1-BoltCapHeight(HammerBolt())-HammerTravel(),0,0]) {
    
    translate([BreechRearX()+ManifoldGap(),0,ReceiverCenter()])
    rotate([0,90,0])
    NutAndBolt(bolt=HammerBolt(), boltLength=HammerBoltLength(), nutBackset=0.03125,
               capHex=true, capOrientation=true);
    
    translate([BreechRearX()+ManifoldGap(),0,ReceiverCenter()])
    rotate([0,-90,0])
    cylinder(r=5/16/2, h=HammerBoltLength()+HammerSpringLength(), $fn=Resolution(10,20));
    
    color("Orange")
    translate([BreechRearX(),0,ReceiverCenter()])
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(), h=HammerBoltLength()-NutHexHeight(HammerBolt()), $fn=Resolution(20,50));
  }
}

module PipeHousing(alpha=1, debug=false) {
  length = LowerX()-ReceiverLugRearMinX();
  
  color("Yellow", alpha)
  DebugHalf(enabled=debug) {
    PipeLugCenter(pipe=ReceiverPipe(), wall=WallLower());
    PipeLugFront(pipe=ReceiverPipe(), wall=WallLower());
    PipeLugRear(pipe=ReceiverPipe(), wall=WallLower());
  }
}

module PipeUpperAssembly(receiver=Spec_PipeThreeQuarterInch(),
                 hollowReceiver=true,
                 butt=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                 debug=true) {
  translate([-LowerX(),0,0]) {
    PipeHousing(debug=debug);
    
    Frame(debug=debug);
    FrameMajorStandoff(debug=debug);
    FrameMinorStandoff(debug=debug);
    
    Lower(alpha=1, accessoryBossEnabled=false,
          showTrigger=true,
          searLength=SearLength()+WallLower()+PipeWall(ReceiverPipe())+SearTravel());
  }
  
  PositionedFiringPinAssembly(debug=false);
  
  Receiver(hollow=hollowReceiver, debug=debug);
  
  Breech(debug=debug);
  //Butt(hollow=true, debug=false);
  
  LinearHammer();
}

PipeUpperAssembly(debug=true);

Barrel(debug=true);
//BarrelCollar(debug=true);
