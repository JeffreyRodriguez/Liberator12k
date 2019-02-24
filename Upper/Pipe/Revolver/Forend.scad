include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
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
use <../Linear Hammer.scad>;
use <Breech.scad>;

// Measured: Vitamins
function BarrelCollarDiameter() = 1.75;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = 5/8;

// Settings: Vitamins
function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
function BarrelPipe() = Spec_PipeThreeQuarterInch();
//function BarrelPipe() = Spec_TubingOnePointZero();
function BarrelSleevePipe() = Spec_PipeOneInch();
//function BarrelSleevePipe() = Spec_TubingOnePointZero();
function SquareRodFixingBolt() = Spec_BoltM3();
function LockingRod() = Spec_RodOneQuarterInch();

positions = 6;
radius = RevolverCylinderRadius(
             centerOffset=RevolverSpindleOffset(),
             chamberRadius=BarrelSleeveRadius(PipeClearanceSnug()));


// Settings: Lengths
function ChamberLength() = 3.5;
function BarrelLength() = 18-ChamberLength();
function UpperLength() =  6;
function IndexLockOffset() = 0.5;
function ActuatorPretravel() = 0.125;
function ForegripLength() = 4;
function ForegripChargingGap() = 0.5;

/* How far does the stationary portion of the square rod
 extend into the part that holds it? */
function ChargingRodStaticLength() = 1.5;


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
function ForendFrontLength() = UpperLength()-ChamberLength()-BreechRearX();
function ChargingRodTravel() = ActuatorPretravel()
                             + ZigZagHeight(radius, positions, ZigZagWidth(), 45)
                             + (ZigZagWidth()/2);
                             

// Calculated: Positions
function RevolverSpindleOffset() = BarrelSleeveDiameter(PipeClearanceSnug());
function ChargingRodLength() = abs(ChargingRodMinX())
                             + BreechRearX()
                             + UpperLength()
                             + ChargingRodTravel()
                             + ChargingRodStaticLength()
                             + ForegripChargingGap();
function ActuatorRodX() = (ZigZagWidth()/2)+ChargingRodTravel();
function ForendFrontX() = BreechRearX()+UpperLength();
function ForegripFrontX() = ForendFrontX()+ChargingRodTravel()+ForegripChargingGap();
function ForegripRearX() = ForegripFrontX()-ForegripLength();

module FrameSupportFront(debug=false, alpha=1) {
  translate([ForendFrontX(),0,0])
  mirror([1,0,0])
  FrameSupport(debug=debug, alpha=alpha);
}



