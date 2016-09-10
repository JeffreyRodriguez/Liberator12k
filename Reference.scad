use <Meta/Manifold.scad>;
use <Meta/Resolution.scad>;

use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

//DEFAULT_BARREL = Spec_PointFiveSix9mmBarrel();
//DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
//DEFAULT_BARREL = Spec_PipeOneInch(); // Trying a 1" pipe sleeve around the shell
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();

DEFAULT_STOCK = Spec_PipeThreeQuarterInchSch80();
DEFAULT_BREECH = Spec_BushingThreeQuarterInch();
DEFAULT_FRAME_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_ACTUATOR_ROD = Spec_RodFiveSixteenthInch(); // Revolver Setting
DEFAULT_CYLINDER_ROD = Spec_RodFiveSixteenthInch(); // Revolver Setting
DEFAULT_CHARGING_ROD = Spec_RodOneQuarterInch();
DEFAULT_PIVOT_ROD = Spec_RodOneEighthInch();
DEFAULT_STRIKER_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_SAFETY_ROD = Spec_RodOneEighthInch();
DEFAULT_RESET_ROD = Spec_RodOneEighthInch();
DEFAULT_TRIGGER_ROD = Spec_RodOneEighthInch();
DEFAULT_FIRING_PIN_ROD = Spec_RodOneEighthInch();
DEFAULT_GRIP_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_RECEIVER = Spec_AnvilForgedSteel_TeeThreeQuarterInch();
DEFAULT_BUTT = Spec_AnvilForgedSteel_TeeThreeQuarterInch();
DEFAULT_BARREL_LENGTH = 18;
DEFAULT_STOCK_LENGTH = 12;
DEFAULT_NOZZLE_DIAMETER=0.8/25.4; // I'm using an 0.8mm Volcano clone.

// Settings: Nozzle
function NozzleDiameter() = DEFAULT_NOZZLE_DIAMETER;
function NozzleMultipleFloor(metric) = metric - (metric % DEFAULT_NOZZLE_DIAMETER);
function NozzleMultipleCeiling(metric) = metric + (metric % DEFAULT_NOZZLE_DIAMETER);


// Settings: Walls
function WallTee()              = 0.1;
function WallTriggerGuardRod()  = 0.35;
function WallFrontGripRod()     = 0.25;
function WallFrameRod()         = 0.2;
function WallFrameFront()       = 0.215;
function WallFrameBack()        = 0.3;
function WallBarrelLug()        = 0.1;

// Settings: Lengths
function StockLength() = DEFAULT_STOCK_LENGTH;
function BarrelLength() = DEFAULT_BARREL_LENGTH;

// Settings: Offsets
function OffsetFrameRod() = 0.4;
function OffsetFrameBack() = 0.315 + WallFrameBack();
function FrameRodMatchedAngle() = 45;

// Settings: Vitamins
function BarrelPipe() = DEFAULT_BARREL;
function BreechBushing() = DEFAULT_BREECH;
function ReceiverTee() = DEFAULT_RECEIVER;
function ButtTee() = DEFAULT_BUTT;
function StockPipe() = DEFAULT_STOCK;
function FrameRod() = DEFAULT_FRAME_ROD;
function ActuatorRod() = DEFAULT_ACTUATOR_ROD;
function ChargingRod() = DEFAULT_CHARGING_ROD;
function PivotRod() = DEFAULT_PIVOT_ROD;
function CylinderRod() = DEFAULT_CYLINDER_ROD;
function StrikerRod() = DEFAULT_STRIKER_ROD;
function SafetyRod() = DEFAULT_SAFETY_ROD;
function ResetRod() = DEFAULT_RESET_ROD;
function TriggerRod() = DEFAULT_TRIGGER_ROD;
function FiringPinRod() = DEFAULT_FIRING_PIN_ROD;
function GripRod() = DEFAULT_GRIP_ROD;

// Calculated: Positions
function ButtTeeCenterX() = - StockLength()
                            - (TeePipeEndOffset(ReceiverTee(),StockPipe())*2);

function BreechFrontX(receiver=ReceiverTee(),
                               breech=BreechBushing()) = (TeeWidth(receiver)/2)
                                                       + BushingHeight(breech)
                                                       - BushingDepth(breech);

