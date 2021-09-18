include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;
use <../../Meta/MirrorIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Helix.scad>;
use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Gear.scad>;
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
_RENDER = ""; // ["", "Receiver_LargeFrame", "Evolver_ReceiverFront", "Evolver_Spindle", "Evolver_SpindleSpacer", "Evolver_SpindleZigZag", "Evolver_SpindleGear", "Evolver_SpindleRatchet", "Evolver_SpindleRatchetPawl", "Evolver_SpindleActuator", "Evolver_SpindleActuatorBlock", "Evolver_BarrelSupport", "Evolver_ForendSpacer"]

/* [Assembly] */
_SHOW_BELT = true;
_SHOW_RECEIVER = true;
_SHOW_STOCK = true;
_SHOW_LOWER_LUGS = true;
_SHOW_LOWER = true;
_SHOW_FCG = false;
_SHOW_RECOIL_PLATE = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_ACTION_ROD = false;
_SHOW_FOREND_SPACER = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_FRAME_SPACER = true;
_SHOW_BARREL = true;
_SHOW_SPINDLE = true;
_SHOW_SPINDLE_SPACER = true;
_SHOW_SPINDLE_RATCHET = true;
_SHOW_SPINDLE_RATCHET_PAWL = true;
_SHOW_SPINDLE_ZIGZAG = true;
_SHOW_SPINDLE_ACTUATOR = true;
_SHOW_SPINDLE_GEAR = false;
_SHOW_SPINDLE_DRIVE = false;

/* [Transparency] */
_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_FOREND_SPACER = 1;      // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_FCG = 1;                // [0:0.1:1]
_ALPHA_STOCK = 1;              // [0:0.1:1]

/* [Cutaways] */
_CUTAWAY_BARREL = false;
_CUTAWAY_BARREL_SUPPORT = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_RECEIVER_FRONT = false;
_CUTAWAY_FOREND_SPACER = false;
_CUTAWAY_FCG = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;
_CUTAWAY_STOCK = false;

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
function ActionRodTravel() = 2;
function ReceiverFrontLength() = 0.5;
function TemplateHoleRadius() = 1/16;

function ChamferRadius() = 1/16;
function CR() = 1/16;

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilSpreaderThickness() = 0.5;

// Settings: Vitamins
function BarrelSetScrew() = BoltSpec(GP_BOLT);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown GP_BOLT?");

function ForendBolt() = BoltSpec(GP_BOLT);
assert(ForendBolt(), "ForendBolt() is undefined. Unknown GP_BOLT?");

// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);

// Calculated: Lengths
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - ReceiverFrontLength();
function SpindleLength() = 3.125;
function SpindleSplineLength() = 0.5;
function SpindleDriveLength() = 1.5;
function SpindleInterlockLength() = 0.25;
function SpindleInterlockRadius() = 0.75;
function SpindleToothPitch() = 0.125;
function SpindleSplineTeeth() = 21;
function SpindlePitchRadius() = pitch_radius(
                                  SpindleToothPitch(),
                                  SpindleSplineTeeth());

function SpindleGearRadius(clearance=0) = outer_radius(
                                 SpindleToothPitch(),
                                 SpindleSplineTeeth(), clearance);

function SpindleGearRootRadius(clearance=0) = root_radius(
                                 SpindleToothPitch(),
                                 SpindleSplineTeeth(), clearance);
                                 

// Calculated: Positions
function BarrelMinX() = ShellRimLength();
function ForendMaxX() = ForendLength();
function SpindleMaxX() = SpindleLength()+SpindleInterlockLength();                        
function ForendBoltZ() = TensionRodBottomZ()-0.375;
function ForendBoltY() = 1;

function ExtractorLength() = 0.25;
function ExtractorWidth() = 0.75;

function ForendSpacerLength() = SpindleLength();
function Evolver_BarrelSupportLength() = SpindleInterlockLength()+2.125;//ForendLength()-ForendSpacerLength();


