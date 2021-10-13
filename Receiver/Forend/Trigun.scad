include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Cutaway.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Shapes/Components/Pivot.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Pipe.scad>;

use <../../Ammo/Shell Slug.scad>;
use <../../Ammo/Cartridges/Cartridge.scad>;
use <../../Ammo/Cartridges/Cartridge_12GA.scad>;

use <../FCG.scad>;
use <../Frame.scad>;
use <../Lower.scad>;
use <../Receiver.scad>;
use <../Stock.scad>;

/* [Print] */

// Select a part, Render it (F6), then Export to STL (F7)
_RENDER = ""; // ["", "ReceiverFront", "ReceiverForend", "BarrelCollar", "Extractor", "Latch", "Foregrip"]

/* [Assembly] */
_SHOW_BARREL = true;
_SHOW_FOREND = true;
_SHOW_FRAME = true;
_SHOW_COLLAR = true;
_SHOW_EXTRACTOR = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_FCG = true;
_SHOW_STOCK = true;
_SHOW_LOWER = true;
_SHOW_LOWER_MOUNT = true;
_SHOW_LATCH = true;

_ALPHA_FOREND = 1;  // [0:0.1:1]
_ALPHA_LATCH = 1; // [0:0.1:1]
_ALPHA_COLLAR = 1; // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]

_CUTAWAY_RECEIVER = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_COLLAR = false;
_CUTAWAY_EXTRACTOR = false;
_CUTAWAY_LATCH = false;

/* [Vitamins] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

BARREL_SET_SCREW = "#8-32"; // ["M4", "#8-32"]
BARREL_SET_SCREW_CLEARANCE = -0.05;

BARREL_OUTSIDE_DIAMETER = 1.0001;
BARREL_INSIDE_DIAMETER = 0.813;
BARREL_CLEARANCE = 0.005;
BARREL_LENGTH = 18;
BARREL_OFFSET = 0.7;
RIM_WIDTH = 0.0301;
RIM_DIAMETER = 0.8875;

/* [Fine Tuning] */
FRAME_BOLT_LENGTH = 10;

/* [Branding] */
BRANDING_MODEL_NAME = "Trigun 12ga";

$fs = UnitsFs()*0.5;

// Settings: Vitamins
function BarrelSetScrew() = BoltSpec(BARREL_SET_SCREW);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown BARREL_SET_SCERW?");

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function BarrelRadius(clearance=0)
    = BarrelDiameter(clearance*2)/2;

function BarrelDiameter(clearance=0)
    = BARREL_OUTSIDE_DIAMETER+clearance;
    
function BarrelWall() = (BarrelDiameter() - BARREL_INSIDE_DIAMETER)/2;
    

// Settings: Dimensions
function BarrelLength() = BARREL_LENGTH;
function BarrelSleeveLength() = 4;
function WallBarrel() = 0.125;

function ActionRodLength() = 10;
function FrameBoltLength() = FRAME_BOLT_LENGTH;
function FrameBackLength() = 0.75+0.5;
function ReceiverFrontLength() = 0.5;
function ForendLength() = FrameExtension(length=FRAME_BOLT_LENGTH)
                        - 0.5
                        -ReceiverFrontLength();

function ChargerTravel() = 1.75;

// Calculated: Lengths
function ForegripOffsetX() = 6+ChargerTravel();
function ForegripLength() = 4.625;

// Vitamins
module Barrels(od=BARREL_OUTSIDE_DIAMETER, id=BARREL_INSIDE_DIAMETER, length=BarrelLength(), clearance=BARREL_CLEARANCE, cartridgeRimThickness=RIM_WIDTH, cutter=false, alpha=1, cutaway=false) {

  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter) Cutaway(cutaway)
  translate([(cutter?0:cartridgeRimThickness),0,-BARREL_OFFSET])
  for (N = [0,1,2]) rotate([360/3*N,0,0])
  translate([0,0,BARREL_OFFSET])
  difference() {
    rotate([0,90,0])
    cylinder(r=(od/2)+clear, h=length, $fn=60);

    if (!cutter) {
      
      // Hollow inside
      rotate([0,90,0])
      cylinder(r=(id/2)+clear, h=length);
    }
  }
}

