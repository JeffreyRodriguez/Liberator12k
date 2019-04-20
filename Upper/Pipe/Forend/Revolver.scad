include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Math/Triangles.scad>;

use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pipe/Lugs.scad>;

use <../../../Lower/Lower.scad>;
use <../../../Lower/Trigger.scad>;

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


// Settings: Lengths
function ChamberLength() = 3;
function CraneLengthRear() = 0.5;
function CraneLengthFront() = 0.5;
function BarrelLength() = 18-ChamberLength();
function ActuatorPretravel() = 0.125;
function ForendGasGap() = 0.625;
function RevolverSpindleOffset() = 31/32;
function WallCrane() = 0.25;
function WallBarrel() = 0.375;


// Settings: Vitamins
function BarrelPipe() = Spec_TubingZeroPointSevenFive();
function BarrelPipe() = Spec_TubingOnePointOneTwoFive();
//function BarrelPipe() = Spec_PipeThreeQuarterInch();
//function BarrelPipe() = Spec_TubingOnePointZero();
function BarrelSleevePipe() = Spec_PipeOneInch();
function CranePivotRod() = Spec_RodFiveSixteenthInch();

// Shorthand: Measurements
function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelSleeveRadius(clearance=undef)
    = PipeOuterRadius(BarrelSleevePipe(), clearance);

function BarrelSleeveDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelSleevePipe(), clearance);

positions = 4;
radius = RevolverCylinderRadius(
             centerOffset=RevolverSpindleOffset(),
             chamberRadius=BarrelSleeveRadius(PipeClearanceSnug()));
height = RevolverCylinderHeight(radius, positions=positions, zigzagAngle=45)+ActuatorPretravel();

// Calculated: Lengths
function ForendFrontLength() = FrameUpperBoltExtension()-ChamberLength();

// Calculated: Positions
function ForendFrontX() = RecoilPlateRearX()+FrameUpperBoltExtension();

function RecoilPlateTopZ() = ReceiverOR()
                           + FrameUpperBoltDiameter()
                           + (WallFrameUpperBolt()*2);
                           
                           
function CranePivotAngle() = 90;
function CranePivotY() = 28/32;//FrameUpperBoltOffsetY();//1.35;//1;
function CranePivotZ() = 19/32;//FrameUpperBoltOffsetZ();// 1.35;//RevolverSpindleOffset();//+1.355+1;


