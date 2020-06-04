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

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Receiver.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;
use <../Lugs.scad>;
use <../Frame.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FrameSpacer", "ReceiverFront", "Foregrip", "RevolverCylinder", "BarrelSupport"]
//$t = 1; // [0:0.01:1]

_SHOW_ACTION_ROD = true;
_SHOW_BARREL = true;
_SHOW_CHAMBERS = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_CYLINDER = true;
_SHOW_SPINDLE = true;
_SHOW_FOREND_SPACER = true;
_SHOW_FRAME = true;
_SHOW_LATCH = true;
_SHOW_LATCH_HANDLE = true;
_SHOW_RECEIVER = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_SHIELD = true;

/* [Assembly Transparency] */
_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_CYLINDER = 1;           // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_LATCH = 1;              // [0:0.1:1]
_ALPHA_LATCH_HANDLE = 1;       // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
_ALPHA_SHIELD = 1;             // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]


/* [Assembly Cutaways] */
_CUTAWAY_BARREL_SUPPORT = false;
_CUTAWAY_CYLINDER = false;
_CUTAWAY_LATCH = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_FOREND = false;

/* [Barrel and Cylinder Dimensions] */
BARREL_LENGTH = 15.5;
BARREL_DIAMETER = 1.0001;
BARREL_CLEARANCE = 0.008;

CYLINDER_DIAMETER = 4;
CYLINDER_LENGTH = 2.75;
CYLINDER_CLEARANCE = 0.005;
CYLINDER_OFFSET = 1.1251;
CHAMBER_LENGTH = 3;
CHAMBER_ID = 0.8101;

/* [Screws] */
GP_BOLT = "#8-32"; // ["M4", "#8-32"] 
GP_BOLT_CLEARANCE = 0.015;

// Settings: Lengths
function ShellRimLength() = 0.06+0.05;
function ChamberLength() = CHAMBER_LENGTH;
function BarrelLength() = BARREL_LENGTH;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.5; //0.4375;
function WallSpindle() = 0.25;

function ChamferRadius() = 1/16;
function CR() = 1/16;


// Settings: Vitamins
// ZigZag Cylinder
function CylinderRod() = Spec_RodFiveSixteenthInch();
function SpindleCollarDiameter() = 0.61;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;

function BarrelSetScrew() = BoltSpec(GP_BOLT);
assert(BarrelSetScrew(), "BarrelSetScrew() is undefined. Unknown GP_BOLT?");

// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);
    
function CylinderDiameter() = CYLINDER_DIAMETER;
function CylinderRadius() = CylinderDiameter()/2;

// Calculated: Lengths
function FrameBoltLength() = 10;
function ReceiverFrontLength() = 0.5;
function ReceiverBackLength() = 0.5;
function ForendLength() = FrameExtension(length=FrameBoltLength())
                        - ReceiverFrontLength()
                        - NutHexHeight(FrameBolt());

// Calculated: Positions
function BarrelMinX() = ChamberLength()+ShellRimLength();
function ForendMinX() = BarrelMinX()+RecoilPlateThickness();
function ForendMaxX() = ForendLength();

function BarrelSupportLength() = ForendMaxX()-ForendMinX();
echo("Barrel Support Length: ", BarrelSupportLength());

// Vitamins
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

module BarrelSetScrews(cutter=false, teardrop=false, teardropAngle=0, clearance=0.01) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("Gold") RenderIf(!cutter)
  for (R = [90,-90]) rotate([R,0,0])
  translate([BarrelMinX()+0.75,0,BarrelRadius()])
  rotate(teardropAngle)
  NutAndBolt(bolt=BarrelSetScrew(), boltLength=(cutter?1:0.5),
       head="none", nut="heatset",
       teardrop=teardrop, clearance=clear,
       nutHeightExtra=(cutter?BarrelRadius():0));

}

