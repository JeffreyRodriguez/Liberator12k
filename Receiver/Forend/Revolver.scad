include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;
use <../../Meta/Conditionals/MirrorIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Helix.scad>;
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

use <../FCG.scad>;
use <../Frame.scad>;
use <../Lower.scad>;
use <../Receiver.scad>;
use <../Stock.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "ReceiverFront", "FrameSpacer", "Foregrip", "VerticalForegrip", "CylinderCore", "CylinderShell", "BarrelSupport", "ForendSpindleToggleLinkage", "ForendSpindleToggleHandle", "Projection_Cylinder", "Projection_CylinderCore", "Projection_BlastPlate", "Projection_RecoilPlate"]

/* [Assembly] */

_FOREGRIP = "Standard"; // ["Standard", "Vertical"]

_SHOW_RECEIVER = true;
_SHOW_LOWER_LUGS = true;
_SHOW_LOWER = true;
_SHOW_FCG = true;
_SHOW_STOCK = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_ACTION_ROD = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_CYLINDER = true;
_SHOW_FOREGRIP = true;
_SHOW_FRAME_SPACER = true;
_SHOW_BARREL = true;
_SHOW_BLAST_PLATE = true;
_SHOW_SHIELD = true;
_SHOW_SPINDLE = true;

_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_CYLINDER = 1;           // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_FOREGRIP = 1;           // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]
_ALPHA_FCG = 1;                // [0:0.1:1]
_ALPHA_STOCK = 1;              // [0:0.1:1]

_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_SHIELD = false;
_CUTAWAY_BARREL_SUPPORT = false;
_CUTAWAY_CYLINDER = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_RECEIVER_FRONT = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_FOREGRIP = false;
_CUTAWAY_FCG = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;
_CUTAWAY_STOCK = false;

/* [Vitamins] */
SPINDLE_DIAMETER = 0.31251;

FRAME_BOLT_LENGTH = 10;

GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

FOREGRIP_BOLT = "#8-32"; // ["M4", "#8-32"]
FOREGRIP_BOLT_CLEARANCE = 0.015;

RECOIL_PLATE_BOLT = "#8-32"; // ["M4", "#8-32"]
RECOIL_PLATE_BOLT_CLEARANCE = 0.015;

ENABLE_BLAST_SHIELD = false;
BLAST_PLATE_THICKNESS = 1/8;

BARREL_LENGTH = 15.5;
BARREL_DIAMETER = 1.0001;
BARREL_CLEARANCE = 0.008;

CYLINDER_DIAMETER = 3.501;
CYLINDER_LENGTH = 2.4375;
CYLINDER_CLEARANCE = 0.005;
CYLINDER_OFFSET = 1.0001;
CHAMBER_LENGTH = 3.0001;
CHAMBER_ID = 0.8101;

/* [Branding] */
BRANDING_MODEL_NAME = "ZZR 6x12ga";

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Settings: Lengths
function SpindleRadius() = SPINDLE_DIAMETER/2;
function ShellRimLength() = 0.06;
function CylinderGap() = 0.005;
function ChamberLength() = CHAMBER_LENGTH;
function BarrelLength() = BARREL_LENGTH;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.375; //0.4375;
function WallSpindle() = 0.1875;
function ForegripGap() = -1.25;
function ActionRodTravel() = 2;
function ReceiverFrontLength() = 0.5;
function TemplateHoleRadius() = 1/16;

function ChamferRadius() = 1/16;
function CR() = 1/16;

// Measured: Vitamins
function BlastPlateThickness() = BLAST_PLATE_THICKNESS;
function BlastPlateWidth() = CYLINDER_DIAMETER;
function ShieldLength() = 0.5;
function ShieldWidth() = 0.125;
function ShieldHeight() = 0.75;

function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilSpreaderThickness() = 0.5;

function Revolver_ForendSpindlePinLength() = 1.5;
function Revolver_ForendSpindlePinRadius() = 3/32/2;
function Revolver_ForendSpindlePinClearance() = 0.005;

