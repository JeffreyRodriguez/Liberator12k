include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pivot.scad>;

use <../../../Lower/Lower.scad>;

use <../../../Finishing/Chamfer.scad>;

use <../../../Shapes/Bearing Surface.scad>;
use <../../../Shapes/Teardrop.scad>;
use <../../../Shapes/TeardropTorus.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/ZigZag.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Ammo/Shell Slug.scad>;

use <../Lugs.scad>;
use <../Pipe Upper.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;


$fs = UnitsFs()*0.5;

// Settings: Vitamins
function BarrelPipe() = Spec_PipeThreeQuarterInch();
function BarrelSleevePipe() = Spec_PipeOneInch();
function SquareRodFixingBolt() = Spec_BoltM3();

// Settings: Lengths
function BarrelLength() = 18;
function BarrelSleeveLength() = 4;
function WallBarrel() = 0.25;
function WallPivot() = 0.5;

// Shorthand: Measurements
function PivotWidth() = 1.25;
function PivotDiameter() = .25;
function PivotRadius() = PivotDiameter()/2;

function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);

// Calculated: Lengths
function ForendFrontLength() = 1.5;
function ReceiverTopZ() = ReceiverOR();

// Calculated: Positions
function ForendFrontX() = FrameUpperBoltExtension();
function PivotX() = 5.5;
function PivotZ() = FrameUpperBoltOffsetZ()
                  + (FrameUpperBoltRadius()+PivotRadius());
function PivotAngle() = -180;

function LatchRodZ() = -1.125;
function LatchRodDiameter() = 0.25;
function LatchRodRadius() = LatchRodDiameter()/2;

function LatchSpringLength() = 2.5;
function LatchSpringDiameter() = 0.75;
function LatchSpringRadius() = LatchSpringDiameter()/2;
function LatchSpringFloor() = 0.25;
function LatchSpringWall() = 0.125;

module RenderIf(test=true) {
  if (test) {
    render() children();
  } else {
    children();
  }
}

module BreakActionLatchRod(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Rod
  color("SteelBlue")
  translate([-0.5, 0, LatchRodZ()])
  rotate([0,90,0])
  cylinder(r=LatchRodRadius()+clear,
           h=BarrelSleeveLength()+0.5+(cutter?0.5:0));
}

module BreakActionLatchSpring(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  // Spring
  color("Silver")
  translate([BarrelSleeveLength()-LatchSpringFloor(), 0, LatchRodZ()])
  rotate([0,-90,0])
  cylinder(r=LatchSpringRadius()+clear, h=cutter?BarrelSleeveLength()-LatchSpringFloor():LatchSpringLength());
}

module BreakActionLatch(debug=false, cutter=false, clearance=0.01) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
  
  
  // Latch block
  color("Tomato")
  difference() {
    union() {
      translate([-(cutter?0.25:0),-0.125-clear,LatchRodZ()])
      mirror([0,0,1])
      ChamferedCube([0.75+(cutter?0.5+0.25:0), 0.25+clear2, 1.5], r=1/16);
    
      translate([0,0,LatchRodZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=(0.7/2)-0.008, r2=1/16,
                         h=1.25);
    }
  
    LatchScrews(cutter=true, clearance=-0.02);
    
    BreakActionLatchRod(cutter=true);
  }
}

module LatchScrews(debug=false, cutter=false, clearance=0.008) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
  
  color("Silver")
  translate([0.375,0,LatchRodZ()])
  rotate([90,0,0])
  cylinder(r=(0.17/2)+clearance, center=true,
           h=LatchSpringDiameter()+(LatchSpringWall()*2));
}

module BreakActionRecoilPlateHousing(debug=false) {
  color("MediumSlateBlue")
  DebugHalf(enabled=debug) render()
  difference() {
    RecoilPlateHousing(topHeight=FrameUpperBoltOffsetZ(),
                       bottomHeight=-LowerOffsetZ(),
                       debug=false) {
      
      // Frame upper support
      translate([RecoilPlateRearX(),0,0])
      hull()
      FrameUpperBoltSupport(length=-RecoilPlateRearX());
                         
      // Latch Rod Support
      translate([RecoilPlateRearX(),0,LatchRodZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.75, r2=1/16,
                        h=abs(RecoilPlateRearX()),
                        $fn=60);
    }

    FrameUpperBolts(cutter=true);

    FrameBolts(cutter=true, teardrop=false);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true);
    
    BreakActionLatchRod(cutter=true);
  }
}

module BreakActionPivot(factor=0) {
  Pivot2(xyz=[PivotX(),0,PivotZ()],
         angle=[0,PivotAngle(),0],
         factor=factor)
  children();
}


