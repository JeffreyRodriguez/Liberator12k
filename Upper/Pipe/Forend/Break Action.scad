include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pivot.scad>;
use <../../../Components/Pipe/Lugs.scad>;

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

use <../Pipe Upper.scad>;
use <../Frame.scad>;
use <../Frame - Upper.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;

// Settings: Vitamins
function BarrelPipe() = Spec_PipeThreeQuarterInch();
function PivotBolt() = Spec_BoltFiveSixteenths();
function BarrelSleevePipe() = Spec_PipeOneInch();
function SquareRodFixingBolt() = Spec_BoltM3();

// Settings: Lengths
function BarrelLength() = 18;
function BarrelSleeveLength() = 4;
function UpperLength() =  6.25;
function FrameUpperRearExtension() = 3.75;
function WallBarrel() = 0.25;
function WallPivot() = 0.25;

// Shorthand: Measurements
function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);
function PivotBoltRadius(clearance=false)
    = BoltRadius(PivotBolt(), cutter=clearance);
function PivotBoltDiameter(clearance=false)
    = BoltDiameter(PivotBolt(), cutter=clearance);

// Calculated: Lengths
function ForendFrontLength() = UpperLength()-1-RecoilPlateRearX();
function ReceiverTopZ() = ReceiverOR();

// Calculated: Positions
function ForendFrontX() = RecoilPlateRearX()+UpperLength();
function PivotX() = BarrelSleeveLength()+PivotBoltRadius();
function PivotZ() = -(BarrelRadius()+PivotBoltRadius());
function PivotAngle() = 35;

module BreakActionRecoilPlateHousing(debug=false) {
  color("MediumSlateBlue")
  DebugHalf(enabled=debug)
  difference() {
    RecoilPlateHousing(topHeight=FrameUpperBoltOffsetZ(),
                       bottomHeight=-LowerOffsetZ(),
                       debug=false) {
      
      // Frame upper support
      translate([RecoilPlateRearX(),0,0])
      hull()
      FrameUpperBoltSupport(length=-RecoilPlateRearX());
    }

    FrameUpperBolts(cutter=true);

    translate([RecoilPlateRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=true, teardrop=false);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true, actuator=false, pin=false);
  }
}

module BarrelSleeve(clearance=undef, cutter=false, debug=false) {
  color("Silver") DebugHalf(enabled=debug)
  rotate([0,90,0])
  Pipe(pipe=BarrelSleevePipe(), taperTop=true,
       length=BarrelSleeveLength(),
       hollow=!cutter, clearance=clearance);

}

module Barrel(barrel=BarrelPipe(), length=BarrelLength(), clearance=undef, cutter=false, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=!cutter, length=length);
}

module BarrelPivotBolt(cutter=false, teardrop=false) {
  color("Silver")
  translate([PivotX(), 1.5, PivotZ()])
  rotate([90,0,0])
  NutAndBolt(bolt=PivotBolt(), boltLength=3, center=true,
             clearance=cutter, teardrop=cutter&&teardrop);
}

module BarrelPivotCollar(length=1.75, debug=false, alpha=1, cutter=false) {
  color("Tomato", alpha) DebugHalf(enabled=debug)
  difference() {
    hull() {
      translate([PivotX()+PivotBoltRadius()+WallPivot(), 0, 0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
               h=length,
               $fn=60);
      
      translate([PivotX(), (BarrelSleeveRadius()+WallBarrel()), PivotZ()])
      rotate([90,0,0])
      ChamferedCylinder(r1=PivotBoltRadius()+WallPivot(), r2=1/16,
               h=(BarrelSleeveRadius()+WallBarrel())*2,
               $fn=Resolution(30,60));
      
      translate([PivotX(), -(BarrelSleeveRadius()+WallBarrel()), PivotZ()])
      mirror([1,0,0])
      mirror([0,0,1])
      ChamferedCube([length-(PivotBoltRadius()+WallPivot()),
            (BarrelSleeveRadius()+WallBarrel())*2,
            (PivotBoltRadius()+WallPivot())], r=1/16,  chamferBottom=false);
    }
    
    if (!cutter) {
      Barrel(clearance=PipeClearanceLoose(), cutter=true);
      BarrelSleeve(clearance=PipeClearanceSnug(), cutter=true);
      BarrelPivotBolt(cutter=true);
    }
  }
  
}

module BarrelAssembly(pivotFactor=0, cutter=false) {
  Pivot(factor=pivotFactor, pivotX=PivotX(), pivotZ=PivotZ(), angle=PivotAngle()) {
    Barrel(cutter=cutter);
    BarrelSleeve(cutter=cutter);
    BarrelPivotBolt(cutter=cutter);
    BarrelPivotCollar(cutter=cutter);
  }
}

module BreakActionForend(debug=false, alpha=1) {
  
  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Top strap/bolt wall
      hull()
      FrameUpperBoltSupport(length=RecoilPlateRearX()+UpperLength());
      
