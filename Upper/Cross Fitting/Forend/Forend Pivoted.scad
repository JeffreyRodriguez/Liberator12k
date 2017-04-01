//$t=0.755;
//$t=0;
include <../../../Meta/Animation.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;
use <../../../Components/Printable Shaft Collar.scad>;
use <../../../Reference.scad>;
use <../Frame.scad>;
use <Forend Slotted.scad>;

DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_LOCK_ROD  = Spec_RodOneEighthInch();
SET_SCREW_SPEC = Spec_BoltM4();



function LockRodX() = ReceiverCenter()
                    + RodRadius(DEFAULT_LOCK_ROD)
                    + 1.5;
function LockRodZ() = PipeOuterRadius(DEFAULT_BARREL, undef)
                    + RodRadius(DEFAULT_LOCK_ROD, undef);


function Spec_PivotRod() = Spec_RodOneEighthInch();
function PivotWall()    = 0.25;
function ShaftCollarWall() = 0.375;

function BarrelShaftCollarDiameter() = 1.875;
function BarrelShaftCollarDiameter() = 1.5;
function BarrelShaftCollarLength() = 0.5;

function PivotAngle() = 30;
function PivotOffset() = 5;
function LowerPivotX() = BreechFrontX()+PivotOffset();
function LowerPivotZ() = -PipeOuterRadius(DEFAULT_BARREL)
                         -RodRadius(Spec_PivotRod(), RodClearanceLoose());
                         
function BarrelShaftCollarX() = LowerPivotX()
                              - RodRadius(Spec_PivotRod(), RodClearanceLoose())
                              - BarrelShaftCollarLength()
                              - ManifoldGap();

function ForendOffsetX() = LowerPivotX()
                         - PivotedForendLength()
                         + (PivotWall()*2)
                         + RodRadius(Spec_PivotRod(), RodClearanceLoose())
                         +0.27; // TODO: Calculate this from the shaft collar's bottom tip pivot

function PivotedForendLength() = 
                         + (PivotWall()*3)
                         + BarrelShaftCollarLength()
                         + RodDiameter(Spec_PivotRod())
                         +0.125;

module PivotRod(cutter=false, nutEnable=false, teardropAngle=180, alpha=1) {
  
  color("SteelBlue", alpha)
  translate([LowerPivotX(),1.45,LowerPivotZ()])
  rotate([90,0,0])
  Rod(rod=Spec_PivotRod(),
      length=3,
      clearance=RodClearanceLoose(),
      teardrop=cutter,
      teardropRotation=teardropAngle,
      teardropTruncated=false);
  
  
}

module LockRod(cutter=false, teardropAngle=180, alpha=1) {
  
  color("SteelBlue", alpha)
  translate([LockRodX(),0,LockRodZ()])
  rotate([90,0,0])
  Rod(rod=DEFAULT_LOCK_ROD,
      length=3,
      clearance=RodClearanceLoose(),
      center=true,
      teardrop=cutter,
      teardropRotation=teardropAngle,
      teardropTruncated=false);
}

module BarrelShaftCollar(diameter=BarrelShaftCollarDiameter(), cutter=false, extend=0,
                         height=BarrelShaftCollarLength()) {

  render()
  translate([BarrelShaftCollarX(),0,0])
  rotate([0,90,0])
  scale(cutter ? 1.01 : 1) {
    DoubleShaftCollar(od=diameter, height=height);
  }
}

module Pivot(factor=1) {
  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([0,PivotAngle()*factor,0])
  translate([-LowerPivotX(),0,-LowerPivotZ()])
  children();
}

