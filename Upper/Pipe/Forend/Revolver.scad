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
function ForendGasGap() = 1.5;
function RevolverSpindleOffset() = 1.0001;
function WallCrane() = 0.25;
function WallBarrel() = 0.375;


// Settings: Vitamins
//Spec_TubingZeroPointSevenFive();
//Spec_TubingOnePointOneTwoFive();
//Spec_TubingOnePointZero();

//Spec_PipeThreeQuarterInch();
//Spec_PipeOneInch();
function BarrelPipe() = Spec_TubingOnePointZero();

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

    
// Crane
function CranePivotRadius(clearance=undef)
    = BoltRadius(CraneBolt(), clearance);
function CranePivotDiameter(clearance=undef)
    = BoltDiameter(CraneBolt(), clearance);


// Calculated: Lengths
function ForendFrontLength() = FrameUpperBoltExtension()-ChamberLength()-ForendGasGap();

// Calculated: Positions
function ForendMaxX() = FrameUpperBoltExtension();
function ForendMinX() = ForendMaxX()-ForendFrontLength();
function BarrelCollarMinX() = ForendMinX()-BarrelCollarWidth();

function RecoilPlateTopZ() = ReceiverOR()
                           + FrameUpperBoltDiameter()
                           + (WallFrameUpperBolt()*2);

function CranePivotAngle() = 90;
function CranePivotY() = FrameUpperBoltOffsetY()+(3/32);//28/32;//FrameUpperBoltOffsetY();//1.35;//1;
function CranePivotZ() = FrameUpperBoltOffsetZ()-(15/16);//19/32;// 1.35;//RevolverSpindleOffset();//+1.355+1;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + ForendLength()
                       + BarrelCollarWidth();
function CraneMaxX() = ForendMaxX()+CraneLengthFront();

function CraneMinX() = ForendMaxX()-CraneLength();

function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneLatchLength() = 0.5;
function CraneLatchPinY() = -CranePivotY();
function CraneLatchPinZ() = CranePivotZ();
function CraneLatchMinX() = ForendMaxX()+CraneLengthFront();
function CraneLatchMaxX() = CraneLatchMinX()-CraneLatchLength();
function CraneLatchAngle() = 22.5;


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
                
                
  color("DimGrey", alpha) DebugHalf(enabled=debug)
  translate([ForendMinX(),0,0])
  rotate([0,-90,0])
  cylinder(r=BarrelCollarRadius()+PipeClearance(barrel, clearance),
           h=BarrelCollarWidth(), $fn=PipeFn(BarrelPipe())*2);
}

module RevolverSpindle(teardrop=false, cutter=false) {
  color("Silver")
  translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=FrameUpperBoltExtension()
            -RecoilPlateRearX()
            +CraneLatchLength()
            +CraneLengthFront()
            +ManifoldGap(),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=cutter&&teardrop);
}

module CranePivot(angle=CranePivotAngle(), factor=1) {
  translate([0,CranePivotY(),CranePivotZ()])
  rotate([angle*factor,0,0])
  translate([0,-CranePivotY(),-CranePivotZ()])
  children();
}

module CranePivotPin(cutter=false, teardrop=false) {
  color("Silver")
  translate([ChamberLength()
            +ForendGasGap()
            -CraneLengthFront()
            -BarrelCollarWidth()+ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,90,0])
  NutAndBolt(bolt=CraneBolt(), capHex=true,
             boltLength=ForendFrontLength()
                       +CraneLengthFront()
                       +CraneLengthRear()
                       +BarrelCollarWidth()
                       +ManifoldGap(2),
      clearance=cutter, nutHeightExtra=cutter?CraneLengthRear():0,
      teardrop=teardrop&&cutter);
}

module CraneLatchPin(cutter=false, teardrop=false) {
  color("Silver")
  translate([FrameUpperBoltExtension()+CraneLengthFront()+CraneLatchLength()+ManifoldGap(),
             CraneLatchPinY(),CraneLatchPinZ()])
  rotate([0,-90,0])
  Bolt(CraneBolt(), cap=false,
       length=(cutter?ForendFrontLength():0.5)
             +CraneLengthFront()
             +CraneLatchLength()+ManifoldGap(2),
      clearance=cutter,
      teardrop=teardrop&&cutter);
}

module CraneLatchPivot(angle=CraneLatchAngle(), factor=1) {
  translate([0,0,-RevolverSpindleOffset()])
  rotate([angle*factor,0,0])
  translate([0,0,RevolverSpindleOffset()])
  children();
}

module CraneLatch(cutter=false, clearance=0.0005, alpha=1) {
    clear = cutter?clearance:0;
    clear2 = clear*2;
    