module RevolverSpindle(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([RecoilPlateRearX(),0,CylinderZ()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=ForendMaxX()+ManifoldGap(3), 
      clearance=cutter?RodClearanceSnug():undef);
}

module SpindleCollar(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("SteelBlue") RenderIf(!cutter)
  translate([ForendMaxX(), 0, CylinderZ()])
  rotate([0,-90,0])
  cylinder(r=SpindleCollarRadius()+clear, h=(3/8), $fn=30);
}
module RevolverRecoilPlate(firingPinAngle=0, cutter=false, debug=false) {
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([-RecoilPlateThickness()-(cutter?0.01:0),
               -RecoilPlateWidth()/2,
               FrameTopZ()])
    mirror([0,0,1])
    cube([RecoilPlateThickness()+(cutter?(1/8+0.01):0),
          RecoilPlateWidth(),
          FrameTopZ()+abs(CylinderZ())+1]);
    echo("Recoil Plate Length: ", FrameTopZ()+abs(CylinderZ())+1);

    if (!cutter)
    rotate([firingPinAngle,0,0])
    RecoilPlateFiringPinAssembly(cutter=true);
  }
}
module RevolverBlastPlate(clearance=0.01, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([BarrelMinX()-clear,
               -(RecoilPlateWidth()/2)-clear,
               FrameTopZ()])
    mirror([0,0,1])
    cube([RecoilPlateThickness()+clear,
          RecoilPlateWidth()+clear2,
          FrameTopZ()+abs(CylinderZ())+1]);
    echo("Recoil Plate Length: ", FrameTopZ()+abs(CylinderZ())+1);

    if (!cutter)
    Barrel(cutter=true);
    ChargingRod(cutter=true);
    RevolverSpindle(cutter=true);
  }
}
// Printed Parts
module RevolverReceiverFront(debug=false, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilPlateRearX());
  
  color("Chocolate", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    translate([RecoilPlateRearX(),0,0])
    union() {
      
      FrameSupport(length=length,
                   extraBottom=FrameBoltZ()+abs(CylinderZ()));
      
      ReceiverCouplingPattern(length=length, frameLength=length);
      
      // Crane Rear Support
      for (Z = [0, CylinderZ()])
      translate([0,0,Z])
      rotate([0,90,0])
      ChamferedCylinder(r1=RodRadius(CylinderRod())+WallSpindle(),
                        r2=CR(),
                        h=length);

      // Backing plate for the cylinder
      translate([0,0,CylinderZ()])
      rotate([0,90,0])
      ChamferedCylinder(r1=(BarrelRadius()*3)+(CR()*2)+0.125, r2=CR(),
               h=length-ManifoldGap(), $fn=Resolution(80, 200));
    }
    
    FrameBolts(cutter=true);
    
    translate([-ReceiverFrontLength(),0,0])
    CouplingBolts(extension=ReceiverFrontLength(), boltHead="flat", cutter=true);

    RevolverRecoilPlate(cutter=true);
    
    RecoilPlateFiringPinAssembly(cutter=true);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true);

    RevolverSpindle(cutter=true);
  }
}


module RevolverReceiverFront_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
  RevolverReceiverFront();
}

module BarrelSupport(debug=false, alpha=_ALPHA_FOREND,
                    $fn=Resolution(30,100)) {
                      
  extraBottom=0.125;

  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Frame support
      translate([ForendMinX(),0,0])
      FrameSupport(length=BarrelSupportLength(),
                   extraBottom=extraBottom);

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
      hull() {
        *translate([ForendMinX(),0,CylinderZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=abs(CylinderZ()), r2=CR(),
                 h=CR()*2, teardropTop=true);
        
        translate([ForendMinX(),0,CylinderZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(),
                          r2=CR(),
                          h=BarrelSupportLength(), teardropTop=true);
      
        translate([ForendMinX(), -(SpindleCollarRadius()+WallSpindle()), 0])
        ChamferedCube([BarrelSupportLength(),
                       (SpindleCollarRadius()+WallSpindle())*2,
                       FrameBoltZ()], r=CR());
      }
      
      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMinX()+CR(),
                 BarrelRadius()+WallBarrel(),
                 FrameBottomZ()-0.125])
      rotate([0,90,0])
      rotate(-90)
      Fillet(r=0.25, h=BarrelSupportLength()-(CR()*2),
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
    
    BarrelSetScrews(cutter=true, teardrop=true);

    ChargingRod(cutter=true);
    
    RevolverSpindle(cutter=true);
    
    SpindleCollar(cutter=true);
  }
}

