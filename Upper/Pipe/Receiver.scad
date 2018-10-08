use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

// Settings: Walls
function WallLower()      = 0.25;
function WallFrameFront() = 0.215;
function WallFrameBack()  = 0.3;

// Settings: Lengths
function StockLength() = 12;
function BarrelLength() = 18;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
function ButtTee() = Spec_AnvilForgedSteel_OneInch();
function StockPipe() = Spec_PipeOneInchSch80();
function FrameRod() = Spec_RodOneQuarterInch();
function StrikerRod() = Spec_RodOneQuarterInch();

// Calculated: Positions
function ReceiverCenter() = PipeOuterRadius(StockPipe())+WallLower();
function ButtTeeCenterX() = - StockLength()
                            - (TeePipeEndOffset(ButtTee(),StockPipe())*2);

function BreechFrontX() = PipeCapLength(StockPipe());

function BreechRearX() = BreechFrontX()-PipeCapDepth(StockPipe());


// Shorthand: Measurements
function ReceiverID()     = PipeInnerDiameter(StockPipe());
function ReceiverIR()     = PipeInnerRadius(StockPipe());
function ReceiverOD()     = PipeOuterDiameter(StockPipe());
function ReceiverOR()     = PipeOuterRadius(StockPipe());

function SearRadius(clearance)   = RodRadius(SearRod(), clearance);
function SearDiameter(clearance) = RodDiameter(SearRod(), clearance);

// Component Modules
module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=false,
              clearance=PipeClearanceLoose(), alpha=1) {
  color("SteelBlue", alpha)
  translate([BreechFrontX(),0,ReceiverCenter()])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance, hollow=hollow, length=barrelLength);
}

module Stock(stockLength=12, hollow=true, alpha=1) {
  color("SteelBlue", alpha)
  render()
  translate([BreechFrontX()-PipeThreadDepth(StockPipe()),0,ReceiverCenter()])
  rotate([0,-90,0])
  Pipe(pipe=StockPipe(),
       clearance=undef,
       length=stockLength+0.02,
       hollow=hollow);
}

module Butt(hollow=true, alpha=1) {
  translate([ButtTeeCenterX()+TeeWidth(ButtTee()),0,ReceiverCenter()]) {
      
      color("SteelBlue", alpha)
      translate([-TeeCenter(ButtTee()),0,-TeeWidth(ButtTee())])
      Pipe(pipe=StockPipe(),
           clearance=undef,
           hollow=hollow,
           length=2);
      
      color("DarkSlateGray", alpha)
      translate([-TeeCenter(ButtTee()),0,-TeeWidth(ButtTee())-.75])
      PipeCap(spec=StockPipe(), hollow=hollow);
      
      color("DarkSlateGray", alpha)
      rotate([0,-90,0])
      Tee(ButtTee(), hollow=hollow);
  }
}

module Breech() {
  color("DarkSlateGray")
  translate([BreechFrontX(),0,ReceiverCenter()])
  rotate([0,-90,0])
  rotate([0,0,90])
  PipeCap(spec=StockPipe());
}

module Receiver(stock=Spec_PipeThreeQuarterInch(),
                 stockLength=StockLength(),
                 hollowStock=true,
                 butt=Spec_AnvilForgedSteel_TeeThreeQuarterInch()) {
  Stock(stockLength=stockLength, hollow=hollowStock);
  Breech(hollow=true);
  Butt(hollow=true);
}

scale(25.4) {
    Receiver();
    Barrel();
}