include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;

use <../../../Components/Pipe/Frame.scad>;

use <../../../Components/Cylinder.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Ammo/Shell Slug.scad>;

use <../Pipe Upper.scad>;


// Measured: Vitamins
function BarrelCollarSteelDiameter() = 1.75;
function BarrelCollarSteelRadius() = BarrelCollarSteelDiameter()/2;
function BarrelCollarSteelWidth() = 5/8;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();

// Settings: Lengths
function BarrelLength() = 18;

function MagazineCenterZ() = 0;
function BarrelTravel() = 4;
function UpperLength() = 6.5;


module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") DebugHalf(enabled=debug)
  difference() {
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
  translate([BreechFrontX(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

module RevolverForendAssembly(receiver=Spec_PipeThreeQuarterInch(),
                 hollowReceiver=true,
                 butt=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                 debug=true) {
  translate([BreechFrontX(),0,-FrameMajorRodOffset()])
  rotate([0,90,0])
  RevolverCylinder();
}


RevolverForendAssembly(debug=true);
PipeUpperAssembly(debug=true);

//PipeUpperAssembly(frame=true, debug=true);

FrameAssembly(debug=true);

PumpMagazine(hollow=true, debug=true);

Barrel(debug=false);
//BarrelCollar(debug=true);