// 1.125" OD (A513 DOM) chambers
module RevolverCylinder_DOM5(positions=5, supports=false, chambers=false,
                             chamberBolts=true, cutter=false, debug=false) {
  
  translate([0,0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
  rotate(360/positions/2)
  OffsetZigZagRevolver(positions=positions, depth=3/16,
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=1.135/2, chamberInnerRadius=0.813/2,
      chamberBolts=chamberBolts, boltOffset=1.875,
      teardrop=false, zigzagAngle=49.35,
      supports=supports,  extraTop=ActuatorPretravel(), //+0.25896
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.0, cutter=cutter);
}

// 1.335" OD (A53 ERW Pipe) chambers
module RevolverCylinder_ERW4(positions=4, supports=false, chambers=false,
                             chamberBolts=true, cutter=false,
                             debug=false) {
  translate([0,0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
  OffsetZigZagRevolver(positions=positions,
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=BarrelSleeveRadius(PipeClearanceSnug()), chamberInnerRadius=0.813/2,
      chamberBolts=chamberBolts, wall=0.145, //0.15625,
      supports=supports, extraTop=ActuatorPretravel(),
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.0, cutter=cutter);
}
module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([ChamberLength(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);
}

module ChamberDrillJig() {
  render()
  difference() {
    translate([-1.75/2,-1.75/2,0])
    ChamferedCube([1.75, 1.75, height], r=1/16);
      
    ChamferedCircularHole(r1=BarrelRadius(PipeClearanceSnug()),
                          r2=1/16, h=height, $fn=40);
      
    linear_extrude(height=height)
    translate([0,-1/32])
    square([1.75, 1/16], center=false);
    
    for (Z = [0.625, height-0.625])
    translate([0,0,Z])
    rotate([0,-90,0])
    linear_extrude(height=height)
    Teardrop(r=0.0625, $fn=10);
  }
}

module RevolverSpindle(teardrop=false, cutter=false) {
  color("Silver")
  translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=FrameUpperBoltExtension()-RecoilPlateRearX()+CraneLengthFront()+ManifoldGap(),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=cutter&&teardrop);
}

module RevolverRecoilPlateHousing(debug=false) {
  color("MediumSlateBlue")
  DebugHalf(enabled=debug)
  difference() {
    RecoilPlateHousing(topHeight=FrameUpperBoltOffsetZ(),
                       bottomHeight=-LowerOffsetZ(),
                       debug=false) {

      // Backing plate for the cylinder
      translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      ChamferedCylinder(r1=1, r2=1/16,
               h=abs(RecoilPlateRearX())-ManifoldGap(), $fn=50);
      
      // Frame upper support
      translate([RecoilPlateRearX(),0,0])
      hull()
      FrameUpperBoltSupport(length=-RecoilPlateRearX());
    }

    FrameUpperBolts(cutter=true);

    translate([RecoilPlateRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=true, teardrop=false);

    RevolverSpindle(cutter=true);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true, actuator=false, pin=false);
  }
}

module CranePivot(angle=CranePivotAngle(), factor=1) {
  translate([0,CranePivotY(),CranePivotZ()])
  rotate([angle*factor,0,0])
  translate([0,-CranePivotY(),-CranePivotZ()])
  children();
}

module RevolverCraneRod(cutter=false, teardrop=false) {
  color("Silver")
  translate([ChamberLength()-ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=ForendFrontLength()+CraneLengthFront()+ManifoldGap(2),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=teardrop&&cutter);
}

module RevolverCraneProfile(length=CraneLengthRear()) {
  union() {
      
    // Around the crane rod
    translate([FrameUpperBoltExtension(),CranePivotY(),CranePivotZ()])
    rotate([0,-90,0])
    ChamferedCylinder(r1=RodRadius(CranePivotRod())+0.1875, r2=1/16,
             h=length,
             $fn=Resolution(20,60));
    
    // Around the spindle rod
    translate([FrameUpperBoltExtension(),0,-RevolverSpindleOffset()])
    rotate([0,-90,0])
    ChamferedCylinder(r1=RodRadius(CylinderRod())+0.25, r2=1/16,
             h=length,
             $fn=Resolution(20,60));
    
    translate([FrameUpperBoltExtension(),BarrelRadius(),0])
    mirror([1,0,0])
    ChamferedCube([length,
                   CranePivotY()+RodRadius(CranePivotRod())+0.1875-BarrelRadius(),
                   CranePivotZ()],
                  chamferXYZ=[false, false, true],
                  r=1/16);
  
    // Body around the barrel
    difference() {
      intersection() {
        translate([FrameUpperBoltExtension(),0,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=CranePivotY()+RodRadius(CranePivotRod())+0.1875, r2=1/16,
                 h=length,
                 $fn=Resolution(30,60));
        
        translate([FrameUpperBoltExtension(),0,0])
        rotate([0,-90,0])
        linear_extrude(height=length)
        rotate(180)
        semicircle(od=(BarrelRadius()+(WallBarrel()*2))*2,
                  angle=90, $fn=Resolution(30,60));
      }
      
      translate([FrameUpperBoltExtension(),0,0])
      rotate([0,-90,0])
      ChamferedCircularHole(r1=BarrelRadius(), r2=(1/16), h=length, $fn=Resolution(20,60));
    }
  }
}


module RevolverCrane(cutter=false, teardrop=false) {
  length = CraneLengthFront() + ForendFrontLength()-ForendGasGap()+CraneLengthRear();
  
  color("Tomato") render()
  difference() {
    
    union() {
      // Cylinder-side
      translate([-ForendFrontLength()+ForendGasGap(),0,0])
      RevolverCraneProfile();
      
      // Barrel-side
      translate([0.5,0,0])
      RevolverCraneProfile(length=CraneLengthFront());
      
      // Joint
      translate([FrameUpperBoltExtension()+CraneLengthFront(),0,0])
      rotate([0,-90,0])
      difference() {
        intersection() {
          ChamferedCylinder(r1=CranePivotY()+RodRadius(CranePivotRod())+0.1875, r2=1/16,
                   h=length,
                   $fn=Resolution(30,60));
          
          linear_extrude(height=length)
          rotate(155)
          semicircle(od=(BarrelRadius()+(WallBarrel()*2))*2,
                    angle=65, $fn=Resolution(30,60));
        }
        
        ChamferedCircularHole(r1=BarrelRadius()+WallBarrel()+0.015,
                              r2=(1/16),
                              h=length, $fn=Resolution(20,60));
      }
    }
    
    
    RevolverCraneRod(cutter=true);

    RevolverSpindle(cutter=true);
    
    Barrel(hollow=false, cutter=true);
  }
}

module RevolverForend(debug=false, alpha=1) {
  
  // Forward plate
  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Top strap/bolt wall
      hull()
      FrameUpperBoltSupport(length=FrameUpperBoltExtension());
      
      // Join the barrel collar to the top strap
      translate([FrameUpperBoltExtension(),0,0])
      mirror([1,0,0]) {
        
        // Spindle body
        hull()
        for (Z = [0,-RevolverSpindleOffset()])
        translate([0,0,Z])
        rotate([0,90,0])
        ChamferedCylinder(r1=RodRadius(CylinderRod())+0.25, r2=1/16,
                 h=ForendFrontLength()-ForendGasGap(),
                 $fn=Resolution(20,40));
        
        // Around the barrel
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=1/16,
                 h=ForendFrontLength()-ForendGasGap(),
                 $fn=Resolution(20,60));
        
        hull() {
          FrameUpperBoltSupport(length=ForendFrontLength()-ForendGasGap());
      
          // Around the crane pivot pin
          translate([0,CranePivotY(),CranePivotZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=RodRadius(CranePivotRod())+(7/32), r2=1/16,
                   h=ForendFrontLength()-ForendGasGap(),
                   $fn=Resolution(20,60));
        }
        
        // Join the barrel to the frame
        translate([0,-(BarrelRadius()+WallBarrel()),0])
        ChamferedCube([ForendFrontLength()-ForendGasGap(),
                       (BarrelRadius()+WallBarrel())*2,
                       FrameUpperBoltOffsetZ()], r=1/16);
      }
    }
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), RecoilPlateTopZ()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(cutter=true);

    Barrel(hollow=false, clearance=PipeClearanceLoose());

    ChargingRod(cutter=true);

    RevolverSpindle(cutter=true);
    
    // Swingout spindle        
    translate([FrameUpperBoltExtension(),CranePivotY(),CranePivotZ()])
    rotate([0,-90,0])
    linear_extrude(height=ForendFrontLength()-ForendGasGap())
    rotate(-150)
    semidonut(major=3.9,
              minor=3.26,
              angle=15, $fn=Resolution(30,80));
    
    RevolverCraneRod(cutter=true);
    RevolverCrane(cutter=true);
  }
}

module RevolverFrameAssembly(receiverLength=12, debug=false) {
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly();
                                 
  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0])
  FrameLower();
  
  FrameUpper(debug=debug);

  FrameUpperBolts(extraLength=FrameUpperBoltExtension(), cutter=false);
}

module RevolverShotgunAssembly(receiverLength=12, stock=true, tailcap=false,
                               pipeAlpha=1, debug=false) {
 
  RevolverRecoilPlateHousing();
  RecoilPlateFiringPinAssembly(); 
  RecoilPlate(debug=debug);
  
  ChargingPumpAssembly();
  
  RevolverFrameAssembly(debug=debug);
  
  Barrel(debug=debug);

  RevolverCraneRod();
  
  CranePivot(factor=Animate(ANIMATION_STEP_UNLOAD)
                   -Animate(ANIMATION_STEP_LOAD)) {
    RevolverSpindle();
    RevolverCrane();
    
    RevolverCylinder_DOM5(supports=false, chambers=true, debug=false);
    *RevolverCylinder_ERW4(supports=false, chambers=true, debug=false);
  }
  
  RevolverForend(debug=debug, alpha=1);
}


RevolverShotgunAssembly(pipeAlpha=1, debug=false, positions=positions);


translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.2,
                  receiverLength=12,
                  frame=false,
                  stock=true, tailcap=false,
                  debug=false);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=$t);
