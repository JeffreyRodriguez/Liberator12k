include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Shapes/Components/Cylinder Redux.scad>;
use <../../../Shapes/Components/Pipe/Lower/Lugs.scad>;

use <../../../Receiver/Lower/Lower.scad>;

use <../../../Shapes/Chamfer.scad>;

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

// Settings: Vitamins
function BarrelPipe() = Spec_PipeThreeQuarterInch();
function BarrelSleevePipe() = Spec_PipeOneInch();
function SquareRodFixingBolt() = Spec_BoltM3();

// Settings: Lengths
function BarrelLength() = 18;
function BarrelSleeveLength() = 4;
function UpperLength() =  5;
function FrameReceiverLength() = 3.75;
function WallBarrel() = 0.25;

// Shorthand: Measurements
function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);

// Calculated: Lengths
function ForendFrontLength() = UpperLength()-1-RecoilPlateRearX();
function ReceiverTopZ() = ReceiverOR();

// Calculated: Positions
function ForendFrontX() = RecoilPlateRearX()+UpperLength();

module SimpleSlotRecoilPlateHousing(debug=false) {
  color("MediumSlateBlue")
  DebugHalf(enabled=debug)
  difference() {
    RecoilPlateHousing(topHeight=FrameBoltZ(),
                       bottomHeight=-LowerOffsetZ(),
                       debug=false) {

      // Frame upper support
      translate([RecoilPlateRearX(),0,0])
      hull()
      FrameBoltSupport(length=-RecoilPlateRearX());
    }

    FrameBolts(cutter=true);

    translate([RecoilPlateRearX()-LowerMaxX(),0,0])
    CouplingBolts(cutter=true, teardrop=false);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true, actuator=false, pin=false);
  }
}

module BarrelSleeve(clearance=undef, cutter=false, debug=false) {
  color("Silver") DebugHalf(enabled=debug)
  rotate([0,90,0])
  Pipe(pipe=BarrelSleevePipe(), taperTop=false,
       length=BarrelSleeveLength(),
       hollow=!cutter, clearance=clearance);

}

module Barrel(barrel=BarrelPipe(), length=BarrelLength(), clearance=undef, cutter=false, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=!cutter, length=length);
}

module BarrelPivotCollar(length=1.75, debug=false, alpha=1, cutter=false) {
  color("Tomato", alpha) DebugHalf(enabled=debug)
  difference() {
    hull() {
      translate([0, 0, 0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelSleeveRadius()+WallBarrel(), r2=1/16,
               h=length,
               $fn=60);
    }

    if (!cutter) {
      Barrel(clearance=PipeClearanceLoose(), cutter=true);
      BarrelSleeve(clearance=PipeClearanceSnug(), cutter=true);
    }
  }

}

module BarrelAssembly(cutter=false) {

  Barrel(cutter=cutter);
  BarrelSleeve(cutter=cutter);
  *BarrelPivotCollar(cutter=cutter);
}

module SimpleSlotForend(debug=false, alpha=1) {

  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {

      // Top strap/bolt wall
      hull()
      FrameBoltSupport(length=RecoilPlateRearX()+UpperLength());

      // Hull on the front of the forend
      translate([RecoilPlateRearX()+UpperLength(),0,0]) {

        // Top strap/bolt wall
        mirror([1,0,0])
        FrameBoltSupport(length=ForendFrontLength());

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
                       FrameBoltZ()], r=1/16);
      }
    }

    Barrel(cutter=true);

    hull() {
      BarrelSleeve(cutter=true);

      translate([0,0,2])
      BarrelSleeve(cutter=true);
    }

    translate([ManifoldGap(),0,0]) {

      // Barrel sleeve top slot
      *translate([0, -BarrelSleeveRadius(PipeClearanceSnug()), 0])
      cube([PivotX()-1, BarrelSleeveDiameter(PipeClearanceSnug()), 2]);

      Barrel(hollow=false, clearance=PipeClearanceLoose());
      BarrelSleeve(clearance=PipeClearanceLoose(), cutter=true);
    }

    // Cutout for a picatinny rail insert
    *translate([-ManifoldGap(), -UnitsMetric(15.6/2), ReceiverTopZ()-0.125])
    cube([RecoilPlateRearX()+UpperLength()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(length=UpperLength()+FrameReceiverLength()+ManifoldGap(), cutter=true);

    *ChargingRod(length=ChargingRodLength(),
                cutter=true);
  }
}

module SimpleSlotFrameAssembly(receiverLength=12, debug=false) {

  translate([FiringPinMinX()-HammerTravel(),0,0])
  HammerAssembly();

  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0])
  FrameLower();

  Frame(debug=debug);

  FrameBolts(extraLength=FrameExtension(), cutter=false);
}

  triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                             - Animate(ANIMATION_STEP_TRIGGER_RESET);
module SimpleSlotAssembly(receiverLength=12, pipeAlpha=1,
                           stock=true, tailcap=false,
                           debug=false) {

  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);

  SimpleSlotRecoilPlateHousing();
  RecoilPlateFiringPinAssembly();
  RecoilPlate(debug=debug);

  *ChargingPumpAssembly(debug=debug);

  SimpleSlotFrameAssembly(debug=debug);

  BarrelAssembly(debug=debug);

  SimpleSlotForend(debug=debug, alpha=0.5);
}

//AnimateSpin()translate([-2.5,0,0])
//for (R = [-1,1]) rotate([60*R,0,0]) translate([0,0,- SpindleOffset()])
SimpleSlotAssembly(debug=true);

translate([RecoilPlateRearX(),0,0])
Receiver(pipeAlpha=0.3,
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
SimpleSlotRecoilPlateHousing();

// Revolver Frame - Lower
*!scale(25.4) translate([0,0,-LowerOffsetZ()])
SimpleSlotFrameLower();

// Revolver Forend Rear
*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-RecoilPlateRearX(),0,0])
SimpleSlotForend();
