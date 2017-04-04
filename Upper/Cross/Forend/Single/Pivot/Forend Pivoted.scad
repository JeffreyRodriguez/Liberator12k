//$t=0.70;
//$t=0.75;
//$t=0.665;
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
use <../../../../../Components/Teardrop.scad>;
use <../../../Reference.scad>;
use <../../../Frame.scad>;
use <../../Forend Slotted.scad>;
use <../../Forend.scad>;

DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_LOCK_ROD  = Spec_RodOneEighthInch();
DEFAULT_LATCH_BOLT = Spec_BoltM4();

function LatchWidth() = 0.75;
function LatchHeight() = 0.25;
function LatchSpringLength() = 0.875;
function LatchSpringOD() = 0.26;

function PivotLatchTravel() = 0.375;
function ForendPivotedLatchWall() = 0.25;

function Spec_PivotRod() = Spec_RodOneEighthInch();
function PivotWall()    = 0.25;
function ShaftCollarWall() = 0.375;
function PivotLatchCollarLength() = 0.5+PivotLatchTravel();

//function BarrelShaftCollarDiameter() = 1.5;
function BarrelShaftCollarDiameter() = 1.875;
function BarrelShaftCollarLength() = 0.5;

function PivotAngle() = 30;
function PivotOffset() = 5.625;
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


function PivotLatchX() = ForendX()
                             + 0.5
                             + 0.05;
function LatchBoltX() = PivotLatchX()
                      + PivotLatchTravel()
                      + 0.25;
function LatchSpringX() = LatchBoltX()+PivotLatchTravel()+0.25;
function LatchLength() = LatchSpringX()-PivotLatchX()
                       + LatchSpringLength()
                       + ForendPivotedLatchWall();
                       
function ForendPivotedLatchLength() = (PivotLatchX()-ForendX())
                                    + LatchLength()
                                    + PivotLatchTravel();

function PivotLatchZ(barrel=DEFAULT_BARREL) = -PipeOuterRadius(pipe=barrel)
                                                  - 0.25;



function LatchBoltZ(barrel=DEFAULT_BARREL) = PivotLatchZ(barrel);

function LatchSlotWidth() = 0.5;

echo("ForendPivotedLatchLength: ", ForendPivotedLatchLength());

module LatchSlot(barrel=DEFAULT_BARREL,
                 slotWidth=LatchSlotWidth(),
                 slotExtraLength=0,
                 clearance=0.005) {
  hull()
  for (X = [-slotExtraLength,PivotLatchTravel()])
  translate([LatchBoltX()+X,
             0,
             LatchBoltZ()+ManifoldGap()])
  mirror([0,0,1])
  linear_extrude(h=ReceiverCenter()+ManifoldGap(2))
  rotate(180)
  Teardrop(r=(slotWidth/2)+clearance, truncated=true);
  
  translate([LatchBoltX()+PivotLatchTravel(),
              -slotWidth/2,
              -ReceiverCenter()+0.125])
  mirror([0,0,1])
  cube([extend, slotWidth, 1]);
};

module LatchBolt(boltSpec=DEFAULT_LATCH_BOLT,
                 cutter=false) {
  
    translate([LatchBoltX(), 0, LatchBoltZ()+ManifoldGap()])
    rotate([180,0,0])
    NutAndBolt(boltSpec = boltSpec,
               length = UnitsMetric(30),
               nutBackset=UnitsMetric(1.5), nutHeightExtra=UnitsMetric(1.5),
               clearance = cutter);
}

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

