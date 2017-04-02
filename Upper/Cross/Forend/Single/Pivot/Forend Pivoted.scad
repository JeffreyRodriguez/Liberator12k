//$t=0.70;
//$t=0.755;
//$t=0;
include <../../../../../Meta/Animation.scad>;
use <../../../../../Meta/Clearance.scad>;
use <../../../../../Meta/Manifold.scad>;
use <../../../../../Meta/Resolution.scad>;
use <../../../../../Meta/Units.scad>;
use <../../../../../Vitamins/Pipe.scad>;
use <../../../../../Vitamins/Rod.scad>;
use <../../../../../Vitamins/Nuts And Bolts.scad>;
use <../../../../../Vitamins/Double Shaft Collar.scad>;
use <../../../../../Components/Printable Shaft Collar.scad>;
use <../../../../../Components/Set Screw.scad>;
use <../../../Reference.scad>;
use <../../../Frame.scad>;
use <../../Forend Slotted.scad>;
use <../../Forend.scad>;

DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_LOCK_ROD  = Spec_RodOneEighthInch();

function LatchWidth() = 0.75;
function LatchHeight() = 0.25;
function LatchLength() = 2;

function Spec_PivotRod() = Spec_RodOneEighthInch();
function PivotWall()    = 0.25;
function ShaftCollarWall() = 0.375;

//function BarrelShaftCollarDiameter() = 1.5;
function BarrelShaftCollarDiameter() = 1.875;
function BarrelShaftCollarLength() = 0.5;

function PivotAngle() = 30;
function PivotOffset() = 5;
function BarrelPivotX() = BreechFrontX()+PivotOffset();
function BarrelPivotZ() = -PipeOuterRadius(DEFAULT_BARREL)
                         -RodRadius(Spec_PivotRod(), RodClearanceLoose());

function BarrelShaftCollarX() = BarrelPivotX()
                              - RodRadius(Spec_PivotRod(), RodClearanceLoose())
                              - BarrelShaftCollarLength()
                              - ManifoldGap();

function PivotedForendLength() =
                         + (PivotWall()*3)
                         + BarrelShaftCollarLength()
                         + RodDiameter(Spec_PivotRod())
                         +0.125;
                         
function ForendOffsetX() = BarrelPivotX()
                         - PivotedForendLength()
                         + (PivotWall()*2)
                         + RodRadius(Spec_PivotRod(), RodClearanceLoose())
                         +0.27; // TODO: Calculate this from the shaft collar's bottom tip pivot


function ForendPivotLatchTravel() = 0.25;
function ForendPivotLatchX() = ForendX()
                             + 0.5
                             + 0.05;

function ForendPivotLatchZ(barrel=DEFAULT_BARREL) = -PipeOuterRadius(pipe=barrel)
                                                  - 0.125;

module PivotRod(cutter=false, nutEnable=false, teardropAngle=180, alpha=1) {

  color("SteelBlue", alpha)
  translate([BarrelPivotX(),1.45,BarrelPivotZ()])
  rotate([90,0,0])
  Rod(rod=Spec_PivotRod(),
      length=3,
      clearance=RodClearanceLoose(),
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
  translate([BarrelPivotX(),0,BarrelPivotZ()])
  rotate([0,PivotAngle()*factor,0])
  translate([-BarrelPivotX(),0,-BarrelPivotZ()])
  children();
}

module ForendPivoted(barrelPipe=DEFAULT_BARREL, length=PivotedForendLength(),
                     forendOffsetX=ForendOffsetX(),
                     bolt=false,
                    wall=WallTee(), $fn=40, alpha=1) {

  color("Purple", alpha)
  render(convexity=4)
  difference() {
    translate([forendOffsetX,0,0])
    Forend(barrelSpec=barrelPipe, length=length);

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

      // Cutout for the barrel near breach
      hull() {

        Barrel(barrel=barrelPipe, barrelLength =
               BarrelPivotX()
             - BreechFrontX());

        Pivot()
        Barrel(barrel=barrelPipe, barrelLength =
               BarrelPivotX()
             - BreechFrontX());
      }

      // Cutout for the barrel near front
      hull() {
        translate([BarrelPivotX()-BreechFrontX(),0,0])
        Barrel(barrel=barrelPipe, barrelLength = length
                            + forendOffsetX
                            - BarrelPivotX()
                            + PipeOuterRadius(barrelPipe));

        Pivot()
        translate([BarrelPivotX()-BreechFrontX(),0,0])
        Barrel(barrel=barrelPipe, barrelLength = length
                            + forendOffsetX
                            - BarrelPivotX()
                            + PipeOuterRadius(barrelPipe));
      }
    }
  }
}

