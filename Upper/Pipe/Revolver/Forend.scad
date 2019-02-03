include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pipe/Lugs.scad>;

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
function BarrelSleevePipe() = Spec_PipeOneInch();
function ChargingRod() = Spec_RodOneQuarterInch();
function SquareRodFixingBolt() = Spec_BoltM3();
function LockingRod() = Spec_RodOneQuarterInch();

positions = 6;
radius = RevolverCylinderRadius(
             centerOffset=RevolverSpindleOffset(),
             chamberRadius=BarrelSleeveRadius(PipeClearanceSnug()));


// Settings: Lengths
function ChamberLength() = 3.6;
function BarrelLength() = 18-ChamberLength();
function UpperLength() =  6;
function IndexLockOffset() = 0.5;
function ActuatorPretravel() = 0.5;
function ForegripLength() = 5;
function ForegripChargingGap() = 0.5;
function LockingRockerAngle() = 18;
function LockingRockerRadius() = 1;

/* How far does the stationary portion of the square rod
 extend into the part that holds it? */
function LockingRodStaticLength() = 1;
function ChargingRodStaticLength() = 1;
function LockingRodDynamicLength() = 2;


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
function ForendFrontLength() = UpperLength()-ChamberLength()-BreechPlateThickness();
function ChargingRodTravel() = ActuatorPretravel()
                             + ZigZagHeight(radius, positions, ZigZagWidth())
                             + (ZigZagWidth()/2);
function LockingRodLength() = ChargingRodStaticLength()
                            + ForegripChargingGap()
                            + ChargingRodTravel()
                            + LockingRodDynamicLength();


// Calculated: Positions
function RevolverSpindleOffset() = BarrelSleeveDiameter(PipeClearanceSnug());
function ChargingRodMinX() = BreechRearX()-1;
function ChargingRodOffset() = BreechBoltOffsetZ();
function ChargingRodLength() = abs(ChargingRodMinX())
                             - BreechPlateThickness()
                             + UpperLength()
                             + ChargingRodTravel()
                             + ChargingRodStaticLength()
                             + ForegripChargingGap();
function ActuatorRodX() = (ZigZagWidth()/2)+ChargingRodTravel();
function ForendFrontX() = BreechRearX()+UpperLength();
function ForegripFrontX() = ForendFrontX()+ChargingRodTravel()+ForegripChargingGap();
function ForegripRearX() = ForegripFrontX()-ForegripLength();
function LockingRodRearX() = ForendFrontX()-LockingRodStaticLength();
function LockingRodOffsetY() = 0.5;
function LockingRodOffsetZ() = 1-RodRadius(LockingRod());

function LockingRockerPivotX() = ForegripFrontX()
                             + LockingRodDynamicLength()
                             + LockingRockerRadius();



echo("Barrel sleeve length: ", ForendFrontLength()+ForegripChargingGap());
echo("Locking Rod Length: ", LockingRodLength());