pawlRadius = (1/32)+(1/128);
pawlPivotY = 0;
pawlPivotZ = SpindleZ()-(7/8);
pawlPivotAngle = -15;
pawlPinRadius = UnitsMetric(2.5)/2;
actuatorPinRadius = UnitsMetric(2.5)/2;
actuatorPinDepth = 0.125;

//************
//* Vitamins *
//************
module Evolver_Barrel(barrelLength=BarrelLength(), clearance=BARREL_CLEARANCE, cutter=false, alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

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

module Evolver_SpindlePins(cutter=false, clearance=0.003) {
  clear = cutter? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  RenderIf(!cutter)
  translate([SpindleLength()-0.25,0,SpindleZ()])
  rotate([0,90,0])
  for (R = [0:120:360]) rotate(R)
  translate([0.25, 0, -clear])
  cylinder(r=(UnitsMetric(2.5)/2)+clear, h=3/4+(cutter?1:0)+clear2);
}


module Evolver_SpindlePawlPin(cutter=false, clearance=0.003) {
  clear = cutter? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  RenderIf(!cutter)
  translate([SpindleLength()-clear,pawlPivotY,pawlPivotZ])
  rotate([0,90,0])
  cylinder(r=pawlPinRadius+clear, h=1+clear2);
}

module Evolver_SpindleActuatorPin(cutter=false, clearance=0.003, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  
  height = 0.5;
  
  color("Silver")
  RenderIf(!cutter)
  translate([0.5+actuatorPinRadius,0, SpindleZ()])
  rotate([60,0,0])
  translate([SpindleMaxX(),0, 0.5-actuatorPinDepth])
  cylinder(r=actuatorPinRadius+clear, h=height+ManifoldGap());
}
//**********
//* Motion *
//**********
module Evolver_SpindleRatchetPawlPivot(factor=0, angle=pawlPivotAngle) {
  translate([0,pawlPivotY,pawlPivotZ])
  rotate([factor*angle,0,0])
  translate([0,-pawlPivotY,-pawlPivotZ])
  children();
}

//*****************
//* Printed Parts *
//*****************
module Evolver_ReceiverFront(contoured=true, debug=_CUTAWAY_RECEIVER_FRONT, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilSpreaderThickness());
  
  color("Chocolate", alpha)
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
    
    ActionRod(cutter=true);
  }
}

module Evolver_ForendSpacer(length=ForendSpacerLength(), doRender=true, debug=false, alpha=1) {
  
  color("Tan", alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    
    hull() {
      FrameSupport(length=length,
                   chamferRadius=1/16, chamferFront=true, teardropFront=true);
      
      *translate([0,-3.625/2,0])
      ChamferedCube([length,3.625, 0.25], r=1/8);
    }
    
    // Belt clearance
    translate([-ManifoldGap(),0,SpindleZ()])
    rotate([0,90,0])
    cylinder(r=3.6875/2, h=3.125+ManifoldGap());
    
    // Belt clearance (wider guide)
    *translate([-ManifoldGap(),0,SpindleZ()-0.825])
    rotate([0,90,0])
    cylinder(r=5/2, h=3.125+ManifoldGap());
    
    FrameBolts(cutter=true);
  }
}

module Evolver_BarrelSupport(length=Evolver_BarrelSupportLength(), doRender=true, debug=false, alpha=_ALPHA_FOREND_SPACER) {
  extraBottom=0;
  
  offsetX = SpindleLength();
  