module ForendPivoted(barrelPipe=DEFAULT_BARREL,
                     length=PivotedForendLength(),
                     forendOffsetX=ForendOffsetX(),
                     bolt=false,
                     wall=WallTee(),
                     $fn=40, alpha=1) {

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

module PivotLatch(barrel=DEFAULT_BARREL,
                        length=LatchLength(), width=LatchWidth(), height=LatchHeight(),
                        cutter=false, clearance=0.015, alpha=1) {
  clear  = Clearance(clearance, cutter);
  clear2 = clear*2;
       
  color("White", alpha)
  render()
  difference() {
    // Latch body
    translate([PivotLatchX()-clear,
               -(width/2)-clear,
               PivotLatchZ(barrel)+clear])
    mirror([0,0,1])
    cube([length+clear2+(cutter ? PivotLatchTravel()+ForendPivotedLatchWall() : 0),
          width+clear2,
          height+clear2]);
    
    if (cutter) {
      
      // Latch Spring Depressor (leave uncut)
      translate([LatchSpringX()+LatchSpringLength()-ManifoldGap(1),
                 -(LatchSpringOD()/2)+clear-ManifoldGap(1),
                 PivotLatchZ(barrel)+clear+ManifoldGap(1)])
      mirror([0,0,1])
      cube([PivotLatchTravel()+(ForendPivotedLatchWall()*2)+ManifoldGap(2),
            LatchSpringOD()-clear2+ManifoldGap(2),
            height+clear2+ManifoldGap(2)]);
    }
    
    if (!cutter) {
      LatchBolt(cutter=true);
      
      // Latch Spring Cutout
      translate([LatchSpringX()-ManifoldGap(1),
                 -(LatchSpringOD()/2)-ManifoldGap(1),
                 PivotLatchZ(barrel)+ManifoldGap(1)])
      mirror([0,0,1])
      cube([LatchSpringLength()+ForendPivotedLatchWall()+ManifoldGap(2),
            LatchSpringOD()+ManifoldGap(2),
            height+ManifoldGap(2)]);
      
      // Latch Bolt Cutout
      translate([LatchBoltX(),
                 0,
                 PivotLatchZ()+ManifoldGap()])
      mirror([0,0,1])
      cylinder(r=BoltRadius(bolt=DEFAULT_LATCH_BOLT, clearance=true),
               h=LatchHeight()+ManifoldGap(2), $fn=8);
      
      // Incline the tip
      translate([PivotLatchX()+(sin(15)*LatchHeight()),
                  -(LatchWidth()/2)-ManifoldGap(),
                  PivotLatchZ(barrel)+ManifoldGap(1)])
      rotate([0,180+25,0])
      cube([1, LatchWidth()+ManifoldGap(2), LatchHeight()*2]);
      
      // Bevel the fork
      translate([LatchSpringX()+LatchSpringLength(),0,PivotLatchZ()])
      scale([1,0.75,1])
      rotate(-45)
      mirror([0,0,1])
      cube([LatchWidth(),LatchWidth(),LatchHeight()+ManifoldGap(2)]);
    }
  }
}

module PivotedLatchHandle(diameter=LatchSlotWidth()-0.015,
                          height=UnitsMetric(25)-LatchHeight(), $fn=30) {
  render()
  translate([LatchBoltX(),0,PivotLatchZ()-LatchHeight()-ManifoldGap()])
  mirror([0,0,1])
  difference() {
    cylinder(r=diameter/2, h=height);

    translate([0,0,-LatchHeight()-ManifoldGap()])
    Bolt(boltSpec=DEFAULT_LATCH_BOLT,height=height+ManifoldGap(2),
         clearance=true);
  }
}

module PivotLatchCollar(barrel=DEFAULT_BARREL,
                             wall=WallTee(),
                             length=UnitsMetric(15),
                             height=PivotLatchCollarLength(),
                             clearance=0.005, cutter=false,
                             $fn=40, alpha=1) {

  radius = ReceiverOR() - clearance;
  
  color("Orange", alpha)
  render()
  difference() {
    translate([ForendX(),0,0])
    hull() {
      
      // For later... extractor support.
      *translate([0,-radius,0])
      cube([height,radius*2,ReceiverCenter()]);
      
      rotate([0,90,0])
      cylinder(r=radius, h=height);
      
      // Set screw supports
      for (r = [-1,1])
      rotate([90,90+(r*22),90])
      SetScrewSupport(radius=PipeOuterRadius(barrel),
                      length=length+UnitsMetric(1), height=height);
    }
    
    if (!cutter) {
      translate([ForendX()+0.25,0,0])
      for (r = [-1,1])
      rotate([90,90+(r*20),90])
      SetScrew(radius=PipeOuterRadius(barrel),
                length=length, height=height, cutter=true);
      
      PivotLatch(barrel=barrel, cutter=true);
      
      Barrel(clearance=PipeClearanceSnug(), cutter=true);
    }

    // Cut an incline for the latch to ride on
    translate([ForendX()+height,
                -ReceiverOR(),
                PivotLatchZ(barrel) - (LatchHeight()*0.5)])
    rotate([0,25,0])
    mirror([0,0,1])
    cube([1, ReceiverOD(), 2]);
    
    // Cut the walls with a slight incline for loading
    for (m=[0,1])
    mirror([0,m,0])
    //translate([0,ReceiverOR(),0])
    rotate([-10,0,0])
    translate([ForendX()-ManifoldGap(),
                radius,
                PivotLatchZ(barrel) -ReceiverLength()])
    cube([height+ManifoldGap(2), radius, ReceiverLength()*2]);
  }
}

module ForendPivotedLatch(barrelPipe=DEFAULT_BARREL,
                       length=ForendPivotedLatchLength(),
                       wall=WallTee(),
                       $fn=40, alpha=1) {

  color("Purple", alpha)
  render(convexity=4)
  difference() {
    translate([ForendX(),0,0])
    rotate([0,90,0])
    linear_extrude(height=length)
    ForendSlotted2d(barrelSpec=barrelPipe,
                    slotAngles=[180]);
    
    difference() {
      union() {
        translate([ForendX(),0,0])
        rotate([0,90,0])
        linear_extrude(height=PivotLatchCollarLength())
        rotate(180)
        ForendSlotCutter2d(width=ReceiverOD());
        
        hull()
        for (f = [0,1])
        Pivot(f)
        PivotLatchCollar(barrel=DEFAULT_BARREL);
      }
      
      translate([ForendX()+PivotLatchCollarLength(),-ReceiverOR(),BarrelPivotZ()])
      mirror([0,0,1])
      cube ([length, ReceiverOD(), ReceiverLength()]);
    }
    
    scale([1.00,1.01,1.01])
    hull()
    PivotLatchCollar(cutter=true);
    
    PivotLatch(barrel=barrelPipe, cutter=true);
    
    LatchSlot(barrel=barrelPipe, extend=length);
  }
}

translate([PivotLatchTravel()*Animate(ANIMATION_STEP_UNLOCK),0,0])
translate([-PivotLatchTravel()*SubAnimate(ANIMATION_STEP_UNLOAD, start=0, end=0.3),0,0])
translate([PivotLatchTravel()*SubAnimate(ANIMATION_STEP_LOAD, start=0.7),0,0])
translate([-PivotLatchTravel()*Animate(ANIMATION_STEP_LOCK),0,0]) {
  PivotLatch();
  PivotedLatchHandle();
  LatchBolt();
}

translate([ForendX()-0.375,0,0])
Frame(length=6.5);

FrameCouplingNuts();


Pivot(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)) {

  PivotLatchCollar(barrel=DEFAULT_BARREL);
  
  Barrel(barrel=DEFAULT_BARREL, clearance=undef, hollow=true);
  
  PivotRod(nutEnable=false);

  BarrelShaftCollar();
}

ForendPivotedLatch(alpha=.5);

ForendPivoted(bolt=false, alpha=1);

Reference(barrelPipe=DEFAULT_BARREL);


// Plated Forend Pivoted Lock
*!scale(25.4)
rotate([0,90,0])
translate([-ForendX(),0,0])
ForendPivotedLatch(alpha=0.5);


// Plated Pivot Latch
*!scale(25.4)
translate([-PivotLatchX(),0,-PivotLatchZ()+LatchHeight()])
PivotLatch();


// Plated Forend Pivoted
*!scale(25.4)
rotate([0,90,0])
translate([-ForendOffsetX()-PivotedForendLength(),0,0])
ForendPivoted(bolt=true, alpha=1);

// Plated Lock Collar
*!scale(25.4)
rotate([0,-90,0])
translate([-ForendX(),0,0])
PivotLatchCollar(barrel=DEFAULT_BARREL);

// Plated Latch Handle
*!scale(25.4)
translate([-LatchBoltX(),0,0])
PivotedLatchHandle();
