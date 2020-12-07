include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;
use <../../Meta/MirrorIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Components/Cylinder Redux.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;

use <../../Shapes/Chamfer.scad>;
use <../../Shapes/Helix.scad>;
use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;
use <../../Shapes/Components/Pivot.scad>;

use <../../Vitamins/Bearing.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Rod.scad>;

use <../Action Rod.scad>;
use <../Receiver.scad>;
use <../Lugs.scad>;
use <../Frame.scad>;
use <../Buttstock.scad>;

use <Revolver Fire Control Group.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Revolver Assembly"; // ["Revolver Assembly", "Receiver_LargeFrame", "FrameSpacer", "ReceiverFront", "Foregrip", "RecoilPlate_Template", "RevolverCylinderCore_Projection", "RevolverCylinderCore", "RevolverCylinderShell", "BarrelSupport", "SpindleLatch"]
//$t = 1; // [0:0.01:1]

_SHOW_RECEIVER = true;
_SHOW_LOWER_LUGS = true;
_SHOW_LOWER = true;
_SHOW_FCG = true;
_SHOW_STOCK = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_ACTION_ROD = true;
_SHOW_BARREL = true;
_SHOW_CHAMBERS = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_CYLINDER = true;
_SHOW_PUMP = true;
_SHOW_SPINDLE = true;
_SHOW_FOREND_SPACER = true;
_SHOW_FRAME = true;
_SHOW_BUTTSTOCK = true;

/* [Assembly Transparency] */
_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_CYLINDER = 1;           // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]
_ALPHA_FCG = 1;                // [0:0.1:1]

/* [Assembly Cutaways] */
_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_BARREL_SUPPORT = false;
_CUTAWAY_CYLINDER = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_RECEIVER_FRONT = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_FCG = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;

/* [Barrel and Cylinder Dimensions] */
BARREL_LENGTH = 15.5;
BARREL_DIAMETER = 1.0001;
BARREL_CLEARANCE = 0.008;

CYLINDER_DIAMETER = 3.501;
CYLINDER_LENGTH = 2.75;
CYLINDER_CLEARANCE = 0.005;
CYLINDER_OFFSET = 1.001;
CHAMBER_LENGTH = 3;
CHAMBER_ID = 0.8101;

