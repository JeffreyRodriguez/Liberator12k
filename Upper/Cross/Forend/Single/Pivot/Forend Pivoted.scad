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
use <../../../../../Lower/Receiver Lugs.scad>;
use <../../../../../Lower/Lower.scad>;
use <../../../Reference.scad>;
use <../../../Frame.scad>;
use <../../Forend Slotted.scad>;
use <../../Forend.scad>;

DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_LOCK_ROD  = Spec_RodOneQuarterInch();
DEFAULT_LATCH_BOLT = Spec_BoltM4();
DEFAULT_EXTRACTOR_GUIDE_ROD  = Spec_RodOneEighthInch();

function LatchWidth() = 0.75;
function LatchHeight() = 0.25;
function LatchSpringLength() = 0.875;
function LatchSpringOD() = 0.25;

function PivotLatchTravel() = 0.375;
function ForendPivotedLatchWall() = 0.25;

function Spec_PivotRod() = Spec_RodOneQuarterInch();
function PivotWall()    = 0.25;
function ShaftCollarWall() = 0.375;
function PivotLatchCollarLength() = 0.75;
function PivotLatchCollarLength() = 1;

function BarrelShaftCollarDiameter() = 1.5;
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
                         
function ForendPivotedX() = ForendPivotedLatchLength();


function PivotLatchX() = ForendX()
                       + PivotLatchCollarLength()
                       - PivotLatchTravel();
                       
                       
function LatchSlotWidth() = 0.5;

function LatchBoltX() = PivotLatchX()
                      + PivotLatchTravel()
                      + (LatchSlotWidth()/2);

function LatchSpringX() = LatchBoltX()+PivotLatchTravel()+0.25;

function LatchLength() = LatchSpringX()-PivotLatchX()
                       + LatchSpringLength()
                       + ForendPivotedLatchWall();
                       
function ForendPivotedLatchLength() = (PivotLatchX()-ForendX())
                                    + LatchLength()
                                    + PivotLatchTravel();

function PivotedForendFrameLength() = 6.25;
function PivotedForendLength() = PivotedForendFrameLength()
                               - ForendPivotedLatchLength()
                               - 0.4;

function PivotLatchZ(barrel=DEFAULT_BARREL) = -PipeOuterRadius(pipe=barrel)
                                                  - 0.25;



function LatchBoltZ(barrel=DEFAULT_BARREL) = PivotLatchZ(barrel);

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
  
  // Full-length slot
  translate([ForendX()-ManifoldGap(),
              -(slotWidth/2)-clearance,
              -ReceiverCenter()+0.125])
  mirror([0,0,1])
  cube([ForendPivotedLatchLength()+ManifoldGap(2),
        slotWidth+(clearance*2),
        1]);
};

module LatchBolt(boltSpec=DEFAULT_LATCH_BOLT,
                 length=UnitsMetric(30),
                 cutter=false) {
  
    translate([LatchBoltX(), 0, LatchBoltZ()+ManifoldGap()])
    rotate([180,0,0])
    NutAndBolt(bolt=boltSpec,
               length = UnitsMetric(30),
               nutBackset=UnitsMetric(1.5), nutHeightExtra=UnitsMetric(1.5),
               clearance = cutter);
}

module PivotRod(cutter=false, nutEnable=false, teardropAngle=180, alpha=1) {