  // Branding text
  *color("DimGrey", alpha) 
  RenderIf(doRender) DebugHalf(enabled=debug) {
     
    fontSize = 0.375;
    
    // Right-side text
    translate([ForendMaxX()-0.125,-FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

    // Left-side text
    translate([ForendMaxX()-0.125,FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
  }
  
  color("Tan", alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([ForendSpacerLength(),0,0])
      Frame_ReceiverSegment(length=length,
                            highTop=true, chamferFront=false);
      
      // Spindle and interlock support
      hull() {
        
        // Spindle support
        translate([SpindleLength(),0,SpindleZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=0.5+0.125, r2=1/8, h=length,
                          teardropTop=true);
        
        // Spindle Interlock support
        translate([offsetX,0,SpindleZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=SpindleInterlockRadius()+0.125, r2=1/16,
                          h=SpindleInterlockLength(),
                          teardropBottom=false);
        
        // Pawl Pivot Support
        translate([offsetX,pawlPivotY,pawlPivotZ])
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
    
    Evolver_Spindle(cutter=true);
    
    Evolver_SpindlePawlPin(cutter=true);
    
    // Spindle ratchet pawl clearance
    hull() {
      
      // Pivot
      translate([SpindleMaxX(),pawlPivotY,pawlPivotZ])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.1875+0.005,
                        r2=1/32,
                        h=0.51,
                        teardropTop=true);
      
      translate([SpindleMaxX(),-(1/2), SpindleZ()-0.5])
      ChamferedCube([0.51, 1, 0.5], r=1/16);
      
      // Spindle
      translate([0,0,SpindleZ()-pawlPivotZ])
      translate([SpindleMaxX(),pawlPivotY,pawlPivotZ])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.5,
                        r2=1/32,
                        h=0.51,
                        teardropTop=true);
    }
          
    // Flatten the pivot support
    translate([offsetX+SpindleInterlockLength()-0.005,-(0.375/2), pawlPivotZ+0.1875])
    mirror([0,0,1])
    ChamferedCube([0.51, 0.375, 0.5], r=1/16);

    
    *for (F = [0,1]) Evolver_SpindleRatchetPawlPivot(factor=F)
    Evolver_SpindleRatchetPawl(cutter=true);
    
    // Spindle Drivetrain
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=0.51, r2=1/16,
                      h=SpindleMaxX()-SpindleInterlockLength()+length-0.375+0.01);
    
    // Clearance cut for rotating elements
    translate([0,-0.875/2, SpindleZ()])
    cube([SpindleMaxX()-SpindleInterlockLength()+length-0.375, 0.875, 1]);
    
    // Spindle hole
    translate([SpindleMaxX()-SpindleInterlockLength()+length,0,SpindleZ()])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32, h=0.375);
    
    FrameBolts(cutter=true);

    Evolver_Barrel(cutter=true);
    
    for (M = [0,1]) mirror([0,M,0])
    Evolver_SpindleActuator(cutter=true);
  }
}


module Evolver_Spindle(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  color("Chocolate", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Barrel interlock
      translate([SpindleLength(),0,SpindleZ()])
      rotate([0,90,0])
      difference() {
        
        // Interlock
        ChamferedCylinder(r1=SpindleInterlockRadius()+clear, r2=CR,
                           h=SpindleInterlockLength()+clearCR+clear,
                           chamferBottom=!cutter, teardropTop=true);
        
        // Interlock holes
        if (!cutter)
        for (R = [0:120:360]) rotate(60+R)
        translate([1,0,0])
        ChamferedCircularHole(r1=BarrelRadius()+0.005,
                              r2=(2/16),
                              h=SpindleInterlockLength(),
                              chamferBottom=false, teardropTop=true);
      }
      
      translate([0,0,SpindleZ()])
      rotate([0,90,0]) {
        
        hull() {
          
          // Trilobes
          hull()
          for (R = [0:120:360]) rotate(R)
          translate([0.66,0,0])
          ChamferedCylinder(r1=0.0625, r2=1/16, h=SpindleLength()+SpindleInterlockLength());
          
          // Wide flats
          hull()
          for (R = [0:120:360]) rotate(60+R)
          translate([0,-1/2,0])
          ChamferedCube([0.5-0.0625-0.01, 1, SpindleLength()+SpindleInterlockLength()], r=1/16);
        }
        
        // Rear position stops
        for (R = [0:120:360]) rotate(R)
       hull() {
          translate([BeltOffsetVertex()-0.25,0,0])
          ChamferedCylinder(r1=0.125, r2=1/16, h=0.625-0.01);
          
          translate([0.66,0,0])
          ChamferedCylinder(r1=0.0625, r2=1/16, h=0.625-0.01);
        }
      
        // Front position stops
        for (R = [0:120:360]) rotate(R)
        translate([0,0,2.125])
        hull() {
          translate([BeltOffsetVertex()-0.25+0.01,0,0])
          ChamferedCylinder(r1=0.125, r2=1/16, h=0.25);
          
          translate([0.66,0,0])
          ChamferedCylinder(r1=0.0625, r2=1/16, h=1);
        }
      }
    }
    
    if (!cutter)
    Evolver_SpindlePins(cutter=true);
    
    // Spindle hole
    if (!cutter)
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=SpindleLength()+SpindleInterlockLength()+SpindleSplineLength());
  }
}
module Evolver_SpindleSpacer(length=0.125, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Chocolate", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([SpindleMaxX()+0.5,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=(0.5)+clear,
                      r2=1/32,
                      h=length+clear2,
                      teardropTop=true);
    