module Barrel(barrel=BarrelPipe(), length=BarrelLength(),
              clearance=PipeClearanceSnug(),
              cutter=false, alpha=1, debug=false) {

  color("Silver") DebugHalf(enabled=!cutter&&debug) RenderIf(!cutter)
  rotate([0,90,0])
  Pipe(pipe=BarrelSleevePipe(),
       length=BarrelSleeveLength(),
       hollow=!cutter, clearance=clearance);
  
  color("SteelBlue", alpha) DebugHalf(enabled=!cutter&&debug) RenderIf(!cutter)
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=!cutter, length=length);
}


module BarrelPivotCollar(length=(PivotRadius()+WallPivot())*2, debug=false, alpha=1, cutter=false) {
  echo(length+0.375);
  
  color("Tomato", alpha) DebugHalf(enabled=!cutter&&debug)
  difference() {
    union() {
        
      // Around the barrel
      translate([PivotX()+PivotRadius()+WallPivot(), 0, 0])
      intersection() {
        rotate([0,-90,0])
        ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
                 h=length+0.375,
                 $fn=60);
        
        mirror([1,0,0])
        translate([0,-(BarrelSleeveRadius()+WallBarrel()),
                   -(BarrelSleeveRadius()+WallBarrel())])
        cube([length+0.875,
              (BarrelSleeveRadius()+WallBarrel())*2,
              BarrelSleeveRadius()+BarrelRadius()+(WallBarrel()*2)]);
      }
      
      translate([PivotX()+(PivotRadius()+WallPivot()), -1.125/2, 0])
      mirror([1,0,0])
      ChamferedCube([length+0.375,
                     PivotWidth(),
                     FrameUpperBoltOffsetZ()
                       -FrameUpperBoltRadius()
                       -WallFrameUpperBolt()],
                    r=1/16);
      
      // Pivot support
      hull() {
        translate([PivotX(), -PivotWidth()/2, PivotZ()])
        rotate([-90,0,0])
        ChamferedCylinder(r1=PivotRadius()+WallPivot(), r2=1/16, h=PivotWidth());
  
        translate([PivotX()-(PivotRadius()+WallPivot()), -1.125/2, 0])
        ChamferedCube([(PivotRadius()+WallPivot())*2,
                       PivotWidth(),
                       BarrelRadius()+WallBarrel()],
                      r=1/16);
      }
    }
    
    // Set screw hole
    for (X = [0.25,-0.625])
    translate([PivotX()+X,0,0])
    mirror([0,0,1])
    cylinder(r=1/8/2, h=FrameUpperBoltOffsetZ());
    
    // Pivot hole
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius(), h=3, center=true);
    
    Barrel(cutter=true);
  }
  
}

module BarrelLatchCollar(length=BarrelSleeveLength(),
                         debug=false, alpha=0.5, cutter=false) {
  color("Tan", alpha) DebugHalf(enabled=!cutter&&debug) render()
  difference() {
    union() {
      
      // Around the barrel sleeve
      hull() {
        
        intersection() {
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
                   h=length,
                   $fn=60);
          
          translate([0,-(BarrelSleeveRadius()+WallBarrel()),
                     -(BarrelSleeveRadius()+WallBarrel())])
          cube([length,
                (BarrelSleeveRadius()+WallBarrel())*2,
                BarrelSleeveRadius()+BarrelRadius()+(WallBarrel()*2)]);
        }
        
        translate([0, -(BarrelSleeveRadius()), 0])
        ChamferedCube([length,
                       (BarrelSleeveRadius())*2,
                       FrameUpperBoltOffsetZ()
                         -FrameUpperBoltRadius()
                         -WallFrameUpperBolt()],
                      r=1/16);
      }
      
      // Spring support
      color("Silver")
      translate([0, -(LatchSpringRadius()+LatchSpringWall()), LatchRodZ()-(LatchSpringRadius()+LatchSpringWall())])
      ChamferedCube([length,
                     (LatchSpringRadius()+LatchSpringWall())*2,
                     abs(LatchRodZ())],
                     r=1/16);
    
      // Set screw support
      translate([BarrelSleeveLength(),0,0])
      for (R = [40,-40]) rotate([180+R,0,0])
      translate([0, -0.25, 0])
      mirror([1,0,0])
      ChamferedCube([0.5,
                     0.5,
                     abs(LatchRodZ())-(LatchSpringRadius()+LatchSpringWall())+0.375],
                     r=1/16);
    }
    
    // Set screws
    translate([BarrelSleeveLength()-0.25,0,0])
    for (R = [40,-40]) rotate([R,0,0])
    rotate([0,180,0])
    cylinder(r=1/8/2, h=BarrelSleeveDiameter()+WallBarrel());
    
    Barrel(cutter=true);
    
    BreakActionLatchRod(cutter=true);
    
    BreakActionLatchSpring(cutter=true);
    
    BreakActionLatch(cutter=true);
    
    hull() for (X = [0,0.5])
    LatchScrews(cutter=true);
  }
  
}

