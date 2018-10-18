//$t=0.70;
//$t=0.75;
//$t=0.665;
//$t=0;
include <../../../../../Components/Latch_Lookup.scad>;
include <../../../../../Meta/Animation.scad>;
use <../../../../../Meta/Clearance.scad>;
use <../../../../../Meta/Debug.scad>;
use <../../../../../Meta/Manifold.scad>;
use <../../../../../Meta/Resolution.scad>;
use <../../../../../Meta/Units.scad>;
use <../../../../../Vitamins/Pipe.scad>;
use <../../../../../Vitamins/Rod.scad>;
use <../../../../../Vitamins/Nuts And Bolts.scad>;
use <../../../../../Vitamins/Double Shaft Collar.scad>;
use <../../../../../Components/Printable Shaft Collar.scad>;
use <../../../../../Components/Set Screw.scad>;
use <../../../../../Components/Latch.scad>;
use <../../../../../Components/Pivot.scad>;
use <../../../../../Shapes/Semicircle.scad>;
use <../../../../../Shapes/Teardrop.scad>;
use <../../../../../Lower/Receiver Lugs.scad>;
use <../../../../../Lower/Lower.scad>;
use <../../../../../Finishing/Chamfer.scad>;
use <../../../Reference.scad>;
use <../../../Frame.scad>;
use <../../Forend Slotted.scad>;
use <../../Forend.scad>;

DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_LATCH_BOLT = Spec_BoltM4();
DEFAULT_PIVOT_BOLT = Spec_BoltM4();
DEFAULT_EXTRACTOR_BOLT = Spec_BoltM5();


PIVOT_LATCH = [
  [LatchWidth,        UnitsImperial(0.75)],
  [LatchHeight,       UnitsImperial(0.25)],
  [LatchTravel,       UnitsImperial(0.375)],
  [LatchSpringLength, UnitsImperial(0.875)],
  [LatchHandleWidth,  UnitsImperial(0.5)],
  [LatchBoltOffset,   UnitsImperial(0.625)],
  [LatchBoltLength,   UnitsMetric(25)]
];

function BarrelLatchCollarLength() = 1;
function PivotLatchX() = ForendX()
                       + BarrelLatchCollarLength()
                       - LatchTravel(PIVOT_LATCH);

function PivotLatchZ(barrel=DEFAULT_BARREL) = -PipeOuterRadius(pipe=barrel)
                                              - 0.25;

function PivotPivotLatchBoltZ(barrel=DEFAULT_BARREL) = PivotLatchZ(barrel);

function PivotPivotLatchBoltX() = PivotLatchX()
                      + LatchTravel(PIVOT_LATCH)
                      + (LatchHandleWidth(PIVOT_LATCH)/2);


function ForendPivotedPivotLatchLength() = (PivotLatchX()-ForendX())
                                    + LatchLength(PIVOT_LATCH)
                                    + LatchTravel(PIVOT_LATCH);

function ForendPivotedX() = ForendPivotedPivotLatchLength();

function BarrelPivotCollarLength() = 1.125;
function BarrelPivotCollarWall() = 0.4375; //0.3125;
function BarrelPivotCollarSteelDiameter() = 1.75;
function BarrelPivotCollarSteelWidth() = 5/8;

function PivotAngle() = 30;
function PivotOffset() = 5.375;
function PivotRadius() = 0.375;
function BarrelPivotInterface() = 0.25;
function BarrelPivotX() = BreechFrontX()+PivotOffset();
function BarrelPivotZ() = -PipeOuterRadius(DEFAULT_BARREL);

function PivotedForendFrameLength() = 5.9;
function PivotedForendLength() = PivotedForendFrameLength()
                               - ForendPivotedPivotLatchLength()
                               - 0.2;


function ExtractorTravel()            = 0.5;
function ExtractorDwellDistance()     = 0.55; //0.4375;

function ExtractorGuideWidth()   = 0.1875;
function ExtractorGuideHeight()  = 0.5;
function ExtractorGuideOffsetY() = 0.5625+ManifoldGap();
function ExtractorGuideOffsetZ() = 0.125;
function ExtractorGuideLength()  = ForendBreechGap()
              + BarrelLatchCollarLength()
              + ExtractorTravel()
              + ExtractorDwellDistance()
              + 0.25
              + 0.25;

