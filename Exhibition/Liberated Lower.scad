use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;

use <../Vitamins/Nuts And Bolts.scad>;

use <../Shapes/Components/AR15/Mating Pins.scad>;
use <../Shapes/Components/AR15/Trigger Pocket.scad>;
use <../Shapes/Components/AR15/Trigger.scad>;
use <../Shapes/Components/AR15/Fire Control.scad>;

use <../Shapes/Components/Grip Handle.scad>;
use <../Shapes/Components/T Lug.scad>;
use <../Shapes/Components/Trigger Finger Slot.scad>;

use <../Receiver/Magwells/AR15 Magwell.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

function BufferLugHeight() = 0.75;


function AR15_MagwellX() = AR15_RearPinX()+3.35;
function AR15_MagwellZ() = 0;

function AR15_InterfaceX() = AR15_RearPinX() + 0.1250;
function AR15_InterfaceZ() = AR15_PinZ() + 0.975;
function AR15_InterfaceRadius() = 0.75;
function AR15_TowerLength() = 0.5030;

function AR15_TowerMinX() = AR15_InterfaceX()
                          - AR15_InterfaceRadius()
                          - AR15_TowerLength();
function AR15_TowerMinZ() = -BufferLugHeight()-+0.2243;

function AR15_BufferCenterZ() = AR15_InterfaceZ()-0.12;

function BufferHoleRadius() = 1.14/2;

function LowerWidth() = 0.9;

module AR15_BufferTube(cutter=true) {
  translate([AR15_TowerMinX()-ManifoldGap(),
             0,
             AR15_BufferCenterZ()-ManifoldGap()])
  rotate([0,90,0]) {
    cylinder(r=BufferHoleRadius(),
             h=AR15_TowerLength()+1+ManifoldGap(2));

    translate([0,0,-1])
    cylinder(r=1.112/2,
             h=1);

    translate([0,0,-0.125])
    cylinder(r=BufferHoleRadius()+0.07,
             h=0.125);
  }
}

module AR15_ForwardAssist(cutter=true) {
  translate([AR15_TowerMinX()+3.25,0,AR15_BufferCenterZ()])
  rotate([0,-90,22])
  cylinder(r=(0.61/2)+0.05,
            h=3.75);
}

module AR15_LowerBolts(boltSpec=Spec_BoltM4(),
                      length=UnitsMetric(30),
                      cutter=false, teardrop=false, $fn=8) {

  capHeightExtra = cutter ? 1 : 0;
  nutHeightExtra = cutter ? 1 : 0;
  boltsXZ = [[-1,-2],
             [1.25,-2.125],
             [AR15_TowerMinX()-0.375,0.125]];

  color("SteelBlue")
  translate([AR15_RearPinX(),0,AR15_PinZ()])
  for (boltXZ = boltsXZ)
  translate([boltXZ[0],-UnitsMetric(14),boltXZ[1]])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length,
              teardrop=teardrop, teardropAngle=-90,
              clearance=cutter, capOrientation=true,
              capHeightExtra=capHeightExtra,
              nutHeightExtra=nutHeightExtra, nutBackset=0.0);
}

module AR15_BufferLugBolt(boltSpec=Spec_BoltM4(),
                         length=UnitsMetric(30),
                         cutter=false, teardrop=false, $fn=8) {

  capHeightExtra = cutter ? 1 : 0;
  nutHeightExtra = cutter ? 1 : 0;

  color("SteelBlue")
  translate([AR15_TowerMinX()+(0.75/2),-UnitsMetric(14),AR15_TowerMinZ()+0.5])
  rotate([90,0,0])
  rotate(90)
  NutAndBolt(bolt=boltSpec, boltLength=length,
              teardrop=teardrop, teardropAngle=-90,
              clearance=cutter, capOrientation=true,
              capHeightExtra=capHeightExtra,
              nutHeightExtra=nutHeightExtra, nutBackset=0.0);
}



module AR15_BufferTowerTLug(cutter=true) {