module BarrelSupport_print() {
  rotate([0,-90,0]) translate([-ForendMinX(),0,0])
  BarrelSupport();
}
module FrameSpacer(length=ForendMinX(), debug=false, alpha=_ALPHA_FOREND) {
  extraBottom=0.125;
  
  color("Tan", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    FrameSupport(length=length,
                 extraBottom=extraBottom);
    
    translate([BarrelMinX()-0.25,-0.5,FrameBottomZ()-extraBottom])
    ChamferedSquareHole(sides=[1, 1], center=false,
                        length=FrameTopZ()-FrameBottomZ()+extraBottom,
                        corners=false,
                        chamferRadius=0.25);

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);
    
    RevolverBlastPlate(cutter=true);
    
    ChargingRod(cutter=true);
  }
}

module FrameSpacer_print() {
  rotate([0,-90,0])
  translate([0,0,-FrameBoltZ()])
  FrameSpacer();
}


module RevolverCylinder(supports=true, chambers=false,
                        chamberBolts=false,
                        debug=_CUTAWAY_CYLINDER,
                        alpha=_ALPHA_CYLINDER) {
  OffsetZigZagRevolver(
      diameter=CYLINDER_DIAMETER,
      height=CYLINDER_LENGTH,
      centerOffset=abs(CylinderZ()),
      spindleRadius=RodRadius(CylinderRod())+0.005,
      chamberRadius=BarrelRadius(),
      chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=CHAMBER_ID/2,
      extraBottom=0.125,
      supportsBottom=false, supportsTop=supports,
      chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha);
}


module RevolverCylinder_print() {
  translate([0,0, CYLINDER_LENGTH])
  rotate([0,180,0])
  RevolverCylinder(supports=true);
}

// Assemblies
module RevolverForendAssembly(stock=true,
                               pipeAlpha=1, debug=false) {

  if (_SHOW_ACTION_ROD)
  ChargingPumpAssembly(debug=debug);

  if (_SHOW_BARREL) {
    Barrel(debug=debug);
    
    RevolverBlastPlate(debug=debug);
    
    BarrelSetScrews();
  }

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
  }

  if (_SHOW_RECEIVER_FRONT)
  RevolverReceiverFront(debug=debug);
}

module RevolverFireControlAssembly(debug=false) {

  translate([FiringPinMinX()-1,0,0])
  HammerAssembly(insertRadius=0.75, alpha=0.5);

  RecoilPlateFiringPinAssembly(debug=debug);

  RevolverRecoilPlate(debug=debug);

  *Charger();
}

module RevolverAssembly() {
  if (_SHOW_RECEIVER) {
  translate([-ReceiverFrontLength(),0,0])
  Receiver(debug=_CUTAWAY_RECEIVER,
           pipeAlpha=_ALPHA_RECEIVER_TUBE,
           buttstockAlpha=_ALPHA_RECEIVER_TUBE,
           buttstock=true,

           couplingAlpha=_ALPHA_RECEIVER_COUPLING,
           couplingBoltHead="flat",
           couplingBoltExtension=ReceiverFrontLength(),
           
           frameBolts=_SHOW_FRAME,
           frameBoltLength=FrameBoltLength(),
           frameBoltBackset=ReceiverBackLength(),
  
           triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                          -Animate(ANIMATION_STEP_TRIGGER_RESET));

    RevolverFireControlAssembly();
  }

  RevolverForendAssembly(pipeAlpha=0.5, debug=false);
}

if (_RENDER == "Assembly")
RevolverAssembly();

*!intersection() {
  projection(cut=true)
  scale(25.4)
  translate([0,0,-1/16])
  RevolverCylinder_print();
  
  scale(25.4)
  circle(r=1.125-0.125, $fn=100);
}

scale(25.4) {
  
  if (_RENDER == "BarrelSupport")
  BarrelSupport_print();
  
  if (_RENDER == "FrameSpacer")
  FrameSpacer_print();

  if (_RENDER == "ReceiverFront")
  RevolverReceiverFront_print();

  if (_RENDER == "ReceiverFront")
  RevolverReceiverFront_print();
  
  if (_RENDER == "RevolverCylinder")
  RevolverCylinder_print();
}
