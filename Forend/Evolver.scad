include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Conditionals/MirrorIf.scad>;

use <../Meta/Math/Triangles.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Helix.scad>;
use <../Shapes/Bearing Surface.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/ZigZag.scad>;

use <../Shapes/Components/Pivot.scad>;
use <../Shapes/Components/Cylinder Redux.scad>;
use <../Shapes/Components/Pump Grip.scad>;

use <../Vitamins/Bearing.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <../Receiver/FCG.scad>;
use <../Receiver/Frame.scad>;
use <../Receiver/Lower.scad>;
use <../Receiver/Receiver.scad>;
use <../Receiver/Stock.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/Receiver_LargeFrame", "Prints/Evolver_ReceiverFront", "Prints/Evolver_Foregrip", "Prints/Evolver_VerticalForegrip", "Prints/Evolver_CylinderCore", "Prints/Evolver_CylinderShell", "Prints/Evolver_BarrelSupport", "Prints/Evolver_Projection_Cylinder", "Prints/Evolver_Projection_CylinderCore", "Prints/Evolver_Projection_RecoilPlate"]

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

_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_FOREND_SPACER = 1;      // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_FCG = 1;                // [0:0.1:1]
_ALPHA_STOCK = 1;              // [0:0.1:1]

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
BRANDING_MODEL_NAME = "BFG-12ga";

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
             h=barrelLength,
             $fn=Resolution(20,50));

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
      hull() {
        mirror([1,0,0])
        ReceiverTopSegment(length=length, chamferBack=false);

        FrameSupport(length=length,
                     chamferFront=true, teardropFront=true);
      }

      hull() {

        // Recoil plate backing
        translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
        mirror([0,0,1])
        ChamferedCube([length,
                       RecoilPlateWidth()+0.5,
                       RecoilPlateHeight()-0.5],
                      r=1/8, teardropFlip=[true,true,true]);

        // Round off the bottom
        translate([0,0,-1])
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

  // Branding text
  color("DimGrey", alpha)
  RenderIf(doRender) Cutaway(cutaway) {

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

      // Frame support
      hull() {
        translate([ForendMinX(),0,0])
        FrameSupport(length=Evolver_BarrelSupportLength(),
                     extraBottom=extraBottom,
                     chamferBack=true, teardropBack=true);

        translate([ForendMinX(), 0, 0])
        mirror([1,0,0])
        ReceiverTopSegment(length=Evolver_BarrelSupportLength(),
                           chamferFront=false);
      }

      // Around the barrel
      hull() {
        translate([ForendMinX(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR(),
                 h=Evolver_BarrelSupportLength(),
                            teardropTop=true);

        translate([ForendMinX(), -(BarrelRadius()+WallBarrel()), 0])
        ChamferedCube([Evolver_BarrelSupportLength(),
                       (BarrelRadius()+WallBarrel())*2,
                       FrameBoltZ()], r=CR(), teardropFlip=[true,true,true]);
      }
    }

    // Weld clearance: Barrel to blast plate fillet
    translate([ForendMinX(), 0, 0])
    rotate([0,90,0])
    HoleChamfer(r1=BarrelRadius(), r2=0.3125, teardrop=true);

    FrameBolts(cutter=true);

    Evolver_Barrel(cutter=true);
    
    for (M = [0,1]) mirror([0,M,0])
    Evolver_SpindleActuator(cutter=true);
  }
}

module Evolver_VerticalForegrip(length=2, cutaway=true, alpha=1) {
  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    union() {
      translate([ForegripMinX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel(),
                        r2=1/16, h=length, $fn=Resolution(40,80));

      // Grip block
      translate([ForegripMinX(),-1/2,0])
      rotate([0,90,0])
      ChamferedCube([abs(CylinderZ())+0.25, 1, length], r=1/16);

      // Action Rod Support Block
      translate([ForegripMinX(),-0.75/2,0])
      ChamferedCube([2, 0.75, ActionRodZ()+0.375], r=1/8);
    }

    // Inner bearing profile
    translate([ForegripMinX(),0,0])
    rotate([0,90,0])
    BearingSurface(r=BarrelRadius()+0.02,
                   length=length, center=false,
                   depth=0.0625, segments=6, taperDepth=0.125);

    ActionRod(cutter=true);
    Evolver_Barrel(cutter=true);
    Evolver_ForegripBolts(cutter=true);
  }
  
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

    // Body around the barrel
    union() {
    
      translate([0,0,SpindleZ()])
      rotate([0,90,0])
      PumpGrip(length=length);

      // Action Rod Support Block
      translate([ForegripMinX(),-0.75/2,0])
      ChamferedCube([2, 0.75, ActionRodZ()+0.375], r=1/8);
    }

    // Inner bearing profile
    translate([ForegripMinX(),0,0])
    rotate([0,90,0])
    BearingSurface(r=BarrelRadius()+0.02,
                   length=length, center=false,
                   depth=0.0625, segments=6, taperDepth=0.125);

    ActionRod(cutter=true);
    Evolver_ForegripBolts(cutter=true);
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
module EvolverForendAssembly(pipeAlpha=1, cutaway=false) {

  animateBarrel = Animate(ANIMATION_STEP_CHARGE)
                - Animate(ANIMATION_STEP_CHARGER_RESET);

  barrelTravel = CHAMBER_LENGTH;

  if (_SHOW_BARREL)
  translate([(barrelTravel*animateBarrel),0,0])
  Evolver_Barrel(cutaway=cutaway);

  if (_SHOW_BARREL_SUPPORT)
  Evolver_BarrelSupport(cutaway=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_FOREND);

  if (_SHOW_RECEIVER_FRONT)
  translate([-0.5,0,0])
  Evolver_ReceiverFront();
}


scale(25.4)
if ($preview) {

  translate([-ReceiverFrontLength(),0,0]) {

    if (_SHOW_LOWER_LUGS)
    LowerMount();

    if (_SHOW_LOWER)
    Lower();

    if (_SHOW_RECEIVER) {

      Receiver_TensionBolts(cutaway=_CUTAWAY_RECEIVER);

      Receiver_LargeFrameAssembly(
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_FCG)
    SimpleFireControlAssembly(recoilPlate=_SHOW_RECOIL_PLATE) {

      if (_SHOW_FOREGRIP) {

        Evolver_ForegripBolts();

        if (_FOREGRIP == "Standard") {
          Evolver_Foregrip(cutaway=_CUTAWAY_FOREGRIP,
                            alpha=_ALPHA_FOREGRIP);
        } else {
          Evolver_VerticalForegrip(cutaway=_CUTAWAY_FOREGRIP,
                                    alpha=_ALPHA_FOREGRIP);
        }
      }

      // Actuator pin
      *translate([0.125+ReceiverFrontLength()+ActionRodTravel(),0,ActionRodZ()])
      mirror([0,0,1])
      cylinder(r=0.125, h=0.15+0.125);


      // Forward Actuator Pin
      *translate([0.25+ForendMaxX(),0,ActionRodZ()])
      rotate([-90,0,0])
      cylinder(r=0.125, h=0.15+0.125+3);
    }

    if (_SHOW_STOCK) {
      StockAssembly();
    }
  }
  
  *translate([0,0,0])
  rotate([0,90,0]) rotate(90)
  Belt(rounds=1,offset=0);

  EvolverForendAssembly(debug=false);
} else {

  if (_RENDER == "Prints/Evolver_ReceiverFront")
  rotate([0,-90,0])
  Evolver_ReceiverFront();

  if (_RENDER == "Prints/Evolver_BarrelSupport")
  rotate([0,90,0]) translate([-ForendMaxX(),0,0])
  render()
  Evolver_BarrelSupport(doRender=false);

  if (_RENDER == "Prints/Evolver_Foregrip")
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Evolver_Foregrip();

  if (_RENDER == "Prints/Evolver_VerticalForegrip")
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Evolver_VerticalForegrip();
}