function ExtractorPusherPivotRadius() = 0.25;
function ExtractorPusherWall()        = 0.125;
function ExtractorPusherWidth() = 0.74;
function ExtractorPusherX() = ForendX()
                            + ForendPivotedX()
                            + PivotedForendLength()
                            - (ExtractorPusherPivotRadius()*2);

function ExtractorPusherZ() = ReceiverCenter();
function ExtractorPusherSightHeight() = 0.5;
function ExtractorPusherBarLength() = ExtractorPusherX()
                                      -BreechFrontX()
                                      -ExtractorGuideLength()
                                      + 0.09;

function ExtractorJointPinRadius()      = 0.125;
function ExtractorJointRadius()         = (ExtractorGuideHeight()/2)
                                        + ExtractorGuideOffsetZ();

function ExtractorSpringLength() = 0.875;
function ExtractorSpringOD() = 0.25;

module PivotLatchBolt(boltSpec=DEFAULT_LATCH_BOLT,
                 length=UnitsMetric(25),
                 cutter=false) {

    translate([PivotPivotLatchBoltX(), 0, PivotPivotLatchBoltZ()+ManifoldGap()])
    rotate([180,0,0])
    NutAndBolt(bolt=boltSpec,
               boltLength = length, capHeightExtra=(cutter?1:0),
               nutBackset=UnitsMetric(1), nutHeightExtra=UnitsMetric(1.5),
               clearance = cutter);
}


module BarrelPivotInnerRace(pivotRadius=PivotRadius(),
                            clearance=0) {
      translate([BarrelPivotX(), 0, BarrelPivotZ()])
      rotate([90,0,0])
      cylinder(r=pivotRadius+clearance,
               h=3,
               center=true,
               $fn=Resolution(20,100));
}

module BarrelPivotCollarBolts(barrelPipe=DEFAULT_BARREL,
                              pivotRadius = PivotRadius(),
                              length=UnitsMetric(10),
                              angles=[0],
                              teardropAngle=90, cap=true,
                              clearance=0.005, cutter=false) {
  *translate([BarrelPivotX() - pivotRadius - UnitsMetric(6),0,0])
  for (r = angles)
  rotate([180,0,0]) // Rotate to bottom
  rotate([r,0,0])   // Lean angle
  rotate([0,-90,0]) // Stand up on-end
  SetScrew(radius=PipeOuterRadius(barrelPipe),
            cap=cap, capHeightExtra=(cutter ? ReceiverCenter() : 0),
            length=length,
            teardrop=cutter, teardropAngle=teardropAngle,
            cutter=cutter);
}

module BarrelPivotCollar(barrelPipe=DEFAULT_BARREL,
                         pivotRadius = PivotRadius(),
                         height=BarrelPivotCollarLength(),
                         cutter=false, clearance=0.008, extend=0, cutter2=false,
                         alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Tan", alpha)
  render() {
    if (cutter2==false)
    difference() {
      intersection() {

        // Shaft collar
        translate([BarrelPivotX() - pivotRadius + BarrelPivotInterface(),0,0])
        rotate([0,-90,0])
        rotate(-90)
        PrintableShaftCollar(pipeSpec=barrelPipe, pipeClearance=PipeClearanceSnug(),
                             height=height+extend+clear,
                             length=UnitsMetric(10),
                             setScrewLength=UnitsMetric(8),
                             screwOffsetZ=-height,
                             teardropAngle=90,
                             wall=BarrelPivotCollarWall()+clear,
                             cutter=cutter);

        if (extend == 0) {
          // TODO: Math this out so we don't pivot through the frame rods automagically.
          extra=1.1875;

          translate([BarrelPivotX(), 0, BarrelPivotZ()])
          rotate([90,0,0])
          cylinder(r=PipeOuterRadius(barrelPipe,undef)+extra+clearance,
                   h=3,
                   center=true,
                   $fn=Resolution(20,100));
        }
      }
      
      // Steel Shaft Collar
      if (!cutter)
      translate([BarrelPivotX()
                -pivotRadius
                +BarrelPivotInterface()
                -height
                +BarrelPivotCollarSteelWidth()-0.25,
                 0,0])
      rotate([0,-90,0])
      rotate(-90)
      cylinder(r=BarrelPivotCollarSteelDiameter()/2,
               h=BarrelPivotCollarSteelWidth(), $fn=40);

      BarrelPivotInnerRace();
    }
  
    // Steel Shaft Collar
    if (cutter2)
    translate([BarrelPivotX()
              -pivotRadius
              +BarrelPivotInterface()
              -height
              +BarrelPivotCollarSteelWidth()-0.25,
               0,0])
    rotate([0,-90,0])
    rotate(-90)
    cylinder(r=BarrelPivotCollarSteelDiameter()/2,
             h=BarrelPivotCollarSteelWidth(), $fn=40);
  }
}

