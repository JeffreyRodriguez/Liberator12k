use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

//DEFAULT_BARREL = Spec_PointFiveSix9mmBarrel();
DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
//DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();

DEFAULT_STOCK = Spec_PipeThreeQuarterInch();
DEFAULT_BREECH = Spec_BushingThreeQuarterInch();
DEFAULT_FRAME_ROD = Spec_RodFiveSixteenthInch();
DEFAULT_RECEIVER = Spec_TeeThreeQuarterInch();
DEFAULT_BARREL_LENGTH = 18;


// Settings: Walls
function WallTee()              = 3/16;
function WallTriggerGuardRod()  = 1/4;
function WallFrameRod()         = 3/16;
function WallFrameBack()        = 0.2;

// Settings: Offsets
function OffsetFrameBack() = 0.25;

// Settings: Vitamins
function BarrelPipe() = DEFAULT_BARREL;
function BreechBushing() = DEFAULT_BREECH;
function ReceiverTee() = DEFAULT_RECEIVER;
function FrameRod() = DEFAULT_FRAME_ROD;
function StockPipe() = DEFAULT_STOCK;

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

scale([25.4, 25.4, 25.4])
Reference();
