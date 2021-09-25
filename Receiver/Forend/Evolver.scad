include <../../Meta/Animation.scad>;
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=0.25, end=0.375);
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=1);
//$t = 0;
$t = 0.5+(0.5*$t);

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;
use <../../Meta/MirrorIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Shapes/Components/Pivot.scad>;
use <../../Shapes/Components/Cylinder Redux.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <../../Ammo/Belt.scad>;

use <../Receiver.scad>;
use <../FCG.scad>;
use <../Frame.scad>;
use <../Lower.scad>;
use <../Receiver.scad>;
use <../Stock.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Receiver_LargeFrame", "Evolver_ReceiverFront", "Evolver_Spindle", "Evolver_SpindleZigZag", "Evolver_Ratchet", "Evolver_RatchetPawl","Evolver_Actuator", "Evolver_BarrelSupport", "Evolver_ForendSpacer"]

/* [Assembly] */
_SHOW_RECEIVER = false;
_SHOW_FCG = false;
_SHOW_LOWER = false;
_SHOW_RECEIVER_FRONT = false;
_SHOW_BARREL = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_BARREL_STOP = true;
_SHOW_BELT = true;
_SHOW_PUMP = true;
_SHOW_EXTRACTOR = true;
_SHOW_FOREND_SPACER = true;
_SHOW_RATCHET_PAWL = true;
_SHOW_SPINDLE = true;
_SHOW_ACTUATOR = true;

/* [Transparency] */
_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_FOREND_SPACER = 1;      // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_FCG = 1;                // [0:0.1:1]
_ALPHA_ACTUATOR = 1;           // [0:0.1:1]

/* [Cutaways] */
_CUTAWAY_BARREL = false;
_CUTAWAY_BARREL_SUPPORT = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_RECEIVER_FRONT = false;
_CUTAWAY_FOREND_SPACER = false;
_CUTAWAY_FCG = false;
_CUTAWAY_SPINDLE = false;
_CUTAWAY_ACTUATOR = false;

/* [Vitamins] */
SPINDLE_DIAMETER = 0.31251;

FRAME_BOLT_LENGTH = 10;

GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_LENGTH = 18.5;
BARREL_DIAMETER = 1.0001;
BARREL_CLEARANCE = 0.008;
CYLINDER_OFFSET = 1.0001;
CHAMBER_LENGTH = 3.5;
CHAMBER_ID = 0.8101;

/* [Branding] */
BRANDING_MODEL_NAME = "EVOLver";

$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Settings: Lengths
function SpindleRadius() = SPINDLE_DIAMETER/2;
function ShellRimLength() = 0.06;
function BarrelLength() = BARREL_LENGTH;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.375; //0.4375;
function WallSpindle() = 0.1875;
function ReceiverFrontLength() = 0.5;
function TemplateHoleRadius() = 1/16;
function ForendSpacerLength() = 3.25;
function ActionRodZ() = 0.875;

function ChamferRadius() = 1/16;
function CR() = 1/16;

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilSpreaderThickness() = 0.5;
function BarrelCollarDiameter() = 1.625;
function BarrelCollarLength() = 0.625;
function ActuatorPinDiameter() = UnitsMetric(2.5);
function ActuatorPinRadius() = ActuatorPinDiameter()/2;

// Settings: Vitamins
function ActionRodBolt() = BoltSpec(GP_BOLT);
assert(ActionRodBolt(), "ActionRodBolt() is undefined. Unknown GP_BOLT?");

function BarrelSetScrew() = BoltSpec(GP_BOLT);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown GP_BOLT?");

function ForendBolt() = BoltSpec(GP_BOLT);
assert(ForendBolt(), "ForendBolt() is undefined. Unknown GP_BOLT?");

// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);

function ExtractorLength() = 0.5;
function ExtractorWidth() = 0.75;
function BarrelCollarRadius() = BarrelCollarDiameter()/2;

// Calculated: Lengths
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - ReceiverFrontLength();
function SpindleLength() = 2.75;//3.25;
function Evolver_ZigZagLength() = 1.375;
function Evolver_RatchetLength() = 0.5;