module ForendPivoted(barrelPipe=DEFAULT_BARREL,
                     length=PivotedForendLength(),
                     wall=WallTee(),
                     $fn=40, alpha=1) {

  color("DimGrey", alpha)
  render()
  difference() {
    union() {
      translate([ForendPivotedX(),0,0])
      Forend(barrelSpec=barrelPipe, length=length, scallopAngles=[]);

      // Extractor pusher support
      intersection() {
        hull() {
          translate([ExtractorPusherX(),0,ExtractorPusherZ()])
          rotate([90,0,0])
          linear_extrude(height=1, center=true)
          Teardrop(r=ExtractorPusherPivotRadius()
                    + ExtractorPusherWall(), truncated=false);

          translate([ExtractorPusherX(),-ReceiverOR(),ReceiverOR()])
          cube([0.5,ReceiverOD(),ManifoldGap()]);
        }

        // Make sure the pivot doesn't extend past the end of the forend
        translate([ForendX()+ForendPivotedX(),-ReceiverOR(),0])
        cube([length, ReceiverOD(), ReceiverLength()]);
      }
    }

    union() {

      // Extractor pusher pathway through the forend
      translate([ExtractorPusherX()-length-ExtractorPusherPivotRadius(),
                 -(ExtractorPusherWidth()/2)-0.005,
                 0])
      cube([length, ExtractorPusherWidth()+0.01, ReceiverCenter()]);

      // Extractor pusher pivot on top of the forend
      translate([ExtractorPusherX(),0,ExtractorPusherZ()])
      rotate([90,0,0])
      linear_extrude(height=ExtractorPusherWidth()+0.01, center=true) {

        // Pivotted section
        difference() {
          rotate(-45)
          semicircle(od=0.75*sqrt(2), angle=315, center=false);

          Teardrop(r=ExtractorPusherPivotRadius());
        }
      }

      difference() {
        union() {
          
          PivotHull(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(), angle=PivotAngle())
          BarrelPivotCollar(cutter=true, cutter2=false);
          
          PivotHull(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(), angle=PivotAngle())
          BarrelPivotCollar(cutter=true, cutter2=true);
        }

        BarrelPivotInnerRace(clearance=-0.01);
      }

      // Pivot collar installation tunnel
      // Note: back-pivoted so the collar is fully retained in normal operation
      Pivot(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(),
            factor=1, angle=-5)
      BarrelPivotCollar(cutter=true, extend=length);

      BarrelPivotCollarBolts(length=ReceiverCenter(),cutter=true);

      // These need a shortened barrel segment to look decent.
      PivotHull(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(), angle=PivotAngle())
      translate([-BreechFrontX()+ForendX()+ForendPivotedX()-1,0])
      Barrel(barrel=barrelPipe, barrelLength=length+1.5);

      *hull() {
        Extractor(cutter=true);

        Pivot(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(), factor=1)
        translate([-ExtractorTravel(),0,0])
        Extractor(cutter=true);
      }
    
    }
  }
}

module PivotLatch(barrel=DEFAULT_BARREL,
                  cutter=false, clearance=0.015, alpha=1) {
  translate([PivotLatchX(), 0, PivotLatchZ()-LatchHeight(PIVOT_LATCH)])
  Latch(spec=PIVOT_LATCH, cutter=cutter);
}

