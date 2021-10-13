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

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Receiver_LargeFrame", "Evolver_ReceiverFront", "Evolver_Foregrip", "Evolver_VerticalForegrip", "Evolver_CylinderCore", "Evolver_CylinderShell", "Evolver_BarrelSupport", "Evolver_Projection_Cylinder", "Evolver_Projection_CylinderCore", "Evolver_Projection_RecoilPlate"]

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

_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_FOREGRIP = 1;           // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
_ALPHA_FCG = 1;                // [0:0.1:1]
_ALPHA_STOCK = 1;              // [0:0.1:1]

_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_BARREL_SUPPORT = false;
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

BARREL_LENGTH = 18.5;
BARREL_DIAMETER = 1.0001;
BARREL_CLEARANCE = 0.008;
CYLINDER_OFFSET = 1.0001;
CHAMBER_LENGTH = 3.5;
CHAMBER_ID = 0.8101;

/* [Branding] */
BRANDING_MODEL_NAME = "E-VOLver";

$fs = UnitsFs()*0.25;

// Settings: Lengths
function SpindleRadius() = SPINDLE_DIAMETER/2;
function ShellRimLength() = 0.06;
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
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilSpreaderThickness() = 0.5;

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

// Calculated: Lengths
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - ReceiverFrontLength();

// Calculated: Positions
function BarrelMinX() = ShellRimLength();
function ForendMinX() = 0;
function ForendMaxX() = ForendLength();
function ForegripMinX() = ForendMaxX()+ForegripGap()+ActionRodTravel()+1.5;

function Evolver_BarrelSupportLength() = ForendMaxX()-ForendMinX();
echo("Barrel Support Length: ", Evolver_BarrelSupportLength());

//************
//* Vitamins *
//************
module Evolver_Barrel(barrelLength=BarrelLength(), clearance=BARREL_CLEARANCE, cutter=false, alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([(cutter?0:BarrelMinX()),0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=BarrelRadius()+clear,
             h=barrelLength,
             $fn=Resolution(20,50));
    
    if (!cutter)
    cylinder(r=CHAMBER_ID/2,
             h=barrelLength,
             $fn=Resolution(20,50));
  }
}

module Evolver_ForegripBolts(template=false, bolt=ForegripBolt(), cutter=false) {
  color("Silver") RenderIf(!cutter)
  for (X = [ForegripMinX()+0.5, ForegripMinX()+1.375])
  translate([X,0,ActionRodZ()+0.375])
  Bolt(bolt=bolt, capOrientation=true, head="socket",
       length=(cutter?ActionRodZ()+0.375:5/8), teardrop=cutter, teardropTruncated=cutter);
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

module Evolver_BarrelSupport(doRender=true, debug=false, alpha=_ALPHA_FOREND, $fn=Resolution(30,100)) {
  extraBottom=0;
  
  // Branding text
  color("DimGrey", alpha) 
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

    ActionRod(cutter=true);

    Evolver_Barrel(cutter=true);
  }
}

module Evolver_VerticalForegrip(length=2, debug=true, alpha=1) {
  color("Tan", alpha) render() DebugHalf(enabled=debug) 
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
}

module Evolver_Foregrip(length=PumpGripLength(), debug=false, alpha=1) {
  color("Tan", alpha) render() DebugHalf(enabled=debug)
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
    Evolver_ForegripBolts(cutter=true);
  }
}

module Evolver_ActionRodJig() {
  height=0.75;
  width=0.75;

  difference() {
    translate([0,-(width/2),0])
    ChamferedCube([length,
                   width,
                   height], r=1/16);

    // Charging rod
    translate([0,0,height-RodRadius(ChargingRod())])
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=length+ManifoldGap(),
              clearance=RodClearanceSnug());

    // ZigZag Actuator
    for (X = [0,ChargerTravel()+(ChargerTowerLength()/2)])
    translate([(ChargerTowerLength()/2)+X,0,-ManifoldGap()])
    cylinder(r=3/32/2, h=height, $fn=8);
  }
}


//**************
//* Assemblies *
//**************
module EvolverForendAssembly(pipeAlpha=1, debug=false) {
    
  animateBarrel = Animate(ANIMATION_STEP_CHARGE)
                - Animate(ANIMATION_STEP_CHARGER_RESET);
  
  barrelTravel = CHAMBER_LENGTH;
  
  if (_SHOW_BARREL)
  translate([(barrelTravel*animateBarrel),0,0])
  Evolver_Barrel(debug=debug);
  
  if (_SHOW_BARREL_SUPPORT)
  Evolver_BarrelSupport(debug=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_FOREND);
  
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
      
      Receiver_TensionBolts(debug=_CUTAWAY_RECEIVER);
      
      Receiver_LargeFrameAssembly(
        length=FRAME_BOLT_LENGTH,
        debug=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_FCG)
    SimpleFireControlAssembly(recoilPlate=_SHOW_RECOIL_PLATE) {
  
      if (_SHOW_FOREGRIP) {
        
        Evolver_ForegripBolts();
        
        if (_FOREGRIP == "Standard") {
          Evolver_Foregrip(debug=_CUTAWAY_FOREGRIP,
                            alpha=_ALPHA_FOREGRIP);
        } else {
          Evolver_VerticalForegrip(debug=_CUTAWAY_FOREGRIP,
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

  EvolverForendAssembly(debug=false);
} else {

  if (_RENDER == "Evolver_ReceiverFront")
  rotate([0,-90,0])
  Evolver_ReceiverFront();
  
  if (_RENDER == "Evolver_BarrelSupport")
  rotate([0,90,0]) translate([-ForendMaxX(),0,0])
  render()
  Evolver_BarrelSupport(doRender=false);

  if (_RENDER == "Evolver_Foregrip")
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Evolver_Foregrip();
  
  if (_RENDER == "Evolver_VerticalForegrip")
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Evolver_VerticalForegrip();
}