    if (!cutter)
    Evolver_SpindlePins(cutter=true);
  
    // Spindle hole
    if (!cutter)
    translate([SpindleMaxX()+0.5,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
}

module Evolver_SpindleGear(length=SpindleSplineLength(), cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Chocolate", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([SpindleMaxX()+length,0,SpindleZ()])
    rotate([0,90,0])
    intersection() {
      ChamferedCylinder(r1=SpindleGearRadius()+clear,
                        r2=1/16,
                        h=length+clear2,
                        teardropTop=true);
      
      if (!cutter)
      translate([0,0,length/2])
      gear(SpindleToothPitch(),SpindleSplineTeeth(),length,0,0);
    }
    
    if (!cutter)
    Evolver_SpindlePins(cutter=true);
  
    // Spindle hole
    if (!cutter)
    translate([SpindleMaxX()+length,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
}
module Evolver_SpindleExtractor(length=0.5, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([ShellRimLength()*2,-0.125,SpindleZ()-(0.813/2)])
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
  
  color("Chocolate", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
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

module Evolver_SpindleRatchet(teeth = 3*7, length=0.5, angle=0, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  offsetX = SpindleMaxX();
  
  color("Chocolate", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([offsetX-clear,0,SpindleZ()])
    rotate([0,90,0])
    union() {
      
      // Centeral body
      ChamferedCylinder(r1=(29/64)+clear,
                        r2=1/32,
                        h=length+clear2,
                        teardropTop=true,
                        chamferBottom=!cutter, chamferTop=!cutter);
      // Teeth
      rotate(-90+angle)
      intersection() {
        for (T = [0:teeth-1])
        rotate(360/teeth*T)
        hull() {
          
          cylinder(r=(1/16), h=length+clear2);
          
          translate([0.5-(1/128),(1/64),0])
          cylinder(r=(1/128), h=length+clear2, $fn=8);
          
          rotate(45)
          translate([(7/16)-(1/16),0,0])
          cylinder(r=(1/64), h=length+clear2);
        }
        
        if (!cutter)
        ChamferedCylinder(r1=0.5, r2=1/32, h=length,
                          teardropTop=true);
      }
    }
    
    if (!cutter)
    Evolver_SpindlePins(cutter=true);
    
    // Spindle hole
    if (!cutter)
    translate([offsetX,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
}
module Evolver_SpindleRatchetPawl(length=0.5, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  
  length = length+clear2;
  offsetX = SpindleMaxX()-clear;
  
  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Extension
      translate([offsetX,pawlPivotY,pawlPivotZ])
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
      translate([SpindleMaxX(),0, SpindleZ()])
      rotate([360/21*3,0,0])
      translate([0,-pawlRadius-(1/32),-(0.5)+(1/64)])
      rotate([0,90,0]) {
        cylinder(r=pawlRadius, h=length, $fn=20);
        
        rotate(-360/21*3)
        translate([0.125,0,0])
        ChamferedCylinder(r1=5/64, r2=1/32, h=length);
      }
      
      // Pawl Support
      hull() {
        
        
        translate([SpindleMaxX(),0, SpindleZ()])
        rotate([360/21*3,0,0])
        translate([0,-pawlRadius-(1/32),-(0.5)+(1/64)])
        rotate([0,90,0])
        rotate(-360/21*3)
        translate([0.125,0,0])
        ChamferedCylinder(r1=5/64, r2=1/32, h=length);
        
        // Hull back to pivot
        translate([SpindleMaxX(),pawlPivotY-0.125,pawlPivotZ-0.125])
        ChamferedCube([length, 0.125*2, 0.1875], r=1/32);
      }
      
    }
    
    // Pawl pivot pin
    if (!cutter)
    Evolver_SpindlePawlPin(cutter=true);
  }
}


module Evolver_SpindleZigZag(length=1.25, cutter=false, clearance=0.01, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  offsetX = SpindleMaxX()+0.125;
  
  color("Chocolate", alpha)
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
    ZigZag(radius=0.5, mirrored=true,
           depth=0.125, width=(actuatorPinRadius+0.002)*2, positions=3,
           extraTop=length, extraBottom=actuatorPinRadius*2,
           supportsTop=false, supportsBottom=false);
  
    // Spindle hole
    if (!cutter)
    translate([offsetX,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=(0.3125/2)+0.007, r2=1/32,
                          h=length);
  }
}
module Evolver_SpindleActuator(cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;
  clearInstall = cutter ? SpindleInterlockLength() : 0;
  
  length = 3;
  width = 0.3125;
  height = 0.375;
  
  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([0,0, SpindleZ()])
    rotate([60,0,0])
    translate([SpindleMaxX()-clearInstall-clearCR-clear,-(width/2)-clear, 0.5-clear])
    ChamferedCube([length+clearInstall+clearCR+clear, width+clear2, height+clear2], r=1/16);
    
    if (!cutter)
    Evolver_SpindleActuatorPin(cutter=true);
  }
}

module Evolver_SpindleActuatorBlock(debug=false, alpha=1) {
  CR = 1/16;
  
  length = 0.5;
  width = 2;
  offsetX = ForendSpacerLength()+Evolver_BarrelSupportLength();
  
  color("Olive", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    hull() {
      translate([offsetX,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=width/2,r2=CR,h=length);
      
      translate([offsetX,-(width/2), 0])
      mirror([0,0,1])
      ChamferedCube([length, width, width/2], r=CR);
    }
    
    for (M = [0,1]) mirror([0,M,0])
    Evolver_SpindleActuator(cutter=true, clearance=0.002);
    
    Evolver_Barrel(cutter=true);
  }
}



module Evolver_SpindleDrive(length=0.5, cutter=false, clearance=0.007, debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  teeth = SpindleSplineTeeth();
  pitchRadius = pitch_radius(
                  SpindleToothPitch(),
                  teeth);

  outerRadius = outer_radius(
                 SpindleToothPitch(),
                 teeth, clearance);
    
  
  color("Olive", alpha) render() DebugHalf(enabled=debug)
  translate([0,0,SpindleZ()])
  for (R = [110, -110]) rotate([R,0,0])
  translate([SpindleMaxX()+0.5,0,-(SpindlePitchRadius()+pitchRadius)])
  rotate([0,90,0])
  union() {
    translate([0,0,length])
    difference() {
      ChamferedCylinder(
          r1=SpindleGearRadius()+clear,
          r2=1/16,
          h=SpindleDriveLength()+clear2,
          chamferBottom=false);
      
      if (!cutter)
      rotate(360/SpindleSplineTeeth())
      rotate(-R)
      ZigZag(radius=SpindleGearRadius(),
             depth=0.125, width=0.125, positions=3,
             extraTop=1, extraBottom=0.5,
             supportsTop=false, supportsBottom=false);
    }
    
    // Gear
    translate([0,0,length/2])
    intersection() {
      ChamferedCylinder(
          r1=outerRadius+clear,
          r2=1/16,
          center=true,
          h=length+clear2,
          chamferTop=false);
      
      if (!cutter)
      rotate(360/SpindleSplineTeeth())
      gear(SpindleToothPitch(),
           teeth,
           SpindleSplineLength(),0,0);
    }
  }
}

//**************
//* Assemblies *
//**************
module EvolverForendAssembly(pipeAlpha=1, debug=false) {
  animateSpindle = SubAnimate(ANIMATION_STEP_EXTRACT, end=0.5)
                   + SubAnimate(ANIMATION_STEP_EXTRACT, start=0.5);
  
  translate([0,0,SpindleZ()])
  rotate([animateSpindle*120,0,0])
  translate([0,0,1]) {
    Evolver_SpindlePins();
    
    if (_SHOW_BELT)
    translate([0.125,0,SpindleZ()])
    for (R = [0:120:360]) rotate([R,0,0])
    translate([0,0,1])
    rotate([0,90,0]) rotate(90)
    Belt(rounds=1,offset=0);
    
    if (_SHOW_SPINDLE)
    Evolver_Spindle(alpha=_ALPHA_SPINDLE);
    
    if (_SHOW_SPINDLE_ACTUATOR) {
      for (M = [0,1]) mirror([0,M,0]) {
        Evolver_SpindleActuator();
        Evolver_SpindleActuatorPin();
      }
      
      Evolver_SpindleActuatorBlock();
    }
    
    if (_SHOW_SPINDLE_SPACER)
    Evolver_SpindleSpacer();
    
    if (_SHOW_SPINDLE_GEAR)
    Evolver_SpindleGear(alpha=_ALPHA_SPINDLE);
    
    if (_SHOW_SPINDLE_RATCHET)
    Evolver_SpindleRatchet(alpha=_ALPHA_SPINDLE);
    
    if (_SHOW_SPINDLE_ZIGZAG)
    translate([0.5,0,0])
    Evolver_SpindleZigZag(alpha=_ALPHA_SPINDLE);
    
    *mirror([0,1,0])
    translate([0.25,0,0]) {
      Evolver_SpindleRatchet(teeth=3, angle=-360/12);
    }
  }
  
  if (_SHOW_SPINDLE_RATCHET_PAWL) {
    Evolver_SpindlePawlPin();
    
    Evolver_SpindleRatchetPawlPivot(factor=0)
    Evolver_SpindleRatchetPawl(alpha=_ALPHA_SPINDLE);
  }
  
  *mirror([0,1,0])
  translate([0.25,0,0]) {
    Evolver_SpindlePawlPin();
    Evolver_SpindleRatchetPawlPivot(factor=0)
    Evolver_SpindleRatchetPawl(alpha=_ALPHA_SPINDLE);
  }
  
  if (_SHOW_SPINDLE_DRIVE)
  Evolver_SpindleDrive();
  
  if (_SHOW_BARREL) {
    barrelTravel = SpindleMaxX();
    animateBarrel = Animate(ANIMATION_STEP_UNLOAD)
                  - Animate(ANIMATION_STEP_LOAD);
    
    barrelTravel2 = 1;
    animateBarrel2 = SubAnimate(ANIMATION_STEP_EXTRACT, end=0.5)
                   - SubAnimate(ANIMATION_STEP_EXTRACT, start=0.5);
    
    translate([(barrelTravel2*animateBarrel2),0,0])
    translate([(barrelTravel*animateBarrel),0,0]) {
      Evolver_Barrel(debug=_CUTAWAY_BARREL);
      
      // Actuator Nubbin
      translate([0.75,0.5,0])
      rotate([-90,0,0])
      render()
      cylinder(r=0.125, h=0.25);
    }
      
      
  }
  
  if (_SHOW_FOREND_SPACER)
  Evolver_ForendSpacer(debug=_CUTAWAY_FOREND_SPACER, alpha=_ALPHA_FOREND_SPACER);
  
  if (_SHOW_BARREL_SUPPORT)
  Evolver_BarrelSupport(debug=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_BARREL_SUPPORT);
  
  if (_SHOW_RECEIVER_FRONT)
  translate([-0.5,0,0])
  Evolver_ReceiverFront();
}


scale(25.4)
if ($preview) {
  
  *Evolver_SpindleExtractor();

  translate([-ReceiverFrontLength(),0,0]) {
    
    if (_SHOW_LOWER_LUGS)
    LowerMount();

    if (_SHOW_LOWER)
    Lower();
    
    if (_SHOW_RECEIVER) {
      
      Receiver_TensionBolts(debug=_CUTAWAY_RECEIVER);
      
      Receiver_LargeFrameAssembly(
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_FCG)
    SimpleFireControlAssembly(recoilPlate=_SHOW_RECOIL_PLATE);

    if (_SHOW_STOCK) {
      StockAssembly();
    }
  }
  
  *translate([0,0,0])
  rotate([0,90,0]) rotate(90)
  Belt(rounds=1,offset=0);

  EvolverForendAssembly(debug=false);
} else {

  if (_RENDER == "Evolver_ReceiverFront")
  rotate([0,-90,0])
  Evolver_ReceiverFront();
  
  if (_RENDER == "Evolver_Spindle")
  rotate([0,90,0])
  translate([-3.375,0,1])
  Evolver_Spindle(alpha=_ALPHA_SPINDLE);
  
  if (_RENDER == "Evolver_SpindleZigZag")
  rotate([0,-90,0])
  translate([-(SpindleMaxX()+0.125),0,-SpindleZ()])
  Evolver_SpindleZigZag(alpha=_ALPHA_SPINDLE);
  
  if (_RENDER == "Evolver_SpindleGear")
  rotate([0,-90,0])
  translate([-(SpindleMaxX()),0,-SpindleZ()])
  Evolver_SpindleGear(alpha=_ALPHA_SPINDLE);
  
  if (_RENDER == "Evolver_SpindleSpacer")
  rotate([0,-90,0])
  translate([-SpindleMaxX()-0.5,0,-SpindleZ()])
  Evolver_SpindleSpacer(alpha=_ALPHA_SPINDLE);
  
  if (_RENDER == "Evolver_SpindleRatchet")
  rotate([0,-90,0])
  translate([-(SpindleLength()+SpindleInterlockLength()),0,-SpindleZ()])
  Evolver_SpindleRatchet();
  
  if (_RENDER == "Evolver_SpindleRatchetPawl")
  rotate([0,-90,0])
  translate([-(SpindleLength()+SpindleInterlockLength()),-pawlPivotY,-pawlPivotZ])
  Evolver_SpindleRatchetPawl();
  
  if (_RENDER == "Evolver_SpindleActuatorBlock")
  rotate([0,-90,0])
  translate([-(ForendSpacerLength()+Evolver_BarrelSupportLength()),0,0])
  Evolver_SpindleActuatorBlock();
  
  if (_RENDER == "Evolver_SpindleActuator")
  translate([-SpindleMaxX(),0, -0.5])
  rotate([-60,0,0])
  translate([0,0, -SpindleZ()])
  Evolver_SpindleActuator();
  
  if (_RENDER == "Evolver_SpindleDrive")
  rotate([0,90,0])
  translate([-3.25,0,1])
  Evolver_SpindleDrive();
  
  if (_RENDER == "Evolver_BarrelSupport")
  rotate([0,90,0])
  translate([-ForendSpacerLength()-Evolver_BarrelSupportLength(),0,0])
  Evolver_BarrelSupport();
  
  if (_RENDER == "Evolver_ForendSpacer")
  rotate([0,-90,0])
  Evolver_ForendSpacer();
}