module PivotLatchHandle(diameter=LatchHandleWidth(PIVOT_LATCH)-0.015,
                        clearance=0.005, extend=0,
                        $fn=30, alpha=1) {

  height = 0.5;
  zMin = -ReceiverCenter()-height;
  clear  = clearance;
  clear2 = clearance*2;

  color("Gold", alpha)
  render()
  difference() {
    union() {
      translate([PivotPivotLatchBoltX(),0,zMin+ManifoldGap()])
      cylinder(r=diameter/2, h=height+(ReceiverCenter()+PivotLatchZ())-LatchHeight(PIVOT_LATCH));

      // Ambidextrous Index-finger Unlock Button
      hull()
      for (m = [0,1])
      mirror([0,m,0]) {

        // Finger interface
        translate([LowerMaxX()-LowerWallFront()-0.125,
                   (LowerMaxWidth()/2)+0.125,
                   zMin])
        rotate(-25)
        cube([0.25, 0.5, height]);

        // Anchor hull to the latch bolt
        translate([PivotPivotLatchBoltX(), 0, zMin])
        cylinder(r=(diameter/2), h=height);
      }

      // Slot Key
      translate([ForendX()+BarrelLatchCollarLength()-0.125-(extend/2),
                  -(LatchHandleWidth(PIVOT_LATCH)/2)+clear,
                  zMin])
      cube([LatchTravel(PIVOT_LATCH)+1+extend,
            LatchHandleWidth(PIVOT_LATCH)-clear2,
            height+0.125-clear]);
    }

    // Thumbhole? Less material, anyway.
    hull() {
      translate([LowerMaxX()+0.125,0, zMin-ManifoldGap()])
      cylinder(r=0.5,h=height+ManifoldGap(2));

      translate([ForendX(),0, zMin-ManifoldGap()])
      cylinder(r=0.375,h=height+ManifoldGap(2));
    }

    // Lower clearance
    translate([0,-(LowerMaxWidth()/2)-0.1, zMin-ManifoldGap()])
    cube([LowerMaxX()+clear+ManifoldGap(), LowerMaxWidth()+0.2, height+ManifoldGap(2)]);


    PivotLatchBolt(cutter=true);
  }
}


module BarrelLatchCollarBolts(barrel=DEFAULT_BARREL,
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
            length=length, height=BarrelLatchCollarLength(),
            teardrop=cutter, teardropAngle=teardropAngle,
            cutter=cutter);
}

module BarrelLatchCollar(barrel=DEFAULT_BARREL,
                             wall=WallTee(),
                             length=UnitsMetric(30),
                             height=BarrelLatchCollarLength(),
                             chamferRadius=0.0625, 
                             clearance=0.005, cutter=false,
                             $fn=40, alpha=1) {

  radius = ReceiverOR() - clearance;
  rearCut = cutter ? height : 0;

  color("Tan", alpha)
  render()
  difference() {
    union() {
      translate([ForendX()-rearCut,0,0])
      hull() {
        
        // Extractor Support
        translate([0,-radius,0])
        ChamferedCube([height+rearCut,radius*2,ReceiverCenter()], r=chamferRadius);

        // Collar body
        rotate([0,90,0])
        ChamferedCylinder(r1=radius, r2=chamferRadius, h=height+rearCut);

        // Latch Support
        translate([0,-radius,-ReceiverCenter()+clearance])
        ChamferedCube([height+rearCut,radius*2,0.25], r=chamferRadius);
      }
    }

    if (!cutter) {
      BarrelLatchCollarBolts(barrel=barrel, teardropAngle=-90, cutter=true);

      PivotLatch(barrel=barrel, cutter=true);

      Extractor(cutter=true);

      Barrel(barrel=barrel, clearance=PipeClearanceSnug(), cutter=true);
    }

    // Cut an incline for the latch to ride on
    translate([ForendX()+height,
                -ReceiverOR(),
                PivotLatchZ(barrel) - (LatchHeight(PIVOT_LATCH)*0.5)])
    rotate([0,35,0])
    mirror([0,0,1])
    cube([1, ReceiverOD(), 2]);

    // Cut the walls with a slight incline for loading
    translate([-rearCut,0,-PipeOuterRadius(pipe=barrel)])
    for (m=[0,1])
    mirror([0,m,0])
    rotate([-20,0,0])
    translate([ForendX()-ManifoldGap(),
                radius,
                PivotLatchZ(barrel)-ReceiverLength()])
    cube([height+rearCut+ManifoldGap(2), radius, ReceiverLength()*2]);
  }
}

