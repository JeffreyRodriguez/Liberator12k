//$t=0.8;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Semicircle.scad>;

use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;

use <../../../Ammo/Cartridges/Cartridge.scad>;
use <../../../Ammo/Cartridges/Cartridge_12GA.scad>;

use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Lower.scad>;
use <../../../Lower/Trigger.scad>;

use <../Reference.scad>;

use <../Frame.scad>;

use <Forend Slotted.scad>;

function ForendSlottedLength() = 3;
function ForendMidsectionLength() = 0.25;
function ForendFrontLength() = 0.375;

module ForendSlotted() {
  translate([LowerMaxX(),0,0])
  rotate([0,90,0])
  color("Gold")
  render()
  linear_extrude(height=ForendSlottedLength())
  ForendSlotted2d(slotAngles=[0,180]);
}

function ForendFrontMinX() = LowerMaxX()
                             +ForendSlottedLength()
                             +ForendMidsectionLength()
                             +ForendSlottedLength();


module Forend(barrelSpec=BarrelPipe(), length=1,
              wall=WallTee(), wallTee=0.7,
              clearCeiling=false, clearFloor=false, $fn=40) {
  color("DimGrey")
  render(convexity=4)
  difference() {
    union() {
      rotate([0,90,0])
      linear_extrude(height=length) {
        Quadrail2d(wall=wall, wallTee=wallTee,
                   clearCeiling=clearCeiling, clearFloor=clearFloor);
        
        children();
      }
    }
      
    Frame();

    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel(barrel=barrelSpec);
  }
}

module ForendBaseplate(length=LowerWallFront()) {
  color("DimGrey")
  render()
  translate([LowerMaxX()-LowerWallFront(),0,0])
  difference() {
    hull() {
      Forend(length=ManifoldGap(), clearFloor=true, clearCeiling=false);

      translate([length,0,0])
      Forend(length=ManifoldGap(), clearFloor=true, clearCeiling=false);
    }

    Frame();

    // Larger center hole for the hex plug
    translate([-ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=(BushingCapWidth(Spec_BushingThreeQuarterInch())/2)+0.1,
             h=length*2, $fn=30);
  }
}

module ForendMidsection(barrelSpec=BarrelPipe()) {
  translate([LowerMaxX()+ForendSlottedLength(),0,0])
  Forend(barrelSpec=barrelSpec, length=ForendMidsectionLength());
}

module ForendFront() {
  
  color("DimGrey")
  render()
  difference() {
    translate([ForendFrontMinX(),0,0])
    union() {
      Forend(length=ForendFrontLength()) {
        
        // Front bead sight
        hull() {
          mirror([1,0])
          translate([0,-0.125])
          square([ReceiverCenter()+0.5,0.25]);
          
          mirror([1,0])
          translate([0,-ReceiverOR()])
          square([ReceiverCenter(),ReceiverOD()]);
        }
      }
      

      // Barrel-supporting cone
      rotate([0,90,0])
      cylinder(r1=FrameRodOffset()-RodRadius(FrameRod(), RodClearanceLoose()),
               r2=PipeOuterRadius(BarrelPipe())+0.25,
                h=1,
              $fn=PipeFn(BarrelPipe()));
    }
    
    Barrel();
  }
}

ForendBaseplate();
ForendSlotted();
ForendMidsection();
ForendFront();

Frame();
Receiver();
Breech();

// Plated Forend Baseplate
*!scale(25.4) rotate([0,90,0]) translate([-LowerWallFront(),0,0])
ForendBaseplate();

// Plated Forend-Midsection
*!scale(25.4)
rotate([0,-90,0])
translate([-LowerMaxX()-ForendSlottedLength(),0,0])
ForendMidsection(barrelSpec=Spec_Tubing1628x1125());

// Plated Far Forend
*!scale(25.4)
rotate([0,-90,0])
translate([-ForendFrontMinX(),0,0])
ForendFront();