//$t=AnimationDebug(ANIMATION_STEP_UNLOAD, T=1);
//$t=0;



/*
 * Platers
 */
 
 
// Revolver Cylinder shell
*!scale(25.4) render()
difference() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder_DOM5(supports=true, chambers=false, chamberBolts=false, debug=false);
  //RevolverCylinder_ERW4(supports=true, chambers=false, debug=false);

  translate([0,0,-ManifoldGap()])
  cylinder(r=RevolverSpindleOffset()-0.125, h=ChamberLength()+ManifoldGap(2), $fn=20);
}

// Revolver Cylinder core
*!scale(25.4) render()
intersection() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder_DOM5(supports=true, chambers=false, chamberBolts=false, debug=false);
  //RevolverCylinder_ERW4(supports=true, chambers=false, debug=false);

  translate([0,0,-ManifoldGap()])
  cylinder(r=RevolverSpindleOffset()-0.25, h=ChamberLength()+ManifoldGap(2), $fn=20);
}
 
*!scale(25.4) rotate([0,90,0]) translate([-UpperLength(),0,0])
RevolverForend();

*!scale(25.4) rotate([0,90,0]) translate([-UpperLength()-0.375,0,0])
RevolverCrane();

*!scale(25.4) rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
RevolverRecoilPlateHousing();