module ForendPivotedLatch(barrelPipe=DEFAULT_BARREL,
                       length=ForendPivotedPivotLatchLength(),
                       wall=WallTee(),
                       $fn=Resolution(20,60), alpha=1) {

  color("DimGrey", alpha)
  render(convexity=4)
  difference() {
    Forend(barrelSpec=barrelPipe, length=length,
           scallopAngles=[],
           clearFloor=true);

    // Barrel Slot
    translate([ForendX()-ManifoldGap(),0,0])
    rotate([0,90,0])
    linear_extrude(height=length+ManifoldGap(2))
    rotate(180)
    ForendSlotCutter2d(width=PipeOuterDiameter(pipe=barrelPipe, clearance=PipeClearanceLoose()));

    // Latching Collar Slot
    PivotHull(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(), angle=PivotAngle())
    scale([1.00,1.01,1.01])
    BarrelLatchCollar(cutter=true);
    
    translate([PivotLatchX(), 0, PivotLatchZ()-LatchHeight(PIVOT_LATCH)]) {
      Latch(spec=PIVOT_LATCH, cutter=true);
      LatchHandle(latchSpec=PIVOT_LATCH, boltSpec=DEFAULT_LATCH_BOLT, cutter=true);
    }
    
    PivotLatchHandle(extend=length);
  }
}

module ExtractorPusherPivotBolt(boltSpec=DEFAULT_PIVOT_BOLT,
                 length=UnitsMetric(18),

                 cutter=false) {

    translate([ExtractorPusherBarLength(), 0, 0])
    rotate([0,0,180+45])
    translate([0, ExtractorJointRadius(), 0])
    rotate([90,0,0])
    Bolt(bolt=boltSpec, teardrop=cutter, teardropAngle=90,
               length=length,
               clearance = cutter);
}

module ExtractorPusher(pivotAngle=PivotAngle(), pivotFactor=1,
                       width=ExtractorPusherWidth(), barWidth=0.25,
                       clearance=0.005,
                       $fn=Resolution(12,30), alpha=1) {

  backPivotAngle = -13.7;
  forwardPivotAngle = -7.5;
  barLength = ExtractorPusherBarLength();

  color("Goldenrod", alpha)
  render()
  translate([ExtractorPusherX(), 0, ExtractorPusherZ()])
  rotate([0,(backPivotAngle*(1-pivotFactor))
            +((pivotAngle+forwardPivotAngle)*pivotFactor),0])
  mirror([1,0,0])
  rotate([90,0,0])
  difference() {
    linear_extrude(height=width, center=true)
    difference() {
      union() {

        // Bar
        translate([0,-barWidth/2])
        square([barLength,barWidth]);

        // Front clip (teardropped for strength)
        Teardrop(r=ExtractorPusherPivotRadius()+ExtractorPusherWall());

        // Joint
        translate([barLength,0,0])
        rotate(180)
        Teardrop(r=ExtractorJointRadius());
      }

      // Front clip installation cutout
      rotate(240)
      semicircle(od=(ExtractorPusherPivotRadius()+ExtractorPusherWall())*3, angle=120, center=false);

      // Front clip pivot hole
      circle(r=ExtractorPusherPivotRadius()+clearance, center=true);

      // Joint hole
      translate([barLength,0,0])
      circle(r=ExtractorJointPinRadius()+clearance);
    }
    
    ExtractorPusherPivotBolt(cutter=true);
  }
}

module ExtractorBolt(boltSpec=DEFAULT_EXTRACTOR_BOLT,
                     barrelPipe=DEFAULT_BARREL,
                     length=UnitsMetric(18),
                     cutter=false) {
      
    translate([BreechFrontX()-0.06, 0, PipeInnerRadius(pipe=barrelPipe)])
    rotate([0,45,0])
    NutAndBolt(bolt=boltSpec, boltLength=length, capHeightExtra=(cutter?1:0),
                nutHeightExtra=(cutter?1:0), nutBackset=UnitsMetric(10),
                teardrop=cutter, clearance = cutter);
}

