include <../Meta/Common.scad>;

use <../Shapes/Bearing Surface.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/Components/Pump Grip.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Square Tube.scad>;

use <../Ammo/Shell Slug.scad>;

use <../Receiver/FCG.scad>;
use <../Receiver/Frame.scad>;
use <../Receiver/Lower.scad>;
use <../Receiver/Stock.scad>;
use <../Receiver/Receiver.scad>;

/* [Export] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/ReceiverFront", "Prints/Forend"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_HARDWARE = true;
_SHOW_STOCK = true;
_SHOW_STOCK_HARDWARE = true;
_SHOW_FCG = true;
_SHOW_FCG_HARDWARE = true;
_SHOW_LOWER = true;
_SHOW_LOWER_HARDWARE = true;
_SHOW_TENSION_RODS = false;

_SHOW_RECEIVER_FRONT = true;
_SHOW_FOREND = true;
_SHOW_BARREL = true;

/* [Transparency] */
_ALPHA_RECEIVER_FRONT=1; // [0:0.1:1]
_ALPHA_FOREND = 0.5;  // [0:0.1:1]
_ALPHA_RECEIVER = 1; // [0:0.1:1]
_ALPHA_LOWER = 1; // [0:0.1:1]
_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_FCG = 1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_RECEIVER = false;
_CUTAWAY_RECEIVER_FRONT = false;
_CUTAWAY_LOWER = false;
_CUTAWAY_BARREL = false;
_CUTAWAY_FOREND = false;

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

FOREND_BOLT = "#8-32"; // ["M4", "#8-32"]
FOREND_BOLT_CLEARANCE = -0.05;

BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.8131;
BARREL_CLEARANCE = 0.008;
BARREL_LENGTH = 19;
BARREL_Z = 0.0001;
RIM_WIDTH = 0.0301;
RIM_DIAMETER = 0.8875;

RECOIL_PLATE_LENGTH = 0.25;

/* [Fine Tuning] */
FRAME_BOLT_LENGTH = 10;
WALL_BARREL = 0.1875;
FOREGRIP_RADIUS = 1.0001;
/* [Branding] */
BRANDING_MODEL_NAME = "BIG IRON";

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=0.5);

// Settings: Dimensions
function BarrelLength() = BARREL_LENGTH;
function WallBarrel() = WALL_BARREL;
function BarrelTravel() = 3;
function MagazineMinX() = 3;
function ForegripX() = MagazineMinX();

// Settings: Vitamins
function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function ForendBolt() = BoltSpec(FOREND_BOLT);
assert(ForendBolt(), "ForendBolt() is undefined. Unknown FOREND_BOLT?");

// Measured: Vitamins
function BarrelRadius(clearance=0)
  = BarrelDiameter(clearance*2)/2;

function BarrelDiameter(clearance=0)
  = BARREL_OUTSIDE_DIAMETER+clearance;

function BarrelInsideRadius(clearance=0)
    = BarrelInsideDiameter(clearance*2)/2;

function BarrelInsideDiameter(clearance=0)
    = BARREL_INSIDE_DIAMETER+clearance;

function BarrelWall() = (BarrelDiameter() - BARREL_INSIDE_DIAMETER)/2;

function BarrelCollarSteelDiameter() = 1.75;
function BarrelCollarSteelRadius() = BarrelCollarSteelDiameter()/2;
function BarrelCollarSteelWidth() = 5/8;

// Settings: Vitamins
function ReceiverPipe()  = Spec_OnePointFiveSch40ABS();
function ReceiverPipe()  = Spec_OnePointSevenFivePCTube();
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
function CouplingBolt() = BoltSpec("1/4\"-20");

// Settings: Lengths
function ReceiverFrontLength() = 0.5;
function BarrelLength() = 18;
function PumpForegripLength() = 5;

// Settings: Positions
function MagazineZ() = -BarrelRadius()-0.5;
function ForegripZ() = MagazineZ()-1;
function ForegripTravel() = 4+1;
function ForendLength() = 5.5;
function WallFrameSide() = 0.125;

function MagazineSquareTube() = Spec_SquareTubeOneInch();


// * Vitamins *
module PumpMagazine(height=8, cutter=false, clearance=SquareTubeClearanceLoose(), alpha=1, cutaway=false) {
  clear = cutter ? clearance : undef;

