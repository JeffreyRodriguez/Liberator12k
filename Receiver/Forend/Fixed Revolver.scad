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

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Action Rod.scad>;
//use <../Charging Pump.scad>;
use <../Receiver.scad>;
use <../Firing Pin.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Lugs.scad>;
use <../Frame.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FrameSpacer", "ReceiverFront", "Foregrip", "RevolverCylinderCore", "RevolverCylinderShell", "BarrelSupport"]
//$t = 1; // [0:0.01:1]

_SHOW_ACTION_ROD = true;
_SHOW_BARREL = true;
_SHOW_CHAMBERS = true;
_SHOW_BARREL_SUPPORT = true;
_SHOW_CYLINDER = true;
_SHOW_PUMP = true;
_SHOW_SPINDLE = true;
_SHOW_FOREND_SPACER = true;
_SHOW_FRAME = true;
_SHOW_LOWER = true;
_SHOW_RECEIVER = true;
_SHOW_FCG = true;
_SHOW_RECEIVER_FRONT = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_BUTTSTOCK = true;
_SHOW_SHIELD = true;

/* [Assembly Transparency] */
_ALPHA_BARREL_SUPPORT = 1;     // [0:0.1:1]
_ALPHA_CYLINDER = 1;           // [0:0.1:1]
_ALPHA_FOREND = 1;             // [0:0.1:1]
_ALPHA_RECEIVER_TUBE = 1;      // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]
_ALPHA_RECEIVER_FRONT = 1;     // [0:0.1:1]
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]
_ALPHA_SHIELD = 1;             // [0:0.1:1]
_ALPHA_SPINDLE = 1;            // [0:0.1:1]

/* [Assembly Cutaways] */
_CUTAWAY_BARREL_SUPPORT = false;
_CUTAWAY_CYLINDER = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_RECEIVER_FRONT = false;
_CUTAWAY_FOREND = false;
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_DISCONNECTOR = false;

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

// Settings: Lengths
function ShellRimLength() = 0.06+0.05;
function ChamberLength() = CHAMBER_LENGTH;
function BarrelLength() = BARREL_LENGTH;
function CylinderZ() = -(CYLINDER_OFFSET + ManifoldGap());
function WallBarrel() = 0.375; //0.4375;
function WallSpindle() = 0.25;

function ChargingRodOffset() =  0.75+RodRadius(ChargingRod());


function ChamferRadius() = 1/16;
function CR() = 1/16;


// Settings: Vitamins
// ZigZag Cylinder
function CylinderRod() = Spec_RodFiveSixteenthInch();
function SpindleCollarDiameter() = 0.61;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;
function SpindleCollarWidth() = (3/8);

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

module RevolverSpindle(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([RecoilPlateRearX(),0,CylinderZ()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=ForendMaxX()+abs(RecoilPlateRearX())+ManifoldGap(3), 
      clearance=cutter?RodClearanceSnug():undef);
}

module SpindleCollar(cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("SteelBlue") RenderIf(!cutter)
  translate([ForendMinX(), 0, CylinderZ()])
  rotate([0,90,0])
  cylinder(r=SpindleCollarRadius()+clear, h=SpindleCollarWidth()+clear, $fn=30);
}
module RevolverRecoilPlate(firingPinAngle=0, cutter=false, debug=_CUTAWAY_RECEIVER_FRONT) {
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
    *ChargingRod(cutter=true);
    RevolverSpindle(cutter=true);
  }
}
// Printed Parts
module RevolverReceiverFront(debug=_CUTAWAY_RECEIVER_FRONT, alpha=_ALPHA_RECEIVER_FRONT) {
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
    
    // Cut out the middle hole
    rotate([0,-90,0])
    cylinder(r=ReceiverIR(),
    h=RecoilSpreaderThickness(),
    $fn=Resolution(50,100));
    
    FrameBolts(cutter=true);
    
    translate([-ReceiverFrontLength(),0,0])
    CouplingBolts(extension=ReceiverFrontLength(), boltHead="flat", cutter=true);

    RevolverRecoilPlate(cutter=true);
    
    RecoilPlateFiringPinAssembly(cutter=true);
    
    RevolverActionRod(cutter=true);