  color("Gold", alpha) render()
  difference() {
      union() {
          hull() {
            
              // Spindle
              translate([CraneLatchMinX(),0,-RevolverSpindleOffset()])
              rotate([0,90,0])
              ChamferedCylinder(r1=RodRadius(CylinderRod())+WallCrane()+clear, r2=1/16,
                                h=CraneLatchLength()+(cutter?1:0),
                                teardropTop=true, teardropBottom=true,
                                $fn=Resolution(20,40));
              
              // Crane latch pin
              translate([CraneLatchMinX(),CraneLatchPinY(),CraneLatchPinZ()])
              rotate([0,90,0])
              ChamferedCylinder(r1=RodRadius(CylinderRod())+WallCrane()+clear, r2=1/16,
                                h=CraneLatchLength()+(cutter?1:0),
                                $fn=Resolution(20,40));
          }
              
          // Crane latch pin
          translate([ForendMaxX(),CraneLatchPinY(),CraneLatchPinZ()])
          rotate([0,90,0])
          ChamferedCylinder(r1=RodRadius(CylinderRod())+WallCrane()+clear, r2=1/16,
                            h=CraneLatchLength()+CraneLengthFront(),
                            $fn=Resolution(20,40));
          
          *translate([ForendMaxX(),0,CraneLatchPinZ()-(RodRadius(CylinderRod())+WallCrane())])
          mirror([0,1,0])
          ChamferedCube([CraneLatchLength()+CraneLengthFront(),
                         abs(CraneLatchPinY())+0.75,
                         (RodRadius(CylinderRod())+WallCrane())*2], r=1/16, $fn=20);
      }
  
    Barrel(hollow=false, clearance=PipeClearanceSnug());
      
    RevolverSpindle(cutter=false);
    CraneLatchPin(cutter=false);
  }
}

module RevolverCrane(cutter=false, teardrop=false, clearance=1/32, alpha=1) {
  length = CraneLengthFront()
         + ForendFrontLength()
         + CraneLengthRear()
         + BarrelCollarWidth()
         + clearance;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+0.005;
  
