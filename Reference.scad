use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference Build Area.scad>;

//DEFAULT_BARREL = Spec_PointFiveSix9mmBarrel();
DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
//DEFAULT_BARREL = Spec_PipeOneInch(); // Trying a 1" pipe sleeve around the shell
//DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();

DEFAULT_STOCK = Spec_PipeThreeQuarterInch();
DEFAULT_BREECH = Spec_BushingThreeQuarterInch();
DEFAULT_FRAME_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_SEAR_ROD = Spec_RodOneEighthInch();
DEFAULT_SAFETY_ROD = Spec_RodOneEighthInch();
DEFAULT_TRIGGER_ROD = Spec_RodOneEighthInch();
DEFAULT_FIRING_PIN_ROD = Spec_RodOneEighthInch();
DEFAULT_RECEIVER = Spec_TeeThreeQuarterInch();
DEFAULT_BARREL_LENGTH = 18;


// Settings: Resolution 0 = low, 1 = high
RESOLUTION = 1;
function Resolution(low, high) = RESOLUTION == 0 ? low : high;

// Settings: Walls
function WallTee()              = 3/16;
function WallTriggerGuardRod()  = 0.2;
function WallFrameRod()         = 0.18;
function WallFrameBack()        = 0.5;
function WallBarrelLug()        = 0.1;

// Settings: Offsets
function OffsetFrameBack() = 0.315 + WallFrameBack();

// Settings: Vitamins
function BarrelPipe() = DEFAULT_BARREL;
function BreechBushing() = DEFAULT_BREECH;
function ReceiverTee() = DEFAULT_RECEIVER;
function StockPipe() = DEFAULT_STOCK;
function FrameRod() = DEFAULT_FRAME_ROD;
function SearRod() = DEFAULT_SEAR_ROD;
function SafetyRod() = DEFAULT_SAFETY_ROD;
function TriggerRod() = DEFAULT_TRIGGER_ROD;
function FiringPinRod() = DEFAULT_FIRING_PIN_ROD;

module Barrel(barrel=DEFAULT_BARREL, barrelLength=DEFAULT_BARREL_LENGTH,
              breech=DEFAULT_BREECH,
              receiver=DEFAULT_RECEIVER) {
  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
  rotate([0,90,0])
  Pipe(barrel, length=barrelLength);

}

module Receiver(receiver=Spec_TeeThreeQuarterInch()) {
  translate([0,0,-TeeCenter(receiver)])
  Tee(receiver);
}

function ReceiverInnerWidth(receiver) = TeeWidth(receiver) - (TeeRimWidth(receiver)*2);

module Stock(receiver, stock, stockLength) {
  translate([-(TeeWidth(receiver)/2) +0.01,0,0])
  rotate([0,-90,0])
  Pipe(stock, clearance=PipeClearanceLoose(), length=stockLength+0.02);
}

module Butt(receiver, stockLength) {
  translate([-stockLength,0,0])
  rotate([0,-90,0])
  Tee(receiver);
}

module Breech(receiver, breech) {
  translate([(TeeWidth(receiver)/2) + BushingHeight(breech) - BushingDepth(breech),0,0])
  rotate([0,-90,0])
  rotate([0,0,90])
  Bushing(spec=breech);
}

module Reference(barrel=Spec_TubingOnePointOneTwoFive(), barrelLength=18,
                 breech=Spec_BushingThreeQuarterInch(),
                 receiver=Spec_TeeThreeQuarterInch(),
                 stock=Spec_PipeThreeQuarterInch(), stockLength=12,
                 butt=Spec_TeeThreeQuarterInch()) {

  %color("White", 0.25) {
    Receiver(receiver);
    Breech(receiver, breech);
    Butt(receiver, stockLength);
    Stock(receiver, stock, stockLength);
    Barrel(receiver=receiver, breech=breech, barrel=barrel, barrelLength=barrelLength);
  }
}

scale([25.4, 25.4, 25.4]) {
  Reference();
  ReferenceBuildArea();
}
