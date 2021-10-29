include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/Conditionals/MirrorIf.scad>;

use <../Meta/Math/Triangles.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Bearing Surface.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Helix.scad>;
use <../Shapes/ZigZag.scad>;

use <../Shapes/Components/Pivot.scad>;
use <../Shapes/Components/Cylinder Redux.scad>;
use <../Shapes/Components/Pump Grip.scad>;

use <../Vitamins/Bearing.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <../Ammo/Belt.scad>;

use <../Receiver/Receiver.scad>;
use <../Receiver/FCG.scad>;
use <../Receiver/Frame.scad>;
use <../Receiver/Lower.scad>;
use <../Receiver/Receiver.scad>;
use <../Receiver/Stock.scad>;

use <../Receiver/FCG.scad>;


/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "ReceiverFront", "Spindle", "ZigZag", "Ratchet", "RatchetPawl","Actuator", "ActuatorToggle", "BarrelSupport", "ForendSpacer", "PumpRod", "PumpCollar"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_PRINTS = true;
_SHOW_HARDWARE = true;
_SHOW_RECEIVER = true;
_SHOW_STOCK = true;
_SHOW_FCG = true;
_SHOW_LOWER = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_FOREND_SPACER = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_BARREL = true;
_SHOW_PUMP_COLLAR = true;
_SHOW_PUMP_RODS = true;
_SHOW_ACTUATOR = true;
_SHOW_ACTUATOR_TOGGLE = true;
_SHOW_RATCHET_PAWL = true;
_SHOW_SPINDLE = true;
_SHOW_EXTRACTOR = true;
_SHOW_BELT = true;

/* [Transparency] */
_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_FOREND_SPACER = 1;      // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_ACTUATOR = 1;           // [0:0.1:1]
_ALPHA_PUMP = 1;               // [0:0.1:1]
_ALPHA_RECEIVER = 0.15;        // [0:0.1:1]
_ALPHA_LOWER = 0.15;           // [0:0.1:1]
_ALPHA_STOCK = 0.15;           // [0:0.1:1]
_ALPHA_FCG = 0.15;             // [0:0.1:1]

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

/*
 * Setup
 */
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT);
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=1);
//$t = AnimationDebug(ANIMATION_STEP_EXTRACT, start=1,end=1);
//$t = 0.2;
$t = 0.5+(0.5*$t);

// Settings: Lengths
function SpindleRodLength() = 6;
function SpindleRadius() = SPINDLE_DIAMETER/2;
function ShellRimLength() = 0.06;
function BarrelLength() = BARREL_LENGTH;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.3575; //0.4375;
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
function BarrelCollarOffset() = 0.5;

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



function Evolver_PumpRodToggleExtension() = 0.1875;
function Evolver_ActuatorMinX() = ForendSpacerLength()-0.25;
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
pumpPinX = 2;