  color("Olive", alpha) render()
  difference() {
    
    translate([CraneLengthRear(),0,0])
    hull() {
        
      // Around the crane rod
      translate([FrameUpperBoltExtension(),CranePivotY(),CranePivotZ()])
      rotate([0,-90,0])
      ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=1/16,
               h=length, teardropTop=true, teardropBottom=true,
               $fn=Resolution(20,60));
      
      // Around the spindle rod
      translate([FrameUpperBoltExtension(),0,-RevolverSpindleOffset()])
      rotate([0,-90,0])
      ChamferedCylinder(r1=RodRadius(CylinderRod())+WallCrane(), r2=1/16,
               h=length, teardropTop=true, teardropBottom=true,
               $fn=Resolution(20,60));
    
      // Body around the barrel
      difference() {
        intersection() {
          translate([FrameUpperBoltExtension(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=CranePivotY()+CranePivotRadius()+WallCrane(), r2=1/16,
                   h=length, teardropTop=true, teardropBottom=true,
                   $fn=Resolution(30,60));
          
          translate([FrameUpperBoltExtension(),0,0])
          rotate([0,-90,0])
          linear_extrude(height=length)
          rotate(180)
          semidonut(major=(CranePivotY()+CranePivotRadius()+WallCrane())*2,
                    minor=BarrelDiameter(),
                    angle=90, $fn=Resolution(30,60));
        }
      }
      
      // Flatten off near the top          
      translate([ForendMaxX(),0,CraneLatchPinZ()])
      mirror([1,0,0])
      ChamferedCube([length,
                     abs(CraneLatchPinY()),
                     CranePivotRadius()+WallCrane()],
                     r=1/16, $fn=20);
    }
    
    
    // Pivot path (clear the barrel)
    translate([ForendMaxX()+CraneLengthFront()+ManifoldGap(),CranePivotY(),CranePivotZ()])
    rotate([0,-90,0])
    linear_extrude(height=length+ManifoldGap(2))
    semidonut(major=(CranePivotHypotenuse()*2)+BarrelDiameter(PipeClearanceSnug()),
              minor=(CranePivotHypotenuse()*2)-BarrelDiameter(PipeClearanceSnug()),
              angle=90+(CranePivotPinAngle()/2),
              $fn=Resolution(20,60));
    
    
    // Pivot path (clear the barrel collar)
    translate([ForendMinX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
    rotate([0,-90,0])
    linear_extrude(height=BarrelCollarWidth()+ManifoldGap(2))
    semidonut(major=(CranePivotHypotenuse()*2)+BarrelCollarDiameter(),
              minor=(CranePivotHypotenuse()*2)-BarrelCollarDiameter(),
              angle=90+(CranePivotPinAngle()/2),
              $fn=Resolution(20,60));
    
    // Forend clearance (around the barrel)
    translate([ForendMaxX()+0.005+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+0.005, r2=1/16,
             h=ForendFrontLength()+0.01, teardropTop=true,
             $fn=Resolution(20,60));
    
    // Forend clearance (Crane Pivot Support)
    translate([ForendMinX()-0.005+ManifoldGap(),
                0,
                CranePivotZ()-(pivotCutterRadius)])
    cube([ForendFrontLength()+0.01,
          CranePivotY()+(pivotCutterRadius)*3,
          (pivotCutterRadius)*3]);
    
    // Forend clearance (Spindle Support)
    translate([ForendMaxX()+0.005+ManifoldGap(),
                pivotCutterRadius,
                -(CranePivotY()+CranePivotRadius()+WallCrane())-ManifoldGap()])
    mirror([0,1,0])
    mirror([1,0,0])
    cube([ForendFrontLength()+0.01 +ManifoldGap(2),
          (pivotCutterRadius*2)+ManifoldGap(2),
          (CranePivotY()+CranePivotRadius()+WallCrane())]);
    
    // Chamfered Barrel Cutout: Front
    translate([CraneLengthRear()+ManifoldGap(),0,0])
    translate([FrameUpperBoltExtension(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                        teardropTop=true, teardropBottom=true,
                        r2=(1/16), h=CraneLengthRear(), $fn=Resolution(20,60));
    
    // Chamfered Barrel Cutout: Rear
    translate([ManifoldGap(),0,0])
    translate([FrameUpperBoltExtension()-length+ForendGasGap()-CraneLengthRear(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=PipeClearanceLoose()),
                          teardropTop=true, teardropBottom=true,
                          r2=(1/16), h=CraneLengthRear(), $fn=Resolution(20,60));
    
    CranePivotPin(cutter=true);
    
    CraneLatchPin(cutter=true);
    
    // Crane latch travel path (unused)
    *for (angle = [0,90])
    CraneLatchPivot(angle=angle)
    CraneLatch(cutter=true);

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
        
        
        // Spindle body
        *hull()
        for (Z = [0,-RevolverSpindleOffset()])
        translate([0,0,Z])
        rotate([0,90,0])
        ChamferedCylinder(r1=RodRadius(CylinderRod())+0.25, r2=1/16,
                 h=ForendFrontLength(),
                 $fn=Resolution(20,40));
      }
    }
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), RecoilPlateTopZ()-0.125])
    cube([FrameUpperBoltExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameUpperBolts(cutter=true);

    Barrel(hollow=false, clearance=PipeClearanceSnug());

    ChargingRod(cutter=true);

    RevolverSpindle(cutter=true);
    
    // Spindle Swingout Path (unused)
    *translate([FrameUpperBoltExtension(),CranePivotY(),CranePivotZ()])
    rotate([0,-90,0])
    linear_extrude(height=ForendFrontLength())
    rotate(-145)
    semidonut(major=3.96,
              minor=3.3,
              angle=20, $fn=Resolution(30,80));
    
    CranePivotPin(cutter=true);
    CraneLatchPin(cutter=true);
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
      zigzagAngle=80, wall=0.1875,
      extraTop=ActuatorPretravel(),
      supports=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=1.0, cutter=cutter);
}

module RevolverShotgunAssembly(receiverLength=12, stock=true, tailcap=false,
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
    RevolverCylinder_4130x6(supports=false, chambers=true, debug=false);
                     
    
    translate([(0.5)*(SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                  -SubAnimate(ANIMATION_STEP_LOCK, start=0.5)),0,0])        
    CraneLatchPivot(factor=SubAnimate(ANIMATION_STEP_UNLOCK, start=0.5)
                          -SubAnimate(ANIMATION_STEP_LOCK, end=0.5)) {
        
    RevolverSpindle();
        CraneLatchPin();
        CraneLatch();
    }
    

    CranePivotPin();
    RevolverCrane(alpha=1);
  }
}


RevolverShotgunAssembly(pipeAlpha=1, debug=false);


translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=.51,
                  receiverLength=12,
                  frame=false,
                  stock=true, tailcap=false,
                  debug=false);


//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=180*sin($t));
//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=1);
//$t=AnimationDebug(ANIMATION_STEP_UNLOAD, T=$t);
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
  RevolverCylinder_4130x6(supports=true, chambers=false, chamberBolts=false, debug=false);
  //RevolverCylinder_ERW4(supports=true, chambers=false, debug=false);

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

*!scale(25.4) rotate([0,90,0]) translate([-UpperLength()-0.375,0,0])
RevolverCrane();

*!scale(25.4) rotate([0,90,0]) translate([-CraneLatchMaxX(),0,0])
CraneLatch();

*!scale(25.4) rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
RevolverRecoilPlateHousing();