    RevolverSpindle(cutter=true);
  }
}


module RevolverReceiverFront_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
  RevolverReceiverFront();
}

module BarrelSupport(debug=false, alpha=_ALPHA_FOREND,
                    $fn=Resolution(30,100)) {
                      
  extraBottom=0.25;

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
      hull()
      for (Z = [0, CylinderZ()])
      translate([ForendMinX()+SpindleCollarWidth(),0,Z])
      rotate([0,90,0])
      ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(),
                        r2=CR(),
                        h=BarrelSupportLength()-SpindleCollarWidth(),
                        teardropTop=true);
      
      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMinX()+CR(),
                 BarrelRadius()+WallBarrel()-ManifoldGap(2),
                 FrameBottomZ()-extraBottom+ManifoldGap()])
      rotate([0,90,0])
      rotate(-90)
      Fillet(r=0.5, h=BarrelSupportLength()-(CR()*2),
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

    *ChargingRod(cutter=true);
    
    RevolverSpindle(cutter=true);
    
    SpindleCollar(cutter=true);
  }
}

module BarrelSupport_print() {
  rotate([0,90,0]) translate([-ForendMaxX(),0,0])
  BarrelSupport();
}
module FrameSpacer(length=ForendMinX(), debug=false, alpha=_ALPHA_FOREND) {
  extraBottom=0.25;
  
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
    
    *ChargingRod(cutter=true);
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
                        alpha=_ALPHA_CYLINDER,
                        render_cylinder=true) {
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
      debug=debug, alpha=alpha,
      render_cylinder=render_cylinder);
}


