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
function BarrelLength() = 18-ChamberLength();
function ActuatorPretravel() = 0.125;
function ForendGasGap() = 1.5;
function RevolverSpindleOffset() = 1.0001;
function WallBarrel() = 0.375;
function WallSpindle() = 0.25;


// Settings: Vitamins
//Spec_TubingZeroPointSevenFive();
//Spec_TubingOnePointOneTwoFive();
//Spec_TubingOnePointZero();

//Spec_PipeThreeQuarterInch();
//Spec_PipeOneInch();
function BarrelPipe() = Spec_TubingOnePointZero();

// ZigZag Cylinder
function SpindleCollarWidth() = 0.32;
function SpindleCollarDiameter() = 0.63;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;

function CranePivotRod() = Spec_RodFiveSixteenthInch();
function CraneBolt() = Spec_BoltFiveSixteenths();

// Shorthand: Measurements
function BarrelRadius(clearance=undef)
    = PipeOuterRadius(BarrelPipe(), clearance);

function BarrelDiameter(clearance=undef)
    = PipeOuterDiameter(BarrelPipe(), clearance);

function BarrelCollarDiameter() = 1 + (5/8);
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = (5/8);


// Calculated: Lengths
function ForendFrontLength() = FrameUpperBoltExtension()-ChamberLength()-ForendGasGap();

// Calculated: Positions
function ForendMaxX() = FrameUpperBoltExtension();
function ForendMinX() = ForendMaxX()-ForendFrontLength();

function BarrelCollarMinX() = ForendMinX()-BarrelCollarWidth();

function RecoilPlateTopZ() = ReceiverOR()
                           + FrameUpperBoltDiameter()
                           + (WallFrameUpperBolt()*2);

// Crane
function CranePivotAngle() = 90;
function WallCrane() = 0.25;

function CranePivotRadius(clearance=undef)
    = BoltRadius(CraneBolt(), clearance);
function CranePivotDiameter(clearance=undef)
    = BoltDiameter(CraneBolt(), clearance);


function CraneLatchTravel() = BarrelCollarWidth();
function CraneLatchLength() = CraneLatchTravel()+0.125;
function CraneLatchGuideWidth() = 1;
function CraneLatchGuideHeight() = 0.25;

function CraneLengthFront() = 0.5;
function CraneLengthRear() = 0.5;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + ForendFrontLength()
                       + BarrelCollarWidth();
function CraneMaxX() = ForendMaxX()
                     + CraneLengthFront();
function CraneMinX() = CraneMaxX()-CraneLength();

function CranePivotY() = FrameUpperBoltOffsetY()+(3/32);
function CranePivotZ() = FrameUpperBoltOffsetZ()-(15/16);
function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneLatchMinX() = CraneMaxX();
function CraneLatchMaxX() = CraneLatchMinX()+CraneLatchLength();

function CraneLatchPinY() = -CranePivotY();
function CraneLatchPinZ() = CranePivotZ();


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
      FrameUpperBoltSupport(length=abs(RecoilPlateRearX()));
    }

    FrameUpperBolts(cutter=true);

    translate([RecoilPlateRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=true, teardrop=false);

    RevolverSpindle(cutter=true);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true, actuator=false, pin=false);
  }
}