//************
//* Vitamins *
//************
module Evolver_Barrel(barrelLength=BarrelLength(), clearance=BARREL_CLEARANCE, cutter=false, alpha=1, cutaway=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("DimGrey", alpha) RenderIf(!cutter) Cutaway(cutaway)
  translate([ForendLength()+BarrelCollarOffset()-clear,0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=(BarrelCollarDiameter()/2)+clear, h=BarrelCollarLength()+clear2);

    if (!cutter)
    cylinder(r=BarrelRadius()+clearance,
             h=barrelLength);
  }

  color("Silver", alpha) RenderIf(!cutter) Cutaway(cutaway)
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

module Evolver_BarrelCollar(clearance=BARREL_CLEARANCE, cutter=false, alpha=1, cutaway=false) {
  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("DimGrey", alpha) RenderIf(!cutter) Cutaway(cutaway)
  translate([ForendLength()+BarrelCollarOffset()-clear,0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=(BarrelCollarDiameter()/2)+clear, h=BarrelCollarLength()+clear2);

    if (!cutter)
    Evolver_Barrel(cutter=true);
  }
}


module Evolver_SpindleRod(cutter=false, clearance=0.003) {
  clear = cutter? clearance : 0;
  clear2 = clear*2;

  color("Silver")
  RenderIf(!cutter)
  translate([-0.5,0,SpindleZ()])
  rotate([0,90,0])
  cylinder(r=SpindleRadius()+clear, h=SpindleRodLength());
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

module Evolver_ActuatorPin(cutter=false, clearance=0.003, cutaway=false, alpha=1) {
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
module Evolver_PumpCollarBolts(cutter=false, clearance=0.003, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;

  height = 0.5;
  offsetX = actuatorPinX;

  color("Silver")
  RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  rotate([60,0,0])
  translate([ForendLength()+0.25+(BarrelCollarLength()/2),
             0,
             BarrelCollarRadius()-0.25-clear])
  cylinder(r=actuatorPinRadius+clear, h=0.5+clear2);
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
module Evolver_ReceiverFront(contoured=true, cutaway=_CUTAWAY_RECEIVER_FRONT, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilSpreaderThickness());

  color("Tan", alpha)
  render() Cutaway(cutaway)
  difference() {
    union() {
        Frame_Receiver_Segment(length=length,
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

    RecoilPlateSideBolts(cutter=true);
    RecoilPlateCenterBolts(cutter=true);

    RecoilPlate(contoured=contoured, spindleZ=CylinderZ(), cutter=true);
    FiringPin(cutter=true);
    Frame_Bolts(cutter=true);

    RecoilPlateBolts(cutter=true);
    Receiver_TensionBolts(cutter=true);

    // Firing Pin Spring Chamfer
    rotate([0,90,0])
    HoleChamfer(r1=FiringPinSpringRadius(), r2=1/16);

    FiringPinSpring(cutter=true);

    translate([0,0,0.25])
    ActionRod(cutter=true);

    // Spindle Rod
    translate([0,0,SpindleZ()])
    rotate([0,90,0])
    HoleChamfer(r1=SpindleRadius(), r2=1/16);

    Evolver_SpindleRod(cutter=true);
  }
}

module Evolver_ForendSpacer(length=ForendSpacerLength(), doRender=true, cutaway=false, alpha=1) {

  color("Tan", alpha)
  RenderIf(doRender) Cutaway(cutaway)
  difference() {

    hull() {

      Frame_Support(length=length,
                   chamferRadius=1/16, chamferFront=true, teardropFront=true);

      mirror([1,0,0])
      ReceiverTopSegment(length=length, chamferBack=false);

      translate([0.875,-3.5/2,-0.25])
      ChamferedCube([1,3.5, FrameBoltZ()+ 0.25], r=1/16);
    }

    // Belt clearance
    translate([-ManifoldGap(),0,SpindleZ()])
    rotate([0,90,0])
    cylinder(r=(3.6875/2), h=length+ManifoldGap());

    translate([0,0,0.25])
    ActionRod(cutter=true);

    Frame_Bolts(cutter=true);
  }
}

module Evolver_BarrelSupport(length=Evolver_BarrelSupportLength(), doRender=true, cutaway=false, alpha=_ALPHA_FOREND_SPACER) {
  extraBottom=0;

  offsetX = ForendSpacerLength();

  // Branding text
  color("DimGrey", alpha)
  RenderIf(doRender) Cutaway(cutaway) {

    fontSize = 0.375;

    // Right-side text
    translate([ForendMaxX()-0.25,-FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

    // Left-side text
    translate([ForendMaxX()-0.25,FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
  }

  color("Tan", alpha)
  RenderIf(doRender) Cutaway(cutaway)
  difference() {
    union() {
      translate([offsetX,0,0])
      Frame_Receiver_Segment(length=length,
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
    Evolver_ZigZag(cutter=true);

    Evolver_PumpRods(cutter=true, innerCut=true);

    translate([0,0,0.25])
    ActionRod(cutter=true);

    // Spindle hole
    translate([ForendSpacerLength(),0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCylinder(r1=(0.3125/2)+0.007, r2=1/32, h=Evolver_ZigZagLength()+0.5);

    Frame_Bolts(cutter=true);

    Evolver_Barrel(cutter=true);
    Evolver_BarrelCollar(cutter=true);

    Evolver_Actuator(cutter=true);
    Evolver_ActuatorToggle(cutter=true);
  }
}
module Evolver_Extractor(length=0.5, cutter=false, clearance=0.002, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver", alpha) RenderIf(!cutter) Cutaway(cutaway)
  difference() {

    translate([0,0,SpindleZ()])
    for (R = [0:120:360]) rotate([R,0,0])
    translate([0,0,-SpindleZ()])

    translate([ShellRimLength()*1.5,-0.125,-(0.813/2)])
    rotate([0,180-45,0])
    mirror([1,0,0])

    cube([(1/16)+clear2, 0.25, 0.625]);
  }
}
module Evolver_Ratchet(teeth = 3*7, length=Evolver_RatchetLength(), angle=0, cutter=false, clearance=0.01, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;

  offsetX = ForendSpacerLength()-length;

  color("Olive", alpha) RenderIf(!cutter) Cutaway(cutaway)
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
    Evolver_SpindlePins(cutter=true);

    if (!cutter)
    translate([offsetX-clear,0,SpindleZ()])
    rotate([0,90,0])
    ChamferedCircularHole(r1=0.3125/2, r2=1/32, h=length,
                      teardropTop=true);
  }
}

module Evolver_RatchetPawl(length=0.5, cutter=false, clearance=0.01, cutaway=false, alpha=1) {
clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;

  length = length+clear2;
  offsetX = ForendSpacerLength()-length-clear;

  color("Pink", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
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
module Evolver_Spindle(cutter=false, clearance=0.007, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;

  color("Olive", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
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
module Evolver_ZigZag(length=Evolver_ZigZagLength(), cutter=false, clearance=0.01, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  offsetX = ForendSpacerLength();

  color("Olive", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    union() {
      translate([offsetX,0,SpindleZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=0.5+clear,
                        r2=1/16,
                        h=length+clear2,
                        teardropTop=true,
                        chamferBottom=!cutter);
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
module Evolver_Actuator(cutter=false, clearance=0.01, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;

  width = 0.5;
  height = 0.375;
  length = Evolver_BarrelSupportLength()+0.25;
  legLength = 0.5;

  color("Chocolate", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    union() {
      translate([Evolver_ActuatorMinX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelCollarRadius()+clear,r2=CR,
                         h=length+clearCR+(cutter?Evolver_ActuatorTravel():0));

      // Actuator legs
      hull()
      for (M = [0,1]) mirror([0,M,0])
      translate([Evolver_ActuatorMinX(),0, SpindleZ()])
      rotate([60,0,0])
      translate([-clearCR-clear,-(width/2)-clear, 0.5-clear])
          ChamferedCube([legLength+(cutter?Evolver_ActuatorTravel():0)+clearCR+clear,
                         width+clear2, height+clear2], r=1/16);
    }

    if (!cutter)
    Evolver_PumpRods(cutter=true);

    if (!cutter)
    for(X = [0,-Evolver_ActuatorTravel()]) translate([X,0,0])
    Evolver_ZigZag(cutter=true);

    if (!cutter)
    Evolver_ActuatorPin(cutter=true);

    if (!cutter)
    Evolver_ActuatorToggle(stopTab=false, cutter=true);

    if (!cutter) {
      Evolver_Barrel(cutter=true);
      Evolver_BarrelCollar(cutter=true);
    }
  }
}

module Evolver_ActuatorToggle(AF=0, stopTab=true, cutter=false, clearance=0.01, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;


  tabLength = 0.5;
  width = 0.25;
  height = 0.125;
  wall = 0.125;
  angle=-15;
  tabOffsetX = Evolver_ActuatorMinX()+0.5-clear;
  length = 1.125;
  extension = 1;
  innerRadius = BarrelRadius();
  extensionRadius = BarrelCollarRadius()-Evolver_PumpRodToggleExtension();//(BarrelRadius()+(1/16)+clear);
  bodyAngle = 60;
  extensionAngle = bodyAngle+abs(angle*3);
  helixOffsetX = tabOffsetX+tabLength;

  color("CornflowerBlue", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  for (M = [0,1]) mirror([0,M,0])
  rotate([angle*AF,0,0])
  difference() {
    union() {
      // Cam
      difference() {
        union() {

          // Body
          translate([tabOffsetX-clear,0,0])
          rotate([-70+angle+(cutter?angle:0),0,0])
          rotate([0,90,0])
          mirror([1,0])
          linear_extrude(2.25+clear2)
          semidonut(major=(BarrelCollarRadius()+clear)*2,
                    minor=(innerRadius-clear)*2,
                    angle=bodyAngle+(cutter?abs(angle):0));

          // Stop tab
          if (stopTab)
          intersection()  {
            translate([(cutter?0:tabOffsetX)-clear,0,0])
            rotate([-60-angle,0,0])
            translate([0,-(width/2)+(cutter?clearance*2:clearance), 0])
            cube([tabLength+(cutter?tabOffsetX:0), width+(cutter?clearance*2:-(clearance*2)), BarrelCollarRadius()+Evolver_PumpRodToggleExtension()+clear]);

            translate([(cutter?0:tabOffsetX)-clear,0,0])
            rotate([0,90,0])
            cylinder(r=BarrelCollarRadius()+0.1875, h=length);
          }

        }

        // Helix
        if (!cutter)
        for (X = [0:width/2:1-(width/2)])
        translate([helixOffsetX+X,0,0])
        rotate([-60,0,0])
        rotate([0,90,0])
        mirror([1,0,0])
        difference() {
          HelixSegment(radius=BarrelCollarRadius(),
                       depth=Evolver_PumpRodToggleExtension(), width=0.25+clear2,
                       angle=abs(angle),
                       verbose=false);

          cylinder(r=BarrelCollarRadius()-Evolver_PumpRodToggleExtension(), h=length);
        }

        // Pump rod slot
        if (!cutter)
        translate([Evolver_ActuatorMinX()-clear,0,0])
        difference() {
          rotate([-60,0,0])
          translate([0,-(width/2), 0])
          cube([length+1-0.0625,
                width,
                BarrelCollarRadius()+Evolver_PumpRodToggleExtension()+clear]);

          rotate([0,90,0])
          cylinder(r=BarrelCollarRadius()-Evolver_PumpRodToggleExtension(),
                   h=length+1);
        }
      }

      // Captured Lip Extension
      translate([tabOffsetX-clear,0,0])
      rotate([-60+(angle*3)+(cutter?angle:0),0,0])
      rotate([0,90,0])
      mirror([1,0])
      intersection() {
        linear_extrude(2.25+clear2)
        semicircle(od=extensionRadius*2,
                  angle=extensionAngle+(cutter?abs(angle):0));


      }

    }

    if (!cutter) {
      Evolver_Barrel(cutter=true);
      Evolver_BarrelCollar(cutter=true);
    }

    *if (!cutter)
    translate([-0.5,0,0])
    Evolver_PumpRods(cutter=true);
  }
}


module Evolver_PumpRods(doMirror=true, cutter=false, innerCut=false, clearance=0.01, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  CR = 1/16;
  clearCR = cutter ? CR : 0;

  length = 4+actuatorPinRadius;
  width = 0.25;
  height = 0.25;
  toggleHeight = Evolver_PumpRodToggleExtension();
  angle = -60;
  extend=1;

  // Pump rods
  color("Olive", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  for (M = (doMirror?[0,1]:[0])) mirror([0,M,0])
  rotate([angle,0,0])
  difference() {
    union() {

      // Long rod
      translate([pumpPinX-width-clear,-(width/2)-clear, (innerCut?0:BarrelCollarRadius())-clear])
      ChamferedCube([length+width+CR*2+clear2, width+clear2, (innerCut?+BarrelCollarRadius():0)+height+clear2],
                    r=1/16, teardropFlip=[true,true,true]);

      // Actuator tab
      translate([pumpPinX-clear,
                 -(width/2)-clear,
                 BarrelCollarRadius()-toggleHeight-clear])
      translate([-extend,0,0])
      ChamferedCube([extend+(cutter?Evolver_BarrelTravel():0)+clear2,
                     width+clear2,
                     height+toggleHeight+clear2],
                    r=1/16, teardropFlip=[true,true,true]);

      // Barrel Collar Stop
      translate([pumpPinX+length-ManifoldGap(), -(width/2)-clear, 0])
      ChamferedCube([BarrelCollarOffset()+BarrelCollarLength()+0.5,
                     width+clear2,
                     BarrelCollarRadius()+height+clear],
                    r=1/16, teardropFlip=[true,true,true]);
    }

    if (!cutter)
    Evolver_BarrelCollar(cutter=true);

    Evolver_Barrel(cutter=true);
  }
}

module Evolver_PumpCollar() {
  length = 0.5+BarrelCollarLength();
  width = 0.5;
  offsetX = ForendLength()+BarrelCollarOffset();

  color("Chocolate") render()
  difference() {
    union() {
      hull() {

        // Around the collar
        translate([offsetX,0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelCollarRadius()+0.125,r2=1/16,
                           h=BarrelCollarLength()+0.125);

        // Around the barrel
        translate([offsetX,0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+0.125,r2=1/16,
                           h=length+0.5);
      }

      for (R = [60,-60]) rotate([R,0,0])
      hull()
      translate([offsetX,0,0])
      translate([0,-width/2,0]) {
        ChamferedCube([BarrelCollarLength(),
                       width,
                       BarrelCollarRadius()+0.25+0.125],
                      r=1/16);

        ChamferedCube([length,
                       width,
                       BarrelRadius()+0.125],
                      r=1/16);
      }
    }

    Evolver_Barrel(cutter=true);
    Evolver_BarrelCollar(cutter=true);
    Evolver_PumpRods(cutter=true, clearance=0.005);
    Evolver_PumpCollarBolts(cutter=true);
  }
}

//**************
//* Assemblies *
//**************
module EvolverForendAssembly(hardware=true, prints=true, pipeAlpha=1, cutaway=false) {
  animateSpindle = (SubAnimate(ANIMATION_STEP_EXTRACT, start=0.19, end=0.46)
                   + SubAnimate(ANIMATION_STEP_EXTRACT, start=0.63, end=0.9))/2;

  animateBarrel = Animate(ANIMATION_STEP_UNLOAD)
                - Animate(ANIMATION_STEP_LOAD);

  animateBarrel2 = SubAnimate(ANIMATION_STEP_EXTRACT, end=0.5)
                 - SubAnimate(ANIMATION_STEP_EXTRACT, start=0.5);

  animateActuatorLatch = SubAnimate(ANIMATION_STEP_EXTRACT, end=0.05)
                       - SubAnimate(ANIMATION_STEP_LOAD, end=0.05);

  Evolver_SpindleRod();

  if (_SHOW_RATCHET_PAWL) {
    if (hardware)
    Evolver_RatchetPawlPin();
    
    if (prints)
    Evolver_RatchetPawlPivot(factor=0)
    Evolver_RatchetPawl();
  }

  translate([0,0,SpindleZ()])
  rotate([animateSpindle*120,0,0])
  translate([0,0,1]) {

    if (prints && _SHOW_BELT)
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
      if (hardware && _SHOW_EXTRACTOR)
      Evolver_Extractor(cutaway=_CUTAWAY_SPINDLE);

      if (hardware)
      Evolver_SpindlePins();
      
      
      if (prints)
      Evolver_Spindle(cutaway=_CUTAWAY_SPINDLE, alpha=_ALPHA_SPINDLE);
      
      if (prints)
      Evolver_Ratchet(cutaway=_CUTAWAY_SPINDLE, alpha=_ALPHA_SPINDLE);
      
      if (prints)
      Evolver_ZigZag(cutaway=_CUTAWAY_SPINDLE, alpha=_ALPHA_SPINDLE);
    }
  }


  translate([(Evolver_ActuatorTravel()*animateBarrel2),0,0])
  translate([(Evolver_BarrelTravel()*animateBarrel),0,0]) {

    if (hardware && _SHOW_BARREL)
    Evolver_Barrel(cutaway=_CUTAWAY_BARREL);

    if (prints && _SHOW_PUMP_COLLAR)
    Evolver_PumpCollar();
  }

  translate([Evolver_ActuatorTravel()*animateBarrel2,0,0]) {

    if (prints && _SHOW_ACTUATOR_TOGGLE)
    Evolver_ActuatorToggle(AF=animateActuatorLatch);

    if (hardware && _SHOW_ACTUATOR)
    Evolver_ActuatorPin();

    if (prints && _SHOW_ACTUATOR)
    Evolver_Actuator(cutaway=_CUTAWAY_ACTUATOR, alpha=_ALPHA_ACTUATOR);
  }

  translate([(Evolver_ActuatorTravel()*animateBarrel2),0,0])
  translate([(Evolver_BarrelTravel()*animateBarrel),0,0]) {

    if (hardware && _SHOW_PUMP_RODS)
    Evolver_PumpCollarBolts();

    if (prints && _SHOW_PUMP_RODS)
    Evolver_PumpRods(alpha=_ALPHA_PUMP);

    *translate([-3,0,0.125])
    ActionRod();
  }

  if (prints && _SHOW_FOREND_SPACER)
  Evolver_ForendSpacer(cutaway=_CUTAWAY_FOREND_SPACER, alpha=_ALPHA_FOREND_SPACER);

  if (prints && _SHOW_BARREL_SUPPORT)
  Evolver_BarrelSupport(cutaway=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_BARREL_SUPPORT);

  if (prints && _SHOW_RECEIVER_FRONT)
  translate([-0.5,0,0])
  Evolver_ReceiverFront();
}
//

scale(25.4)
if ($preview) {
  translate([-ReceiverFrontLength(),0,0]) {
    if (_SHOW_FCG)
      SimpleFireControlAssembly(hardware=false, prints=_SHOW_PRINTS,
                                actionRod=false, alpha=_ALPHA_FCG);

    if (_SHOW_LOWER) {
      LowerMount(hardware=false, prints=_SHOW_PRINTS, alpha=_ALPHA_LOWER);
      Lower(hardware=false, prints=_SHOW_PRINTS, alpha=_ALPHA_LOWER);
    }

    if (_SHOW_RECEIVER)
    Frame_ReceiverAssembly(
      hardware=false, prints=_SHOW_PRINTS,
      length=FRAME_BOLT_LENGTH,
      cutaway=_CUTAWAY_RECEIVER, alpha=_ALPHA_RECEIVER);

    if (_SHOW_STOCK)
    StockAssembly(hardware=false, prints=_SHOW_PRINTS, alpha=_ALPHA_STOCK);
  }

  EvolverForendAssembly(hardware=_SHOW_HARDWARE, prints=_SHOW_PRINTS,
                        cutaway=false);
} else {

  // **********
  // * Prints *
  // **********
  if (_RENDER == "Prints/ReceiverFront")
    if (!_RENDER_PRINT)
      Evolver_ReceiverFront();
    else
      rotate([0,-90,0])
      Evolver_ReceiverFront();

  if (_RENDER == "Prints/BarrelSupport")
    if (!_RENDER_PRINT)
      Evolver_BarrelSupport();
    else
      rotate([0,90,0])
      translate([-ForendSpacerLength()-Evolver_BarrelSupportLength(),0,0])
      Evolver_BarrelSupport();

  if (_RENDER == "Prints/ForendSpacer")
    if (!_RENDER_PRINT)
      Evolver_ForendSpacer();
    else
      rotate([0,-90,0])
      Evolver_ForendSpacer();

  if (_RENDER == "Prints/Spindle")
    if (!_RENDER_PRINT)
      Evolver_Spindle();
    else
      rotate([0,90,0])
      translate([-2.75,0,1])
      Evolver_Spindle();

  if (_RENDER == "Prints/Ratchet")
    if (!_RENDER_PRINT)
      Evolver_Ratchet();
    else
      rotate([0,90,0])
      translate([-3.25,0,1])
      Evolver_Ratchet();

  if (_RENDER == "Prints/ZigZag")
    if (!_RENDER_PRINT)
      Evolver_ZigZag();
    else
      rotate([0,-90,0])
      translate([-(SpindleMaxX()+0.125),0,-SpindleZ()])
      Evolver_ZigZag();

  if (_RENDER == "Prints/Actuator")
    if (!_RENDER_PRINT)
      Evolver_Actuator();
    else
      rotate([0,-90,0])
      translate([-SpindleMaxX(),0, -0.5])
      translate([0,0, -SpindleZ()])
      Evolver_Actuator();

  if (_RENDER == "Prints/ActuatorToggle")
    if (!_RENDER_PRINT)
      Evolver_ActuatorToggle();
    else
      rotate([0,-90,0])
      rotate([-60+15,0,0])
      translate([-(ForendSpacerLength()+0.25),0,0])
      Evolver_ActuatorToggle(AF=1);

  if (_RENDER == "Prints/PumpRod")
    if (!_RENDER_PRINT)
      Evolver_PumpRods();
    else
      translate([-pumpPinX,-BarrelCollarRadius(),0.1235])
      rotate([-30,0,0])
      Evolver_PumpRods(doMirror=false);

  if (_RENDER == "Prints/PumpCollar")
    if (!_RENDER_PRINT)
      Evolver_PumpCollar();
    else
      rotate([0,90,0])
      translate([-(ForendLength()+BarrelCollarLength()+0.25),0,0])
      Evolver_PumpCollar();

  // ************
  // * Vitamins *
  // ************
  if (_RENDER == "Hardware/Barrel")
  Evolver_Barrel();
  if (_RENDER == "Hardware/BarrelCollar")
  Evolver_BarrelCollar();
  if (_RENDER == "Hardware/SpindleRod")
  Evolver_SpindleRod();
  if (_RENDER == "Hardware/SpindlePins")
  Evolver_SpindlePins();
  if (_RENDER == "Hardware/RatchetPawlPin")
  Evolver_RatchetPawlPin();
  if (_RENDER == "Hardware/PumpCollarBolts")
  Evolver_PumpCollarBolts();

}