function Revolver_ForendSpindleTogglePinLength() = 1.5;
function Revolver_ForendSpindleTogglePinRadius() = 3/32/2;
function Revolver_ForendSpindleTogglePinClearance() = 0.005;

function Revolver_ForendSpindleLinkagePinLength() = 1.5;
function Revolver_ForendSpindleLinkagePinRadius() = 3/32/2;
function Revolver_ForendSpindleLinkagePinClearance() = 0.005;

// Settings: Vitamins

function BarrelSetScrew() = BoltSpec(GP_BOLT);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown GP_BOLT?");

function ForegripBolt() = BoltSpec(FOREGRIP_BOLT);
assert(ForegripBolt(), "ForegripBolt() is undefined. Unknown FOREGRIP_BOLT?");

function RecoilPlateBolt() = BoltSpec(RECOIL_PLATE_BOLT);
assert(RecoilPlateBolt(), "RecoilPlateBolt() is undefined. Unknown RECOIL_PLATE_BOLT?");

// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);
    
function CylinderDiameter() = CYLINDER_DIAMETER;
function CylinderRadius() = CylinderDiameter()/2;

// Calculated: Lengths
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - ReceiverFrontLength()
                        - NutHexHeight(FrameBolt());

// Calculated: Positions
function BarrelMinX() = CylinderGap()+ChamberLength()+ShellRimLength();
function ForendMinX() = BarrelMinX();
function ForendMaxX() = ForendLength();
function ForegripMinX() = ForendMaxX()+ForegripGap()+ActionRodTravel()+1.5;

function SpindleTogglePinOffset() = 0.5;
function SpindleTogglePinX() = ForendMaxX()-SpindleTogglePinOffset();
function SpindleTogglePinZ() = CylinderZ()-0.3215;
function SpindlePinMinX() = ForendMinX()+BlastPlateThickness()+0.375;
function SpindlePinTravel() = RecoilPlateThickness();
function SpindlePinMaxX() = SpindlePinMinX()+SpindlePinTravel();
function SpindleLinkagePinOffset() = 0.5;
function SpindleLinkagePinX() = SpindleTogglePinX()-Revolver_ForendSpindleTogglePinRadius()-SpindleLinkagePinOffset();


function Revolver_BarrelSupportLength() = ForendMaxX()-ForendMinX();
echo("Barrel Support Length: ", Revolver_BarrelSupportLength());


// Distance between the toggle and spindle pins
hypotenuseExtended = pyth_A_B(abs(SpindleTogglePinZ()-CylinderZ()),
              SpindleTogglePinX()-SpindlePinMinX());
hypotenuseRetracted = pyth_A_B(abs(SpindleTogglePinZ()-CylinderZ()),
              SpindleTogglePinX()-SpindlePinMaxX());
hypotenuseDiff = hypotenuseExtended-hypotenuseRetracted;

echo("Spindle/Toggle Pin Hypotenuse: ",
     hypotenuseRetracted, hypotenuseExtended, hypotenuseDiff);

hypPins = pyth_A_B(abs(SpindleTogglePinZ()-CylinderZ()),
              SpindleTogglePinX()-SpindlePinMinX());
              
    
animateLock = (SubAnimate(ANIMATION_STEP_UNLOCK, start=0, end=1)
            - SubAnimate(ANIMATION_STEP_LOCK, start=0, end=1));

//************
//* Vitamins *
//************
module Revolver_Barrel(barrelLength=BarrelLength(), clearance=BARREL_CLEARANCE, cutter=false, alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(debug) RenderIf(!cutter)
  translate([(cutter?0:BarrelMinX()),0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=BarrelRadius()+clear,
             h=barrelLength+(cutter?ChamberLength():0));
    
    if (!cutter)
    cylinder(r=CHAMBER_ID/2,
             h=barrelLength);
  }
}