module RevolverBreech() {
  render()
  difference() {
    Breech(debug=false, spindleOffset=RevolverSpindleOffset()) {
    
      translate([BreechRearX(),0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      cylinder(r=RevolverSpindleOffset(), h=BreechPlateThickness(), $fn=50);
    }
    
    rotate([0,90,0])
    cylinder(r=0.125, h=1, center=true, $fn=12);
    
    translate([BreechPlateThickness(),0,0])
    ChargingRod(cutter=true);
  }
}

module RevolverFrameUpper(debug=false) {
  color("Olive")
  DebugHalf(enabled=debug)
  difference() {
    
    // Pipe Lug Center
    translate([BreechRearX(),-(2/2),ReceiverIR()/2])
    mirror([1,0,0])
    ChamferedCube([0.75-ManifoldGap(2),
                   2,
                   BreechTopZ()-(ReceiverIR()/2)],
                  r=1/16, chamferXYZ=[1,0,0]);
    
    PipeLugPipe(cutter=true);
    
    BreechBolts(cutter=true);
    
    // Charging rod cutout
    hull() {
      for (Z = [0,BreechBoltOffsetZ()]) translate([0,0,Z])
      rotate([0,-90,0])
      SquareRod(ChargingRod(),
          length=2,
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
       length=ForendFrontLength()+ForegripChargingGap(),
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
      chambers=chambers, chamberLength=ChamberLength()-0.01,
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

module ChargingRod(clearance=RodClearanceLoose(), cutter=false, debug=false) {
  color("Silver") DebugHalf(enabled=debug) {
    
    // Charging rod
    translate([ChargingRodMinX(),0,ChargingRodOffset()])
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=ChargingRodLength()+ManifoldGap(),
              clearance=cutter?clearance:undef);
    
    // Charging Rod Fixing Bolt
    translate([ChargingRodMinX()+ChargingRodLength()-0.5,0,BreechTopZ()])
    Bolt(bolt=SquareRodFixingBolt(), capOrientation=true,
         length=cutter?BreechTopZ():1, clearance=cutter, teardrop=cutter);
  
    // Actuator rod
    translate([ActuatorRodX(),0,ChargingRodOffset()-RodRadius(ChargingRod())])
    mirror([0,0,1])
    hull() {
      Rod(ActuatorRod(), clearance=cutter?RodClearanceSnug():undef,
          length=0.49);
      
      if (cutter) {
        translate([-ChargingRodTravel()-ZigZagWidth(),0,0])
        Rod(ActuatorRod(), clearance=cutter?RodClearanceLoose():undef,
            length=0.49);
      }
    }
  }
}

module LockingRod(clearance=RodClearanceLoose(), debug=false, cutter=false) {
  color("Silver") DebugHalf(enabled=debug)
  for (Y = [-1,1])
  translate([LockingRodRearX(),LockingRodOffsetY()*Y,LockingRodOffsetZ()]) {
    rotate([0,90,0])
    SquareRod(LockingRod(), length=LockingRodLength()+(cutter?ChargingRodTravel():0),
              clearance=cutter?clearance:undef);
    
    // Locking Rod Fixing Bolt
    rotate([-90*Y,0,0])
    translate([0.5,0,RodRadius(LockingRod())])
    rotate(180)
    Bolt(bolt=SquareRodFixingBolt(),
         capHeightExtra=cutter?1:0,
         length=(BreechPlateWidth()/2)-LockingRodOffsetY()-RodRadius(LockingRod()), clearance=cutter, teardrop=cutter);
  }
}

module LockingRocker(animateFactor=0, cutter=false, $fn=Resolution(20,40)) {
  clearance = 0.005;
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  
  if (cutter)
  render() {
    translate([LockingRockerPivotX(),0,LockingRodOffsetZ()-RodRadius(LockingRod())-clear])
    linear_extrude(height=RodDiameter(LockingRod(), RodClearanceLoose())) 
    intersection() {
      Teardrop(r=LockingRockerRadius()+clear);
      
      translate([-LockingRockerRadius(), -LockingRodOffsetY()-RodRadius(LockingRod())])
      square([LockingRockerRadius(),(LockingRodOffsetY()+RodRadius(LockingRod()))*2]);
    }
    
    translate([LockingRockerPivotX(),0,LockingRodOffsetZ()-RodRadius(LockingRod())-clear])
    linear_extrude(height=RodDiameter(LockingRod(), RodClearanceLoose())+0.25) 
    hull() {
      for (X = [0, LockingRockerRadius()]) translate([X,0,0])
      Teardrop(r=(lockingRodGap/2)+clear);
    }
    
    translate([LockingRockerPivotX(),0,0])
    cylinder(r=RodRadius(LockingRod(),RodClearanceSnug())*sqrt(2), h=BreechTopZ());
  }
  
  
  
  lockingRodGap = (LockingRodOffsetY()-RodRadius(LockingRod(), RodClearanceLoose()))*2;
  
  translate([LockingRockerPivotX(),0,LockingRodOffsetZ()-RodRadius(LockingRod())-clear])
  rotate((LockingRockerAngle())*(1-animateFactor))
  color("Gold") render()
  union() {
    
    {
      
      // Inner locking block
      linear_extrude(height=RodDiameter(LockingRod())) {
        difference() {
          union() {
            intersection() {
              translate([-LockingRockerRadius(), -lockingRodGap/2])
              square([LockingRockerRadius(),lockingRodGap]);
              
              circle(r=LockingRockerRadius(), $fn=Resolution(20,40));
            }
            
            Teardrop(r=(lockingRodGap/2));
          }
          
          rotate(45)
          SquareRod2d(LockingRod(), RodClearanceSnug());
        }
      }
        
      // Tab for pushing
      *if (!cutter)
      //rotate((LockingRockerAngle())*(1-animateFactor))
      translate([0,0,0.5])
      linear_extrude(height=0.25)
      hull() {
        translate([0,LockingRockerRadius()/2])
        square([LockingRockerRadius(),LockingRockerRadius()/2]);
        
        circle(r=lockingRodGap/2, $fn=Resolution(20,40));
        
        *circle(r=LockingRockerRadius(), $fn=Resolution(20,40));
      }
    }
  }
}

module RevolverForegrip(debug=false, alpha=1, $fn=Resolution(20,30)) {
  
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    
    union() {
      
      // Body around the charging rod
      translate([ForegripFrontX(),-RodRadius(LockingRod())-0.25,0])
      rotate([0,90,0])
      mirror([1,0,0])
      ChamferedCube([BreechTopZ(),
                     RodDiameter(LockingRod())+0.5,
                     LockingRodStaticLength()], r=1/8);
      
      // Body around the action locking rods
      translate([ForegripFrontX(),-LockingRodOffsetY()-RodDiameter(LockingRod()),0])
      rotate([0,90,0])
      mirror([1,0,0])
      ChamferedCube([LockingRodOffsetZ()+RodRadius(LockingRod())+0.125,
                     (LockingRodOffsetY()+RodDiameter(LockingRod()))*2,
                     ForegripLength()], r=1/8);
      
      difference() {
      
        // Body around the barrel
        translate([ForegripFrontX(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=ReceiverOR(), r2=1/16,
                 h=ForegripLength());
        
        // Gripping cutouts
        for (X = [0.5:0.75:ForegripLength()-0.5])
        translate([ForegripFrontX()+X,0,0])
        rotate([0,90,0])
        for (M = [0,1]) mirror([0,0,M])
        TeardropTorus(majorRadius=ReceiverOR()-0.125, minorRadius=1/8);
      }
    }

    // Barrel hole, but with a bearing profile
    *Barrel(hollow=false, cutter=true);
    translate([ForegripFrontX()+(ForegripLength()/2),0,0])
    rotate([0,90,0])
    BearingSurface(r=BarrelRadius(PipeClearanceLoose()), length=ForegripLength(), 
                   depth=0.0625, segment=0.25, taperDepth=0.125, center=true);
    
    
    LockingRocker(cutter=true);
    ChargingRod(cutter=true);
    LockingRod(cutter=true);
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
      translate([BreechRearX()+UpperLength(),-BreechPlateWidth()/2,0])
      rotate([0,-90,0])
      ChamferedCube([BreechBoltOffsetZ()+BreechBoltRadius()+WallBreechBolt(),
                     BreechPlateWidth(),
                     UpperLength()-BreechPlateThickness()], r=1/16);
      
      hull() {
        // Body around the barrel collar
        translate([BreechRearX()+UpperLength(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=BreechPlateWidth()/2, r2=1/16,
                 h=UpperLength()-ChamberLength()-BreechPlateThickness()-ManifoldGap(2),
                 $fn=Resolution(20,40));
        
        // Spindle body
        translate([BreechRearX()+UpperLength(),0,-RevolverSpindleOffset()])
        rotate([0,-90,0])
        ChamferedCylinder(r1=RodRadius(CylinderRod())+0.1875, r2=1/16,
                 h=ForendFrontLength()-ManifoldGap(2),
                 $fn=Resolution(20,40));
      }
    }
    
    RevolverCylinder(cutter=true);
    
    BreechBolts(length=UpperLength(), cutter=true);
    
    translate([-ManifoldGap(),0,0]) {
      Barrel(hollow=false, clearance=PipeClearanceSnug());
      
      BarrelSleeve(clearance=PipeClearanceSnug(), cutter=true);
      *BarrelCollar(cutter=true);
    }
    
    ChargingRod(cutter=true);
    
    LockingRod(clearance=RodClearanceSnug(), cutter=true);
    
    RevolverSpindle(cutter=true);
  }
}

module RevolverShotgunAssembly(receiverLength=12, stock=true, tailcap=false,
                               pipeAlpha=1, debug=false) {
  
  hammerTravelFactor = Animate(ANIMATION_STEP_FIRE)
                     - SubAnimate(ANIMATION_STEP_CHARGE, start=0.275, end=0.69);
  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);
  
  triggerAnimationFactor = Animate(ANIMATION_STEP_TRIGGER)
                             - Animate(ANIMATION_STEP_TRIGGER_RESET);
  
  
  
  BreechAssembly(breechBoltLength=UpperLength()+BreechBoltRearExtension(), debug=debug);
  RevolverBreech();
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly(travelFactor=hammerTravelFactor);
  
  translate([BreechRearX(),0,0])
  PipeUpperAssembly(pipeAlpha=pipeAlpha,
                    receiverLength=receiverLength,
                    chargingHandle=false,
                    frameUpper=false,
                    stock=stock, tailcap=tailcap,
                    triggerAnimationFactor=triggerAnimationFactor,
                    debug=debug);
                    
                    
  RevolverFrameUpper();

  Barrel(debug=debug);
  BarrelSleeve(debug=debug);
  *BarrelCollar(debug=debug);
  
  RevolverSpindle();
  RevolverCylinder(supports=false, chambers=true, debug=false);
  
  translate([]) {
    LockingRod();
    
    translate([-ChargingRodTravel()*chargingRodAnimationFactor,0,0]) {
      ChargingRod(debug=debug);
      LockingRocker(animateFactor=Animate(ANIMATION_STEP_FIRE)-Animate(ANIMATION_STEP_LOAD));
      RevolverForegrip(debug=debug, alpha=1);
    }
  }

  RevolverForend(debug=debug, alpha=1);


}

//AnimateSpin()translate([-2.5,0,0])
RevolverShotgunAssembly(pipeAlpha=1, debug=false, positions=positions);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_FIRE, T=0);
//$t=0;



/*
 * Platers
 */

// Printed mock breech (quick 'n dirty)
*!scale(25.4) rotate([0,90,0])
RevolverBreech();

// Foregrip
*!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
RevolverForegrip();

// Revolver Forend Rear
*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-BreechRearX(),0,0])
render() intersection() {
  RevolverForend();
  
  translate([0,-BreechPlateWidth()/2, 0])
  cube([ChamberLength(), BreechPlateWidth(), BreechBoltOffsetZ()*2]);
}

// Revolver Forend Front
*!scale(25.4)
rotate([0,90,0])
translate([-UpperLength()-BreechRearX(),0,0])
render() difference() {
  RevolverForend();
  
  translate([0,-BreechPlateWidth()/2, 0])
  cube([ChamberLength(), BreechPlateWidth(), BreechBoltOffsetZ()*2]);
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