module ForendPivoted(barrelPipe=DEFAULT_BARREL, length=PivotedForendLength(),
                     forendOffsetX=ForendOffsetX(),
                     bolt=false,
                    wall=WallTee(), $fn=40, alpha=1) {
  
  color("Purple", alpha)
  render(convexity=4)
  difference() {
    union() {
      translate([forendOffsetX,0,0])
      rotate([0,90,0])
      difference() {
        linear_extrude(height=length)
        Quadrail2d();
      
        translate([0,0,-ManifoldGap()])
        linear_extrude(height=length+ManifoldGap(2)) {
          FrameRods();
        }
      }
    }
    

    union() {
      
      PivotRod(cutter=true, nutEnable=bolt, teardropAngle=180);
      
      BarrelShaftCollar(extend=2);

      // Printing-taper
      //hull()
      for (X = [0,-BarrelShaftCollarX()+ForendOffsetX()-ManifoldGap()])
      translate([X,0,0])
      BarrelShaftCollar(cutter=true);

      // Curve the top-end of the shaft collar
      hull()
      for (f = [0,0.25,0.5,0.75,1])
      Pivot(factor=f)
      difference() {
        BarrelShaftCollar(cutter=true);
        
        translate([BarrelShaftCollarX()-ManifoldGap(),0,0])
        scale(1.01)
        translate([0,
                   -BarrelShaftCollarDiameter()/2,
                   -PipeOuterRadius(barrelPipe)])
        mirror([0,0,1])
        cube([BarrelShaftCollarLength()+ManifoldGap(2),
              BarrelShaftCollarDiameter(),
              BarrelShaftCollarDiameter()]);
      }
      
      // Fully pivoted shaft collar position
      Pivot(factor=1)
      BarrelShaftCollar(cutter=true);

      // Square off the breech-end
      hull()
      for (z = [0,1.5])
      translate([0,0,z])
      Barrel(barrel=barrelPipe, barrelLength=2.5);

      // Cutout for the barrel near breach
      hull() {

        Barrel(barrel=barrelPipe, barrelLength =
               LowerPivotX()
             - BreechFrontX()
             + PipeOuterRadius(barrelPipe));

        Pivot()
        Barrel(barrel=barrelPipe, barrelLength =
               LowerPivotX()
             - BreechFrontX()
             + PipeOuterRadius(barrelPipe));
      }

      // Cutout for the barrel near front
      hull() {
        translate([LowerPivotX()-BreechFrontX(),0,0])
        Barrel(barrel=barrelPipe, barrelLength = length
                            + forendOffsetX
                            - LowerPivotX()
                            + PipeOuterRadius(barrelPipe));

        Pivot()
        translate([LowerPivotX()-BreechFrontX(),0,0])
        Barrel(barrel=barrelPipe, barrelLength = length
                            + forendOffsetX
                            - LowerPivotX()
                            + PipeOuterRadius(barrelPipe));
      }
    }
  }
}

module ForendPivotLock(barrelPipe=DEFAULT_BARREL,
                           length=1,
                    wall=WallTee(), $fn=40, alpha=1) {
  
  color("Purple", alpha)
  render(convexity=4)
  difference() {
    translate([LockRodX()-0.5,0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    ForendSlotted2d(barrelSpec=barrelPipe,
                    slotAngles=[180]);
    
    LockRod(cutter=true, teardropAngle=180);

  }
}


translate([LowerPivotX(),0,LowerPivotZ()])
rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
translate([-LowerPivotX(),0,-LowerPivotZ()]) {

  Barrel(barrel=DEFAULT_BARREL, hollow=true);
  PivotRod(nutEnable=false);

  BarrelShaftCollar();
}

translate([0,0,0]) {
  
  translate([0,-2.125*Animate(ANIMATION_STEP_UNLOCK),0])
  translate([0,2.125*Animate(ANIMATION_STEP_LOCK),0])
  LockRod();
  Frame();
  Reference(barrelPipe=DEFAULT_BARREL);
}

ForendPivoted(bolt=false, alpha=0.5);
ForendPivotLock(alpha=0.5);


// Plated Forend Pivoted Lock
*!scale(25.4)
rotate([0,90,0])
translate([-LockRodX()-0.5,0,0])
ForendPivotLock(alpha=0.5);


// Plated Forend Pivoted
*!scale(25.4)
rotate([0,90,0])
translate([-ForendOffsetX()-PivotedForendLength(),0,0])
ForendPivoted(bolt=true, sidebars=false, alpha=1);