module Revolver_CylinderSpindle(template=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  radius = template ? TemplateHoleRadius() : SpindleRadius();
  length = ForendMaxX()-ForendMinX()
         - 1.5
         + (cutter?BlastPlateThickness()+0.5:0)
         + ManifoldGap(3);

  color("Silver") RenderIf(!cutter)
  translate([-ReceiverFrontLength()-ManifoldGap(),0,CylinderZ()])
  rotate([0,90,0])
  cylinder(r=radius+clear, h=length);
}

module Revolver_ForegripBolts(template=false, bolt=ForegripBolt(), cutter=false) {
  color("Silver") RenderIf(!cutter)
  for (X = [ForegripMinX()+0.5, ForegripMinX()+1.375])
  translate([X,0,ActionRodZ()+0.375])
  Bolt(bolt=bolt, capOrientation=true, head="socket",
       length=(cutter?ActionRodZ()+0.375:5/8), teardrop=cutter, teardropTruncated=cutter);
}
module Revolver_ForendSpindle(template=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  radius = template ? TemplateHoleRadius() : SpindleRadius();

  color("Silver") RenderIf(!cutter)
  translate([ForendMinX()-BlastPlateThickness()-ManifoldGap(),0,CylinderZ()])
  rotate([0,90,0])
  cylinder(r=radius + clear,
           h=ForendMaxX()-ForendMinX()-1.5+(cutter?0.5:0)+ManifoldGap(3));
}

module Revolver_ForendSpindlePin(cutter=false, teardrop=false, clearance=Revolver_ForendSpindlePinClearance()) {
  clear = cutter ? clearance : 0;
  
  color("Silver") render()
  translate([SpindlePinMinX(),0,CylinderZ()])
  rotate([90,0,0])
  linear_extrude(height=Revolver_ForendSpindlePinLength(), center=true)
  rotate(180)
  Teardrop(r=Revolver_ForendSpindlePinRadius()+clear, enabled=teardrop);
}
module Revolver_ForendSpindleLinkagePin(cutter=false, teardrop=false, clearance=Revolver_ForendSpindleLinkagePinClearance()) {
  clear = cutter ? clearance : 0;
  
  color("Silver") RenderIf(cutter==false)
  translate([SpindleLinkagePinX(),0,CylinderZ()])
  rotate([90,0,0])
  linear_extrude(height=Revolver_ForendSpindleTogglePinLength(), center=true)
  rotate(180)
  Teardrop(r=Revolver_ForendSpindleTogglePinRadius()+clear, enabled=teardrop);
}

module Revolver_ForendSpindleTogglePin(cutter=false, teardrop=false, clearance=Revolver_ForendSpindleTogglePinClearance()) {
  clear = cutter ? clearance : 0;
  
  color("Silver") RenderIf(cutter==false)
  translate([SpindleTogglePinX(),0,SpindleTogglePinZ()])
  rotate([90,0,0])
  linear_extrude(height=Revolver_ForendSpindleTogglePinLength(), center=true)
  rotate(180)
  Teardrop(r=Revolver_ForendSpindleTogglePinRadius()+clear, enabled=teardrop);
}

module Revolver_PumpLockRod(cutter=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear * 2;
  
  length = 2;
  width = 0.25;
  
  color("Silver") RenderIf(!cutter)
  translate([ForendMaxX()-1,-(width/2)-clear,-BarrelRadius()-width-clear])
  cube([length, width+clear2, width+clear2]);
}

module Revolver_BlastPlateBolts(bolt=RecoilPlateBolt(), boltLength=Revolver_BarrelSupportLength(), template=false, cutter=false, clearance=0.01, debug=false) {
  clear = cutter ? clearance : 0;
  
  color("Silver")
  RenderIf(!cutter) DebugHalf(debug)
  for (M = [0,1]) mirror([0,M,0])
  translate([ForendMaxX(),BarrelRadius()+0.375,0])
  rotate([0,90,0])
  Bolt(bolt=bolt, length=boltLength+ManifoldGap(), clearance=clear, head="hex", capOrientation=true);
}

