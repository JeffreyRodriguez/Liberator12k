//$t=0.755;
//$t=0;
include <../../../Meta/Animation.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Components/Printable Shaft Collar.scad>;
use <../../../Reference.scad>;
use <../Frame.scad>;

DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
SET_SCREW_SPEC = Spec_BoltM4();


function Spec_PivotRod() = Spec_RodFiveSixteenthInch();
function PivotWall()    = 0.25;
function ShaftCollarWall() = 0.375;

function PivotAngle() = 30;
function PivotOffset() = 5;
function LowerPivotX() = BreechFrontX()+PivotOffset();
function LowerPivotZ() = -PipeOuterRadius(DEFAULT_BARREL)
                         -RodRadius(Spec_PivotRod(), RodClearanceLoose());

function ForendOffsetX() = LowerPivotX()-1.125;
function BarrelShaftCollarLength() = 1.375;
function BarrelShaftCollarX() = LowerPivotX()
                              + RodDiameter(Spec_PivotRod(), RodClearanceLoose())
                              - ManifoldGap();

function PivotedForendLength() = 2.25;
module PivotRod(cutter=false, teardropAngle=180) {
  clearance = cutter ? 0.005 : 0;

  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([90,0,0])
  Rod(rod=Spec_PivotRod(),
   length=PipeOuterDiameter(DEFAULT_BARREL)+3.375,
clearance=RodClearanceLoose(),
   center=true, teardrop=true, teardropRotation=teardropAngle);
}

module BarrelShaftCollar(cutter=false, extend=0, height=BarrelShaftCollarLength()) {

  render()
  union() {
    scale(cutter ? 1.01 : 1)
    difference() {
      translate([BarrelShaftCollarX(),0,0])
      mirror([1,0,0])
      rotate([0,90,0])
      union() {
        rotate(90)
        PrintableShaftCollar(pipeSpec=DEFAULT_BARREL,
                               height=height,
                              screwOffsetZ=height-ShaftCollarWall(),
                                 wall=ShaftCollarWall(),
                               length=UnitsMetric(10), teardropAngle=-90);
        
      
        // Bolt Cutout
        if (cutter)
        translate([PipeOuterRadius(DEFAULT_BARREL),
                  -BoltCapRadius(SET_SCREW_SPEC, true),
                  height])
        mirror([0,0,1])
        cube([UnitsMetric(25),
               BoltCapDiameter(SET_SCREW_SPEC, true),
               ShaftCollarWall()+BoltCapDiameter(SET_SCREW_SPEC, true)]);
      }
      
      if (cutter==false)
      PivotRod(cutter=true);
    }
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
                    wall=WallTee(), $fn=40) {
  color("Purple", 0.25)
  render(convexity=4)
  difference() {
    translate([forendOffsetX,0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    Quadrail2d();

    union() {
      Frame();

      PivotRod(cutter=true, teardropAngle=180);

      union() {
        BarrelShaftCollar(extend=2);

        // Printing-taper
        hull()
        for (X = [0,-BarrelShaftCollarX()+ForendOffsetX()-ManifoldGap()])
        translate([X,0,0])
        BarrelShaftCollar(cutter=true);

        hull()
        for (f = [0,0.25,0.5,0.75,1])
        Pivot(factor=f)
        BarrelShaftCollar(cutter=true);

        // Square off the breech-end
        hull()
        for (z = [0,1.5])
        translate([0,0,z])
        Barrel(barrelLength=2.5);

        // Cutout for the barrel near breach
        hull() {

          Barrel(barrelLength =
                 LowerPivotX()
               - BreechFrontX()
               + PipeOuterRadius(DEFAULT_BARREL));

          Pivot()
          Barrel(barrelLength =
                 LowerPivotX()
               - BreechFrontX()
               + PipeOuterRadius(DEFAULT_BARREL));
        }

        // Cutout for the barrel near front
        hull() {
          translate([LowerPivotX()-BreechFrontX(),0,0])
          Barrel(barrelLength = length
                              + forendOffsetX
                              - LowerPivotX()
                              + PipeOuterRadius(DEFAULT_BARREL));

          Pivot()
          translate([LowerPivotX()-BreechFrontX(),0,0])
          Barrel(barrelLength = length
                              + forendOffsetX
                              - LowerPivotX()
                              + PipeOuterRadius(DEFAULT_BARREL));
        }
      }
    }
  }
}


translate([LowerPivotX(),0,LowerPivotZ()])
rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
translate([-LowerPivotX(),0,-LowerPivotZ()]) {

  Barrel();
  PivotRod();

  BarrelShaftCollar();
}

translate([0,0,0]) {
  Frame();
  Reference(barrelPipe=DEFAULT_BARREL);
}

ForendPivoted();


*!scale(25.4)
translate([0,0,BarrelShaftCollarLength()])
rotate([0,-90,0])
translate([-BarrelShaftCollarX(),0,0])
BarrelShaftCollar(cutter=false);

// Plated Forend
*!scale(25.4)
rotate([0,90,0])
translate([-ForendOffsetX()-PivotedForendLength(),0,0])
ForendPivoted();