// Calculated: Positions
function BarrelMinX() = ShellRimLength();
function ForendMaxX() = ForendLength();
function BarrelSupportMinX() = 3.5;
function SpindleMaxX() = ExtractorLength()+SpindleLength();
function ForendBoltZ() = TensionRodBottomZ()-0.375;
function ForendBoltY() = 1;

function Evolver_BarrelTravel() = ForendSpacerLength();
function Evolver_ActuatorTravel() = Evolver_ZigZagLength()-ActuatorPinDiameter();
function Evolver_BarrelSupportLength() = ForendLength()-ForendSpacerLength();

beltOffsetX = 0.0625;
ratchetRadius = 0.375;
pawlRadius = (1/64)+(1/128);
pawlPivotZ = -1.75;
pawlPivotY = 0;
pawlPivotAngle = -15;
pawlPinRadius = UnitsMetric(2.5)/2;
actuatorPinRadius = ActuatorPinRadius();
actuatorPinDepth = 0.125;
actuatorPinX = ForendSpacerLength()+ActuatorPinRadius();

//************
//* Vitamins *
//************
module Evolver_Barrel(barrelLength=BarrelLength(), clearance=BARREL_CLEARANCE, cutter=false, alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;
  
  color("Gold", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([ForendLength(),0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=(BarrelCollarDiameter()/2)+clear, h=BarrelCollarLength());
    
    if (!cutter)
    cylinder(r=CHAMBER_ID/2,
             h=barrelLength);
  }

  color("Silver", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  translate([(cutter?0:BarrelMinX()),0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=BarrelRadius()+clear,
             h=barrelLength);
    
    if (!cutter)
    cylinder(r=CHAMBER_ID/2,
             h=barrelLength);
  }
}

module Evolver_SpindleRod(cutter=false, clearance=0.003) {
  clear = cutter? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  RenderIf(!cutter)
  translate([SpindleLength()-0.25,0,SpindleZ()])
  rotate([0,90,0])
  for (R = [0:120:360]) rotate(R)
  translate([0.25, 0, -clear])
  cylinder(r=(UnitsMetric(2.5)/2)+clear, h=3/4+(cutter?2:0)+clear2);
}
module Evolver_SpindlePins(cutter=false, clearance=0.003) {
  clear = cutter? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  RenderIf(!cutter)
  translate([SpindleLength()-0.25,0,SpindleZ()])
  rotate([0,90,0])
  for (R = [0:120:360]) rotate(R)
  translate([0.25, 0, -clear])
  cylinder(r=(UnitsMetric(2.5)/2)+clear, h=3/4+(cutter?2:0)+clear2);
}



module Evolver_RatchetPawlPin(cutter=false, clearance=0.003) {
  clear = cutter? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  RenderIf(!cutter)
  translate([ForendSpacerLength()-Evolver_RatchetLength()-clear,0,pawlPivotZ])
  rotate([0,90,0])
  cylinder(r=pawlPinRadius+clear, h=1+clear2);
}

module Evolver_ActuatorPin(cutter=false, clearance=0.003, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  
  height = 0.5;
  offsetX = actuatorPinX;
  
  color("Silver")
  RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  translate([0,0, SpindleZ()])
  rotate([60,0,0])
  translate([offsetX,0, 0.5-actuatorPinDepth])
  cylinder(r=actuatorPinRadius+clear, h=height+ManifoldGap());
}
//**********
//* Motion *
//**********
module Evolver_RatchetPawlPivot(factor=0, angle=pawlPivotAngle) {
  translate([0,0,pawlPivotZ])
  rotate([factor*angle,0,0])
  translate([0,0,-pawlPivotZ])
  children();
}

//*****************
//* Printed Parts *
//*****************
module Evolver_ReceiverFront(contoured=true, debug=_CUTAWAY_RECEIVER_FRONT, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilSpreaderThickness());
  
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
        Frame_ReceiverSegment(length=length,
                              highTop=true);

      hull() {
        
        // Recoil plate backing
        translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
        mirror([0,0,1])
        ChamferedCube([length,
                       RecoilPlateWidth()+0.5,
                       RecoilPlateHeight()-0.5],
                      r=1/8, teardropFlip=[true,true,true]);
        
        // Spindle support
        translate([0,0,SpindleZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.625, r2=1/8, h=0.5);
        
      }
    }
    
    FrameBolts(cutter=true);

    RecoilPlate(contoured=contoured, spindleZ=CylinderZ(), cutter=true);
    
    FiringPin(cutter=true);
    
    RecoilPlateBolts(cutter=true);
    Receiver_TensionBolts(cutter=true);
    
    translate([0,0,0.125])
    ActionRod(cutter=true);
  }
}

