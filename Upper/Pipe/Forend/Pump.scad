include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Teardrop.scad>;

use <../../../Components/Pipe/Frame.scad>;
use <../../../Components/Pipe/Frame Standoffs.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Square Tube.scad>;

use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Trigger.scad>;
use <../../../Lower/Lower.scad>;

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

function MagazineOffset() = (BarrelCollarSteelRadius()+0.5);
function BarrelTravel() = 4;
function UpperLength() = 6.5;

function MagazineSquareTube() = Spec_SquareTubeOneInch();

module PumpMagazine2d(hollow=false, clearance=undef) {
  translate([-(SquareTubeOuter(MagazineSquareTube(), clearance)/2),
             -SquareTubeOuter(MagazineSquareTube(), clearance)/2])
  Tubing2D(spec=MagazineSquareTube(),
           hollow=hollow,
           clearance=clearance);
}

module PumpMagazine(height=10.875, hollow=false, clearance=undef, alpha=1, debug=false) {
  
  translate([BreechFrontX(),0,0])
  for (R = [180-45, 45]) rotate([R,0,0])
  translate([0,MagazineOffset(),0]) {
    color("Red")
    for (i = [1:3])
    translate([(i-1)*2.8,0,0])
    rotate([0,90,0])
    ShellSlugBall(height=2.0);
    
    color("Silver", alpha)
    rotate([0,90,0])
    DebugHalf(enabled=debug)
    linear_extrude(height=height)
    rotate(0)
    PumpMagazine2d(hollow=hollow);
  }
}

/*
module PumpRails(length=UpperLength(), cutter=false, clearance=0.002, extraRadius=0) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  translate([BreechFrontX()-clear,0,0])
  rotate([0,90,0])
  rotate(180)
  linear_extrude(height=length+clear2)
  Teardrop(r=WallFrameSide()+BoltRadius(FrameBolt())+extraRadius+clear,
           $fn=Resolution(20,30));
}
*/

module ShellLoadingSupport() {
}


module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([6,0,0])
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


module PumpForend(alpha=1, debug=false) {
  ForendWall=0.25;
  ForendLength=0.5;
  
  color("Green", alpha) DebugHalf(enabled=debug)
  difference() {
    union() {
      hull() {
        translate([BreechFrontX()+UpperLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=PipeCapRadius(ReceiverPipe())+ForendWall,
                          r2=0.0625,
                          h=ForendLength,
                          $fn=Resolution(20,50));
        
            
        translate([BreechFrontX()+6.75,0,0])
        rotate([0,90,0])
        linear_extrude(height=ForendLength)
        offset(r=0.1875)
        PumpMagazine2d(clearance=SquareTubeClearanceSnug());
      }
      
      hull() {
    
        translate([BreechFrontX(),0,0])
        rotate([0,90,0])
        intersection() {
          
          ChamferedCylinder(r1=PipeCapRadius(ReceiverPipe())+ForendWall,
                            r2=0.0625,
                            h=UpperLength()+ForendLength,
                            $fn=Resolution(20,50));
          
          translate([-ManifoldGap(),
                     -PipeCapRadius(ReceiverPipe())-ForendWall-ManifoldGap(),
                     -ManifoldGap()])
          cube([PipeCapDiameter(ReceiverPipe())+(ForendWall*2)+ManifoldGap(2),
                PipeCapDiameter(ReceiverPipe())+(ForendWall*2)+ManifoldGap(2),
                UpperLength()+ForendLength+ManifoldGap(2)]);
        }
        
        PumpRails(extraRadius=0.1875, length=UpperLength()+ForendLength);
      }
    }
    
    translate([0,-(SquareTubeOuter(MagazineSquareTube(),SquareTubeClearanceLoose())/2)-0.1875,0])
    cube([UpperLength(),
           SquareTubeOuter(MagazineSquareTube(), SquareTubeClearanceLoose())+0.375,
          (PipeCapRadius(ReceiverPipe())*sqrt(2))+0.125]);
    
    PumpRails(cutter=true);
    
    translate([BreechFrontX()+1-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=PipeCapRadius(ReceiverPipe(), clearance=PipeClearanceLoose())+0.01,
                      h=UpperLength()-1+ManifoldGap(2),
                      $fn=Resolution(20,50));
    
    translate([-ManifoldGap(),0,0])
    Barrel(hollow=false, cutter=true, clearance=PipeClearanceLoose());
    
    PumpMagazine(hollow=false, clearance=SquareTubeClearanceLoose());
  }
}

module PumpShotgunAssembly(debug=false) {
  
  ShellLoadingSupport();

  *PipeUpperAssembly(debug=debug);

  FrameAssembly(debug=debug);
    

color("LightSteelBlue")
translate([11.25,0,0])
hull()
Breech();
  
  color("Red") {
    // In position for load
    translate([BreechFrontX(),0,0])
    rotate([0,90,0])
    ShellSlugBall(height=2.0);
  }

  translate([BarrelTravel()*(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)),0,0]) {
    Barrel(debug=debug, hollow=true);
    BarrelCollar(debug=debug);
    //PumpForend(alpha=1, debug=debug);
  }

  PumpMagazine(hollow=true, debug=false, alpha=0.5);
}

PumpShotgunAssembly(debug=false);

//$t=0.75;
