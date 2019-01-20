include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;

use <../../../Components/Pipe/Frame.scad>;
use <../../../Components/Pipe/Frame Standoffs.scad>;

use <../../../Components/Cylinder Redux.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Ammo/Shell Slug.scad>;

use <../Pipe Upper.scad>;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
//function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ActuatorRod() = Spec_RodOneQuarterInch();
function ChargingRod() = Spec_RodOneHalfInch();
function ChargingExtensionRod() = Spec_RodOneHalfInch();
function IndexLockRod() = Spec_RodOneQuarterInch();

// Settings: Lengths
function BarrelLength() = 18-BarrelX();
function BarrelX() = 1.5;
function UpperLength() = 6.5;
function IndexLockOffset() = 0.5;

// Settings: Angles
function ChargingRodAngle()=35;
function ChargingExtensionAnglePush()=-10;
function ChargingExtensionAngleClear()=30;

// Calculated: Positions
function ChargingRodMinX() = BreechRearX()-0.5;
function ChargingRodTravel() = LinearHammerTravel()+1.4625;
function ChargingRodOffset() = FrameMajorRodOffset()+BarrelCollarRadius()+RodRadius(ChargingRod());
function ChargingRodLength() = (BarrelX()*2)+LinearHammerTravel()+2+4;
function ActuatorRodX() = BarrelX();


module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([BarrelX()+ManifoldGap(),0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth(), $fn=40);
    
    Barrel(hollow=false, cutter=true);
  }
}

module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([BarrelX(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

module ChargingRod() {
  extensionRotationFactor = SubAnimate(ANIMATION_STEP_CHARGE, start=0.6, end=0.70)
                          - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.3, end=0.4);
  
  translate([0,0,-FrameMajorRodOffset()])
  rotate([-ChargingRodAngle(),0,0])
  translate([ChargingRodMinX(),0,ChargingRodOffset()])
  union() {
    
    // Charging rod
    translate([-2,0,0])
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=ChargingRodLength());
  
    // Actuator rod
    translate([-ChargingRodMinX()+ActuatorRodX(),0,0])
    mirror([0,0,1])
    Rod(ActuatorRod(), length=BarrelCollarRadius()-PipeOuterRadius(BarrelPipe()));
  
    // Charging extension
    *rotate([ChargingExtensionAngleClear()*extensionRotationFactor,0,0])
    rotate([ChargingExtensionAnglePush(),0,0])
    translate([-0.25,0,0.25])
    mirror([0,0,1])
    SquareRod(ChargingExtensionRod(), length=IndexLockOffset()+RodDiameter(ChargingExtensionRod()));
  }
}

module RevolverForendAssembly(receiver=Spec_PipeThreeQuarterInch(),
                 hollowReceiver=true,
                 butt=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                 debug=true) {
                   
  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);
  translate([BreechFrontX(),0,-FrameMajorRodOffset()])
  rotate([0,90,0])
  //DebugHalf(enabled=true)
  rotate([0,0,30*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.14, end=0.8)])
  rotate([0,0,30*SubAnimate(ANIMATION_STEP_CHARGE, start=0.33, end=0.97)])
  OffsetZigZagRevolver(
      centerOffset=FrameMajorRodOffset(),
      trackAngle=30-ChargingRodAngle(),
      chambers=true, chamberLength=BarrelX());

  translate([-ChargingRodTravel()*chargingRodAnimationFactor,0,0])
  ChargingRod();
}

module RevolverShotgunAssembly(pipeAlpha=1, debug=false) {
  
  hammerTravelFactor = Animate(ANIMATION_STEP_FIRE)
                     - SubAnimate(ANIMATION_STEP_CHARGE, start=0.275, end=0.69);

  RevolverForendAssembly(debug=debug);

  FixedBreechPipeUpperAssembly(pipeAlpha=pipeAlpha,
                    hammerTravelFactor=hammerTravelFactor,
                    frame=true, debug=debug);
  
  FrameAssembly(offsetMajor=0,
                lengthMajorTop=BarrelX()+1.375,
                lengthMajorBottom=BarrelX()+1.375,
                debug=debug);

  Barrel(debug=false);
  BarrelCollar(debug=false);

  color("LightSteelBlue")
  render()
  difference() {
    translate([BarrelX()+0.5+BreechPlateThickness(),0,0])
    hull()
    Breech();
    
    Barrel(hollow=false, cutter=true);
  }
}

//AnimateSpin()translate([-2.5,0,0])
RevolverShotgunAssembly(pipeAlpha=0.5, debug=false);

//$t=AnimationDebug(ANIMATION_STEP_FIRE, T=$t);
//$t=0.37;