module ForendPivotLatch(barrel=DEFAULT_BARREL,
                        length=LatchLength(), width=LatchWidth(), height=LatchHeight(),
                        cutter=false, clearance=0.01) {
  clear  = Clearance(clearance, cutter);
  clear2 = clear*2;

  translate([ForendPivotLatchX()-clear,
             -(width/2)-clear,
             ForendPivotLatchZ(barrel)-clear])
  mirror([0,0,1])
  cube([length+clear2,
        width+clear2,
        height+clear2]);
}

module ForendPivotLockCollar(barrel=DEFAULT_BARREL,
                             wall=WallTee(),
                             length=0.5, height=0.5+ForendPivotLatchTravel(),
                             $fn=40, alpha=0.5) {
  color("Orange", alpha)
  render()
  difference() {
    translate([ForendX(),0,0])
    hull() {
      rotate([0,90,0])
      cylinder(r=ReceiverOR(), h=height);
      
      // Set screw supports
      for (r = [-1,1])
      rotate([90,90+(r*22),90])
      SetScrewSupport(radius=PipeOuterRadius(barrel),
                      length=length, height=height);
    }
    
    translate([ForendX()+0.25,0,0])
    for (r = [-1,1])
    rotate([90,90+(r*22),90])
    SetScrew(radius=PipeOuterRadius(barrel),
              length=length*2, height=height);
    
    ForendPivotLatch(barrel=barrel, cutter=true);
    
    Barrel(cutter=true);

    // Cut an incline for the latch to ride on
    translate([ForendX()+height,
                -ReceiverOR(),ForendPivotLatchZ(barrel)])
    rotate([0,20,0])
    mirror([0,0,1])
    cube([1, ReceiverOD(), 1]);
  }
}

module ForendPivotLock(barrelPipe=DEFAULT_BARREL,
                       length=1,
                       wall=WallTee(),
                       $fn=40, alpha=1) {

  color("Purple", alpha)
  render(convexity=4)
  difference() {
    translate([ForendX(),0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    difference() {
      ForendSlotted2d(barrelSpec=barrelPipe,
                      slotAngles=[180]);
      
      for (r=[0,180])
      rotate(r)
      ForendSlotCutter2d(width=ReceiverOD(), semiAngle=108);
    }
  }
}

translate([ForendPivotLatchTravel()*Animate(ANIMATION_STEP_UNLOCK),0,0])
translate([-ForendPivotLatchTravel()*Animate(ANIMATION_STEP_LOCK),0,0])
ForendPivotLatch();

translate([BarrelPivotX(),0,BarrelPivotZ()])
rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
translate([-BarrelPivotX(),0,-BarrelPivotZ()]) {

  ForendPivotLockCollar(barrel=DEFAULT_BARREL);
  
  color("Black", 0.25)
  Barrel(barrel=DEFAULT_BARREL, clearance=undef, hollow=true);
  PivotRod(nutEnable=false);

  BarrelShaftCollar();
}

ForendPivotLock(alpha=0.5);

ForendPivoted(bolt=false, alpha=1);

translate([0,0,0]) {

  color("Black", 0.25)
  Frame();
  color("Black", 0.25)
  FrameCouplingNuts();
  Reference(barrelPipe=DEFAULT_BARREL);
}


// Plated Forend Pivoted Lock
*!scale(25.4)
rotate([0,90,0])
translate([-ForendX(),0,0])
ForendPivotLock(alpha=0.5);


// Plated Forend Pivoted
*!scale(25.4)
rotate([0,90,0])
translate([-ForendOffsetX()-PivotedForendLength(),0,0])
ForendPivoted(bolt=true, alpha=1);