module RevolverCylinderCore_print() {
  render()
  intersection() {
  
    translate([0,0, CYLINDER_LENGTH])
    rotate([0,180,0])
    RevolverCylinder(render_cylinder=false);
    
    cylinder(r=CYLINDER_OFFSET-(BARREL_DIAMETER*0.33), h=CYLINDER_LENGTH, $fn=100);
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

module Foregrip_print() {
  rotate([0,-90,0])
  translate([-ForegripFrontX(),0,0])
  ChargingPump(innerRadius=(BARREL_DIAMETER+BARREL_CLEARANCE)/2);
}

// Assemblies
module RevolverForendAssembly(stock=true,
                               pipeAlpha=1, debug=false) {
  if (_SHOW_BARREL) {
    Barrel(debug=debug);
    
    RevolverBlastPlate();
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
  RevolverReceiverFront();
}


chargerTravel = 2;
actionRodZ = 0.75+RodRadius(ActionRod());

module RevolverActionRod(debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  translate([-RecoilPlateThickness()-0.5,0,actionRodZ])
  color("Silver")
  DebugHalf(enabled=debug)
  ActionRod(length=10+ManifoldGap(), clearance=clear);
  
  // Pusher
  actionRodPusherWidth=0.5;
  
  color("Green")
  render()
  union() {
    // Vertical
    translate([-RecoilPlateThickness(),
               -(actionRodPusherWidth/2)-clear,
               actionRodZ+0.125-clear])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([0.75+(cutter?2:0), actionRodPusherWidth+clear2, 0.5+clear2]);
    
    //  Horizontal
    *translate([-RecoilPlateThickness(),
               -(actionRodPusherWidth/2),
               0.25])
    mirror([1,0,0])
    cube([FiringPinHousingLength(), actionRodPusherWidth, 0.375]);
  }
}



hammerFiredX  = FiringPinMinX();
hammerCockedX = FiringPinMinX()-0.125-(LowerMaxX()-FiringPinHousingLength())-0.25;

hammerTravelX = abs(hammerCockedX-hammerFiredX);
hammerOvertravelX = (chargerTravel-0.25)-hammerTravelX;
echo("hammerOvertravelX", FiringPinMinX());

module LinearHammerHead(cutter=false, clearance=UnitsImperial(0.01)) {
  
  hammerBodyWidth=0.5;
  hammerHeadWidth=0.25;
  hammerHeadHeight=0.75;
  
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Hammer Rod
  translate([hammerCockedX,
             -(0.25/2)-clear,
             -0.25/2])
  mirror([1,0,0])
  cube([10, 0.25+clear2, 0.25+clear]);
  
  // Head
  color("CornflowerBlue")
  RenderIf(!cutter)
  union() {
    translate([hammerCockedX, -(hammerBodyWidth/2)-clear,-0.125])
    mirror([1,0,0])
    cube([1, hammerBodyWidth+clear2, hammerHeadHeight+clear2]);
    
    // Tip
    *translate([hammerCockedX, -(hammerHeadWidth/2)-clear, 0.25])
    cube([2, hammerHeadWidth+clear2, hammerHeadHeight+clear2]);
    
    // Tip Top
    translate([hammerCockedX,
               -(1/4)-clear,
               -0.125])
    mirror([1,0,0])
    cube([2, 0.5+clear2, 0.25+clear2]);
  }
}

disconnectorPivotX = -ReceiverFrontLength();
disconnectorPivotZ = -(1/8);
disconnectorPivotAngle=5;

disconnectorTravelZ = 0.25;
disconnectorThickness = 1;
disconnectorMaxX = -ReceiverFrontLength();

disconnectDistance = 1/8;
disconnectorBackRadius = abs(hammerCockedX-disconnectorPivotX-disconnectDistance);
disconnectorBackDiameter = disconnectorBackRadius*2;
disconnectorTabRadius = 3/32/2;

disconnectorCatchPinX = disconnectorPivotX-disconnectorBackRadius+disconnectorTabRadius;
disconnectorCatchPinZ = -disconnectorTabRadius-0.125;

disconnectorAnchorX = -RecoilPlateThickness()-(0.25)-1;
disconnectorAnchorZ = disconnectorPivotZ+1.25;

disconnectorTripPivotX = -RecoilPlateThickness()-(0.75);
disconnectorTripPivotZ = 1.25;
disconnectorTripPivotAngle = 5;

module DisconnectorTrip() {
  rotate([90,0,0])
  linear_extrude(height=0.5, center=true) {
    
    translate([disconnectorTripPivotX, disconnectorTripPivotZ])
    circle(r=0.125, $fn=40);

    hull() {
      // Disconnector-trip interface
      translate([disconnectorAnchorX, disconnectorAnchorZ+0.125])
      circle(r=0.0625, $fn=20);
      
      // Pivot
      translate([disconnectorTripPivotX, disconnectorTripPivotZ])
      circle(r=0.0625, $fn=40);
    }
    
    #hull() {
      // Action-rod interface
      translate([-0.375, actionRodZ+0.1875])
      circle(r=(1/16), $fn=20);
      
      // Pivot
      translate([disconnectorTripPivotX, disconnectorTripPivotZ])
      circle(r=(1/16), $fn=40);
    }
  }
}

module Disconnector(alpha=1, debug=_CUTAWAY_DISCONNECTOR) {
  
  // Disconnector Catch Pin
  color("Silver")
  translate([disconnectorCatchPinX, 0, -(1/8)-disconnectorTabRadius])
  rotate([90,0,0])
  cylinder(r=disconnectorTabRadius, h=1.3125, center=true, $fn=20);
  
  // Disconnector extension spring pin (Moving)
  color("Silver")
  translate([disconnectorAnchorX, 0, disconnectorAnchorZ])
  rotate([90,0,0])
  cylinder(r=disconnectorTabRadius, h=1.01, center=true, $fn=20);
  
  
  color("Tan", alpha)
  render()
  DebugHalf(enabled=debug)
  //for (My = [1,0]) mirror([0,My,0])
  difference() {
    
    // Body
    intersection() {
      rotate([90,0,0])
      linear_extrude(height=disconnectorThickness, center=true)
      {
        difference() {
          hull() {
          
            // Pivot Support
            translate([disconnectorPivotX, disconnectorPivotZ])
            circle(r=0.25, $fn=20);
            
            // Catch pin support
            translate([disconnectorCatchPinX, disconnectorCatchPinZ])
            circle(r=0.25, $fn=20);
            
            // Extension Spring Pin Support
            translate([disconnectorAnchorX, disconnectorAnchorZ])
            circle(r=1/8, $fn=20);
          }
          
          translate([-1.75,0.25])
          circle(r=0.5, $fn=50);
        }
      }
      
      union() {
        rotate([0,-90,0])
        cylinder(r=ReceiverIR()-0.01, h=6, $fn=100);
        
        translate([0,-0.5, 0])
        mirror([1,0,0])
        cube([6, 1, FrameTopZ()]);
      }
    }
      
    // Clear firing pin retainer block
    translate([disconnectorPivotX, 0, disconnectorPivotZ])
    rotate([0, -disconnectorPivotAngle, 0])
    translate([-disconnectorPivotX, 0, -disconnectorPivotZ])
    translate([-1.25-3, -(0.75/2)-0.01, -ReceiverOR()])
    cube([1.25+0.01+3, 0.75+0.02, ReceiverOR()+FrameTopZ()]);
    
    // Clear the hammer
    translate([disconnectorPivotX,-0.26,-0.125-0.01])
    rotate([0,-disconnectorPivotAngle,0])
    mirror([1,0,0])
    cube([disconnectorBackRadius+0.5, 0.52, FrameTopZ()]);
    
    // Clear the sear
    translate([disconnectorCatchPinX,-0.126,disconnectorCatchPinZ-0.5])
    for (R = [0, -disconnectorPivotAngle]) rotate([0,R,0])
    cube([0.5, 0.27, 1]);
  }
}

module RevolverFireControlAssembly(debug=false) {
  disconnectStart = 0.8;
  disconnectLetdown = 0.2;
  connectStart = 0.8;
  
  disconnectorTripAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.0, end=0.2)
                     - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=connectStart, end=0.99);
  
  disconnectorAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.99)
                 - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=connectStart, end=0.99);
  
  chargeAF = Animate(ANIMATION_STEP_CHARGE)
           - Animate(ANIMATION_STEP_CHARGER_RESET);

  if (_SHOW_ACTION_ROD)
  translate([-chargerTravel*chargeAF,0,0])
  RevolverActionRod();
  
  // Linear Hammer
  translate([Animate(ANIMATION_STEP_FIRE)*hammerTravelX,0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGE, start=0.25)*-((chargerTravel-0.25)),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1)*(hammerOvertravelX-disconnectDistance),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.95, end=1)*disconnectDistance,0,0])
  LinearHammerHead();
  
  // Disconnector Pivot pin
  color("Silver")
  translate([disconnectorPivotX, 0, disconnectorPivotZ])
  rotate([90,0,0])
  cylinder(r=3/32/2, h=1.375, center=true, $fn=20);
  
  // Disconnector extension spring pin (Static)
  color("Silver")
  translate([disconnectorTripPivotX, 0, disconnectorTripPivotZ])
  rotate([90,0,0])
  cylinder(r=disconnectorTabRadius, h=1.01, center=true, $fn=20);
  
  // Disconnector
  Pivot(factor=disconnectorAF,
        pivotX=disconnectorPivotX,
        pivotZ=disconnectorPivotZ,
        angle=disconnectorPivotAngle)
  Disconnector();
          
  Pivot(factor=disconnectorTripAF,
        pivotX=disconnectorTripPivotX,
        pivotZ=disconnectorTripPivotZ,
        angle=disconnectorTripPivotAngle)
  DisconnectorTrip();
  
  if (_SHOW_PUMP)
  translate([ForendMaxX()+2.75,0,0])
  rotate([0,90,0])
  PumpGrip(doRender=true, alpha=1);
  *ChargingPumpAssembly(debug=debug);

  *translate([-ReceiverFrontLength()-LowerMaxX()-(0.25/2)-disconnectorThickness,0,0])
  HammerAssembly(insertRadius=0.75,
                 alpha=0.5, travel=abs(FiringPinMinX()));
  
  // FCG Top Screw
  *color("Silver")
  translate([-3.5-ManifoldGap(),0,FrameTopZ()-0.25])
  rotate([0,-90,0])
  Bolt(bolt=BoltSpec("1/4\"-20"), length=3.5+ManifoldGap(2),
        head="flat",
        capOrientation=true);
  
  // FCG Bottom Screw
  color("Silver")
  translate([-0.5-ManifoldGap(),0,-1.75])
  rotate([0,-90,0])
  Bolt(bolt=BoltSpec("1/4\"-20"), length=0.5+ManifoldGap(2),
        head="flat",
        capOrientation=true);

    FiringPin(cutter=false, debug=false);
    FiringPinHousingBolts(bolt=FiringPinHousingBolt(), boltLength=0.25, cutter=false);

    color("Olive") render()
    DebugHalf(enabled=_CUTAWAY_FIRING_PIN_HOUSING)
    difference() {
      translate([-RecoilPlateThickness(),0,FiringPinZ()])
      rotate([0,-90,0])
      rotate(90)
      union() {
        rotate(-90)
        //hull() {
          
          // Bolt support
          translate([-FiringPinBoltOffsetY(),0,0])
          ChamferedCylinder(r1=0.25, r2=1/32,
                             h=FiringPinHousingLength(),
                           teardropTop=true, teardropBottom=true);

          // Firing pin support
          translate([-FiringPinHousingWidth()/2, -(FiringPinHousingWidth()/2)-1,0])
          ChamferedCube([FiringPinHousingWidth(), FiringPinHousingWidth()+1, FiringPinHousingLength()-0.25], r=1/32);
        //}
      
        // Disconnector extension spring pin support
        translate([-(0.75/2), (FiringPinHousingWidth()/2),0.25])
        mirror([0,1,0])
        ChamferedCube([0.75, FrameTopZ()+(FiringPinHousingWidth()/2), FiringPinHousingLength()-0.25], r=1/32);
      
        // Disconnector extension spring pin support - upper
        translate([-0.5,-FrameTopZ(),0.25])
        ChamferedCube([1, 0.75, FiringPinHousingLength()-0.25], r=1/32);
      }

      FiringPin(cutter=true);

      FiringPinHousingBolts(bolt=FiringPinHousingBolt(), cutter=true);

      // Chamfered Firing Pin Hole
      translate([0,0,FiringPinHousingLength()-FiringPinHousingBack()])
      ChamferedCircularHole(r1=FiringPinRadius(0.015), r2=FiringPinRadius(), h=FiringPinHousingBack());
      
      
      // Action rod cutout
      RevolverActionRod(cutter=true);
      
      // Disconnector spring cutout
      translate([-0.75,-0.52/2,0.5])
      mirror([1,0,0])
      cube([1, 0.52, 1.25]);
    }

  if (_SHOW_RECOIL_PLATE)
  RevolverRecoilPlate();

  *Charger();
}

