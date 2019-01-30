include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pipe/Lugs.scad>;

use <../../../Finishing/Chamfer.scad>;

use <../../../Shapes/ZigZag.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Ammo/Shell Slug.scad>;

use <../Pipe Upper.scad>;
use <../Frame.scad>;
use <../Linear Hammer.scad>;
use <Breech.scad>;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
//function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function ChargingRod() = Spec_RodOneQuarterInch();

positions = 6;
radius = OffsetRevolverRadius(
             RevolverSpindleOffset(),
             PipeOuterRadius(BarrelPipe()),
             CylinderOuterWall());


// Settings: Lengths
function BarrelLength() = 18-BarrelX();
function BarrelX() = 4;
function UpperLength() =  7;
function IndexLockOffset() = 0.5;
function ActuatorPretravel() = 0.5;
function ForegripLength() = 3;

// Settings: Angles
function ChargingRodAngle()=0;

// Calculated: Positions
function ChargingRodMinX() = BreechRearX()-1;
function ChargingRodTravel() = ActuatorPretravel()
                             + ZigZagHeight(radius, positions, ZigZagWidth())
                             + (ZigZagWidth()/2);
function ChargingRodOffset() = BreechBoltOffsetZ();
function ChargingRodLength() = abs(ChargingRodMinX())
                             - BreechPlateThickness()
                             + ChargingRodTravel()
                             + UpperLength()
                             + ForegripLength();
function ActuatorRodX() = ChargingRodTravel()+ (ZigZagWidth()/2);

echo("ChargingRodTravel: ", ChargingRodTravel());


function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function ForendFrontLength() = UpperLength()-BarrelX()-BreechPlateThickness();

module BarrelCollar(clearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") DebugHalf(enabled=debug)
  difference() {
    translate([BarrelX(),0,0])
    rotate([0,90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth(), $fn=40);
    
    if (!cutter)
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

module ChargingRod(cutter=false) {
  rotate([ChargingRodAngle(),0,0])
  translate([ChargingRodMinX(),0,ChargingRodOffset()])
  union() {
    
    // Charging rod
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=ChargingRodLength(),
              clearance=cutter?RodClearanceLoose():undef);
  
    // Actuator rod
    translate([-ChargingRodMinX()+ActuatorRodX(),0,-RodRadius(ChargingRod())])
    mirror([0,0,1])
    hull() {
      Rod(ActuatorRod(),
          length=0.49);
      
      if (cutter) {
        translate([-ChargingRodTravel()-ZigZagWidth(),0,0])
        Rod(ActuatorRod(),
            length=0.49);
      }
    }
  }
}

module RevolverCylinder(supports=false, chambers=false, debug=false) {
  translate([BreechFrontX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  rotate([0,0,-30*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8)])
  rotate([0,0,-30*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98)])
  OffsetZigZagRevolver(positions=positions,
      centerOffset=RevolverSpindleOffset(),
      trackAngle=360/positions/2,
      supports=supports, extraTop=ActuatorPretravel(),
      chambers=chambers, chamberLength=BarrelX()-0.01,
      debug=debug, alpha=1.25);
}

module RevolverSpindle(cutter=false) {
  color("Silver")
  translate([BreechRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=UpperLength(),//-BreechRearX()+BarrelX()+(BarrelCollarWidth()*2),
      clearance=cutter?RodClearanceSnug():undef);
}

module RevolverForegrip(debug=false, alpha=1) {
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    
    hull() {
      
      // Body around the barrel
      translate([BreechRearX()+UpperLength()+ChargingRodTravel(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelCollarRadius(), r2=1/16,
               h=ForegripLength(),
               $fn=Resolution(20,40));
      
      // Body around the charging rod
      translate([BreechRearX()+UpperLength()+ChargingRodTravel(),-0.25,0])
      rotate([0,90,0])
      mirror([1,0,0])
      ChamferedCube([BreechBoltOffsetZ()+WallBreechBolt()+BreechBoltRadius(),
                     0.5, ForegripLength()], r=1/16);
    }
    
    Barrel(hollow=false, clearance=PipeClearanceLoose());
    
    ChargingRod(cutter=true);
    
    RevolverSpindle(cutter=true);
  }
}

module RevolverForend(debug=false, alpha=1) {
  
  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Body around the barrel collar
      translate([BarrelX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelCollarRadius()+0.25, r2=1/16,
               h=UpperLength()-BarrelX()-BreechPlateThickness()-ManifoldGap(2),
               $fn=Resolution(20,40));
      
      translate([UpperLength()-BreechPlateThickness(),-BreechPlateWidth()/2,0])
      rotate([0,-90,0])
      ChamferedCube([BreechBoltOffsetZ()+BreechBoltRadius()+WallBreechBolt(),
                     BreechPlateWidth(),
                     UpperLength()-BreechPlateThickness()], r=1/16);
      
      
      color("Silver")
      translate([BarrelX(),0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      ChamferedCylinder(r1=RodRadius(CylinderRod())+0.1875, r2=1/16,
               h=ForendFrontLength()-ManifoldGap(2),
               $fn=Resolution(20,40));
    }
    
    // Revolver cylinder cutout
    translate([BarrelX(),0,-RevolverSpindleOffset()])
    rotate([0,-90,0])
    cylinder(r=radius+0.005, h=UpperLength(), $fn=Resolution(40,100));
    
    BreechBolts(length=UpperLength(), cutter=true);
    
    translate([-ManifoldGap(),0,0]) {
      Barrel(hollow=false, clearance=PipeClearanceSnug());
      
      BarrelCollar(cutter=true);
    }
    
    ChargingRod(cutter=true);
    
    RevolverSpindle(cutter=true);
  }
}

module RevolverShotgunAssembly(pipeAlpha=1, debug=false) {
  
  hammerTravelFactor = Animate(ANIMATION_STEP_FIRE)
                     - SubAnimate(ANIMATION_STEP_CHARGE, start=0.275, end=0.69);
  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);
  
  triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                             - Animate(ANIMATION_STEP_TRIGGER_RESET);

  BreechPipeUpperAssembly(pipeAlpha=pipeAlpha, breechBoltLength=UpperLength(),
                    triggerAnimationFactor=triggerAnimationFactor,
                    hammerTravelFactor=hammerTravelFactor, 
                    chargingHandle=false, frame=true,  stock=true,
                    receiverLength=12, debug=debug);
  
  RevolverSpindle();
  RevolverCylinder(supports=false, chambers=true, debug=false);

  translate([-ChargingRodTravel()*chargingRodAnimationFactor,0,0]) {
    ChargingRod(debug=debug);
    RevolverForegrip(debug=debug);
  }
  
  Barrel(debug=debug);
  BarrelCollar(debug=debug);

  RevolverForend(debug=debug, alpha=1);
}

//AnimateSpin()translate([-2.5,0,0])
RevolverShotgunAssembly(pipeAlpha=0.5, debug=true, positions=positions);

$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=0);
//$t=0;

**!scale(25.4)
rotate([0,90,0])
translate([-BarrelX(),0,RevolverSpindleOffset()])
RevolverSpindle(debug=false);

!scale(25.4)
translate([-BreechBoltOffsetZ(),0,0])
rotate([0,-90,0])
RevolverCylinder(supports=true, chambers=false, debug=false);