  translate([AR15_TowerMinX(),0,AR15_TowerMinZ()])
  T_Lug(height=BufferLugHeight()+0.25, cutter=cutter);
}

module AR15_LowerCutouts() {
  translate([AR15_MagwellX()-2,0,AR15_MagwellZ()]) {
    AR15_MagazineCatch();

    translate([0,0,ManifoldGap(10)])
    AR15_MagwellInsert();
  }


  translate([0.1,0,AR15_PinZ()-1.25])
  TriggerFingerSlot(radius=0.56, length=0.45);

  translate([-2,0,0]) {
    AR15_MatingPins(cutter=true);

    AR15_MatingLugs(cutter=true, extraTop=abs(AR15_PinZ()));

    AR15_BufferTowerTLug(cutter=true);

    AR15_BufferTube(cutter=true);

    AR15_ForwardAssist(cutter=true);

    AR15_BufferLugBolt(cutter=true, teardrop=false);

    AR15_LowerBolts(cutter=true);

    AR15_TriggerPocket();
  }
}

module AR15_BufferTower(cutter=false) {
  color("Orange")
  render()
  difference() {
    union() {

      // Buffer ring
      translate([AR15_TowerMinX()-ManifoldGap(),0,AR15_InterfaceZ()-0.125])
      rotate([0,90,0])
      cylinder(r=0.9,
               h=abs(AR15_TowerMinX()-AR15_RearPinX())-0.25+(cutter ? 0.005 : 0));

      AR15_BufferTowerTLug(cutter=cutter);
    }

    // Buffer threadable hole
    AR15_BufferTube(cutter=true);

    // Cut off the top of the buffer ring
    translate([AR15_TowerMinX()-ManifoldGap(),
               -1,
               AR15_InterfaceZ()-0.0625+BufferHoleRadius()+0.07])
    cube([AR15_TowerLength()+ManifoldGap(2), 2, 1]);

    // AR Interface Curve
    translate([AR15_InterfaceX(),0,AR15_InterfaceZ()])
    rotate([90,0,0])
    cylinder(r=AR15_InterfaceRadius(), center=true, h=2);

    // Flatten the front-face of the buffer ring
    translate([AR15_TowerMinX()+AR15_TowerLength(),
               -1,
               AR15_InterfaceZ()])
    cube([AR15_TowerLength()+1+ManifoldGap(), 2, 1]);

    AR15_ForwardAssist(cutter=true);

    if (!cutter) {
      AR15_BufferLugBolt(cutter=true, teardrop=true);

      // Buffer stop pin hole - just a 1/8" rod for now.
      translate([AR15_TowerMinX()+AR15_TowerLength()+RodRadius(Spec_RodOneEighthInch()),0,AR15_BufferCenterZ()])
      mirror([0,0,1])
      Rod(rod=Spec_RodOneEighthInch(),
        length=BufferHoleRadius()+0.75,
     clearance=RodClearanceSnug());
    }
  }

}

module AR15_BufferTowerTapJigRail() {
  difference() {
    translate([AR15_TowerMinX()+1,-0.5,AR15_TowerMinZ()-0.25])
    mirror([1,0,0])
    cube([3.75,1,1.1]);

    // Cut out that unnecessary infill
    translate([AR15_TowerMinX()-0.25,-0.6,AR15_TowerMinZ()])
    mirror([1,0,0])
    cube([2,1.2,0.6]);

    AR15_BufferTower(cutter=true);

    AR15_BufferLugBolt(cutter=true, teardrop=false);
  }

}

module AR15_BufferTowerTapJigSlide() {
    // Tap OD 1.025
    color("Magenta")
    render()
    translate([AR15_TowerMinX()+0.5-2.6,0,AR15_BufferCenterZ()])
    rotate([0,-90,0])
    linear_extrude(height=1)
    difference() {
      hull() {
        circle(r=(1.025/2)+0.25, $fn=40);

        offset(r=0.25)
        translate([AR15_TowerMinZ(), -0.5])
        mirror([1,0])
        square([1.1,1]);
      }

      // Tap hole
      circle(r=(1.025/2)+0.002, $fn=40);

      translate([AR15_TowerMinZ()+0.01, -0.51])
      mirror([1,0])
      square([1.12,1.02]);
    }
}