module BarrelAssembly(pivotFactor=0, debug=false) {
  BreakActionPivot(factor=pivotFactor) {
    
    %translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=5/16/2, h=3, center=true);
           
    Barrel(debug=debug);
    
    BarrelPivotCollar(debug=debug);
    
    BreakActionLatch(debug=debug);
    
    BarrelLatchCollar(debug=debug);
  }
}

module BreakActionForend(debug=false, alpha=1) {
  
  // Forward plate
  color("MediumSlateBlue", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {
    
      // Pivot support
      hull() {
        
        translate([ForendFrontX(), 0, 0])
        mirror([1,0,0])
        FrameUpperBoltSupport(length=ForendFrontLength());
        
        translate([PivotX(), 0, PivotZ()])
        rotate([90,0,0])
        translate([0,0,-FrameUpperBoltOffsetY()-FrameUpperBoltRadius()-WallFrameUpperBolt()])
        ChamferedCylinder(r1=0.5, r2=1/16,
                 h=(FrameUpperBoltOffsetY()+FrameUpperBoltRadius()+WallFrameUpperBolt())*2,
                 $fn=Resolution(20,60));
      }
    }
    
    // Pivot Slot Top
    translate([PivotX(), -1.125/2, FrameUpperBoltOffsetZ()+(FrameUpperBoltRadius()+WallFrameUpperBolt())])
    mirror([1,0,0])
    ChamferedCube([ForendFrontLength(),
                   PivotWidth(),
                   BarrelSleeveRadius()+WallBarrel()],
                  r=1/16);
    
    // Pivot Slot Front
    translate([PivotX()-(PivotRadius()+WallPivot()), -1.125/2, 0])
    ChamferedCube([(PivotRadius()+WallPivot())*2,
                   PivotWidth(),
                   FrameUpperBoltOffsetZ()+FrameUpperBoltDiameter()+(WallFrameUpperBolt()*2)],
                  r=1/16);
    
    // Pivot rod
    translate([PivotX(), 0, PivotZ()])
    rotate([90,0,0])
    cylinder(r=PivotRadius()+0.01, h=4, center=true);
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameUpperBoltOffsetZ()+FrameUpperBoltRadius()+WallFrameUpperBolt()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(cutter=true);

    ChargingRod(length=ChargingRodLength(),
                cutter=true);
  }
}

module BreakActionForendSpacer(length=FrameUpperBoltExtension()
                                     -ForendFrontLength(),
                               debug=false, alpha=1) {
  
  color("Olive", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    hull()
    FrameUpperBoltSupport(length=length);
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameUpperBoltOffsetZ()+FrameUpperBoltRadius()+WallFrameUpperBolt()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(cutter=true);

    ChargingRod(length=ChargingRodLength(),
                cutter=true);
  }
}

module BreakActionAssembly(receiverLength=12, pipeAlpha=1,
                           pivotFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {

  BreakActionRecoilPlateHousing();
  RecoilPlateFiringPinAssembly(); 
  RecoilPlate(debug=debug);
                             
  BreakActionLatchRod();
                                 
  *ChargingPumpAssembly(debug=debug);

  BreakActionForend(debug=debug, alpha=0.5);
  
  BarrelAssembly(pivotFactor=pivotFactor, debug=debug);
                             
  BreakActionForendSpacer(debug=debug);
}
 
chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                           - Animate(ANIMATION_STEP_CHARGER_RESET);

//AnimateSpin()translate([-2.5,0,0])
//for (R = [-1,1]) rotate([60*R,0,0]) translate([0,0,- SpindleOffset()])
BreakActionAssembly(pivotFactor=chargingRodAnimationFactor,
                    debug=false);

triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                           - Animate(ANIMATION_STEP_TRIGGER_RESET);
PipeUpperAssembly(pipeAlpha=1,
                  receiverLength=12, stock=true,
                  frameUpperBolts=true,
                  triggerAnimationFactor=triggerAnimationFactor,
                  debug=false);

//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=1);
//$t=0;



/*
 * Platers
 */

// Printed breech (quick 'n dirty)
*!scale(25.4) rotate([0,-90,0])
BreakActionRecoilPlateHousing();

// Barrel Pivot Collar
*!scale(25.4) rotate([0,90,0])
translate([-PivotX()-(PivotRadius()+WallPivot()),0,0])
BarrelPivotCollar();

// Barrel Latch Collar
*!scale(25.4) rotate([0,90,0])
translate([-BarrelSleeveLength(),0,0])
BarrelLatchCollar();

// Break-action Forend Front
*!scale(25.4)
rotate([0,-90,0])
translate([-FrameUpperBoltExtension()+ForendFrontLength(),0,-FrameUpperBoltOffsetZ()])
BreakActionForend();


// Latch
*!scale(25.4) render() rotate([0,-90,0]) translate([0,0,-LatchRodZ()])
BreakActionLatch();