/* [Screws] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"] 
GP_BOLT_CLEARANCE = 0.015;

FOREGRIP_BOLT = "#8-32"; // ["M4", "#8-32"]
FOREGRIP_BOLT_CLEARANCE = 0.015;

RECOIL_PLATE_BOLT = "#8-32"; // ["M4", "#8-32"]
RECOIL_PLATE_BOLT_CLEARANCE = 0.015;

$fs = UnitsFs()*0.25;

// Settings: Lengths
function ShellRimLength() = 0.06+0.05;
function ChamberLength() = CHAMBER_LENGTH;
function BarrelLength() = BARREL_LENGTH;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.375; //0.4375;
function WallSpindle() = 0.25;
function ForegripGap() = -1.25;
function ActionRodTravel() = 2;
function ReceiverFrontLength() = 0.5;

function ChargingRodOffset() =  0.75+RodRadius(ChargingRod());

function ChamferRadius() = 1/16;
function CR() = 1/16;

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 1.5;
function RecoilSpreaderThickness() = 0.5;
function SpindleCollarDiameter() = 0.61;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;
function SpindleCollarWidth() = (3/8);

// Settings: Vitamins
function CylinderRod() = Spec_RodFiveSixteenthInch();

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
//function FrameBoltLength() = 10;
//function ReceiverFrontLength() = 0.5;
//function FrameBackLength() = 0.5;
function ForendLength() = FrameExtension(length=FrameBoltLength())
                        - ReceiverFrontLength()
                        - NutHexHeight(FrameBolt());
function SpindleLatchLength() = 1;

// Calculated: Positions
function BarrelMinX() = ChamberLength()+ShellRimLength();
function ForendMinX() = BarrelMinX()+RecoilPlateThickness();
function ForendMaxX() = ForendLength();
function ForegripMinX() = ForendMaxX()+ForegripGap()+ActionRodTravel();

function BarrelSupportLength() = ForendMaxX()-ForendMinX();
echo("Barrel Support Length: ", BarrelSupportLength());

//************
//* Vitamins *
//************
module Barrel(barrelLength=BarrelLength(),
              clearance=BARREL_CLEARANCE, cutter=false,
              alpha=1, debug=false) {

  clear = (cutter ? clearance : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([(cutter?0:BarrelMinX()),0,0])
  rotate([0,90,0])
  difference() {
    cylinder(r=BarrelRadius()+clear,
             h=barrelLength+(cutter?ChamberLength():0),
             $fn=Resolution(20,50));
    
    if (!cutter)
    cylinder(r=CHAMBER_ID/2,
             h=barrelLength,
             $fn=Resolution(20,50));
  }
}

module RevolverSpindle(template=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([-RecoilSpreaderThickness()-ManifoldGap(),0,CylinderZ()])
  rotate([0,90,0])
  Rod((template ? Spec_RodTemplate() : CylinderRod()),
      length=ForendMaxX()+RecoilSpreaderThickness()+ManifoldGap(3), 
      clearance=cutter?RodClearanceSnug():undef);
}

module SpindleCollar(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("SteelBlue") RenderIf(!cutter)
  difference() {
    translate([ForendMinX(), 0, CylinderZ()])
    rotate([0,90,0])
    cylinder(r=SpindleCollarRadius()+clear,
             h=SpindleCollarWidth()+(cutter?0.375:0)+clear);
    
    if (!cutter)
    RevolverSpindle(cutter=true);
  }
}
module RevolverBlastPlate(clearance=0.01, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([BarrelMinX(), // Don't *really* need to clear here
               -(RecoilPlateWidth()/2)-clear,
               FrameTopZ()])
    mirror([0,0,1])
    cube([RecoilPlateThickness()+clear,
          RecoilPlateWidth()+clear2,
          FrameTopZ()+abs(CylinderZ())+1]);
    echo("Recoil Plate Length: ", FrameTopZ()+abs(CylinderZ())+1);

    if (!cutter)
    Barrel(cutter=true);
    RevolverActionRod(cutter=true);
    RevolverSpindle(cutter=true);
  }
}

module RecoilPlateBolts(bolt=RecoilPlateBolt(), boltLength=FiringPinHousingLength()+0.5, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  bolt     = template ? BoltSpec("Template") : bolt;
  boltHead = template ? "none"               : "flat";
  
  color("Silver")
  RenderIf(!cutter) {
  
    // Top
    translate([0.5+ManifoldGap(),0,FrameTopZ()-0.375])
    rotate([0,-90,0])
    Bolt(bolt=bolt, length=0.5+ManifoldGap(2),
          head=boltHead,
          clearance=cutter?clearance:0);

    // Bottom
    color("Silver")
    translate([0.5+ManifoldGap(),0,FrameTopZ()-4+0.375])
    rotate([0,-90,0])
    Bolt(bolt=bolt,
         length=0.5+ManifoldGap(2),
         head=boltHead,
         clearance=cutter?clearance:0);
  }
}
module RevolverRecoilPlate(template=false, cutter=false, debug=_CUTAWAY_RECOIL_PLATE) {
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([RecoilPlateRearX()-(cutter?ManifoldGap():0),
               -RecoilPlateWidth()/2,
               FrameTopZ()])
    mirror([0,0,1])
    cube([RecoilPlateThickness()+(cutter?ManifoldGap():0),
          RecoilPlateWidth(),
          4]);

    if (!cutter) {
      FiringPin(cutter=true, radius=(template?1/16/2:FiringPinRadius()));
      RevolverSpindle(cutter=true, template=template);
      RecoilPlateBolts(cutter=true, template=template);
      
      RevolverActionRod(cutter=true);
      
    }
  }
}
//*****************
//* Printed Parts *
//*****************
module RevolverReceiverFront(debug=_CUTAWAY_RECEIVER_FRONT, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilSpreaderThickness());
  
  color("Chocolate", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      FrameSupport(length=length,
                   extraBottom=FrameBoltZ()+abs(CylinderZ()));
      
      // Cover the back of the cylinder to prevent blowback
      translate([0,0,CylinderZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=(BarrelRadius()*3)+(CR()*2)+0.125, r2=CR(),
                        h=length-ManifoldGap(), $fn=Resolution(80, 200));
    }
    
    FrameBolts(cutter=true);
    
    CouplingBolts(extension=ReceiverFrontLength(), boltHead="flat", cutter=true);

    RevolverRecoilPlate(cutter=true);
    
    FiringPin(cutter=true);
    
    RecoilPlateBolts(cutter=true);
    
    RevolverActionRod(cutter=true);

    RevolverSpindle(cutter=true);
  }
}

module RevolverReceiverFront_print() {
  rotate([0,-90,0])
  RevolverReceiverFront();
}

module BarrelSupport(debug=false, alpha=_ALPHA_FOREND, $fn=Resolution(30,100)) {
                      
  extraBottom=0.25;
  
  
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Frame support
      translate([ForendMinX(),0,0])
      FrameSupport(length=BarrelSupportLength(),
                   extraBottom=extraBottom);
      
      // Right-side text
      translate([ForendMinX()+0.375,-FrameWidth()/2,FrameBoltZ()-(0.25/2)-0.125])
      rotate([90,0,0])
      linear_extrude(height=1/32, center=true)
      text("ZZR 12 gauge", size=0.25, font="Impact");

      // Left-side text
      translate([ForendMaxX()-0.375,FrameWidth()/2,FrameBoltZ()-(0.25/2)-0.125])
      rotate([90,0,0])
      linear_extrude(height=1/32, center=true)
      mirror([1,0])
      text("ZZR 12 gauge", size=0.25, font="Impact");


      // Around the barrel
      hull() {
        translate([ForendMinX(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=CR(),
                 h=BarrelSupportLength(),
                            teardropTop=true);
        
        translate([ForendMinX(), -(BarrelRadius()+WallBarrel()), 0])
        ChamferedCube([BarrelSupportLength(),
                       (BarrelRadius()+WallBarrel())*2,
                       FrameBoltZ()], r=CR());
      }

      // Around the spindle
      hull()
      for (Z = [0, CylinderZ()])
      translate([ForendMinX()+1-0.3125,0,Z])
      rotate([0,90,0])
      ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(),
                        r2=CR(),
                        h=BarrelSupportLength()-SpindleLatchLength()+0.3125,
                        teardropTop=true);
      
      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMinX()+CR(),
                 BarrelRadius()+WallBarrel()-ManifoldGap(2),
                 FrameBottomZ()-extraBottom+ManifoldGap()])
      rotate([0,90,0])
      rotate(-90)
      Fillet(r=WallFrameBolt(), h=BarrelSupportLength()-(CR()*2),
                     taperEnds=true);
    }
    
    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([FrameExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);
    
    // Blast plate fillet weld clearance
    translate([ForendMinX(), 0, 0])
    rotate([0,90,0])
    HoleChamfer(r1=BarrelRadius(), r2=0.25, teardrop=true);

    FrameBolts(cutter=true);

    Barrel(cutter=true);

    RevolverActionRod(cutter=true);
    
    RevolverSpindle(cutter=true);
    
    SpindleCollar(cutter=true);
    
    for (R = [90,-90])
    SpindleLatch(angle=R, cutter=true);
    
    SpindleLatch(angle=0, extend=0.3125, cutter=true);
  }
}

module BarrelSupport_print() {
  rotate([0,90,0]) translate([-ForendMaxX(),0,0])
  BarrelSupport();
}
module FrameSpacer(length=ForendMinX(), debug=false, alpha=_ALPHA_FOREND) {
  extraBottom=1;
  
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    FrameSupport(length=length,
                 extraBottom=extraBottom);
    
    // Gas Port
    *translate([BarrelMinX()-0.25,-0.5,FrameBottomZ()-extraBottom])
    ChamferedSquareHole(sides=[1, 1], center=false,
                        length=FrameTopZ()-FrameBottomZ()+extraBottom,
                        corners=false,
                        chamferRadius=0.25);

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);
    
    RevolverBlastPlate(cutter=true);
    
    RevolverActionRod(cutter=true);
    
    // Cylinder Cutout
    translate([0,0,CylinderZ()])
    rotate([0,90,0])
    cylinder(r=CylinderRadius(), h=length, $fn=120);
  }
}

module FrameSpacer_print() {
  rotate([0,-90,0])
  translate([0,0,-FrameBoltZ()])
  FrameSpacer();
}


module SpindleLatch(angle=0, length=SpindleLatchLength(), width=0.3125, extend=0, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Chocolate") RenderIf(!cutter)
  difference() {
    union() {
      
      // Around the spindle; pushes on the spindle collar.
      translate([ForendMinX()+SpindleCollarWidth(), 0, CylinderZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=SpindleCollarRadius()+clear,
                        r2=1/32,
                        h=length+extend+clear,
                        teardropTop=true);
      
      // Stick and bulb
      translate([0,0,CylinderZ()])
      rotate([angle,0,0]) {
        
        // Stick
        translate([ForendMinX()+SpindleCollarWidth(), -(width/2)-clear, 0])
        rotate([0,90,0])
        ChamferedCube([SpindleCollarRadius()+WallSpindle()+0.5,
                       width+clear2,
                       length+extend+clear], r=1/16);
        
        // Bulb
        translate([ForendMinX()+SpindleCollarWidth(), 0, -(SpindleCollarDiameter()+WallSpindle())])
        rotate([0,90,0])
        ChamferedCylinder(r1=SpindleCollarRadius()+clear,
                          r2=1/32,
                          h=length+extend+clear,
                          teardropTop=true);
      }
    }
    
    if (!cutter)
    RevolverSpindle(cutter=true);
  }
}
module SpindleLatch_print() {
  rotate([0,-90,0])
  translate([-(ForendMinX()+SpindleCollarWidth()), 0, -CylinderZ()])
  SpindleLatch();
}
module RevolverCylinder(supports=true, chambers=false, chamberBolts=false, debug=_CUTAWAY_CYLINDER, alpha=_ALPHA_CYLINDER, render_cylinder=true) {
  OffsetZigZagRevolver(
      diameter=CYLINDER_DIAMETER,
      height=CYLINDER_LENGTH,
      centerOffset=abs(CylinderZ()),
      spindleRadius=RodRadius(CylinderRod())+0.005,
      chamberRadius=BarrelRadius(),
      chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=CHAMBER_ID/2,
      extraBottom=0.25,
      extraTop=0.5,
      supportsBottom=false, supportsTop=supports,
      chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha,
      render_cylinder=render_cylinder);
}


module RevolverCylinderCore_print() {
  render()
  intersection() {
  
    translate([0,0, CYLINDER_LENGTH])
    rotate([0,180,0])
    RevolverCylinder(render_cylinder=false);
    
    cylinder(r=CYLINDER_OFFSET-(BARREL_DIAMETER*0.33), h=0.5, $fn=100);
  }
}

module RevolverCylinderShell_print() {
  render()
  difference() {
  
    translate([0,0, CYLINDER_LENGTH])
    rotate([0,180,0])
    RevolverCylinder(render_cylinder=false);
    
    cylinder(r=CYLINDER_OFFSET, h=CYLINDER_LENGTH, $fn=100);
  }
}

module Foregrip(length=2) {
  render()
  difference() {
    union() {      
      translate([ForegripMinX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=BarrelRadius()+WallBarrel(), r2=1/16, h=length);
      
      // Grip block
      translate([ForegripMinX(),-1/2,0])
      rotate([0,90,0])
      ChamferedCube([abs(CylinderZ())+0.25, 1, length], r=1/16);
      
      // Action Rod Support Block
      translate([ForegripMinX(),-0.75/2,0])
      ChamferedCube([1, 0.75, 1.125], r=1/16);
    }
    
    RevolverActionRod(cutter=true);
    Barrel(cutter=true);
    
    // Foregrip bolt
    translate([ForegripMinX()+0.5,0,0])
    cylinder(r=1/8/2, h=2);
  }
}
module Foregrip_print() {
  rotate([0,-90,0])
  translate([-ForegripMinX(),0,0])
  Foregrip();
}


//**************
//* Assemblies *
//**************
module RevolverForendAssembly(pipeAlpha=1, debug=false) {
  if (_SHOW_BARREL) {
    Barrel(debug=debug);
    RevolverBlastPlate();
  }
  
  if (_SHOW_PUMP)
  translate([ForegripMinX(),0,0])
  rotate([0,90,0])
  render()
  PumpGrip();
  //Foregrip();

  if (_SHOW_FOREND_SPACER)
  FrameSpacer(debug=_CUTAWAY_FOREND, alpha=_ALPHA_FOREND);
  
  if (_SHOW_BARREL_SUPPORT)
  BarrelSupport(debug=_CUTAWAY_BARREL_SUPPORT, alpha=_ALPHA_FOREND);

  if (_SHOW_CYLINDER)
  translate([ShellRimLength(),0,CylinderZ()])
  rotate([0,90,0])
  rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
  rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98))
  RevolverCylinder(supports=false, chambers=_SHOW_CHAMBERS);
  
  if (_SHOW_SPINDLE) {
    RevolverSpindle();
    SpindleCollar();
    SpindleLatch(angle=90);
  }

  if (_SHOW_RECEIVER_FRONT)
  translate([-0.5,0,0])
  RevolverReceiverFront();
}

module RevolverAssembly(stock=true) {
  
  translate([-ReceiverFrontLength(),0,0]) {
    
    if (_SHOW_LOWER_LUGS)
    LowerLugs();

    if (_SHOW_LOWER)
    translate([-LowerMaxX(),0,LowerOffsetZ()+0.0625])
    Lower(showTrigger=true,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+abs(LowerOffsetZ())+SearTravel()-(0.25/2));
    
    if (_SHOW_RECEIVER) {
      ReceiverRods();
      
      Receiver_LargeFrameAssembly(debug=_CUTAWAY_RECEIVER);
      ReceiverBackSegment();
    }

    if (_SHOW_STOCK) {
      StockAssembly();
    }

    if (_SHOW_RECOIL_PLATE)
    RevolverRecoilPlate();

    if (_SHOW_FCG)
    RevolverFireControlAssembly();
  
    RecoilPlateBolts();
  }

  RevolverForendAssembly(debug=false);
}

if (_RENDER == "Revolver Assembly")
RevolverAssembly();

//**********
//* Prints *
//**********
scale(25.4) {
  
  if (_RENDER == "Receiver_LargeFrame")
  Receiver_LargeFrame_print();
  
  if (_RENDER == "BarrelSupport")
  BarrelSupport_print();

  if (_RENDER == "SpindleLatch")
  SpindleLatch_print();
  
  if (_RENDER == "FrameSpacer")
  FrameSpacer_print();
  
  if (_RENDER == "Foregrip")
  Foregrip_print();
  
  if (_RENDER == "RecoilPlate_Template")
  projection()
  rotate([0,90,0])
  RevolverRecoilPlate(template=true);

  if (_RENDER == "ReceiverFront")
  RevolverReceiverFront_print();
  
  if (_RENDER == "RevolverCylinderCore_Projection")
  projection(cut=true)
  RevolverCylinderCore_print();
  
  if (_RENDER == "RevolverCylinderCore")
  RevolverCylinderCore_print();
  
  if (_RENDER == "RevolverCylinderShell")
  RevolverCylinderShell_print();
}