module Barrel(barrel=BarrelPipe(), barrelLength=BarrelLength(), hollow=true,
              clearance=undef, alpha=1, debug=false) {
  color("SteelBlue", alpha) DebugHalf(enabled=debug)
  translate([ChamberLength(),0,0])
  rotate([0,90,0])
  Pipe(pipe=barrel, clearance=clearance,
       hollow=hollow, length=barrelLength);


  // Rear Shaft Collar
  color("DimGrey", alpha) DebugHalf(enabled=debug)
  translate([ForendMinX(),0,0])
  rotate([0,-90,0])
  cylinder(r=BarrelCollarRadius()+PipeClearance(barrel, clearance),
           h=BarrelCollarWidth()+ManifoldGap(), $fn=PipeFn(BarrelPipe())*2);

  // Front Shaft Collar
  color("DimGrey", alpha) DebugHalf(enabled=debug)
  translate([CraneMaxX(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelCollarRadius()+PipeClearance(barrel, clearance),
           h=BarrelCollarWidth(), $fn=PipeFn(BarrelPipe())*2);
}

module RevolverSpindle(teardrop=false, cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=CraneLatchMaxX()-RecoilPlateRearX()
            +ManifoldGap(2),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=cutter&&teardrop);
    
  
  // Rearward shaft collar
  color("SteelBlue")
  translate([ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(),
           $fn=Resolution(20,50));
  
  // Forward shaft collar
  color("SteelBlue")
  translate([CraneLatchMaxX()+ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,-90,0])
  cylinder(r=SpindleCollarRadius()+clear, h=SpindleCollarWidth(), $fn=Resolution(20,50));
}
module CranePivotPath(clearance=0.005, $fn=Resolution(30,90)) {
    
    //
    // Pivot Paths (mirrored for ambidexterity)
    //
    for (M = [0,1]) mirror([0,M,0]) {
        // Pivot path (clear the barrel)
        translate([CraneLatchMaxX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
        rotate([0,-90,0])
        linear_extrude(height=CraneLatchMaxX()-CraneMinX()+ManifoldGap(2))
        semidonut(major=(CranePivotHypotenuse()*2)+BarrelDiameter(PipeClearanceSnug()),
                  minor=(CranePivotHypotenuse()*2)-BarrelDiameter(PipeClearanceSnug()),
                  angle=90+(CranePivotPinAngle()/2)+5);
        
        
        // Pivot path (clear the barrel collar)
        translate([ForendMinX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
        rotate([0,-90,0])
        linear_extrude(height=BarrelCollarWidth()+ManifoldGap(2))
        semidonut(major=(CranePivotHypotenuse()*2)+BarrelCollarDiameter(),
                  minor=(CranePivotHypotenuse()*2)-BarrelCollarDiameter(),
                  angle=90+(CranePivotPinAngle()/2)+5); // TODO: Why is this off by 5 degrees?
        
        // Pivot path (clear the forend's spindle support)
        translate([ForendMaxX()+0.005,CranePivotY(),CranePivotZ()])
        rotate([0,-90,0])
        linear_extrude(height=ForendFrontLength()+0.01)
        semidonut(major=(pyth_A_B(CranePivotY(),CranePivotZ()+RevolverSpindleOffset())
                         +RodRadius(CylinderRod())+WallSpindle()+clearance)*2,
                  minor=(CranePivotHypotenuse()*2)-BarrelDiameter(PipeClearanceSnug()),
                  angle=142); // TODO: Calculate this based on the angle to the pivot pin.
    }
}
module CranePivot(angle=CranePivotAngle(), factor=1) {
  translate([0,CranePivotY(),CranePivotZ()])
  rotate([angle*factor,0,0])
  translate([0,-CranePivotY(),-CranePivotZ()])
  children();
}

module CranePivotPin(cutter=false, teardrop=false) {
  color("Silver")
  translate([CraneMaxX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,-90,0])
  NutAndBolt(bolt=CraneBolt(), capHex=true,
             boltLength=CraneLength()
                       +ManifoldGap(2),
             clearance=cutter,
             nutHeightExtra=cutter?CraneLengthRear():0,
             teardrop=teardrop&&cutter);
}

module CraneLatchPin(cutter=false, teardrop=false) {
  color("Silver")
  translate([CraneLatchMaxX()+ManifoldGap(),
             CraneLatchPinY(),CraneLatchPinZ()])
  rotate([0,-90,0])
  Bolt(CraneBolt(), cap=false,
       length=CraneLatchLength()
             +CraneLengthFront()
             +CraneLatchTravel()
             +ManifoldGap(2),
      threaded=cutter,
      teardrop=teardrop&&cutter);
}

module CraneLatch(cutter=false, clearance=0.0005, alpha=1) {
    clear = cutter?clearance:0;
    clear2 = clear*2;
    
  color("Gold", alpha) render()
  difference() {
      union() {
          hull() {
              
              // Crane pivot pin
              for (M = [0,1]) mirror([0,M,0])
              translate([CraneLatchMinX(),CranePivotY(),CranePivotZ()])
              rotate([0,90,0])
              ChamferedCylinder(r1=RodRadius(CylinderRod())+WallCrane()+clear, r2=1/16,
                                h=CraneLatchLength()+(cutter?1:0),
                                $fn=Resolution(20,40));
              
              // Body around the barrel
              difference() {
                intersection() {
                  translate([CraneLatchMinX(),0,0])
                  rotate([0,90,0])
                  ChamferedCylinder(r1=abs(CraneLatchPinY())
                                      +CranePivotRadius()
                                      +WallCrane(), r2=1/16,
                           h=CraneLatchLength(), teardropTop=true, teardropBottom=true,
                           $fn=Resolution(30,60));
                  
                  translate([CraneLatchMinX()+CraneLatchLength(),0,0])
                  rotate([0,-90,0])
                  linear_extrude(height=CraneLatchLength())
                  rotate(-90)
                  semicircle(od=(abs(CraneLatchPinY())+CranePivotRadius()+WallCrane())*2,
                            angle=180, $fn=Resolution(30,60));
                }
              }
          }
          
          // Handle
          hull() for (Z = [0,-1.5]) translate([0,0,Z])
          translate([CraneLatchMinX(),0,-RevolverSpindleOffset()])
          rotate([0,90,0])
          ChamferedCylinder(r1=RodRadius(CylinderRod())+WallCrane()+clear, r2=1/16,
                            h=CraneLatchLength()+(cutter?0.5:0),
                            teardropTop=true, teardropBottom=true,
                            $fn=Resolution(20,40));
      }
          
    // Forend clearance (around the barrel)
    translate([ForendMaxX()+0.005+ManifoldGap(),0,0])
    rotate([0,-90,0])
    cylinder(r=BarrelRadius()+WallBarrel()+0.005,
             h=ForendFrontLength()+0.01, teardropTop=true,
             $fn=Resolution(20,60));
    
    CranePivotPath();
  
    Barrel(hollow=false, clearance=PipeClearanceSnug());
      
    RevolverSpindle(cutter=true);
      
    for (M = [0,1]) mirror([0,M,0])
    CraneLatchPin(cutter=true);
  }
}

module RevolverCrane(cutter=false, teardrop=false, clearance=1/32, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+0.005;
  
  color("Olive", alpha) render()
  difference() {
    union() {
        hull() {
            
          // Around the crane pivot rods
          for (Y = [1,-1])
          translate([CraneMinX(),CranePivotY()*Y,CranePivotZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=1/16,
                   h=CraneLength(), teardropTop=true, teardropBottom=true,
                   $fn=Resolution(20,60));
        
          // Body around the barrel
          difference() {
            intersection() {
              translate([CraneMinX(),0,0])
              rotate([0,90,0])
              ChamferedCylinder(r1=CranePivotY()+CranePivotRadius()+WallCrane(), r2=1/16,
                       h=CraneLength(), teardropTop=true, teardropBottom=true,
                       $fn=Resolution(30,60));
              
              translate([CraneMinX(),0,0])
              rotate([0,90,0])
              rotate(90)
              linear_extrude(height=CraneLength())
              semidonut(major=(CranePivotY()+CranePivotRadius()+WallCrane())*2,
                        minor=BarrelDiameter(),
                        angle=180, $fn=Resolution(30,60));
            }
          }
          
          // Flat-top fills in, and gets trimmed down for the pivot path
          translate([CraneMinX(),0,CraneLatchPinZ()])
          ChamferedCube([CraneLength(),
                         abs(CraneLatchPinY()),
                         CranePivotRadius()+WallCrane()],
                         r=1/16, teardropTop=true, teardropBottom=true, $fn=20);
        }
            
      // Crane latch guides
      translate([CraneMinX(),
                 -(CraneLatchGuideWidth()/2),
                 -(RevolverSpindleOffset())])
      mirror([0,0,1])
      ChamferedCube([CraneLength(),
            CraneLatchGuideWidth(),
            SpindleRadius()+WallSpindle()+CraneLatchGuideHeight()], r=1/16);
    }
    
    // Forend clearance (Crane Supports)
    translate([ForendMinX()-0.005+ManifoldGap(),
               -CranePivotY()-(pivotCutterRadius*2),
                CranePivotZ()-(pivotCutterRadius)])
    cube([ForendFrontLength()+0.01,
          (CranePivotY()+pivotCutterRadius*2)*2,
          (pivotCutterRadius)*3]);
    
    // Forend clearance (Spindle Support)
    translate([ForendMaxX()+0.005+ManifoldGap(),
                pivotCutterRadius,
                -(CranePivotY()+CranePivotRadius()+WallCrane())-CraneLatchGuideWidth()-ManifoldGap()])
    mirror([0,1,0])
    mirror([1,0,0])
    cube([ForendFrontLength()+0.01 +ManifoldGap(2),
          (pivotCutterRadius*2)+ManifoldGap(2),
          (CranePivotY()+CranePivotRadius()+CraneLatchGuideWidth()+WallCrane())]);
    
    // Chamfered Barrel Cutout: Front
    translate([CraneMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                        teardropTop=true, teardropBottom=true,
                        r2=(1/16), h=CraneMaxX()-ForendMaxX(), $fn=Resolution(20,60));
    
    // Chamfered Barrel Cutout: Rear
    translate([ManifoldGap(),0,0])
    translate([CraneMinX(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                          teardropTop=true, teardropBottom=true,
                          r2=(1/16), h=CraneLengthRear(), $fn=Resolution(20,60));
                          
    CranePivotPath();
    
    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);
    
    RevolverSpindle(cutter=true);
    
    Barrel(hollow=false, cutter=true, clearance=PipeClearanceSnug());
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
        
        // Around the barrel
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=1/16,
                 h=ForendFrontLength(),
                 $fn=Resolution(20,60));
        
        // Crane Pivot/Lock Supports
        hull() {
            
            // Around the upper bolts
            FrameUpperBoltSupport(length=ForendFrontLength());
      
            // Around the crane pivot pin
            translate([0,CranePivotY(),CranePivotZ()])
            rotate([0,90,0])
            ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=1/16,
                               h=ForendFrontLength(),
                             $fn=Resolution(20,60));
            
            // Around the crane lock
            translate([0,CraneLatchPinY(),CraneLatchPinZ()])
            rotate([0,90,0])
            ChamferedCylinder(r1=RodRadius(CylinderRod())+0.25, r2=1/16,
                     h=ForendFrontLength(),
                     $fn=Resolution(20,40));
        }
        
        // Join the barrel to the frame
        translate([0,-(BarrelRadius()+WallBarrel()),0])
        ChamferedCube([ForendFrontLength(),
                       (BarrelRadius()+WallBarrel())*2,
                       FrameUpperBoltOffsetZ()], r=1/16);
        
        
        hull() {
            
            // Spindle body
            for (Z = [0,-RevolverSpindleOffset()])
            translate([0,0,Z])
            rotate([0,90,0])
            ChamferedCylinder(r1=RodRadius(CylinderRod())+WallSpindle(), r2=1/16,
                     h=ForendFrontLength(),
                     $fn=Resolution(20,40));
            
            // Pivot path infill (Might as well have plastic here)
            for (M = [0,1]) mirror([0,M,0])
            translate([0,CranePivotY(),CranePivotZ()])
            rotate([0,90,0])
            linear_extrude(height=ForendFrontLength())
            rotate(-CranePivotPinAngle())
            semidonut(major=(pyth_A_B(CranePivotY(),CranePivotZ()+RevolverSpindleOffset())
                             +RodRadius(CylinderRod())+WallSpindle())*2,
                      minor=(CranePivotHypotenuse()*2)-BarrelDiameter(PipeClearanceSnug()),
                      angle=90-(CranePivotPinAngle()), $fn=Resolution(20,100)); // TODO: Calculate this based on the angle to the pivot pin.
        }
      }
    }
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), RecoilPlateTopZ()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(cutter=true);

    Barrel(hollow=false, clearance=PipeClearanceSnug());

    ChargingRod(cutter=true);

    RevolverSpindle(cutter=true);
    
    for (M = [0,1]) mirror([0,M,0])
    CranePivotPin(cutter=true);
  }
}

module RevolverFrameAssembly(debug=false) {
  
  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly(debug=true);
                                 
  translate([RecoilPlateRearX()-LowerMaxX()-FrameExtension(),0,0])
  FrameLower();
  
  FrameUpper(debug=debug);

  FrameUpperBolts(extraLength=FrameUpperBoltExtension(), cutter=false);
}



// 1.125" OD (A513 DOM) chambers
module RevolverCylinder_DOM5(supports=true, chambers=false,
                             chamberBolts=true, cutter=false, debug=false) {

  positions = 5;
  
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
module RevolverCylinder_ERW4(supports=true, chambers=false,
                             chamberBolts=true, cutter=false,
                             debug=false) {
  positions=4;
                               
  translate([0,0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
  OffsetZigZagRevolver(positions=positions,
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=BarrelRadius(PipeClearanceSnug()), chamberInnerRadius=0.813/2,
      chamberBolts=chamberBolts, wall=0.145, //0.15625,
      supports=supports, extraTop=ActuatorPretravel(),
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.0, cutter=cutter);
}

// 1" OD (4130 Tube) chambers
module RevolverCylinder_4130x6(supports=true, chambers=false,
                             chamberBolts=true, cutter=false,
                             debug=false) {
  positions = 6;

  translate([0,0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
  rotate(-360/positions/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
  OffsetZigZagRevolver(positions=positions,
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=0.5, chamberInnerRadius=0.813/2,
      coreInnerRadius=SpindleCollarRadius()+0.005,
      zigzagAngle=80, wall=0.1875,
      extraTop=ActuatorPretravel(),
      supports=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.0, cutter=cutter);
}

module RevolverShotgunAssembly(stock=true, tailcap=false,
                               pipeAlpha=1, debug=false) {
 
  RevolverRecoilPlateHousing();
  RecoilPlateFiringPinAssembly(); 
  RecoilPlate(debug=debug);
  
  ChargingPumpAssembly();
  
  RevolverFrameAssembly(debug=debug);
  
  Barrel(hollow=true, debug=debug);
  
  RevolverForend(debug=debug, alpha=1);

  CranePivot(factor=Animate(ANIMATION_STEP_UNLOAD)
                   -Animate(ANIMATION_STEP_LOAD)) {
    
    *RevolverCylinder_DOM5(supports=false, chambers=true, debug=false);
    *RevolverCylinder_ERW4(supports=false, chambers=true, debug=false);
    *RevolverCylinder_4130x6(supports=false, chambers=true, debug=false);
                     
    
    translate([CraneLatchTravel()*(SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                  -SubAnimate(ANIMATION_STEP_LOCK, start=0.5)),0,0])
    {
        
        RevolverSpindle();
        CraneLatchPin();
        CraneLatch();
    }
    

    CranePivotPin();
    RevolverCrane(alpha=0.5);
  }
}


RevolverShotgunAssembly(pipeAlpha=1, debug=false);

translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=.51,
                  receiverLength=12,
                  frame=false, lowerLeft=false,
                  stock=true, tailcap=false,
                  debug=true);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_FIRE, T=1);
//$t=AnimationDebug(ANIMATION_STEP_UNLOAD, T=0);
//$t=AnimationDebug(ANIMATION_STEP_UNLOAD, T=0);

//$t=0;


/*
 * Platers
 */
 
 
// Revolver Cylinder shell
*!scale(25.4) render()
difference() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder_4130x6(supports=false, chambers=false, chamberBolts=false, debug=false);
  //RevolverCylinder_ERW4(supports=true, chambers=false, debug=false);

  translate([0,0,-ManifoldGap()])
  cylinder(r=RevolverSpindleOffset()-0.125,
           h=ChamberLength()+ManifoldGap(2), $fn=20);
}

// Revolver Cylinder core
*!scale(25.4) render()
intersection() {
  translate([-RevolverSpindleOffset(),0,0])
  rotate([0,-90,0])
  RevolverCylinder_4130x6(supports=true,
                          chambers=false,
                          chamberBolts=false,
                          debug=false);
  

  translate([0,0,-ManifoldGap()])
  cylinder(r=RevolverSpindleOffset()-0.25, h=ChamberLength()+ManifoldGap(2), $fn=20);
}
  
*!scale(25.4) rotate([0,90,0]) translate([-ForendMinX(),0,0]) {
  intersection() {
    RevolverForend();
    
    // Front
    translate([ChamberLength()+ForendGasGap(),-1.5,-2])
    cube([UpperLength(), 3, 4]);
    
    // Rear
    *translate([-ManifoldGap(),-1.5,-2])
    cube([ForendMinX(), 3, 4]);
  }
}

*!scale(25.4) rotate(90) rotate([0,-90,0]) translate([-CraneMinX(),0,0])
RevolverCrane();

*!scale(25.4) rotate([0,90,0]) translate([-CraneLatchMaxX(),0,0])
CraneLatch();

*!scale(25.4) rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
RevolverRecoilPlateHousing();