function BreechRearX(receiver=ReceiverTee(),
                              breech=BreechBushing()) = (TeeWidth(receiver)/2)
                                                       - BushingDepth(breech);

// Shorthand: Measurements
function ReceiverLength() = TeeWidth(ReceiverTee());
function ReceiverCenter() = TeeCenter(ReceiverTee());
function ReceiverIR()     = TeeInnerRadius(ReceiverTee());
function ReceiverID()     = TeeInnerDiameter(ReceiverTee());
function ReceiverOR()     = TeeRimRadius(ReceiverTee());
function ReceiverOD()     = TeeRimDiameter(ReceiverTee());

function SearRadius(clearance)   = RodRadius(SearRod(), clearance);
function SearDiameter(clearance) = RodDiameter(SearRod(), clearance);

function StrikerRadius(clearance)   = RodRadius(StrikerRod(), clearance);
function StrikerDiameter(clearance) = RodDiameter(StrikerRod(), clearance);


// Component Modules
module Barrel(barrel=BarrelPipe(), barrelLength=DEFAULT_BARREL_LENGTH,
              breech=BreechBushing(),
              receiver=DEFAULT_RECEIVER) {
  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
  rotate([0,90,0])
  Pipe(barrel, length=barrelLength);

}

module Receiver(receiver=ReceiverTee()) {
  translate([0,0,-TeeCenter(receiver)])
  CrossFitting(receiver);
}

function ReceiverInnerWidth(receiver=ReceiverTee()) = TeeWidth(receiver) - (TeeRimWidth(receiver)*2);

module Stock(receiver, stock, stockLength, hollow=true) {
  translate([-TeeCenter(ReceiverTee())+PipeThreadDepth(stock),0,0])
  rotate([0,-90,0])
  Pipe(pipe=stock,
  clearance=PipeClearanceLoose(),
     length=stockLength+0.02,
     hollow=hollow);
}

module Butt(receiver, stockLength) {
  translate([ButtTeeCenterX()+TeeCenter(ReceiverTee()),0,0])
  rotate([0,-90,0])
  Tee(ButtTee());
}

module Breech(receiver, breech) {
  translate([BreechFrontX(),0,0])
  rotate([0,-90,0])
  rotate([0,0,90])
  Bushing(spec=breech);
}

module Reference(barrel=BarrelPipe(),
           barrelLength=18,
                 breech=Spec_BushingThreeQuarterInch(),
               receiver=ReceiverTee(),
                  stock=Spec_PipeThreeQuarterInch(),
            stockLength=StockLength(), hollowStock=false,
                   butt=Spec_TeeThreeQuarterInch()) {

  Stock(receiver, stock, stockLength, hollow=hollowStock);

  color("Black")
  Breech(receiver, breech);

  color("DimGray")
  Receiver(receiver);

  color("DimGray")
  Butt(receiver, stockLength);

  color("Silver")
  translate([ManifoldGap()+3,0,0])
  Barrel(receiver=receiver, breech=breech, barrel=barrel, barrelLength=barrelLength);
}


module ReferenceTeeCutter(centerLength = ReceiverOD(), $fn=Resolution(12,30)) {

  // Vertical
  translate([0,0,-TeeCenter(ReceiverTee())])
  TeeRim(ReceiverTee(), height=TeeWidth(ReceiverTee()));

  // Horizontal
  translate([-TeeWidth(ReceiverTee())/2,0,0])
  rotate([0,90,0])
  TeeRim(ReceiverTee(), height=TeeWidth(ReceiverTee()));

  // Corner Infill
  for (n=[-1,1]) // Top of cross-fitting
  for (i=[-1,1]) // Sides of tee-fitting
  translate([i*TeeOuterRadius(ReceiverTee())/2,0,n*-TeeOuterRadius(ReceiverTee())/2])
  rotate([0,n*i*45,0])
  cylinder(r=TeeOuterRadius(ReceiverTee()), h=0.5, center=true);

  // Stock
  rotate([0,-90,0])
  Pipe(StockPipe(), length=StockLength());

}

scale([25.4, 25.4, 25.4]) {
  Reference();
}