  color("Silver", alpha) RenderIf(!cutter) Cutaway(cutaway)
  translate([MagazineMinX(),0,MagazineZ()])
  rotate([0,90,0])
  linear_extrude(height=height)
  translate([-(SquareTubeOuter(MagazineSquareTube(), clearance)/2),
             -SquareTubeOuter(MagazineSquareTube(), clearance)/2])
  Tubing2D(spec=MagazineSquareTube(),
           hollow=!cutter,
           clearance=clear);
}
module PumpMagazineShells() {
  color("Red")
  for (i = [1:3])
  translate([(i-1)*2.8,0,0])
  rotate([0,90,0])
  ShellSlugBall(height=2.0);
}
module BarrelCollar(clearance=0.002, cutter=false, cutaway=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") Cutaway(cutaway)
  difference() {
    translate([12,0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarSteelRadius()+clear,
             h=BarrelCollarSteelWidth(), $fn=40);

    translate([-ManifoldGap(),0,0])
    Barrel(hollow=false);
  }
}
module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(),
              hollow=true, cutter=false,
              clearance=undef, alpha=1, cutaway=false) {
  color("SteelBlue", alpha) RenderIf(!cutter) Cutaway(cutaway)
  translate([0,0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

// * Shapes *
module ShellLoadingSupport() {
}


// * Printed Parts *
module ReceiverFront(alpha=_ALPHA_RECEIVER_FRONT, cutaway=_CUTAWAY_RECEIVER_FRONT) {
  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {

    translate([-ReceiverFrontLength(),0,0]) {
      hull() {
        mirror([1,0,0])
        ReceiverTopSegment(length=ReceiverFrontLength());

        Frame_Support(length=ReceiverFrontLength(),
                     chamferFront=true, teardropFront=true);
      }

      hull() {

        // Recoil plate backing
        translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
        mirror([0,0,1])
        ChamferedCube([ReceiverFrontLength(),
                       RecoilPlateWidth()+0.5,
                       RecoilPlateHeight()-0.5],
                      r=1/8, teardropFlip=[true,true,true]);

        // Round off the bottom
        translate([0,0,-1])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.625, r2=1/8, h=0.5);

      }
    }

    Frame_Bolts(cutter=true);

    translate([-ReceiverFrontLength(),0,0]) {
      RecoilPlate(length=RECOIL_PLATE_LENGTH, cutter=true);
      RecoilPlateBolts(cutter=true);
      FiringPin(cutter=true);
      FiringPinSpring(cutter=true);
    }
  }
}
module PumpForend(alpha=1, cutaway=false) {
  ForendWall=0.25;

  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    union() {
      mirror([1,0,0])
      Receiver_Segment(length=ForendLength());

      hull() {
        mirror([1,0,0])
        ReceiverTopSegment(length=ForendLength());

        Frame_Support(length=ForendLength(),
                     chamferFront=true, teardropFront=true);
      }
    }

    translate([0,-(SquareTubeOuter(MagazineSquareTube(),SquareTubeClearanceLoose())/2)-0.1875,0])
    cube([ForendLength(),
           SquareTubeOuter(MagazineSquareTube(), SquareTubeClearanceLoose())+0.375,
          (PipeCapRadius(ReceiverPipe())*sqrt(2))+0.125]);

    translate([1-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=PipeCapRadius(ReceiverPipe(), clearance=PipeClearanceLoose())+0.01,
                      h=ForendLength()-1+ManifoldGap(2));

    translate([-ManifoldGap(),0,0])
    Barrel(hollow=false, cutter=true, clearance=PipeClearanceLoose());

    PumpMagazine(cutter=true);
  }
}
module PumpForegrip(length=PumpForegripLength(), cutaway=false, alpha=1) {
  color("Chocolate", alpha) render() Cutaway(cutaway)
  difference() {

    // Body around the barrel
    translate([ForegripX(),0,ForegripZ()])
    rotate([0,90,0])
    PumpGrip(h=length);

    translate([ForegripX(),0,0])
    rotate([0,90,0])
    rotate(360/6/2)
    BearingSurface(r=BarrelRadius()+BARREL_CLEARANCE,
                   length=length, center=false,
                   depth=0.03125, segments=6, taperDepth=0.03125);

  }
}


// * Assemblies *
module PumpShotgunAssembly(cutaway=false) {

  A_barrelX = BarrelTravel()*(SubAnimate(ANIMATION_STEP_UNLOAD, start=0.5)-SubAnimate(ANIMATION_STEP_LOAD, end=0.5));

  A_foregripX = ForegripTravel()*(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD));

  ShellLoadingSupport();

  // In position for load
  color("Red")
  rotate([0,90,0])
  ShellSlugBall(height=1.5);

  translate([A_barrelX,0,0]) {
    Barrel(cutaway=_CUTAWAY_BARREL, hollow=true);
    BarrelCollar(cutaway=_CUTAWAY_BARREL);
  }

  translate([A_barrelX,0,0])
  PumpForegrip();

  PumpMagazine(alpha=0.5);

  translate([-ReceiverFrontLength(),0,0]) {
    if (_SHOW_LOWER) {
      Lower(bolts=_SHOW_LOWER_HARDWARE, showLeft=!_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
      LowerMount(hardware=_SHOW_LOWER_HARDWARE, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
    }


      if(_SHOW_TENSION_RODS)
      Receiver_TensionBolts();

      if (_SHOW_RECEIVER)
      Frame_ReceiverAssembly(
        hardware=_SHOW_RECEIVER_HARDWARE,
        length=FRAME_BOLT_LENGTH-0.5,
        cutaway=_CUTAWAY_RECEIVER,
        alpha=_ALPHA_RECEIVER);

    if (_SHOW_STOCK)
    StockAssembly(hardware=_SHOW_STOCK_HARDWARE, alpha=_ALPHA_STOCK);
  }

  PumpForend(alpha=_ALPHA_FOREND);

  ReceiverFront();
}

ScaleToMillimeters()
if ($preview) {
  PumpShotgunAssembly(cutaway=false);
} else {
  if (_RENDER == "Prints/PumpForend")
  rotate([0,-90,0])
  PumpForend();

}

//$t=0.75;