      // Hull on the front of the forend
      translate([RecoilPlateRearX()+UpperLength(),0,0]) {
        
        // Top strap/bolt wall
        mirror([1,0,0])
        FrameUpperBoltSupport(length=ForendFrontLength());
      
        // Body around the barrel collar
        rotate([0,-90,0])
        ChamferedCylinder(r1=1, r2=1/16,
                 h=ForendFrontLength(),
                 $fn=Resolution(20,60));
      
        // Join the barrel collar to the top strap
        mirror([1,0,0])
        translate([0,-1,0])
        ChamferedCube([ForendFrontLength(),
                       2,
                       FrameUpperBoltOffsetZ()], r=1/16);
      }
    }
    
    //PivotHull()
    //Barrel(length=PivotX(), cutter=true);
    
    for (pf = [0,1])
    BarrelAssembly(pivotFactor=pf, cutter=true);

    translate([ManifoldGap(),0,0]) {
      
      // Barrel sleeve top slot
      translate([0, -BarrelSleeveRadius(PipeClearanceSnug()), 0])
      cube([PivotX()-1, BarrelSleeveDiameter(PipeClearanceSnug()), 2]);
      
      Barrel(hollow=false, clearance=PipeClearanceLoose());
      BarrelSleeve(clearance=PipeClearanceLoose(), cutter=true);
    }
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), ReceiverTopZ()-0.125])
    cube([RecoilPlateRearX()+UpperLength()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(length=UpperLength()+FrameUpperRearExtension()+ManifoldGap(), cutter=true);

    ChargingRod(length=ChargingRodLength(),
                cutter=true);
  }
}

module BreakActionFrameAssembly(receiverLength=12, debug=false) {
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly();
                                 
  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0])
  FrameLower();
  
  FrameUpper(debug=debug);

  FrameUpperBolts(extraLength=FrameUpperBoltExtension(), cutter=false);
}

  triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                             - Animate(ANIMATION_STEP_TRIGGER_RESET);
module BreakActionAssembly(receiverLength=12, pipeAlpha=1,
                           pivotFactor=0,
                           stock=true, tailcap=false,
                           debug=false) {
 
  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);

  BreakActionRecoilPlateHousing();
  RecoilPlateFiringPinAssembly(); 
  RecoilPlate(debug=debug);
                                 
  ChargingPumpAssembly(debug=debug);
  
  BreakActionFrameAssembly(debug=debug);
  
  BarrelAssembly(pivotFactor=pivotFactor, debug=debug);

  BreakActionForend(debug=debug, alpha=0.5);
}

//AnimateSpin()translate([-2.5,0,0])
//for (R = [-1,1]) rotate([60*R,0,0]) translate([0,0,- SpindleOffset()])
BreakActionAssembly(pivotFactor=1, debug=true);

translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  chargingHandle=false,
                  frame=false,
                  stock=true, tailcap=false,
                  triggerAnimationFactor=triggerAnimationFactor,
                  debug=false);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=0);
//$t=0;



/*
 * Platers
 */

// Printed breech (quick 'n dirty)
*!scale(25.4) rotate([0,-90,0])
BreakActionRecoilPlateHousing();

// Revolver Frame - Lower
*!scale(25.4) translate([0,0,-LowerOffsetZ()])
BreakActionFrameLower();

// Revolver Forend Rear
*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-RecoilPlateRearX(),0,0])
BreakActionForend();