module Extractor(barrelPipe=DEFAULT_BARREL, guideSides=[0,1],
                 cutter=false, clearance=0.01,
                      sides=[0,1], showHead=true,
                      alpha=1) {

  extractorGuideOffsetY=0.5625+ManifoldGap();
  extractorGuideOffsetZ=0.125;

  clear  = Clearance(clearance, cutter);
  clear2 = clear*2;


  length = ForendBreechGap()
         + ExtractorTravel()
         + BarrelLatchCollarLength();
  extractorWidth=0.25;
  extractorHeight = 0.5;

  tabLength=0.5;
  tabWidth=0.25;
  tabThickness = 0.03125+0.01;

  color("SaddleBrown")
  render()
  difference() {


    union() {

      if (showHead)
      translate([BreechFrontX()+ManifoldGap(2),-(1.125/2)+ManifoldGap(),0.3125])
      cube([ForendBreechGap()-ManifoldGap(2),
            1.125-ManifoldGap(2),
            PipeOuterRadius(pipe=barrelPipe)+ExtractorGuideHeight()+extractorGuideOffsetZ-0.3125]);

      for (m = sides) mirror([0,m,0])
      translate([BreechFrontX()+ManifoldGap(),
                 extractorGuideOffsetY,
                 PipeOuterRadius(pipe=barrelPipe)])
      translate([0,clear,-clear])
      mirror([0,1,0]) {

        // Guide
        translate([0,0,extractorGuideOffsetZ]) {

          // Guide-rail
          cube([ExtractorGuideLength()+clear,
                ExtractorGuideWidth()+clear2,
                ExtractorGuideHeight()+clear2]);

          // Rounded tip
          translate([ExtractorGuideLength(),0,(ExtractorGuideHeight()/2) +clear])
          rotate([-90,0,0])
          cylinder(r=(ExtractorGuideHeight()/2)+clear,
                   h=ExtractorGuideWidth()+clear2, $fn=40);
        }
      }
    }

    if (!cutter) {
      ExtractorBolt(cutter=true);

      Barrel(barrel=barrelPipe, clearance=PipeClearanceSnug());
      
      // Pusher pin slot
      for (m = sides) mirror([0,m,0])
      translate([BreechFrontX()+ManifoldGap(),
                 extractorGuideOffsetY,
                 PipeOuterRadius(pipe=barrelPipe)])
      translate([0,clear,-clear])
      mirror([0,1,0])
      translate([0,0,extractorGuideOffsetZ])
      translate([ExtractorGuideLength(),0,(ExtractorGuideHeight()/2)+clear])      
      hull() for (X = [0,-ExtractorDwellDistance()]) translate([X,0,0])
      rotate([-90,0,0])
      linear_extrude(height=ExtractorGuideWidth()*3, center=true)
      rotate(90)
      Teardrop(r=ExtractorJointPinRadius()+clear, truncated=true, $fn=20);
      *cylinder(r=ExtractorJointPinRadius()+clear,
               h=ExtractorGuideWidth()*3,
               center=true, $fn=20);
    }
  }
}


module ForendPivotedAssembly(forend=true, debug=false) {

ExtractorPusher(pivotFactor = Animate(ANIMATION_STEP_UNLOAD)
                            - Animate(ANIMATION_STEP_LOAD));

  // Pivot Latch
  translate([LatchTravel(PIVOT_LATCH)*Animate(ANIMATION_STEP_UNLOCK),0,0])
  translate([-LatchTravel(PIVOT_LATCH)*SubAnimate(ANIMATION_STEP_UNLOAD, start=0, end=0.3),0,0])
  translate([LatchTravel(PIVOT_LATCH)*SubAnimate(ANIMATION_STEP_LOAD, start=0.76),0,0])
  translate([-LatchTravel(PIVOT_LATCH)*Animate(ANIMATION_STEP_LOCK),0,0]) {
    PivotLatchBolt();
    PivotLatchHandle();
    PivotLatch();
  }

