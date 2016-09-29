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

use <../../../Reference.scad>;

use <../Frame.scad>;
use <../Cross Upper.scad>;

use <Barrel Lugs.scad>;

function ForendSlottedLength() = 3;
function ForendMidsectionLength() = 0.375;
function ForendFrontLength() = 0.5;

function ForendFrontMinX() = LowerMaxX()
                             +ForendSlottedLength()
                             +ForendMidsectionLength()
                             +ForendSlottedLength()+BarrelLugLength();

module ForendAlignmentLugs(barrelSpec=BarrelPipe(), wall=WallTee(),
                           alignmentSide=0.25, clearance=0) {
  for (i = [0,180,90,270])
  rotate([i,0,0])
  hull()
  //for (r = [15,-15]) rotate([r,0,0])
  rotate([0,0,45])
  translate([-(alignmentSide/2)-clearance,
             -(alignmentSide/2)-clearance,
             PipeOuterRadius(barrelSpec, PipeClearanceLoose())+wall-clearance])
  cube([alignmentSide+(clearance*2),
        alignmentSide+(clearance*2),
        0.45+(clearance*2)]);
}

module Forend(barrelSpec=BarrelPipe(), length=1,
              wall=WallTee(), wallTee=0.7,
              alignmentLugs=false, alignmentSlots=false,
              clearCeiling=false, clearFloor=false, $fn=40) {
  color("DimGrey")
  render(convexity=4)
  difference() {
    union() {
      rotate([0,90,0])
      linear_extrude(height=length)
      Quadrail2d(wall=wall, wallTee=wallTee,
                 clearCeiling=clearCeiling, clearFloor=clearFloor);

      if (alignmentLugs)
      translate([length,0,0])
      ForendAlignmentLugs(barrelSpec=barrelSpec, wall=wall);
    }

    if (alignmentSlots)
    ForendAlignmentLugs(barrelSpec=barrelSpec, clearance=0.01, wall=wall);

    Frame();

    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel();
  }
}

module ForendBaseplate(length=LowerWallFront()) {
  color("DimGrey")
  render()
  translate([LowerMaxX()-LowerWallFront(),0,0])
  difference() {
    hull() {
      Forend(length=ManifoldGap(), clearFloor=true, clearCeiling=true);

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


module ForendSlotted(cartridgeSpec=Spec_Cartridge_12GAx3(),
                     length=ForendSlottedLength(),
                     slotAngles=[90,270]) {

  semiAngle=60;

  color("Gold")
  render()
  translate([LowerMaxX(),0,0])
  difference() {
    Forend(length=length);

    for(slotAngle = slotAngles)
    rotate([slotAngle,0,0]) {
      translate([-ManifoldGap(),-CartridgeRimRadius(cartridgeSpec)-0.05,0])
      cube([length+ManifoldGap(2), CartridgeRimDiameter(cartridgeSpec)+0.1, 2]);

      rotate([0,90,0])
      translate([0,0,-ManifoldGap()])
      linear_extrude(height=length+ManifoldGap(2))
      rotate(-180+(semiAngle/2))
      semidonut(major=4, minor=CartridgeRimDiameter(cartridgeSpec), angle=semiAngle);
    }
  }
}

module ForendMidsection() {
  translate([LowerMaxX()+ForendSlottedLength(),0,0])
  Forend(length=ForendMidsectionLength());
}

module BarrelLugTrack(length=1, open=true) {
  angles = open ? [0, BarrelLugAngle()/2, BarrelLugAngle()] : [0];
  
  color("Gold")
  render()
  difference() {
    Forend(alignmentLugs=false, length=length);
    
    rotate([0,90,0])
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=length+ManifoldGap(2))
    for (i=angles)
    rotate(i)
    offset(r=0.02)
    BarrelLugs2d(barrelHole=false); 
  }
}

module LuggedForend(lengthOpen=BarrelLugLength()+0.05, lengthClosed=3) {
  echo("Lugged Forend Length", lengthOpen+lengthClosed);

  translate([LowerMaxX()+ForendMidsectionLength()+ForendSlottedLength(),0])
  color("Gold")
  render(convexity=4)
  union() {
    BarrelLugTrack(open=true, length=lengthOpen+ManifoldGap());
  
    translate([lengthOpen,0,0])
    BarrelLugTrack(open=false, length=lengthClosed);
  }
}

module ForendFront() {
  
  color("DimGrey")
  render()
  difference() {
    translate([ForendFrontMinX(),0,0])
    union() {
      Forend(length=ForendFrontLength());

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



CrossUpperFront();
CrossUpperBack();

ForendBaseplate();
ForendSlotted();
ForendMidsection();
ForendFront();

%Frame();

Reference();

// Plated Forend Baseplate
*!scale(25.4) rotate([0,90,0]) translate([-LowerWallFront(),0,0])
ForendBaseplate();

*!scale(25.4)
rotate([0,90,0])
translate([-LowerMaxX()-ForendSlottedLength(),0,0])
ForendSlotted();

// Plated Forend-Midsection
*!scale(25.4)
rotate([0,-90,0])
translate([LowerMaxX()+ForendSlottedLength(),0,0])
ForendMidsection();

// Plated Lugged Forend
*!scale(25.4)
//translate([0,0,1])
rotate([0,90,0])
LuggedForend();

// Plated Far Forend
*!scale(25.4)
rotate([0,-90,0])
render()
ForendFront();