module Revolver_BlastPlate(clearance=0.01, holeClearance=0.002, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(debug)
  difference() {
    union() {
      intersection() {
        translate([BarrelMinX(),0,CylinderZ()])
        rotate([0,90,0])
        cylinder(r=CylinderRadius()-0.125+clear, h=BlastPlateThickness());
        
        translate([BarrelMinX(),
                   -CylinderRadius(),
                   -RecoilPlateWidth()/2])
        cube([RecoilPlateThickness()+(cutter?ManifoldGap():0),
              CylinderDiameter(),
              RecoilPlateWidth()]);
      }
      
      translate([BarrelMinX(),0,CylinderZ()])
      rotate([0,90,0])
      cylinder(r=SpindleRadius()+WallSpindle(), h=BlastPlateThickness());
    }

    if (!cutter)
    Revolver_Barrel(cutter=true, clearance=holeClearance);
    ActionRod(cutter=true);
    Revolver_ForendSpindle(cutter=true, clearance=holeClearance);
    Revolver_BlastPlateBolts(cutter=true);
  }
}

module Revolver_Shield(cutter=false, debug=false) {
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(debug)
  translate([BarrelMinX()+BlastPlateThickness(),0,CylinderZ()-0.01])
  rotate([0,-90,0])
  linear_extrude(height=0.5)
  rotate(90)
  semidonut(minor=CylinderDiameter()-0.25, major=CylinderDiameter(), angle=180);
  
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(debug)
  for (M = [0,1]) mirror([0,M,0])
  translate([BarrelMinX()+BlastPlateThickness()-ShieldLength(),CylinderRadius()-ShieldWidth(),CylinderZ()-ShieldHeight()])
  cube([ShieldLength(), ShieldWidth(), ShieldHeight()]);
}

//*****************
//* Printed Parts *
//*****************
module Revolver_ReceiverFront(contoured=true, debug=_CUTAWAY_RECEIVER_FRONT, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilSpreaderThickness());
  
  color("Chocolate", alpha)
  render() DebugHalf(debug)
  difference() {
    union() {
      hull() {
        Frame_Support(length=length, extraBottom=FrameBottomZ()+abs(CylinderZ()),
                     chamferFront=true, teardropFront=true);
        
        mirror([1,0,0])
        ReceiverTopSegment(length=length, chamferBack=false);
      }
      
      // Cover the back of the cylinder to stop gas blowback
      translate([0,0,CylinderZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=CylinderRadius(), r2=CR(),
                        h=length-ManifoldGap());
    }
    
    Frame_Bolts(cutter=true);

    RecoilPlate(contoured=contoured, spindleZ=CylinderZ(), cutter=true);
    
    FiringPin(cutter=true);
    
    RecoilPlateBolts(cutter=true);
    Receiver_TensionBolts(cutter=true);
    
    ActionRod(cutter=true);

    Revolver_ForendSpindle(cutter=true);
    Revolver_CylinderSpindle(cutter=true);
  }
}

module Revolver_BarrelSupport(doRender=true, debug=false, alpha=_ALPHA_FOREND) {
  extraBottom=0;
  