// Shapes
module LatchGuides(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  translate([0,
             -(ExtractorHousingWidth()/2)-LatchGuideWidth()-clear,
             LatchGuideZ()-clear])
  ChamferedCube([LatchCollarLength(),
                 ExtractorHousingWidth()+(LatchGuideWidth()*2)+clear2,
                 LatchGuideHeight()+clear2],
                r=1/16);
}

// Printed Parts
module ReceiverFront(cutaway=false, alpha=1) {
  color("Tan", alpha) render() Cutaway(cutaway)
  difference() {
    
    translate([-ReceiverFrontLength(),0,0])
    union() {
      hull() {
        mirror([1,0,0])
        ReceiverTopSegment(length=1/16);
        
        Frame_Support(length=ReceiverFrontLength());
      }

      // Recoil plate backing
      translate([0,-(RecoilPlateWidth()/2)-0.25,RecoilPlateTopZ()])
      mirror([0,0,1])
      ChamferedCube([ReceiverFrontLength(),
                     RecoilPlateWidth()+0.5,
                     RecoilPlateHeight()+0.25],
                    r=1/16);
    }
    
    Frame_Bolts(cutter=true);

    translate([-ReceiverFrontLength(),0,0]) {
      RecoilPlate(cutter=true);
      RecoilPlateBolts(cutter=true);
      FiringPin(cutter=true);
      FiringPinSpring(cutter=true);
    }
  }
}

module ReceiverFront_print() {
  rotate([0,-90,0]) translate([--ReceiverFrontLength(),0,0])
  ReceiverFront();
}

