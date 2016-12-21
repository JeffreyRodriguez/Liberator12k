//$t=0.755;
//$t=0;
include <../../../Meta/Animation.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Meta/Units.scad>;
use <../../../Vitamins/Bearing.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;
use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Lower.scad>;
use <../../../Lower/Trigger.scad>;
use <../../../Reference.scad>;
use <../Frame.scad>;
use <../Cross Upper.scad>;


function Spec_PivotRod() = Spec_RodFiveSixteenthInch();
function PivotBearing() = Spec_Bearing608();
function PivotWall()    = 0.25;

function PivotAngle() = 20;
function LowerPivotX() = BreechFrontX()+6;
function LowerPivotZ() = -PipeOuterRadius(BarrelPipe())
                         -RodRadius(Spec_PivotRod())-0.0625;

function ForendOffsetX() = LowerPivotX()-1.125;
function BarrelShaftCollarX() = LowerPivotX()
                              -BearingOuterRadius(PivotBearing())-0.125;

module PivotBearings(cutter=false) {
  clearance = cutter ? 0.005 : 0;

  for (m = [0,1])
  mirror([0,m,0])
  translate([LowerPivotX(),PipeOuterRadius(BarrelPipe())-0.07-clearance,LowerPivotZ()])
  rotate([-90,0,0]) {
  Bearing(spec=PivotBearing(),
          solid=cutter,
          clearance = cutter ? BearingClearanceSnug() : undef,
          extraHeight=clearance*2);
  }

  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([90,0,0])
  Rod(rod=Spec_PivotRod(),
   length=PipeOuterDiameter(BarrelPipe())+3.375,
clearance=RodClearanceLoose(),
   center=true);
}

module BarrelPivotLug(cutter=false,
                      collar=true,
                      lug=true,
                      length=LowerPivotX()-BarrelShaftCollarX()+BearingRaceRadius(PivotBearing()),
                      alpha=1) {
  clearance = cutter ? 0.005 : 0;

  color("Green", alpha)
  render()
  difference() {
    union() {
      if (collar)
      translate([BarrelShaftCollarX()-clearance,0,0])
      rotate([0,90,0])
      cylinder(r=PipeOuterRadius(BarrelPipe())+0.375+clearance,
               h=length+(clearance*2),
             $fn=Resolution(20,60));

      if (lug)
      translate([BarrelShaftCollarX()-clearance,
                 -PipeOuterRadius(BarrelPipe())+0.075-clearance,
                 LowerPivotZ()-BearingOuterRadius(PivotBearing())])
      cube([length+(clearance*2),
            PipeOuterDiameter(BarrelPipe())-0.15+(clearance*2),
            BearingOuterDiameter(PivotBearing())+PipeOuterRadius(BarrelPipe())+clearance]);
    }

    // Cut an angle from the pivot point to the front of the lug wall
    for (m = [0,1]) mirror([0,m,0])
    translate([LowerPivotX(),
               PipeOuterRadius(BarrelPipe())-0.07-clearance,
               LowerPivotZ()])
    rotate([0,-PivotAngle()+35,0])
    cube([BearingOuterRadius(PivotBearing()),
          BearingHeight(PivotBearing())+(clearance*2)+1,
          2]);

    if (!cutter) {
      PivotBearings(cutter=true);
      Barrel();
    }
  }
}

module BarrelShaftCollar(cutter=false, extend=0) {
  height = cutter ? 0.5*sqrt(2) : 0.51;

  color("SteelBlue")
  translate([BarrelShaftCollarX(),0,0])
  rotate([-30,0,0])
  mirror([1,0,0])
  rotate([0,90,0])
  DoubleShaftCollar(height=height, extend=extend);
}

module Pivot(factor=1) {
  translate([LowerPivotX(),0,LowerPivotZ()])
  rotate([0,PivotAngle()*factor,0])
  translate([-LowerPivotX(),0,-LowerPivotZ()])
  children();
}

module ForendPivoted(barrelPipe=BarrelPipe(), length=2,
                     forendOffsetX=ForendOffsetX(),
                    wall=WallTee(), $fn=40, alpha=1) {
  color("Purple", alpha)
  render(convexity=4)
  difference() {
    translate([forendOffsetX,0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    Quadrail2d();

    union() {
      Frame();

      PivotBearings(cutter=true);

      union() {
        BarrelShaftCollar(extend=2);

        // Printing-taper
        hull()
        for (X = [0,-BarrelShaftCollarX()+ForendOffsetX()-ManifoldGap()])
        translate([X,0,0])
        BarrelShaftCollar(cutter=true);

        hull()
        for (X = [0,-BarrelShaftCollarX()+ForendOffsetX()-ManifoldGap()])
        translate([X,0,0])
        BarrelPivotLug(cutter=true, collar=false, lug=true);

        hull()
        for (f = [0,0.25,0.5,0.75,1])
        Pivot(factor=f) {
          BarrelShaftCollar(cutter=true);
          BarrelPivotLug(cutter=true, collar=true, lug=false);
        }

        hull()
        for (f = [0,0.25,0.5,0.75,1])
        Pivot(factor=f) {
          BarrelPivotLug(cutter=true, collar=false, lug=true);
        }

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
               + PipeOuterRadius(BarrelPipe()));

          Pivot()
          Barrel(barrelLength =
                 LowerPivotX()
               - BreechFrontX()
               + PipeOuterRadius(BarrelPipe()));
        }

        // Cutout for the barrel near front
        hull() {

          translate([LowerPivotX()-BreechFrontX(),0,0])
          Barrel(barrelLength = length
                              + forendOffsetX
                              - LowerPivotX()
                              + PipeOuterRadius(BarrelPipe()));

          Pivot()
          translate([LowerPivotX()-BreechFrontX(),0,0])
          Barrel(barrelLength = length
                              + forendOffsetX
                              - LowerPivotX()
                              + PipeOuterRadius(BarrelPipe()));
        }
      }
    }
  }
}


translate([LowerPivotX(),0,LowerPivotZ()])
rotate([0,-PivotAngle()*Animate(ANIMATION_STEP_LOAD),0])
rotate([0,PivotAngle()*Animate(ANIMATION_STEP_UNLOAD),0])
translate([-LowerPivotX(),0,-LowerPivotZ()]) {

  BarrelPivotLug();
  Barrel();

  BarrelShaftCollar();
  PivotBearings();
}

ForendPivoted(alpha=0.25);



*!scale(25.4)
rotate([0,-90,0])
translate([-BarrelShaftCollarX(), 0,0])
BarrelPivotLug();


// Plated Forend
*!scale(25.4)
rotate([0,90,0])
translate([-ForendOffsetX(),0,0])
ForendPivoted();