  // Branding text
  color("DimGrey", alpha) 
  RenderIf(doRender) DebugHalf(debug) {
    
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
  RenderIf(doRender) DebugHalf(debug)
  difference() {
    union() {
      
      // Frame support
      hull() {
        translate([ForendMinX(),0,0])
        Frame_Support(length=Revolver_BarrelSupportLength(),
                     extraBottom=extraBottom,
                     chamferBack=true, teardropBack=true);
        
        translate([ForendMinX(), 0, 0])
        mirror([1,0,0])
        ReceiverTopSegment(length=Revolver_BarrelSupportLength(),
                           chamferFront=false);
      
      
        // Barrel Support Bolt Support
        for (M = [0,1]) mirror([0,M,0])
        translate([ForendMaxX(),BarrelRadius()+0.375,0])
        rotate([0,-90,0])
        ChamferedCylinder(r1=0.25, r2=CR(),
                 h=Revolver_BarrelSupportLength()-BlastPlateThickness(),
                            teardropTop=true);
      }

      // Around the barrel
      hull() {
        translate([ForendMinX()+BlastPlateThickness(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR(),
                 h=Revolver_BarrelSupportLength()-BlastPlateThickness(),
                            teardropTop=true);
        
        translate([ForendMinX()+BlastPlateThickness(), -(BarrelRadius()+WallBarrel()), 0])
        ChamferedCube([Revolver_BarrelSupportLength()-BlastPlateThickness(),
                       (BarrelRadius()+WallBarrel())*2,
                       FrameBoltZ()], r=CR());
      }

      // Around the spindle
      hull() {
        translate([ForendMinX()+BlastPlateThickness(), -(0.6875/2), CylinderZ()+SpindleRadius()])
        ChamferedCube([Revolver_BarrelSupportLength()-BlastPlateThickness()-(Revolver_ForendSpindleLinkagePinRadius()*2)-1,
                       0.6875,
                       1], r=CR(), teardropFlip=[false,true,true]);
        translate([ForendMinX()+BlastPlateThickness(), -(0.6875/2), CylinderZ()-(SpindleRadius()+WallSpindle())])
        ChamferedCube([Revolver_BarrelSupportLength()-BlastPlateThickness()-1-(Revolver_ForendSpindleLinkagePinRadius()*2)-(SpindleRadius()+WallSpindle()+abs(SpindleTogglePinZ()-CylinderZ())),
                       0.6875,
                       1], r=CR(), teardropFlip=[false,true,true]);
      }
      
      // Spindle toggle pivot pin support
      translate([ForendMaxX()-1, -(0.6875/2), CylinderZ()-(SpindleRadius()*2)-WallSpindle()-0.125])
      ChamferedCube([1,
                     0.6875,
                     1], r=CR(), teardropFlip=[false,true,true]);
    }
    
    // Weld clearance: Barrel to blast plate fillet
    translate([ForendMinX()+BlastPlateThickness(), 0, 0])
    rotate([0,90,0])
    HoleChamfer(r1=BarrelRadius(), r2=0.3125, teardrop=true);
    
    // Weld clearance: Shield to blast plate fillet
    translate([ForendMinX(), 0, CylinderZ()])
    rotate([0,-90,0])
    TeardropTorus(majorRadius=CylinderRadius()-0.125, minorRadius=0.1875);
    
    // Handle pivot clearance
    rotate([90,0,0])
    linear_extrude(height=0.3125+0.02, center=true)
    translate([SpindleTogglePinX(),SpindleTogglePinZ()])
    mirror([1,0])
    semicircle(od=(pyth_A_B(abs(SpindleTogglePinZ()-CylinderZ()),
                           SpindleTogglePinX()-SpindleLinkagePinX())+0.02+0.1875)*2,
               angle=60);
    
    // Linkage pin pivot path
    *rotate([90,0,0])
    linear_extrude(height=1, center=true)
    translate([SpindleTogglePinX(),SpindleTogglePinZ()])
    mirror([1,0])
    semidonut(major=(pyth_A_B(abs(SpindleTogglePinZ()-CylinderZ()),
                           SpindleTogglePinX()-SpindleLinkagePinX())
                           +(Revolver_ForendSpindleLinkagePinRadius()
                            + Revolver_ForendSpindleLinkagePinClearance()))*2,
              minor=(pyth_A_B(abs(SpindleTogglePinZ()-CylinderZ()),
                           SpindleTogglePinX()-SpindleLinkagePinX())
                           -(Revolver_ForendSpindleLinkagePinRadius()
                            + Revolver_ForendSpindleLinkagePinClearance()))*2,
               angle=25);
    
    Frame_Bolts(cutter=true);

    ActionRod(cutter=true);
    
    //Revolver_PumpLockRod(cutter=true);

    Revolver_Barrel(cutter=true);

    Revolver_BlastPlate(cutter=true);
    
    Revolver_BlastPlateBolts(cutter=true);
    
    Revolver_ForendSpindle(cutter=true);
    
    hull() {
      Revolver_ForendSpindlePin(cutter=true, teardrop=true);
      
      translate([SpindlePinTravel(),0,0])
      Revolver_ForendSpindlePin(cutter=true);
    }
    
    Revolver_ForendSpindleTogglePin(cutter=true, teardrop=true);
    
    for (P = [0,1])
    Revolver_ForendSpindleToggleHandle(pivot=P, cutter=true, teardrop=true);
  }
}

module Revolver_FrameSpacer(length=ForendMinX(), debug=false, alpha=_ALPHA_FOREND) {
  extraBottom=0;
  
  color("Tan", alpha)
  render() DebugHalf(debug)
  difference() {
    hull() {
      
      // Main support
      Frame_Support(length=length);
      
      // Rear ears
      Frame_Support(length=ManifoldGap(), extraBottom=0.5);
    
      mirror([1,0,0])
      ReceiverTopSegment(length=length, chamferFront=false, chamferBack=false);
    }

    Frame_Bolts(cutter=true);
    
    ActionRod(cutter=true);
    
    // Cylinder Cutout
    translate([0,0,CylinderZ()])
    rotate([0,90,0])
    cylinder(r=CylinderRadius()+CYLINDER_CLEARANCE, h=length);
  }
}

module Revolver_ForendSpindleToggleLinkage(pivot=0, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
    
  Pivot(pivotX=SpindlePinMinX(),
        pivotZ=CylinderZ(),
        angle=24, factor=pivot) {

    color("Chocolate") render()
    difference() {
      union() {        
        translate([0,0.625,0])
        rotate([90,0,0])
        linear_extrude(height=0.25)
        difference() {
          hull() {
            translate([SpindleLinkagePinX(),CylinderZ()])
            rotate(180)
            Teardrop(r=0.1875+clear, enabled=false);
            
            translate([SpindlePinMinX(),CylinderZ()])
            rotate(180)
            Teardrop(r=0.1875+clear, enabled=false);
          }
          
          // Linkage Pin
          translate([SpindleLinkagePinX(),CylinderZ()])
          rotate(180)
          Teardrop(r=Revolver_ForendSpindleLinkagePinRadius()+Revolver_ForendSpindleLinkagePinClearance(),
                   enabled=false);
        }
        
      }
      
      Revolver_ForendSpindlePin(cutter=true);
    }
    
    children();
  }
}
module Revolver_ForendSpindleToggleHandle(pivot=0, cutter=false, clearance=0.01, teardrop=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  Pivot(pivotX=SpindleTogglePinX(), pivotZ=SpindleTogglePinZ(),
        angle=-60,factor=pivot) {
    color("Chocolate") RenderIf(!cutter)
    difference() {
      union() {
        
        // Connection to linkage
        rotate([90,0,0])
        linear_extrude(height=0.3125+clear2, center=true)
        hull() {
          translate([SpindleTogglePinX(),SpindleTogglePinZ()])
          circle(r=0.1875+clear);
          
          translate([SpindleLinkagePinX(),CylinderZ()])
          rotate(180)
          Teardrop(r=0.1875+clear, enabled=teardrop);
          
          // Connect to bottom section
          translate([SpindleTogglePinX()-0.25,CylinderZ()-0.5])
          circle(r=0.125+clear);
          
          translate([SpindleTogglePinX()-0.625,CylinderZ()-0.5])
          circle(r=0.125+clear);
        }
        
        // Bottom section, handle
        rotate([90,0,0])
        linear_extrude(height=0.3125, center=true)
        hull() {
          translate([SpindleTogglePinX()-1.75,CylinderZ()-0.5])
          rotate(180)
          circle(r=0.125+clear);
          
          translate([SpindleTogglePinX()-0.25,CylinderZ()-0.5])
          rotate(180)
          circle(r=0.125+clear);
        }
      }
      
      Revolver_ForendSpindlePin(cutter=true);
      Revolver_ForendSpindleTogglePin(cutter=true);
          
      // Linkage Pin
      Revolver_ForendSpindleLinkagePin(cutter=true);
    }
    
    children();
  }
}
module Revolver_Cylinder(chambers=true, supports=true, chamberBolts=false, debug=_CUTAWAY_CYLINDER, alpha=_ALPHA_CYLINDER, render_cylinder=true) {
  OffsetZigZagRevolver(
      diameter=CYLINDER_DIAMETER,
      height=CYLINDER_LENGTH,
      centerOffset=abs(CylinderZ()),
      spindleRadius=SpindleRadius()+0.005,
      chamberRadius=BarrelRadius(),
      chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=CHAMBER_ID/2,
      extraBottom=0,
      extraTop=0,
      supportsBottom=false, supportsTop=supports,
      chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha,
      render_cylinder=render_cylinder);
}

module Revolver_VerticalForegrip(length=2, debug=true, alpha=1) {
  color("Tan", alpha) render() DebugHalf(debug) 
  difference() {
    union() {
      translate([ForegripMinX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel(),
                        r2=1/16, h=length);
      
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
    Revolver_Barrel(cutter=true);
    Revolver_ForegripBolts(cutter=true);
  }
}

module Revolver_VerticalForegrip_print() {
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Revolver_VerticalForegrip();
}

module Revolver_Foregrip(length=PumpGripLength(), debug=false, alpha=1) {
  color("Tan", alpha) render() DebugHalf(debug)
  difference() {
    
    // Body around the barrel
    union() {
      translate([ForegripMinX(),0,0])
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
    Revolver_ForegripBolts(cutter=true);
  }
}

module Revolver_Foregrip_print() {
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Revolver_Foregrip();
}

module Revolver_ActionRodJig() {
  height=0.75;
  width=0.75;

  difference() {
    translate([0,-(width/2),0])
    ChamferedCube([length,
                   width,
                   height], r=1/16);

    // Charging rod
    translate([-0.125,-0.125,height-0.125])
    rotate([0,90,0])
    cube([0.25, 0.25, length+ManifoldGap()])
    SquareRod(ChargingRod(), length=length+ManifoldGap());

    // ZigZag Actuator
    for (X = [0,ChargerTravel()+(ChargerTowerLength()/2)])
    translate([(ChargerTowerLength()/2)+X,0,-ManifoldGap()])
    cylinder(r=3/32/2, h=height);
  }
}


//**************
//* Assemblies *
//**************
module RevolverForendAssembly(pipeAlpha=1, debug=false) {
    
  animateCylinderRotation = SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98)
                          + SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8);
    
  animateCylinderRemoval = SubAnimate(ANIMATION_STEP_UNLOAD, start=0, end=1)
                         - SubAnimate(ANIMATION_STEP_LOAD, start=0, end=1);
  
  *Revolver_PumpLockRod();
  
  if (_SHOW_BARREL)
    Revolver_Barrel(debug=debug);
  
  if (_SHOW_BLAST_PLATE)
  Revolver_BlastPlate(debug=_CUTAWAY_SHIELD);
  
  Revolver_BlastPlateBolts(debug=_CUTAWAY_SHIELD);
  
  if (_SHOW_SHIELD)
  Revolver_Shield(debug=_CUTAWAY_SHIELD);

  if (_SHOW_FRAME_SPACER)
  Revolver_FrameSpacer(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
  
  if (_SHOW_BARREL_SUPPORT)
  Revolver_BarrelSupport(debug=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_FOREND);
  
  if (_SHOW_SPINDLE) {
    Revolver_ForendSpindleTogglePin();
    
    translate([SpindlePinTravel()*animateLock,0,0]) {
      Revolver_ForendSpindle();
      Revolver_ForendSpindlePin();
      
      for (M = [0,1]) mirror([0,M,0])
      Revolver_ForendSpindleToggleLinkage(pivot=animateLock);
    }
    
    Revolver_ForendSpindleToggleHandle(pivot=animateLock)
        Revolver_ForendSpindleLinkagePin();;
  }

  if (_SHOW_RECEIVER_FRONT)
  translate([-0.5,0,0])
  Revolver_ReceiverFront();
  
  if (_SHOW_CYLINDER)
  translate([ShellRimLength(),0,CylinderZ()-(3.5*animateCylinderRemoval)])
  rotate([0,90,0])
  rotate(-360/6/2*animateCylinderRotation)
  rotate(-360/6/2*animateCylinderRotation)
  Revolver_Cylinder(supports=false);
}

module RevolverAssembly(stock=true) {
  
  translate([-ReceiverFrontLength(),0,0]) {
    
    if (_SHOW_LOWER_LUGS)
    LowerMount();

    if (_SHOW_LOWER)
    Lower();
    
    if (_SHOW_RECEIVER) {
      
      Receiver_TensionBolts(debug=_CUTAWAY_RECEIVER);
      
      Frame_ReceiverAssembly(
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_FCG)
    SimpleFireControlAssembly(recoilPlate=_SHOW_RECOIL_PLATE) {
  
      if (_SHOW_FOREGRIP) {
        
        Revolver_ForegripBolts();
        
        if (_FOREGRIP == "Standard") {
          Revolver_Foregrip(debug=_CUTAWAY_FOREGRIP,
                            alpha=_ALPHA_FOREGRIP);
        } else {
          Revolver_VerticalForegrip(debug=_CUTAWAY_FOREGRIP,
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

  RevolverForendAssembly(debug=false);
}

scale(25.4)
if ($preview) {
  RevolverAssembly();
} else {

  if (_RENDER == "ReceiverFront")
  rotate([0,-90,0])
  Revolver_ReceiverFront();
  
  if (_RENDER == "FrameSpacer")
  rotate([0,-90,0])
  translate([0,0,-FrameBoltZ()])
  Revolver_FrameSpacer();
  
  if (_RENDER == "BarrelSupport")
  rotate([0,90,0]) translate([-ForendMaxX(),0,0])
  Revolver_BarrelSupport();
  
  if (_RENDER == "CylinderShell")
  difference() {
    translate([0,0, CYLINDER_LENGTH])
    rotate([0,180,0])
    Revolver_Cylinder(render_cylinder=false, chambers=false);
    
    cylinder(r=CYLINDER_OFFSET+0.0625, h=CYLINDER_LENGTH+ManifoldGap());
  }
  
  if (_RENDER == "CylinderCore")
  intersection() {
    translate([0,0, CYLINDER_LENGTH])
    rotate([0,180,0])
    Revolver_Cylinder(chambers=false, render_cylinder=false);
    
    cylinder(r=CYLINDER_OFFSET-(BARREL_DIAMETER*0.33), h=0.5);
  }

  if (_RENDER == "ForendSpindleToggleLinkage")
  rotate([-90,0,0])
  translate([-SpindleLinkagePinX(),-0.5,-CylinderZ()])
  Revolver_ForendSpindleToggleLinkage();

  if (_RENDER == "ForendSpindleToggleHandle")
  rotate([90,0,0])
  translate([-SpindlePinMinX(),(5/16/2),-CylinderZ()])
  Revolver_ForendSpindleToggleHandle();
  
  if (_RENDER == "Cylinder_Projection")
  projection()
  Revolver_Cylinder(chambers=false);
  
  if (_RENDER == "Foregrip")
  Revolver_Foregrip_print();
  
  if (_RENDER == "Projection_CylinderCore")
  projection(cut=true)
  intersection() {
    translate([0,0, CYLINDER_LENGTH])
    rotate([0,180,0])
    Revolver_Cylinder(chambers=false, render_cylinder=false);
    
    cylinder(r=CYLINDER_OFFSET-(BARREL_DIAMETER*0.33), h=0.5);
  }
  
  if (_RENDER == "Projection_BlastPlate")
  projection()
  rotate([0,-90,0])
  translate([-BarrelMinX(),0,-CylinderZ()])
  Revolver_BlastPlate();
}