module ReceiverForend(clearance=0.005, cutaway=false, alpha=1) {  
  // Branding text
  color("DimGrey", alpha) 
  render() Cutaway(cutaway) {
    
    fontSize = 0.375;
    
    // Right-side text
    translate([ForendLength()-0.375,-FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="right");

    // Left-side text
    translate([ForendLength()-0.375,FrameWidth()/2,FrameBoltZ()-(fontSize/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text(BRANDING_MODEL_NAME, size=fontSize, font="Impact", halign="left");
  }
  
  color("Tan", alpha)
  render() Cutaway(cutaway)
  difference() {
    union() {
      Frame_Support(length=ForendLength());
      
      hull() {
        // Front face
        translate([ForendLength(), 0,0])
        mirror([1,0,0])
        Frame_Support(length=ManifoldGap(),
                     extraBottom=0);
        
        translate([ForendLength(), 0,0])
        mirror([1,0,0])
        Frame_Support(length=(ForendLength())+FrameTopZ());
      }
    }
    
    // Printability allowance
    translate([ForendLength(),0,0])
    rotate([0,-90,0])
    HoleChamfer(r1=BarrelRadius(BARREL_CLEARANCE), r2=1/4,
                teardrop=true, $fn=60);

    Frame_Bolts(cutter=true);

    *translate([-ReceiverFrontLength(),0,0])
    ActionRod(length=ActionRodLength(), cutter=true);
  }
}
module ReceiverForend_print() {
  rotate([0,90,0])
  translate([-ForendLength(),0,0])
  ReceiverForend();
}


module BarrelCollar(rearExtension=0, cutter=false, clearance=0.01, cutaway=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;
                           
  color("Chocolate", alpha) RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    intersection() {
      union() {
        PivotOuterBearing(cutter=cutter);
        
        // Latch guiderails
        LatchGuides(cutter=cutter);
        
        PivotClearanceCut(cut=!cutter)
        union() {
          
          // Around the barrel
          translate([RIM_WIDTH,0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelRadius()+WallBarrel()+clear,
                            h=LatchCollarLength()-RIM_WIDTH+clear,
                            r2=1/16, $fn=100);
          
          // Extractor and latch support
          translate([RIM_WIDTH-rearExtension-clear,-(ExtractorHousingWidth()/2)-clear,BarrelCollarBottomZ()-clear])
          ChamferedCube([LatchCollarLength()-RIM_WIDTH+rearExtension+clear2,
                         ExtractorHousingWidth()+clear2,
                         abs(BarrelCollarBottomZ())+clear],
                         r=1/16, teardropFlip=[false,true,true]);
        }
      }
    }
    
    PivotInnerBearing(cutter=true);
    
    if (!cutter) {
    
      // Angled cut for supportless printability
      translate([0,-(PivotWidth()/2),PivotZ()])
      rotate([0,90+45,0])
      cube([3, PivotWidth(), 3]);
      
      // Angled cut to remove the front-bottom tip of the pivot bearing interface
      translate([PivotX(),-(PivotWidth()/2)-clear, 0])
      translate([0,0,PivotZ()])
      rotate([0,PivotAngle(),0])
      translate([0,0,BarrelCollarBottomZ()])
      cube([PivotX(),
            PivotWidth()+clear2,
            abs(BarrelCollarBottomZ())+PivotRadius()]);
      
      // Pic rail slot
      *translate([0,-(UnitsImperial(0.617)/2)-clear,FrameTopZ()-0.125])
      cube([LatchCollarLength(),
            UnitsImperial(0.617)+clear2,
            FrameTopZ()+clear]);

      for (X = [0,-ExtractorTravel()])
      translate([X,0,0])
      Extractor(cutter=true);
      
      hull()
      for (X = [0,-ExtractorTravel()])
      translate([X,0,0])
      ExtractorRetainer(cutter=true, teardrop=true);

      Barrel(cutter=true);
    }
  }

}

module BarrelCollar_print() {
  rotate([0,-90,0])
  BarrelCollar();
}

module Foregrip(length=ForegripLength(), cutaway=false, alpha=1) {
  color("Tan",alpha) render() Cutaway(cutaway)
  difference() {
    translate([ForegripOffsetX()+ChargerTravel(),0,0])
    rotate([0,90,0])
    PumpGrip(length=length);

    Barrel(cutter=true, clearance=PipeClearanceLoose());
  }
}

module Foregrip_print() {
  rotate([0,90,0])
  translate([-ForegripLength(),0,0])
  translate([-(ForegripOffsetX()+ChargerTravel()),0,0])
  Foregrip();
}


// Assemblies
module TrigunForendAssembly(receiverLength=12, pipeAlpha=1, receiverFrontAlpha=1, pivotFactor=0, extractFactor=0, chargeFactor=0, lockFactor=0, stock=true, tailcap=false, cutaway=false) {


  if (_SHOW_FCG)
  translate([-ReceiverFrontLength(),0,0]) {
    SimpleFireControlAssembly(actionRod=false);
  }

  if (_SHOW_BARREL)
  Barrels();
  
  if (_SHOW_RECEIVER_FRONT)
  ReceiverFront(cutaway=cutaway, alpha=_ALPHA_RECOIL_PLATE_HOUSING);

  if (_SHOW_FOREND)
  ReceiverForend(cutaway=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
}


scale(25.4)
if ($preview) {
  
  translate([-ReceiverFrontLength(),0,0]) {
    
    if (_SHOW_LOWER_MOUNT)
    LowerMount();

    if (_SHOW_LOWER)
    Lower();
    
    if (_SHOW_RECEIVER) {
      Receiver_TensionBolts();
      
      Frame_ReceiverAssembly(
        length=FRAME_BOLT_LENGTH,
        cutaway=_CUTAWAY_RECEIVER);
    }

    if (_SHOW_STOCK) {
      StockAssembly();
    }
  }
  
  TrigunForendAssembly(pivotFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -Animate(ANIMATION_STEP_LOAD),
                      chargeFactor=Animate(ANIMATION_STEP_CHARGE)
                                 -Animate(ANIMATION_STEP_CHARGER_RESET),
                      lockFactor=Animate(ANIMATION_STEP_UNLOCK)
                                 -Animate(ANIMATION_STEP_LOCK),
                      extractFactor=Animate(ANIMATION_STEP_UNLOAD)
                                 -SubAnimate(ANIMATION_STEP_LOAD, end=0.25));
} else {

  if (_RENDER == "BarrelCollar")
  BarrelCollar_print();

  if (_RENDER == "ReceiverFront")
  ReceiverFront_print();

  if (_RENDER == "ReceiverForend")
  ReceiverForend_print();

  if (_RENDER == "Foregrip")
  Foregrip_print();

  if (_RENDER == "Extractor")
  Extractor_print();

  if (_RENDER == "Latch")
  Latch_print();
}