module RevolverBreech(debug=false) {
  color("Orange")
  DebugHalf(enabled=debug)
  difference() {
    Breech(debug=false, spindleOffset=RevolverSpindleOffset()) {

      translate([BreechRearX(),0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      ChamferedCylinder(r1=RevolverSpindleOffset(), , r2=1/16,
               h=abs(BreechRearX())-ManifoldGap(), $fn=50);
    }

    BreechBolts(cutter=true);

    translate([BreechRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=true);

    // Revolver spindle
    translate([BreechRearX()-ManifoldGap(),0,-RevolverSpindleOffset()])
    rotate([0,90,0])
    Rod(CylinderRod(),
        length=abs(BreechRearX())+ManifoldGap(2),
        cutter=true);

    rotate([0,90,0])
    cylinder(r=0.125, h=1, center=true, $fn=12);

    translate([BreechPlateThickness(),0,0])
    ChargingRod(travel=ChargingRodTravel(), cutter=true, actuator=false, pin=false);
  }
}

module RevolverFrameTest(debug=false) {
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {
    translate([BreechRearX(),-(2/2),ReceiverIR()/2])
    mirror([1,0,0])
    ChamferedCube([0.5,
                   2,
                   BreechTopZ()-(ReceiverIR()/2)+1],
                  r=1/16);

    PipeLugPipe(cutter=true);

    BreechBolts(cutter=true);
  }
}

module RevolverFrameUpper(debug=false) {
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {

    // Pipe Lug Center
    translate([BreechRearX(),-(2/2),ReceiverIR()/2])
    mirror([1,0,0])
    ChamferedCube([BreechBoltRearExtension()-0.26-ManifoldGap(2),
                   2,
                   BreechTopZ()-(ReceiverIR()/2)],
                  r=1/16);

    PipeLugPipe(cutter=true);

    BreechBolts(cutter=true);
    
    translate([BreechRearX(),-(0.52/2),ReceiverIR()/2])
    mirror([1,0,0])
    cube([BreechBoltRearExtension(),0.52,BreechTopZ()+ManifoldGap(2)]);

    // Charging rod cutout
    hull() {
      for (Z = [0,ChargingRodOffset()]) translate([0,0,Z])
      rotate([0,-90,0])
      SquareRod(ChargingRod(),
          length=5,
          clearance=RodClearanceLoose());
    }
  }
}

module BarrelCollar(clearance=0.008, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") DebugHalf(enabled=debug)
  difference() {
    for (X = [0, ForendFrontLength()])
    translate([X+ChamberLength()+BarrelCollarWidth(),0,0])
    rotate([0,-90,0])
    cylinder(r=BarrelCollarRadius()+clear,
             h=BarrelCollarWidth()+(cutter?ChamberLength():0), $fn=40);

    if (!cutter)
    Barrel(hollow=false, cutter=true);
  }
}

module BarrelSleeve(clearance=undef, cutter=false, debug=false) {
  color("Silver") DebugHalf(enabled=debug)
  translate([ChamberLength(),0,0])
  rotate([0,90,0])
  Pipe(pipe=BarrelSleevePipe(), taperBottom=true,
       length=ForendFrontLength(),
       hollow=!cutter, clearance=clearance);

}

module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([ChamberLength(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

module RevolverCylinder(supports=false, chambers=false, cutter=false, debug=false) {
  translate([BreechFrontX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  rotate([0,0,-30*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8)])
  rotate([0,0,-30*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98)])
  OffsetZigZagRevolver(positions=positions,
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=BarrelSleeveRadius(PipeClearanceSnug()),
      trackAngle=360/positions/2,
      supports=supports, extraTop=ActuatorPretravel(),
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.25, cutter=cutter);
}

module RevolverSpindle(cutter=false) {
  color("Silver")
  translate([BreechRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=UpperLength(),//-BreechRearX()+ChamberLength()+(BarrelCollarWidth()*2),
      clearance=cutter?RodClearanceSnug():undef);
}

module RevolverForegrip(debug=false, alpha=1, $fn=Resolution(20,50)) {

  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {

    union() {

      // Body around the charging rod
      hull() {
        translate([ForegripFrontX(),-RodRadius(ChargingRod())-0.25,0])
        rotate([0,90,0])
        mirror([1,0,0])
        ChamferedCube([ChargingRodOffset()+RodRadius(ChargingRod())+0.125,
                       RodDiameter(LockingRod())+0.5,
                       ChargingRodStaticLength()], r=1/8);
        
        // Body around the barrel
        translate([ForegripFrontX(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=ReceiverOR(), r2=1/16,
                 h=ChargingRodStaticLength());
      }
      
      // Body around the barrel
      translate([ForegripFrontX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverOR(), r2=1/16,
               h=ForegripLength());
    }

    // Gripping cutouts
    for (X = [ChargingRodStaticLength()+0.1875:0.75:ForegripLength()-0.75])
    translate([ForegripFrontX()+X,0,0])
    rotate([0,90,0])
    for (M = [0,1]) mirror([0,0,M])
    TeardropTorus(majorRadius=ReceiverOR()-0.125, minorRadius=1/8);

    // Barrel hole, but with a bearing profile
    Barrel(hollow=false, cutter=true);
    translate([ForegripFrontX()+(ForegripLength()/2),0,0])
    rotate([0,90,0])
    BearingSurface(r=BarrelRadius(PipeClearanceLoose()), length=ForegripLength(),
                   depth=0.0625, segment=0.25, taperDepth=0.125, center=true);

    for (R = [0,-90,180]) rotate([R,0,0])
    translate([ForegripFrontX()-ManifoldGap(), ReceiverOR(),0])
    rotate([0,90,0])
    cylinder(r=1/8, h=ForegripLength()+ManifoldGap(2));

    ChargingRod(length=ChargingRodLength(),
                travel=ChargingRodTravel(),
                clearance=RodClearanceSnug(), cutter=true);
    RevolverSpindle(cutter=true);
  }
}

module RevolverForend(debug=false, alpha=1) {

  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {

      // Top strap
      translate([BreechRearX()+UpperLength(),-1,0])
      rotate([0,-90,0])
      ChamferedCube([BreechBoltOffsetZ()+BreechBoltRadius()+WallBreechBolt(),
                     2,
                     BreechRearX()+UpperLength()], r=1/16);

      hull() {
        // Body around the barrel collar
        translate([BreechRearX()+UpperLength(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=ReceiverOR(), r2=1/16,
                 h=UpperLength()-ChamberLength()+BreechRearX()-ManifoldGap(2),
                 $fn=Resolution(20,40));

        // Spindle body
        translate([BreechRearX()+UpperLength(),0,-RevolverSpindleOffset()])
        rotate([0,-90,0])
        ChamferedCylinder(r1=RodRadius(CylinderRod())+0.1875, r2=1/16,
                 h=ForendFrontLength()-ManifoldGap(2),
                 $fn=Resolution(20,40));
      }
    }
    
    // Cutout for a picatinny rail insert
    translate([BreechFrontX()-ManifoldGap(), -UnitsMetric(15.6/2), BreechTopZ()-0.125])
    cube([BreechRearX()+UpperLength()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    RevolverCylinder(cutter=true);

    BreechBolts(length=UpperLength()+BreechBoltRearExtension(), cutter=true);

    translate([-ManifoldGap(),0,0]) {
      Barrel(hollow=false, clearance=PipeClearanceSnug());

      BarrelSleeve(clearance=PipeClearanceSnug(), cutter=true);
      *BarrelCollar(cutter=true);
    }

    ChargingRod(length=ChargingRodLength(),
                travel=ChargingRodTravel(),
                cutter=true);

    RevolverSpindle(cutter=true);
  }
}

  triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                             - Animate(ANIMATION_STEP_TRIGGER_RESET);
module RevolverShotgunAssembly(receiverLength=12, stock=true, tailcap=false,
                               pipeAlpha=1, debug=false) {
 
  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);


  BreechAssembly(showBreech=false,
                 chargingRodLength=ChargingRodLength(), chargingRodTravel=ChargingRodTravel(),
                                 chargingRodAnimationFactor=chargingRodAnimationFactor,
                 breechBoltLength=UpperLength()+BreechBoltRearExtension(),
                 debug=debug);
  RevolverBreech(debug=debug);
                                 
  *ChargingRod(length=ChargingRodLength(),
              travel=ChargingRodTravel(),
              cutter=false, animationFactor=chargingRodAnimationFactor);

  *translate([BreechRearX(),0,0])
  PipeUpperAssembly(pipeAlpha=pipeAlpha,
                    receiverLength=receiverLength,
                    chargingHandle=false,
                    frameUpper=false,
                    stock=stock, tailcap=tailcap,
                    triggerAnimationFactor=triggerAnimationFactor,
                    debug=debug);


  RevolverFrameUpper(debug=debug);
  
  *FrameSupportFront(debug=debug);
  *FrameSupportRear(debug=debug);

  Barrel(debug=debug);
  BarrelSleeve(debug=debug);
  *BarrelCollar(debug=debug);

  RevolverSpindle();
  RevolverCylinder(supports=false, chambers=true, debug=false);

  translate([]) {

    translate([-ChargingRodTravel()*chargingRodAnimationFactor,0,0]) {
      RevolverForegrip(debug=debug, alpha=1);
    }
  }

  RevolverForend(debug=debug, alpha=1);


}

//AnimateSpin()translate([-2.5,0,0])
//for (R = [-1,1]) rotate([60*R,0,0]) translate([0,0,-RevolverSpindleOffset()])
RevolverShotgunAssembly(pipeAlpha=1, debug=true, positions=positions);



translate([BreechRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  chargingHandle=false,
                  frameUpper=false,
                  stock=true, tailcap=false,
                  triggerAnimationFactor=triggerAnimationFactor,
                  debug=false);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=0);
//$t=0;



/*
 * Platers
 */

// Printed mock breech (quick 'n dirty)
*!scale(25.4) rotate([0,-90,0])
RevolverBreech();

// Foregrip
*!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
RevolverForegrip();

*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-BreechRearX(),0,0])
RevolverForend();

// Revolver Forend Rear
*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-BreechRearX(),0,0])
render() intersection() {
  RevolverForend();

  translate([0,-1, 0])
  cube([ChamberLength(), 2, BreechBoltOffsetZ()*2]);
}

// Revolver Forend Front
*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-BreechRearX(),0,0])
render() difference() {
  RevolverForend();

  translate([0,-1, 0])
  cube([ChamberLength(), 2, BreechBoltOffsetZ()*2]);
}

// Revolver Cylinder shell
*!scale(25.4) render()
difference() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder(supports=true, chambers=false, debug=false);

  translate([0,0,-ManifoldGap()])
  cylinder(r=BarrelDiameter(), h=ChamberLength()+ManifoldGap(2), $fn=20);
}

// Revolver Cylinder core
*!scale(25.4) render()
intersection() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder(supports=true, chambers=false, debug=false);

  translate([0,0,-ManifoldGap()])
  cylinder(r=BarrelDiameter(), h=ChamberLength()+ManifoldGap(2), $fn=20);
}

// Revolver Frame Upper
*!scale(25.4)
translate([-ReceiverOR(),0,BreechRearX()])
rotate([0,90,0])
RevolverFrameUpper();

// Test part for holding in vise
*!scale(25.4)
rotate([0,90,0])
translate([-BreechRearX(),0,0])
RevolverFrameTest();