  // The barrel and all the stuff that pivots with it
  Pivot(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(),
        Animate(ANIMATION_STEP_UNLOAD)-Animate(ANIMATION_STEP_LOAD)) {

    BarrelLatchCollarBolts(barrel=DEFAULT_BARREL);

    BarrelPivotCollarBolts();

    Barrel(barrel=DEFAULT_BARREL, clearance=undef, hollow=true, alpha=1);

    // Extractor
    translate([-ExtractorTravel()*SubAnimate(ANIMATION_STEP_UNLOAD, start=0),0,0])
    translate([ExtractorTravel()*SubAnimate(ANIMATION_STEP_LOAD, start=0),0,0])
    //translate([ExtractorTravel()*Animate(ANIMATION_STEP_EXTRACT),0,0])
    //translate([-ExtractorTravel()*sin(180*Animate(ANIMATION_STEP_EXTRACT)),0,0])
    //translate([ExtractorTravel()*Animate(ANIMATION_STEP_EXTRACT),0,0])
    {
      ExtractorBolt();
      Extractor();
    }

    color("Tan") DebugHalf(enabled=debug)
    BarrelLatchCollar(barrel=DEFAULT_BARREL, alpha=1);
    
    color("Tan")  DebugHalf(enabled=debug)
    BarrelPivotCollar(alpha=1);
  }
  
  if (forend) {

    color("DimGrey") DebugHalf(enabled=debug)
    ForendPivotedLatch();

    color("Grey") DebugHalf(enabled=debug)
    ForendPivoted(alpha=1);
  
    color("DarkGray") DebugHalf(enabled=debug)
    ShellRamp();
  }

}

ForendPivotedAssembly(debug=true);

Reference(barrelPipe=DEFAULT_BARREL);


module ShellRamp(width=BushingCapWidth(BreechBushing()), height=BushingDepth(BreechBushing()),
                 barrelPipe=DEFAULT_BARREL,
                   length=ForendX()-ReceiverLugFrontMaxX(),
                   wall=WallTee(),
                   $fn=40, alpha=1) {
  color("LightGrey")
  render()
  difference() {
    translate([-ForendX()+ReceiverLugFrontMaxX(),0,0])
    Forend(barrelSpec=barrelPipe, length=length, scallopAngles=[]);

    // Breech Cutout
    translate([ReceiverLugFrontMaxX()-ManifoldGap(),0,0])
    rotate([180,-90,0])
    cylinder(r=(width/2)+0.05, h=length+ManifoldGap(2));
    
    // Ramp
    translate([BreechFrontX(), -width/2, width/2])
    rotate([0,-20,0])
    cube([length, width, ReceiverCenter()]);
    
    // Latching Collar Slot
    PivotHull(pivotX=BarrelPivotX(), pivotZ=BarrelPivotZ(), angle=PivotAngle())
    scale([1.00,1.01,1.01])
    BarrelLatchCollar(cutter=false);
  }
}

*!scale(25.4)
rotate([0,-90,0])
translate([-ReceiverLugFrontMaxX(),0,0])
ShellRamp();

// Plated Forend Pivoted
*!scale(25.4)
rotate([0,90,0])
translate([-ForendX()-ForendPivotedX()-PivotedForendLength(),0,0])
ForendPivoted(bolt=true, alpha=1);

// Plated Pivot Collar
*!scale(25.4)
rotate([0,-90,0])
translate([-BarrelPivotX() + PivotRadius() - BarrelPivotInterface(),0,0])
BarrelPivotCollar(barrel=DEFAULT_BARREL);

// Plated Forend Pivoted Latch
*!scale(25.4)
rotate([0,90,0])
translate([-ForendX(),0,0])
ForendPivotedLatch(alpha=1);

// Plated Latch Collar
*!scale(25.4)
rotate([0,-90,0])
translate([-ForendX(),0,0])
BarrelLatchCollar(barrel=DEFAULT_BARREL);

// Plated Pivot Latch
*!scale(25.4)
translate([-PivotLatchX(),0,-PivotLatchZ()])
PivotLatch();

// Plated Latch Handle
*!scale(25.4)
translate([-PivotPivotLatchBoltX(),0,0])
PivotLatchHandle();

// Extractor Pusher
*!scale(25.4)
rotate([-90,0,22.5])
translate([-ExtractorPusherX(),0,-ExtractorPusherZ()])
ExtractorPusher();

// Extractor
*!scale(25.4)
rotate([180,0,0])
translate([-BreechFrontX(),0,0])
Extractor(barrelPipe=DEFAULT_BARREL);