  color("SteelBlue", alpha)
  translate([BarrelPivotX(),0,BarrelPivotZ()])
  rotate([90,0,0])
  Rod(rod=Spec_PivotRod(),
      length=(cutter ? 3 : 1.65),
      center=true,
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

module ForendPivotHull(steps=4) {
  pivotStep = 1/steps;
  for (f = [0,0.25,0.5,0.75,1]) {
      hull() {
        if (f > 0)
        Pivot(factor=f-pivotStep)
        children();
        
        Pivot(factor=f)
        children();
      }
  }
}

module ForendPivoted(barrelPipe=DEFAULT_BARREL,
                     length=PivotedForendLength(),
                     bolt=false,
                     wall=WallTee(),
                     $fn=40, alpha=1) {

  color("Orange", alpha)
  !render()
  difference() {
    translate([ForendPivotedX(),0,0])
    Forend(barrelSpec=barrelPipe, length=length);

    render()
    union() {

      PivotRod(cutter=true, nutEnable=bolt, teardropAngle=180);

      BarrelShaftCollar(extend=2);

      // Insertion hole
      hull()
      for (X = [RodRadius(rod=Spec_PivotRod()),-BarrelShaftCollarX()])
      translate([X,0,0])
      BarrelShaftCollar(cutter=true);
      
      // Make a hull between each pivot position and the previous position
      ForendPivotHull()
      BarrelShaftCollar(cutter=true);
      
      ForendPivotHull() // These need a shortened barrel segment to look decent.
      translate([-BreechFrontX()+ForendX()+ForendPivotedX()-1,0])
      Barrel(barrel=barrelPipe, barrelLength=length+1.5);
    }
  }
}

module PivotLatch(barrel=DEFAULT_BARREL,
                        length=LatchLength(), width=LatchWidth(), height=LatchHeight(),
                        cutter=false, clearance=0.015, alpha=0.9) {
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

module PivotLatchHandle(diameter=LatchSlotWidth()-0.015,
                        clearance=0.005,
                        boltLength=UnitsMetric(30), $fn=30, alpha=1) {

  height = 0.375;
  zMin = -ReceiverCenter()-height-ManifoldGap();

  color("DimGrey", alpha)
  render()
  difference() {
    union() {
      translate([LatchBoltX(),0,zMin])
      cylinder(r=diameter/2, h=boltLength-LatchHeight());
      
      
      // Ambidextrous Index-finger Unlock Button
      hull()
      for (m = [0,1])
      mirror([0,m,0]) {

        // Finger interface
        translate([LowerMaxX()+0.01,0.625,zMin])
        rotate(-25)
        cube([0.25, 0.375, height]);
                   
        // Anchor to the latch bolt
        translate([ForendX()+PivotLatchCollarLength(), 0, zMin])
        cylinder(r=diameter/2, h=height);
      }
      
      // Slot Key
      difference() {
        translate([ForendX()-ManifoldGap(),
                    -(LatchSlotWidth()/2)+clearance,
                    zMin])
        cube([LatchBoltX()-ForendX()+PivotLatchTravel()+0.5,
              LatchSlotWidth()-(clearance*2),
              height+0.125-clearance]);
        
        translate([ForendX()+PivotLatchCollarLength()+clearance,
                   -(LatchSlotWidth()/2)+clearance,
                   PivotLatchZ()-(LatchHeight()/2)])
        rotate([0,35,0])
        mirror([1,0,0])
        translate([0,0,-height*3])
        cube([height*3, LatchSlotWidth(), height*4]);
      }
      
      // Long Slot Key (for later)
      *translate([ForendX()-ManifoldGap(),
                  -(LatchSlotWidth()/2)+clearance,
                  zMin])
      cube([ForendPivotedLatchLength()-PivotLatchTravel()-clearance,
            LatchSlotWidth()-(clearance*2),
            height+0.125-clearance]);
      
    }
    
    // Don't waste so much material where we meet the lower.
    translate([LowerMaxX()+0.125,0, -ReceiverCenter()+ManifoldGap(2)])
    mirror([0,0,1])
    cylinder(r=0.5,h=height+ManifoldGap(4));

    LatchBolt(cutter=true);
  }
}


module PivotLatchCollarBolts(barrel=DEFAULT_BARREL,
                             length=UnitsMetric(14),
                             angles=[0],
                             teardropAngle=0, cap=true,
                             clearance=0.005, cutter=false) {
  translate([ForendX()+0.25,0,0])
  for (r = angles)
  rotate([180,0,0]) // Rotate to bottom
  rotate([r,0,0])   // Lean angle
  rotate([0,-90,0]) // Stand up on-end
  SetScrew(radius=PipeOuterRadius(barrel),
            cap=cap, capHeightExtra=(cutter ? ReceiverCenter() : 0),
            length=length, height=PivotLatchCollarLength(),
            teardrop=cutter, teardropAngle=teardropAngle,
            cutter=cutter);
}

module PivotLatchCollar(barrel=DEFAULT_BARREL,
                             wall=WallTee(),
                             length=UnitsMetric(30),
                             height=PivotLatchCollarLength(),
                             clearance=0.005, cutter=false,
                             $fn=40, alpha=1) {

  radius = ReceiverOR() - clearance;
  
  color("Orange", alpha)
  render()
  difference() {
    union() {
      translate([ForendX(),0,0])
      hull() {
        
        // Extractor Support
        translate([0,-radius,0])
        cube([height,radius*2,ReceiverCenter()]);
        
        // Collar body
        rotate([0,90,0])
        cylinder(r=radius, h=height);
        
        // Latch Support
        translate([0,-radius,-ReceiverCenter()+clearance])
        cube([height,radius*2,0.25]);
      }
    }
    
    if (!cutter) {
      PivotLatchCollarBolts(barrel=barrel, teardropAngle=-90, cutter=true);
      
      PivotLatch(barrel=barrel, cutter=true);
      
      Extractor(cutter=true);
      
      ExtractorGuide(cutter=true);
      
      Barrel(barrel=barrel, clearance=PipeClearanceSnug(), cutter=true);
    }

    // Cut an incline for the latch to ride on
    translate([ForendX()+height,
                -ReceiverOR(),
                PivotLatchZ(barrel) - (LatchHeight()*0.5)])
    rotate([0,35,0])
    mirror([0,0,1])
    cube([1, ReceiverOD(), 2]);
    
    // Cut the walls with a slight incline for loading
    translate([0,0,-PipeOuterRadius(pipe=barrel)])
    for (m=[0,1])
    mirror([0,m,0])
    rotate([-20,0,0])
    translate([ForendX()-ManifoldGap(),
                radius,
                PivotLatchZ(barrel)-ReceiverLength()])
    cube([height+ManifoldGap(2), radius, ReceiverLength()*2]);
  }
}

module ForendPivotedLatch(barrelPipe=DEFAULT_BARREL,
                       length=ForendPivotedLatchLength(),
                       wall=WallTee(),
                       $fn=Resolution(20,60), alpha=1) {

  color("Gold", alpha)
  render(convexity=4)
  difference() {
    Forend(barrelSpec=barrelPipe, length=length,
           scallops=true,
           clearFloor=true);
    
    // Narrow slot
    translate([ForendX()-ManifoldGap(),0,0])
    rotate([0,90,0])
    linear_extrude(height=length+ManifoldGap(2))
    rotate(180)
    ForendSlotCutter2d(width=PipeOuterDiameter(pipe=barrelPipe, clearance=PipeClearanceLoose()));
    
    
    // Wide slot near latch collar
    translate([ForendX()-ManifoldGap(),0,0])
    rotate([0,90,0])
    linear_extrude(height=PivotLatchCollarLength()+ManifoldGap())
    rotate(180)
    ForendSlotCutter2d(width=ReceiverOD()+0.005, semiAngle=90);
    
    hull()
    for (f = [0,1])
    Pivot(factor=f)
    scale([1.00,1.01,1.01])
    PivotLatchCollar(cutter=true);
    
    PivotLatchCollarBolts(barrel=barrelPipe,
                           length=ReceiverLength(),
                           teardropAngle=-90,
                           cutter=true);
    
    PivotLatch(barrel=barrelPipe, cutter=true);
    
    LatchSlot(barrel=barrelPipe, extend=length);
  }
}



function ExtractorTravel() = 0.5;


module ExtractorGuideBolts(barrelPipe=DEFAULT_BARREL,
                           boltSpec=Spec_BoltM3(),
                           cutter=false, teardrop=false, teardropAngle=0) {
  for (XYZL = [[BreechFrontX()+0.3125, 0.65, 0.375,  UnitsMetric(30)],
               [ForendX()+1.75,        0.55, 0.3125, UnitsMetric(25)],
               [ForendX()+2.25,        0.55, 0.3125, UnitsMetric(25)]])
  translate([XYZL[0],XYZL[1],PipeOuterRadius(pipe=barrelPipe)+XYZL[2]])
  rotate([90,0,0])
  NutAndBolt(bolt=boltSpec,
             boltLength=XYZL[3], capHeightExtra=(cutter?1:0),
             nutBackset=UnitsMetric(1), nutHeightExtra=(cutter?1:0),
             clearance=cutter, teardrop=teardrop, teardropAngle=teardropAngle);
}

module ExtractorGuide(barrelPipe=DEFAULT_BARREL,
                      guideRod=DEFAULT_EXTRACTOR_GUIDE_ROD,
                      sides=[0,1],
                      cutter=false, clearance=0.02) {
  guideWidth=0.1875;
  guideHeight=0.5;
  guideLength = ForendBreechGap()
              + PivotLatchCollarLength()
              + ExtractorTravel()
              + 2.0;
  
  extractorGuideOffsetY=0.5625+ManifoldGap();
  extractorGuideOffsetZ=0.125;

  clear  = Clearance(clearance, cutter);
  clear2 = clear*2;

  color("DimGrey")
  render()
  difference() {
    for (m = sides) mirror([0,m,0])
    translate([BreechFrontX()+ManifoldGap(),
               extractorGuideOffsetY,
               PipeOuterRadius(pipe=barrelPipe)])
    translate([0,clear,-clear])
    mirror([0,1,0]) {
      
      // Guide
      translate([0,0,extractorGuideOffsetZ])
      cube([guideLength+clear, guideWidth+clear2, guideHeight+clear2]);
      
      // Guide Middle
      hull() {
        translate([guideLength,0,0])
        mirror([1,0,0])
        cube([1,
              extractorGuideOffsetY-ManifoldGap(),
              guideHeight+extractorGuideOffsetZ]);
        
        translate([guideLength,
                   extractorGuideOffsetY-ManifoldGap(),
                   -PipeWall(pipe=barrelPipe)])
        mirror([1,0,0])
        mirror([0,1,0])
        cube([ForendBreechGap()-ManifoldGap(2),
              0.25,
              guideHeight]);
        
      }
    }
    
    
    if (!cutter) {
      ExtractorGuideBolts(cutter=true, teardrop=false);
      Barrel(barrelPipe=barrelPipe);
    }
  }
}

module Extractor(barrelPipe=DEFAULT_BARREL, guideSides=[0,1],
                 cutter=false, clearance=0.005) {
                       
  clear  = Clearance(clearance, cutter);
  clear2 = clear*2;
  
  
  length = ForendBreechGap()
         + ExtractorTravel()
         + PivotLatchCollarLength();
  extractorWidth=0.25;
  extractorHeight = 0.5;
  
  tabLength=0.5;
  tabWidth=0.25;
  tabThickness = 0.03125+0.01;
  
  color("Yellow")
  render()
  difference() {
    
    // Extractor holder body
    hull() {
      translate([BreechFrontX()+ManifoldGap(2),-(1.125/2)+ManifoldGap(),0.3125])
      cube([ForendBreechGap()-ManifoldGap(2),
            1.125-ManifoldGap(2),
            1.0]);
      
    }
    
    if (!cutter) {
      ExtractorGuide(cutter=true);
      
      ExtractorGuideBolts(cutter=true, teardrop=true, teardropAngle=0);
      
      // Extractor spring steel tab slot
      translate([BreechFrontX(),
                 0,
                 PipeInnerRadius(pipe=barrelPipe)])
      rotate([0,-45,0])
      translate([0,-(tabWidth/2)-ManifoldGap(),0])
      cube([tabLength, tabWidth+ManifoldGap(2), tabThickness]);
      
      Barrel(barrel=barrelPipe, clearance=PipeClearanceSnug());
    }
  }
}


module ForendPivotedAssembly() {
  
  // Pivot Latch
  translate([PivotLatchTravel()*Animate(ANIMATION_STEP_UNLOCK),0,0])
  translate([-PivotLatchTravel()*SubAnimate(ANIMATION_STEP_UNLOAD, start=0, end=0.3),0,0])
  translate([PivotLatchTravel()*SubAnimate(ANIMATION_STEP_LOAD, start=0.76),0,0])
  translate([-PivotLatchTravel()*Animate(ANIMATION_STEP_LOCK),0,0]) {
    LatchBolt();
    PivotLatchHandle();
    PivotLatch();
  }

  // The barrel and all the stuff that pivots with it
  Pivot(Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)) {
    
    PivotLatchCollarBolts(barrel=DEFAULT_BARREL);
    
    Barrel(barrel=DEFAULT_BARREL, clearance=undef, hollow=true);

    // Extractor
    translate([-ExtractorTravel()*SubAnimate(ANIMATION_STEP_UNLOAD, start=0),0,0])
    translate([ExtractorTravel()*SubAnimate(ANIMATION_STEP_LOAD, start=0),0,0])
    //translate([ExtractorTravel()*Animate(ANIMATION_STEP_EXTRACT),0,0])
    //translate([-ExtractorTravel()*sin(180*Animate(ANIMATION_STEP_EXTRACT)),0,0])
    //translate([ExtractorTravel()*Animate(ANIMATION_STEP_EXTRACT),0,0])
    {
      Extractor();
      ExtractorGuide();
      ExtractorGuideBolts();
    }

    PivotLatchCollar(barrel=DEFAULT_BARREL, alpha=0.5);
    

    BarrelShaftCollar();
  }

  ForendPivotedLatch(alpha=0.3);

  PivotRod(nutEnable=false);
  ForendPivoted(bolt=false, alpha=0.5);

  Reference(barrelPipe=DEFAULT_BARREL);

}

ForendPivotedAssembly();

// Plated Forend Pivoted
*!scale(25.4)
rotate([0,90,0])
translate([-ForendPivotedX()-PivotedForendLength(),0,0])
ForendPivoted(bolt=true, alpha=1);

// Plated Forend Pivoted Latch
*!scale(25.4)
rotate([0,90,0])
translate([-ForendX(),0,0])
ForendPivotedLatch(alpha=1);

// Plated Lock Collar
*!scale(25.4)
rotate([0,-90,0])
translate([-ForendX(),0,0])
PivotLatchCollar(barrel=DEFAULT_BARREL);

// Extractor
*!scale(25.4)
rotate([0,-90,0])
translate([-BreechFrontX(),0,0])
Extractor(barrelPipe=DEFAULT_BARREL);

// Extractor Guides
*!scale(25.4)
translate([-BreechFrontX(),0,0]) {
  rotate([-90,0,0])
  ExtractorGuide(barrelPipe=DEFAULT_BARREL, cutter=false, sides=[0]);
  
  rotate([90,0,0])
  ExtractorGuide(barrelPipe=DEFAULT_BARREL, cutter=false, sides=[1]);
}

// Plated Pivot Latch
*!scale(25.4)
translate([-PivotLatchX(),0,-PivotLatchZ()+LatchHeight()])
PivotLatch();

// Plated Latch Handle
*!scale(25.4)
translate([-LatchBoltX(),0,0])
PivotLatchHandle();