module Evolver_ForendSpacer(length=ForendSpacerLength(), doRender=true, debug=false, alpha=1) {
  
  color("Tan", alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    
    union() {
      FrameSupport(length=length,
                   chamferRadius=1/16, chamferFront=true, teardropFront=true);
      
      translate([0.875,0,-0.25])
      ChamferedCube([1,3.25/2, FrameBoltZ()+ 0.25], r=1/16);
    }
    
    // Belt clearance
    translate([-ManifoldGap(),0,SpindleZ()])
    rotate([0,90,0])
    cylinder(r=(3.6875/2), h=length+ManifoldGap());
    
    // Belt clearance (wider guide)
    *translate([-ManifoldGap(),0,SpindleZ()-0.825])
    rotate([0,90,0])
    cylinder(r=5/2, h=3.125+ManifoldGap());
    
    FrameBolts(cutter=true);
  }
}

module Evolver_BarrelSupport(length=Evolver_BarrelSupportLength(), doRender=true, debug=false, alpha=_ALPHA_FOREND_SPACER) {
  extraBottom=0;
  
  offsetX = ForendSpacerLength();
  
  // Branding text
  color("DimGrey", alpha) 
  RenderIf(doRender) DebugHalf(enabled=debug) {
     
    fontSize = 0.375;
    
    // Right-side text
    translate([ForendMaxX()-0.125-0.5,-FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

    // Left-side text
    translate([ForendMaxX()-0.125-0.5,FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
  }
  
  color("Tan", alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([offsetX,0,0])
      Frame_ReceiverSegment(length=length,
                            highTop=true, chamferFront=false);
      
      // Spindle and interlock support
      hull() {
        
        // Spindle support
        translate([offsetX,0,SpindleZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.5+0.125, r2=1/8, h=length,
                          teardropTop=true);
        
        // Spindle Interlock support
        *translate([offsetX,0,SpindleZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=SpindleInterlockRadius()+0.125, r2=1/16,
                          h=SpindleInterlockLength(),
                          teardropBottom=false);
        
        // Pawl Pivot Support
        translate([offsetX,0,pawlPivotZ])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.1875,
                          r2=1/32,
                          h=1,
                          teardropTop=true);
          
        // Flatten the pivot support
        translate([offsetX,-(1/2), pawlPivotZ+0.1875])
        ChamferedCube([1, 1, 0.5], r=1/16);
      }
    }
    
    
    Evolver_RatchetPawlPin(cutter=true);
    Evolver_SpindleZigZag(cutter=true);
    
    Evolver_PumpRod(cutter=true);
    
    translate([0,0,0.125])
    ActionRod(cutter=true);
    
    // Spindle hole
    translate([ForendSpacerLength(),0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=(0.3125/2)+0.007, r2=1/32, h=Evolver_ZigZagLength()+0.5);
    
    FrameBolts(cutter=true);

    Evolver_Barrel(cutter=true);
    
    for (M = [0,1]) mirror([0,M,0])
    Evolver_Actuator(cutter=true);
  }
}


module Evolver_BarrelStop(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  backset = 1;
  stopLength = 0.25;
  length = stopLength+ForendSpacerLength()+backset;
  width = 0.3125;
  height = 0.375;
  offsetZ = BarrelCollarRadius();
  offsetX = ForendLength()-backset;
  
  color("CornflowerBlue", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Long
      translate([offsetX-clearCR-clear,-(width/2)-clear, offsetZ-clear])
      ChamferedCube([length+clearCR+clear, width+clear2, height+clear2], r=1/16);
      
      // T-Stop
      translate([offsetX-clearCR-clear,-(width)-clear, offsetZ-clear])
      ChamferedCube([stopLength+clearCR+clear, width*2+clear2, height+clear2], r=1/16);
      
      // Forward stop
      translate([ForendLength()+ForendSpacerLength()-clearCR-clear,
                 -(width/2)-clear, 0.5-clear])
      ChamferedCube([stopLength+clearCR+clear, width+clear2, 0.25+height+clear2], r=1/16);
    }
  }
}
module Evolver_Extractor(length=0.5, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    
    translate([0,0,SpindleZ()])
    for (R = [0:120:360]) rotate([R,0,0])
    translate([0,0,-SpindleZ()])
    translate([ShellRimLength()*1.5,-0.125,-(0.813/2)])
    rotate([0,180-60,0])
    mirror([1,0,0])
    cube([(1/16), 0.25, 1]);
    
    // Spindle slot
    if (!cutter)
    hull()
    for (Z = [0,-0.125]) translate([0,0,Z])
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
  
  *color("Chocolate", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
    
      translate([0,0,SpindleZ()])
      rotate([0,90,0])
      cylinder(r=0.5, h=0.25);
      
      translate([0,-ExtractorWidth()/2,SpindleZ()-1])
      cube([ExtractorLength(), ExtractorWidth(), 1]);
    }
    
    // Spindle slot
    if (!cutter)
    hull()
    for (Z = [0,-0.125]) translate([0,0,Z])
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
}

module Evolver_Ratchet(teeth = 3*7, length=Evolver_RatchetLength(), angle=0, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  offsetX = ForendSpacerLength()-length;
  
  color("Olive", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([offsetX-clear,0,SpindleZ()])
    rotate([0,90,0])
    intersection() {
      
      // Centeral body
      ChamferedCylinder(r1=ratchetRadius+clear,
                        r2=1/32,
                        h=length+clear2,
                        teardropTop=true,
                        chamferBottom=!cutter, chamferTop=!cutter);
      // Teeth
      rotate(-90+angle)
      for (T = [0:teeth-1])
      rotate(360/teeth*T)
      hull() {
      
        cylinder(r=(1/16), h=length+clear2);
        
        translate([ratchetRadius-(1/128),(1/64),0])
        cylinder(r=(1/128), h=length+clear2, $fn=8);
        
        rotate(45)
        translate([ratchetRadius-(1/16),0,0])
        cylinder(r=(1/64), h=length+clear2);
      }
    }
        
    if (!cutter)
    translate([offsetX-clear,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=0.3125/2, r2=1/32, h=length,
                      teardropTop=true);
  }
}

module Evolver_RatchetPawl(length=0.5, cutter=false, clearance=0.01, debug=false, alpha=1) {
clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  length = length+clear2;
  offsetX = ForendSpacerLength()-length-clear;
  
  color("Pink", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Extension
      *translate([offsetX,0,pawlPivotZ])
      rotate([180+22.5,0,0])
      translate([0,-(0.1875/2)-clear,0])
      ChamferedCube([length, 0.1875+clear2, 0.625],
                    r=1/32, teardropFlip=[true,true,true]);
      
      // Pivot
      translate([offsetX,pawlPivotY,pawlPivotZ])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.1875+clear,
                        r2=1/32,
                        h=length,
                        teardropTop=true);
      // Pawl Tooth
      hull()
      translate([offsetX,pawlPivotY, SpindleZ()])
      rotate([360/21*3,0,0])
      translate([0,-pawlRadius-(1/64),-(0.5)+(1/64)])
      rotate([0,90,0]) {
        cylinder(r=pawlRadius, h=length, $fn=20);
        
        rotate(-360/21*3)
        translate([0.125,0,0])
        ChamferedCylinder(r1=5/64, r2=1/32, h=length);
      }
      
      // Pawl Support
      hull() {
        translate([offsetX,pawlPivotY, SpindleZ()])
        rotate([360/21*3,0,0])
        translate([0,-pawlRadius-(1/64),-(0.5)+(1/64)])
        rotate([0,90,0])
        rotate(-360/21*3)
        translate([0.125,0,0])
        ChamferedCylinder(r1=5/64, r2=1/32, h=length);
        
        // Hull back to pivot
        translate([offsetX,0-0.125,pawlPivotZ-0.125])
        ChamferedCube([length, 0.125*2, 0.1875], r=1/32);
        hull() {
        }
      }
      
    }
    
    if (!cutter)
    Evolver_RatchetPawlPin(cutter=true);
    Evolver_SpindlePins(cutter=true);
    
    if (!cutter)
    Evolver_Extractor(cutter=true);
    
    // Spindle hole
    if (!cutter)
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=SpindleLength());
  }
}
module Evolver_Spindle(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      translate([0,0,SpindleZ()])
      rotate([0,90,0]) {
        
        hull() {
          
          // Trilobes
          hull()
          for (R = [0:120:360]) rotate(R)
          translate([0.66,0,0])
          ChamferedCylinder(r1=0.0625, r2=1/16, h=SpindleLength());
          
          // Wide flats
          hull()
          for (R = [0:120:360]) rotate(60+R)
          translate([0,-1/2,0])
          ChamferedCube([0.5-0.0625-0.01, 1, SpindleLength()], r=1/16);
        }
      }
    }
    
    // Belt Drive Tooth
    translate([0.5+beltOffsetX,0,SpindleZ()])
    rotate([0,90,0])
    for (R = [0:120:360]) rotate(60+R)
    translate([BarrelRadius()-(1/16),0,-clearance])
    ChamferedCylinder(r1=BeltDriveToothRadius()+0.002,
                      r2=BeltDriveToothRadius(),
                       h=1.5+(clearance*2),
                       teardropTop=true);
    
    if (!cutter)
    Evolver_SpindlePins(cutter=true);
    
    if (!cutter)
    Evolver_Extractor(cutter=true);
    
    // Spindle hole
    if (!cutter)
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=SpindleLength());
  }
}
module Evolver_SpindleZigZag(length=Evolver_ZigZagLength(), cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  offsetX = ForendSpacerLength();
  
  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([offsetX,0,SpindleZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.5+clear,
                        r2=1/16,
                        h=length+clear2,
                        teardropTop=true);
    }
    
    if (!cutter)
    Evolver_SpindlePins(cutter=true);
    
    if (!cutter)
    translate([offsetX,0,SpindleZ()])
    rotate([0,90,0])
    ZigZag(radius=0.5, mirrored=false,
           depth=0.125, width=(actuatorPinRadius+0.002)*2, positions=3,
           extraTop=0.1875+0.01, extraBottom=0.1875+0.01,
           supportsTop=false, supportsBottom=false);
  
    // Spindle hole
    if (!cutter)
    translate([offsetX,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
}
module Evolver_Actuator(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  legLength = 0.5;
  width = 0.5;
  height = 0.375;
  wall = 0.125;
  offsetX = actuatorPinX-(legLength/2);
  length = Evolver_BarrelSupportLength();
  
  color("Chocolate", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {

      translate([offsetX,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelCollarRadius()+clear,r2=CR,
                         h=length+(cutter?Evolver_ActuatorTravel():0));
      
      
      legCutterLength = (cutter?Evolver_ActuatorTravel():0);
      
      // Actuator legs
      for (M = [0,1]) mirror([0,M,0])
      translate([actuatorPinX,0, SpindleZ()])
      rotate([60,0,0])
      translate([-(legLength/2)-clearCR-clear,-(width/2)-clear, 0.5-clear])
      ChamferedCube([legLength+legCutterLength+clearCR+clear, width+clear2, height+clear2], r=1/16);
    }
    
    // Spindle clearance
    *difference() {
      translate([offsetX-ManifoldGap(),0,SpindleZ()])
      rotate([0,90,0])
      cylinder(r=0.5-(cutter?0.01:0), h=length+ManifoldGap(2));
      
      *translate([offsetX+length+ManifoldGap(),0,SpindleZ()])
      rotate([0,-90,0])
      cylinder(r=BarrelCollarRadius()-(cutter?0.01:0), h=length-Evolver_ZigZagLength()+ManifoldGap(2));
      
    }
    
    for(X = [0,-Evolver_ActuatorTravel()]) translate([X,0,0])
    Evolver_SpindleZigZag(cutter=true);
    
    if (!cutter)
    Evolver_ActuatorPin(cutter=true);
    
    if (!cutter)
    Evolver_Barrel(cutter=true);
  }
}

module Evolver_PumpRod(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  length = ForendLength();
  width = 0.25;
  height = 0.25;
      
  *color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    
    translate([ForendMaxX(),0,0])
    rotate([0,90,0])
    ChamferedCylinder(r1=BarrelRadius()+0.25,r2=CR,h=0.5);
    
    if (!cutter) {
      Evolver_Barrel(cutter=true);
      Evolver_PumpActuator(cutter=true);
    }
  }
  
  // Action Bolt
  color("Silver", alpha)
  RenderIf(!cutter)
  translate([2.5-clearCR-clear,0-clear, 1-clear])
  rotate([-90,0,0])
  translate([0,0,0.125])
  Bolt(bolt=ActionRodBolt(), length=0.25, head="socket", capOrientation=true);
  
  // Pump rods
  color("Chocolate", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      for (M = [0,1]) mirror([0,M,0]) {

        rotate([-60,0,0]) 
        translate([1.625-clearCR-clear,-(width/2)-clear, -clear]) {
          
          // Long
          translate([0,0,BarrelCollarRadius()])
          ChamferedCube([length+clearCR+clear2, width+clear2, height+clear2], r=1/16);
          
          cutterLength = Evolver_BarrelTravel()
                       + Evolver_ActuatorTravel();
          
          // Short
          translate([0,0, BarrelCollarRadius()-0.25])
          ChamferedCube([0.25+(cutter?cutterLength:0)+clearCR+clear2, width+clear2, height+0.25+clear2], r=1/16);
        }
        
      }
    }
    
    *if (!cutter)
    Evolver_ActuatorPin(cutter=true);
    
    if (!cutter)
    Evolver_Barrel(cutter=true);
  }
}
module Evolver_PumpActuator(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  width = 2;
  height = 1;
  
  *color("Maroon", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      *translate([ForendMaxX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+0.25,r2=CR,h=4);
      
      // Short
      translate([ForendSpacerLength()+Evolver_RatchetLength()-clearCR-clear,-(width/2)-clear, 0.25-clear])
      ChamferedCube([0.25+clearCR+clear, width+clear2, height+clear2], r=1/16);
    }
    
    *if (!cutter)
    Evolver_ActuatorPin(cutter=true);
  }
}
//**************
//* Assemblies *
//**************
module EvolverForendAssembly(pipeAlpha=1, debug=false) {
  animateSpindle = (SubAnimate(ANIMATION_STEP_EXTRACT, start=0.19, end=0.46)
                   + SubAnimate(ANIMATION_STEP_EXTRACT, start=0.63, end=0.9))/2;
  
  
  animateBarrel = Animate(ANIMATION_STEP_UNLOAD)
                - Animate(ANIMATION_STEP_LOAD);
  
  
  animateBarrel2 = SubAnimate(ANIMATION_STEP_EXTRACT, end=0.5)
                 - SubAnimate(ANIMATION_STEP_EXTRACT, start=0.5);
  
  if (_SHOW_RATCHET_PAWL) {
    Evolver_RatchetPawlPin();
    
    Evolver_RatchetPawlPivot(factor=0)
    Evolver_RatchetPawl();
  }
  
  translate([0,0,SpindleZ()])
  rotate([animateSpindle*120,0,0])
  translate([0,0,1]) {
    
    if (_SHOW_BELT)
    translate([beltOffsetX,0,SpindleZ()]) {
      
      // First round
      rotate([0,0,0])
      translate([0,0,1])
      rotate([0,90,0]) rotate(90)
      Belt(rounds=1,offset=0, expand=1-SubAnimate(ANIMATION_STEP_UNLOAD, start=0.73, end=0.88));
      
      // Second round
      rotate([-120,0,0])
      translate([0,0,1])
      rotate([0,90,0]) rotate(90)
      Belt(rounds=1,offset=0, expand=SubAnimate(ANIMATION_STEP_LOAD, start=0.1, end=0.2));
    }
    
    if (_SHOW_SPINDLE) {
      Evolver_SpindlePins();
      Evolver_Spindle(debug=_CUTAWAY_SPINDLE, alpha=_ALPHA_SPINDLE);
      Evolver_Ratchet(debug=_CUTAWAY_SPINDLE, alpha=_ALPHA_SPINDLE);
      Evolver_SpindleZigZag(debug=_CUTAWAY_SPINDLE, alpha=_ALPHA_SPINDLE);
    }
  }
  
  if (_SHOW_PUMP || _SHOW_ACTUATOR)
  Evolver_PumpActuator();
  
  
  if (_SHOW_ACTUATOR)
  translate([Evolver_ActuatorTravel()*animateBarrel2,0,0]) {
    Evolver_ActuatorPin();
    Evolver_Actuator(debug=_CUTAWAY_ACTUATOR, alpha=_ALPHA_ACTUATOR);
  }
  
  if (_SHOW_PUMP)
  translate([(Evolver_ActuatorTravel()*animateBarrel2),0,0])
  translate([(Evolver_BarrelTravel()*animateBarrel),0,0]) {
    Evolver_PumpRod();
      
    translate([-3,0,0.125])
    ActionRod();
  }
  
  if (_SHOW_BARREL_STOP)
  Evolver_BarrelStop();
  
  if (_SHOW_BARREL) {
    
    translate([(Evolver_ActuatorTravel()*animateBarrel2),0,0])
    translate([(Evolver_BarrelTravel()*animateBarrel),0,0]) {
      Evolver_Barrel(debug=_CUTAWAY_BARREL);
    }
      
      
  }
  
  if (_SHOW_FOREND_SPACER)
  Evolver_ForendSpacer(debug=_CUTAWAY_FOREND_SPACER, alpha=_ALPHA_FOREND_SPACER);
  
  if (_SHOW_BARREL_SUPPORT)
  Evolver_BarrelSupport(debug=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_BARREL_SUPPORT);
  
  if (_SHOW_EXTRACTOR)
  Evolver_Extractor();
  
  if (_SHOW_RECEIVER_FRONT)
  translate([-0.5,0,0])
  Evolver_ReceiverFront();
}


scale(25.4)
if ($preview) {

  translate([-ReceiverFrontLength(),0,0]) {
    if (_SHOW_FCG)
      SimpleFireControlAssembly(actionRod=false);
    
    if (_SHOW_RECEIVER) {
      SimpleFireControlAssembly();
      
      Receiver_TensionBolts(debug=_CUTAWAY_RECEIVER);
      
      Lower();
      
      Receiver_LargeFrameAssembly(
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);

      StockAssembly(debug=_CUTAWAY_RECEIVER);
    }

  }

  EvolverForendAssembly(debug=false);
} else {

  if (_RENDER == "Evolver_ReceiverFront")
  rotate([0,-90,0])
  Evolver_ReceiverFront();
  
  if (_RENDER == "Evolver_BarrelSupport")
  rotate([0,90,0])
  translate([-ForendSpacerLength()-Evolver_BarrelSupportLength(),0,0])
  Evolver_BarrelSupport();
  
  if (_RENDER == "Evolver_ForendSpacer")
  rotate([0,-90,0])
  Evolver_ForendSpacer();
  
  if (_RENDER == "Evolver_Spindle")
  rotate([0,90,0])
  translate([-3.375,0,1])
  Evolver_Spindle();
  
  if (_RENDER == "Evolver_SpindleZigZag")
  rotate([0,-90,0])
  translate([-(SpindleMaxX()+0.125),0,-SpindleZ()])
  Evolver_SpindleZigZag();
  
  if (_RENDER == "Evolver_Actuator")
  translate([-SpindleMaxX(),0, -0.5])
  rotate([-60,0,0])
  translate([0,0, -SpindleZ()])
  Evolver_Actuator();
}
