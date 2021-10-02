include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/Teardrop.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Square Tube.scad>;

use <../Lower/Lower.scad>;
use <../Lower/LowerMount.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Receiver.scad>;
use <../Frame.scad>;
use <../Stock.scad>;
use <../FCG.scad>;

/* [Print] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "PumpForend"]

/* [Assembly] */
//_SHOW_RECEIVER = true;
//_SHOW_BARREL = true;
//_SHOW_FOREND = true;
//_SHOW_FRAME = true;
//_SHOW_COLLAR = true;
//_SHOW_EXTRACTOR = true;
//_SHOW_RECEIVER_FRONT = true;
//_SHOW_FCG = true;
//_SHOW_STOCK = true;
//_SHOW_LOWER = true;
//_SHOW_LOWER_MOUNT = true;
//_SHOW_LATCH = true;
//
//_ALPHA_FOREND = 1;  // [0:0.1:1]
//_ALPHA_LATCH = 1; // [0:0.1:1]
//_ALPHA_COLLAR = 1; // [0:0.1:1]
//_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
//_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
//_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
//
//_CUTAWAY_RECEIVER = false;
//_CUTAWAY_FOREND = false;
//_CUTAWAY_COLLAR = false;
//_CUTAWAY_EXTRACTOR = false;
//_CUTAWAY_LATCH = false;


// Measured: Vitamins
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

function MagazineOffset() = (BarrelCollarSteelRadius()+0.5);
function BarrelTravel() = 4;
function UpperLength() = 6.5;
function WallFrameSide() = 0.125;

function MagazineSquareTube() = Spec_SquareTubeOneInch();


// ************
// * Vitamins *
// ************
module PumpMagazine(height=10.875, hollow=false, clearance=undef, alpha=1, debug=false) {

  color("Silver", alpha)
  for (R = [90]) rotate([R,0,0])
  translate([0,MagazineOffset(),0])
  rotate([0,90,0])
  DebugHalf(enabled=debug)
  linear_extrude(height=height)
  rotate(0)
  PumpMagazine2d(hollow=hollow);
}

module PumpMagazineShells() {
  color("Red")
  for (i = [1:3])
  translate([(i-1)*2.8,0,0])
  rotate([0,90,0])
  ShellSlugBall(height=2.0);
}
module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([8,0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarSteelRadius()+clear,
             h=BarrelCollarSteelWidth(), $fn=40);

    translate([-ManifoldGap(),0,0])
    Barrel(hollow=false);
  }
}

module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(),
              hollow=true, cutter=false,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([0,0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}



// **********
// * Shapes *
// **********
module PumpMagazine2d(hollow=false, clearance=undef) {
  translate([-(SquareTubeOuter(MagazineSquareTube(), clearance)/2),
             -SquareTubeOuter(MagazineSquareTube(), clearance)/2])
  Tubing2D(spec=MagazineSquareTube(),
           hollow=hollow,
           clearance=clearance);
}


module PumpRails(length=UpperLength(), cutter=false, clearance=0.002, extraRadius=0) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  *translate([-clear,0,0])
  rotate([0,90,0])
  rotate(180)
  linear_extrude(height=length+clear2)
  Teardrop(r=WallFrameSide()+BoltRadius(CouplingBolt())+extraRadius+clear,
           $fn=Resolution(20,30));
}

module ShellLoadingSupport() {
}





// *****************
// * Printed Parts *
// *****************
module ReceiverFront(alpha=1, debug=false) {
  difference() {
    Receiver_Segment(length=ReceiverFrontLength());
    
    Receiver_TensionBolts(cutter=true);
  }
}

module PumpForend(alpha=1, debug=false) {
  ForendWall=0.25;
  ForendLength=5;

  color("Green", alpha) DebugHalf(enabled=debug)
  difference() {
    mirror([1,0,0])
    Receiver_Segment(length=ForendLength);

    translate([0,-(SquareTubeOuter(MagazineSquareTube(),SquareTubeClearanceLoose())/2)-0.1875,0])
    cube([UpperLength(),
           SquareTubeOuter(MagazineSquareTube(), SquareTubeClearanceLoose())+0.375,
          (PipeCapRadius(ReceiverPipe())*sqrt(2))+0.125]);

    PumpRails(cutter=true);

    translate([1-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=PipeCapRadius(ReceiverPipe(), clearance=PipeClearanceLoose())+0.01,
                      h=UpperLength()-1+ManifoldGap(2),
                      $fn=Resolution(20,50));

    translate([-ManifoldGap(),0,0])
    Barrel(hollow=false, cutter=true, clearance=PipeClearanceLoose());

    PumpMagazine(hollow=false, clearance=SquareTubeClearanceLoose());
  }
}


// **************
// * Assemblies *
// **************
module PumpShotgunAssembly(debug=false) {

  ShellLoadingSupport();

  translate([-ReceiverFrontLength(),0,0]) {
    Receiver(debug=debug);
    *Frame_Receiver(debug=debug);
    
    StockAssembly();
    
    LowerMount();
    
    Lower(showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true);
    
  }
  
  PumpForend();

  color("LightSteelBlue")
  ReceiverFront();

  // In position for load
  color("Red")
  rotate([0,90,0])
  ShellSlugBall(height=2.0);

  translate([BarrelTravel()*(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)),0,0]) {
    Barrel(debug=debug, hollow=true);
    BarrelCollar(debug=debug);
    //PumpForend(alpha=1, debug=debug);
  }

  PumpMagazine(hollow=true, debug=false, alpha=0.5);
}

scale(25.4)
if ($preview) {
  PumpShotgunAssembly(debug=false);
} else {
  if (_RENDER == "PumpForend")
  rotate([0,-90,0])
  PumpForend();
  
}

//$t=0.75;