module RevolverAssembly() {
  if (_SHOW_RECEIVER)
  translate([-ReceiverFrontLength(),0,0])
  Receiver(debug=_CUTAWAY_RECEIVER,
           pipeAlpha=_ALPHA_RECEIVER_TUBE,
           buttstockAlpha=_ALPHA_RECEIVER_TUBE,
           buttstock=_SHOW_BUTTSTOCK,
           lower=_SHOW_LOWER,

           couplingAlpha=_ALPHA_RECEIVER_COUPLING,
           couplingBoltHead="flat",
           couplingBoltExtension=ReceiverFrontLength(),
           
           frameBolts=_SHOW_FRAME,
           frameBoltLength=FrameBoltLength(),
           frameBoltBackset=ReceiverBackLength(),
  
           triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                          -Animate(ANIMATION_STEP_CHARGER_RESET));

  if (_SHOW_FCG)
  RevolverFireControlAssembly();

  RevolverForendAssembly(pipeAlpha=0.5, debug=false);
}

if (_RENDER == "Assembly")
RevolverAssembly();

*!projection(cut=true)
RevolverCylinderCore_print();

//$t= AnimationDebug(ANIMATION_STEP_CHARGE);
$t= AnimationDebug(ANIMATION_STEP_CHARGER_RESET);
//$t=0.3;
//$t=0.2;
//$t=0;

scale(25.4) {
  
  if (_RENDER == "BarrelSupport")
  BarrelSupport_print();
  
  if (_RENDER == "FrameSpacer")
  FrameSpacer_print();
  
  if (_RENDER == "Foregrip")
  Foregrip_print();

  if (_RENDER == "ReceiverFront")
  RevolverReceiverFront_print();
  
  if (_RENDER == "RevolverCylinderCore")
  RevolverCylinderCore_print();
  
  if (_RENDER == "RevolverCylinderShell")
  RevolverCylinderShell_print();
}