module AR15_LiberatedLowerSides(showLeft=true, showRight=true, alpha=1) {

  color("Tan", alpha)
  render()
  intersection() {
    difference() {
      union() {

        rotate([90,0,0])
        linear_extrude(height=LowerWidth(), center=true)
        translate([AR15_TowerMinX(),0,0])
        mirror([0,1])
        square([abs(AR15_TowerMinX())+1, 1]);

      // Trigger Guard/Sideplates
      translate([2,0,0])
        rotate([90,0,0])
        linear_extrude(height=LowerWidth(), center=true)
        difference() {
          translate([-1.6,0])
          mirror([0,1])
          square([3.215,2.8]);

          translate([1.75, AR15_PinZ()-3.5])
          rotate(45)
          square(1);
        }

        // Tower and extension tube support
        hull() {
          for (m = [0,1])
          mirror([0,m,0])
          translate([AR15_TowerMinX()-0.125,
                     (LowerWidth()/2)-0.125,AR15_TowerMinZ()-0.125])
          sphere(r=0.125);

          translate([AR15_TowerMinX()-0.75, -(LowerWidth()/2), 0])
          cube([0.75, LowerWidth(), abs(AR15_PinZ())]);

          translate([AR15_TowerMinX()+2,0,AR15_TowerMinZ()-0.5])
          cylinder(r=LowerWidth()/2, h=0.1, $fn=20);
        }

        translate([2,0,AR15_PinZ()])
        translate([-0.375,0,-0.5])
        GripHandle(gripWidth=LowerWidth(), showPalmSwell=false, showFingerSwell=false);
      }

      AR15_BufferTower(cutter=true);

      translate([2,0,0])
      AR15_LowerCutouts();
    }

    translate([-2,(showRight?-1:0),-4])
    cube([6,(showLeft?2:1),5]);
  }
}



*!scale(25.4) rotate([-90,0,0]) translate([0,-0.5,0])
AR15_LiberatedLowerSides(showLeft=true, showRight=false);

*!scale(25.4) rotate([90,0,0]) translate([0,0.5,0])
AR15_LiberatedLowerSides(showLeft=false, showRight=true);

module AR15_LiberatedLower() {
%translate([AR15_MagwellX(),0,AR15_MagwellZ()])
AR15_MagazineCatch();
    //translate([2,0,0])
  AR15_BufferLugBolt();
    //translate([2,0,0])
  AR15_LowerBolts();

  //!scale(25.4) rotate([0,-90,0]) translate([-AR15_TowerMinX(),0,0])
  AR15_BufferTower();

  AR15_LiberatedLowerSides();

  //!scale(25.4) rotate([180,0,0])
  color("Orange")
  render()
  difference() {
    translate([AR15_MagwellX(),0,AR15_MagwellZ()])
    AR15_Magwell(wallBack=0.38, wallFront=0.7135);

    translate([AR15_MagwellX()+0.27,-(LowerWidth()/2)-0.01, -3])
    mirror([1,0,0])
    cube([1,LowerWidth()+0.02, 3.3]);

    translate([2,0,0])
    AR15_LowerCutouts();
  }
}

AR15_LiberatedLower();


//!scale(25.4) rotate([90,0,0])
*color("LightGreen")
render()
intersection() {
  AR15_BufferTowerTapJigRail();


  translate([AR15_TowerMinX()-3,-1,AR15_TowerMinZ()-0.3])
  cube([5,1,2]);
}

//!scale(25.4) rotate([0,90,0]) translate([-AR15_TowerMinX()+2.1,0,0])
*AR15_BufferTowerTapJigSlide();
