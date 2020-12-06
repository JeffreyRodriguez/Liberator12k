include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;

use <../../Shapes/Chamfer.scad>;
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

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FireControlHousing", "Disconnector", "RevolverActuator", "Hammer"]
//$t = 1; // [0:0.01:1]

_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_DISCONNECTOR = true;
_SHOW_HAMMER = true;
_SHOW_ACTION_ROD = true;
_SHOW_FIRING_PIN = true;

_SHOW_RECEIVER = true;

/* [Assembly Transparency] */
_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]
_ALPHA_HAMMER = 1; // [0:0.1:1]

/* [Assembly Cutaways] */
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;
_CUTAWAY_RECEIVER = false;

/* [Screws] */
HAMMER_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"] 
HAMMER_BOLT_CLEARANCE = 0.015;

REVOLVER_ACTUATOR_BOLT = "#8-32"; // ["M4", "#8-32"]
REVOLVER_ACTUATOR_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_SPRING_CLEARANCE = 0.01;

// Firing pin diameter
FIRING_PIN_DIAMETER = 0.09375;

// Firing pin clearance
FIRING_PIN_CLEARANCE = 0.015;

// Shaft collar diameter
FIRING_PIN_COLLAR_DIAMETER = 0.375;

// Shaft collar width
FIRING_PIN_COLLAR_WIDTH = 0.1875;

// Settings: Vitamins
function HammerBolt() = BoltSpec(HAMMER_BOLT);
assert(HammerBolt(), "HammerBolt() is undefined. Unknown HAMMER_BOLT?");

function RevolverActuatorBolt() = BoltSpec(REVOLVER_ACTUATOR_BOLT);
assert(RevolverActuatorBolt(), "RevolverActuatorBolt() is undefined. Unknown REVOLVER_ACTUATOR_BOLT?");

// Settings: Lengths
function ChargingRodOffset() =  0.75+RodRadius(ChargingRod());
function ChamferRadius() = 1/16;
function CR() = 1/16;
chargerTravel = 2;

function FiringPinBoltOffsetZ() = 0.5;

function FiringPinDiameter(clearance=0) = FIRING_PIN_DIAMETER+clearance;
function FiringPinRadius(clearance=0) = FiringPinDiameter(clearance)/2;

function FiringPinCollarDiameter() = FIRING_PIN_COLLAR_DIAMETER;
function FiringPinCollarRadius() = FiringPinCollarDiameter()/2;
function FiringPinCollarWidth() = 0.1875;

function FiringPinExtension() = 0;
function FiringPinTravel() = 0.05;
function FiringPinHousingLength() = 1;
function FiringPinHousingBack() = 0.25;
function FiringPinHousingWidth() = 0.75;

function FiringPinLength() = FiringPinHousingLength()+0.5
                           + FiringPinExtension()
                           + FiringPinTravel();

// Calculated: Positions
function FiringPinMinX() = -FiringPinHousingLength();
function RecoilPlateRearX()  = 0.25;

function ActionRodZ() = 0.75+RodRadius(ActionRod());

hammerFiredX  = FiringPinMinX();
hammerCockedX = -LowerMaxX()-0.125;

hammerTravelX = abs(hammerCockedX-hammerFiredX);
hammerOvertravelX = 0.25;
echo("hammerOvertravelX", hammerOvertravelX);

disconnectorOffset = 0.875;
disconnectorPivotZ = -0.125;
disconnectorPivotAngle=-7;
disconnectorThickness = 0.5;
disconnectorHeight = 0.25;
disconnectDistance = 0.125;
disconnectorExtension = 0;
disconnectorPivotX = -disconnectorOffset;
disconnectorLength = abs(hammerCockedX-disconnectorPivotX)
                   + disconnectDistance
                   + disconnectorExtension;

//$t= AnimationDebug(ANIMATION_STEP_CHARGE);
//$t= AnimationDebug(ANIMATION_STEP_CHARGER_RESET, start=0.85);

$fs = UnitsFs()*0.25;

//************
//* Vitamins *
//************
module RevolverActionRod(length=10, debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Action Rod
  color("Silver")
  translate([-0.5-(cutter?1:0),0,ActionRodZ()])
  DebugHalf(enabled=debug)
  ActionRod(length=length+ManifoldGap(), clearance=clear, cutter=true);
}
module RevolverActuatorBolt(debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([-0.25,
             0,
             0.25])
  rotate([180,0,0])
  NutAndBolt(bolt=RevolverActuatorBolt(), boltLength=0.75,
             head="flat", capOrientation=true,
             clearance=clear, teardrop=cutter);
}
module DisconnectorPivotPin(debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([disconnectorPivotX, 0, disconnectorPivotZ])
  rotate([90,0,0])
  cylinder(r=(3/32/2)+clear, h=ReceiverID()+clear2, center=true, $fn=20);
}
module DisconnectorSpring(debug=false, cutter=false, clearance=DISCONNECTOR_SPRING_CLEARANCE) {
  translate([-0.0625,-0.1875+0.01,disconnectorPivotZ-0.125-0.3125])
  mirror([0,1,0])
  mirror([1,0,0])
  ChamferedCube([0.25, 0.25, 0.375+0.02], r=1/32);
}
module HammerBolt(clearance=0.01, cutter=false, debug=false) {
  color("Silver") RenderIf(!cutter)
  translate([hammerCockedX+ManifoldGap(),0,0])
  rotate([0,90,0])
  NutAndBolt(bolt=HammerBolt(), boltLength=1.5+ManifoldGap(2),
             head="flat", nut="hex",
             capOrientation=true,
             clearance=(cutter?clearance:0));
}
module FiringPin(radius=FiringPinRadius(), cutter=false, clearance=FIRING_PIN_CLEARANCE, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Pin
  color("DarkGoldenrod")
  translate([-FiringPinHousingLength()-FiringPinTravel(),0,0])
  rotate([0,90,0])
  cylinder(r=radius+clear,
           h=FiringPinLength());

  // Collar
  color("Silver")
  DebugHalf(enabled=debug)
  translate([-FiringPinHousingLength()-FiringPinTravel(),0,0])
  rotate([0,-90,0])
  cylinder(r=FiringPinCollarRadius()+clear,
           h=FiringPinCollarWidth());

  // Spring
  color("Silver")
  DebugHalf(enabled=debug)
  translate([-(FiringPinHousingLength()
            -FiringPinHousingBack()),0,0])
  rotate([0,90,0])
  cylinder(r=0.125+clear,
           h=FiringPinHousingLength()
            -FiringPinHousingBack());
}


//*****************
//* Printed Parts *
//*****************
module RevolverActuator(debug=false, cutter=false, clearance=0.015) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  width = 0.5;
  chamferRadius = 1/16;
  
  color("Green")
  RenderIf(!cutter)
  difference() {
    
    // Long segment along the action rod
    translate([-0.5-(cutter?1:0),
               -(width/2)-0.125-clear,
               ActionRodZ()+0.25+clear])
    mirror([0,0,1])
    ChamferedCube([0.5+(cutter?2:0), width+0.125+clear2, ActionRodZ()+clear2], r=chamferRadius);
    
    if (!cutter) {
      RevolverActionRod(cutter=true, clearance=0.005);
      RevolverActuatorBolt(cutter=true);
    }
      
  }
}
module Hammer(cutter=false, clearance=UnitsImperial(0.01), debug=_CUTAWAY_HAMMER, alpha=_ALPHA_HAMMER) {
  
  hammerHeadLength=2;
  hammerBodyWidth=0.5;
  hammerHeadHeight=ReceiverIR()+0.25;
  
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Head
  color("CornflowerBlue", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Body
      translate([hammerCockedX,0,0])   
      rotate([0,-90,0])
      intersection () {
        ChamferedCylinder(r1=ReceiverIR()-0.02, r2=1/8,
                           h=hammerHeadLength,
                         teardropTop=true, teardropBottom=true, $fn=80);
        
        translate([-BoltFlatHeadRadius(HammerBolt())-0.3125,-ReceiverIR(),0])
        ChamferedCube([ReceiverIR()+BoltFlatHeadRadius(HammerBolt())+0.3125,
                       ReceiverID(), hammerHeadLength], r=1/8);
      }
      
      // Wings 
      translate([hammerCockedX, -ReceiverIR()-0.125,-0.25+clearance])
      rotate([0,-90,0])
      ChamferedCube([0.5-(clearance*2), ReceiverID()+0.25, 1.25],
                    chamferXYZ=[true, true, false], r=3/16);
    }
    
    // Trigger Slot
    translate([hammerCockedX+0.125,-0.375/2,-BoltFlatHeadRadius(HammerBolt())])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([hammerHeadLength+0.25, 0.375, ReceiverIR()], r=1/32);
    
    translate([disconnectDistance,0,0]) {
      Disconnector(cutter=true, debug=false, cutterLength=5);
      Disconnector(pivotFactor=1, cutter=true, debug=false);
    }
    
    HammerBolt(cutter=true);
    
    // Spring Hole
    translate([hammerCockedX-1.25,0,0])
    rotate([0,-90,0])
    cylinder(r=0.65/2, h=1.75, $fn=30);
    
    // Chop the bottom to avoid the lower lugs
    translate([hammerCockedX+0.125,-ReceiverIR(),-BoltFlatHeadRadius(HammerBolt())-0.3125])
    mirror([1,0,0])
    mirror([0,0,1])
    cube([hammerHeadLength+0.25, ReceiverID(), ReceiverIR()]);
  }
}

module Disconnector(pivotFactor=0, cutter=false, clearance=0.01, cutterLength=0, alpha=1, debug=_CUTAWAY_DISCONNECTOR) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  Pivot(factor=pivotFactor,
        pivotX=disconnectorPivotX,
        pivotZ=disconnectorPivotZ,
        angle=disconnectorPivotAngle) {
          
    children();
    
    color("Tan", alpha)
    RenderIf(!cutter)
    DebugHalf(enabled=debug)
    difference() {
      union() {
        
        // Trip
        hull() {
          translate([disconnectorPivotX+disconnectorOffset-0.125-clearance,
                     -0.5-clear,
                     disconnectorPivotZ-0.125-clear])
          ChamferedCube([0.125+(cutter?0.125:0),
                0.3125+clear2,
                abs(disconnectorPivotZ)+0.375+clear2], r=1/64);
          
          translate([disconnectorPivotX,
                     -0.5-clear,
                     disconnectorPivotZ])
          rotate([-90,0,0])
          ChamferedCylinder(r1=0.125+clear, r2=1/64, h=0.3125+clear2);
        }
        
        // Prong
        translate([disconnectorPivotX+(cutter?0.125:0)-clearance,
                   -0.5-clear,
                   disconnectorPivotZ-0.125-clear])
        mirror([1,0,0])
        ChamferedCube([disconnectorLength+(cutter?cutterLength:0),
              0.25+clear2,
              disconnectorHeight+clear2], r=1/64);
      }
      
      if (!cutter) {
        DisconnectorPivotPin(cutter=true);
        DisconnectorSpring(cutter=true);
      
        // Trim the back edge to clear pivot
        translate([0,-0.5-clear,disconnectorPivotZ+0.125])
        rotate([0,-disconnectorPivotAngle,0])
        mirror([0,0,1])
        cube([1, 0.3125+clear2, 1]);
      }
    }
  }
}
module FireControlHousing(debug=_CUTAWAY_FIRING_PIN_HOUSING, alpha=_ALPHA_FIRING_PIN_HOUSING) {
  
  color("Olive", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    
    // Insert plug
    rotate([0,-90,0])
    intersection () {
      ChamferedCylinder(r1=ReceiverIR()-0.01, r2=1/32,
                         h=FiringPinHousingLength(),
                       teardropTop=true, teardropBottom=true, $fn=80);
      
      translate([-ReceiverIR(),-ReceiverIR(),0])
      ChamferedCube([ReceiverIR()+0.25, ReceiverID(), FiringPinHousingLength()], r=1/32);
    }
    
    ReceiverSideplateBolts(cutter=true, nutType="none", teardropAngle=0);

    FiringPin(cutter=true);
    
    for (PF = [0,1])
    Disconnector(pivotFactor=PF, cutter=true);
    
    DisconnectorSpring(cutter=true);
    DisconnectorPivotPin(cutter=true);
    
    // Disconnector spring access
    translate([0.125,-0.1875+0.01,disconnectorPivotZ-0.125-0.25])
    mirror([0,1,0])
    mirror([1,0,0])
    ChamferedCube([0.25, 0.25, 0.375+0.02], r=1/32);
  }
}

module FireControlHousing_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX()+FiringPinHousingLength(),0,0])
  FireControlHousing(debug=false);
}


//**************
//* Assemblies *
//**************
module RevolverFireControlAssembly(debug=false) {
  disconnectStart = 0.8;
  disconnectLetdown = 0.2;
  connectStart = 0.91;
  hammerChargeStart = 0.25;
  
  disconnectorTripAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.0, end=0.2)
                     - SubAnimate(ANIMATION_STEP_CHARGER_RESET,
                                  start=connectStart);
  
  disconnectorAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.99)
                 - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=connectStart, end=0.98);
  
  chargeAF = Animate(ANIMATION_STEP_CHARGE)
           - Animate(ANIMATION_STEP_CHARGER_RESET);

  if (_SHOW_ACTION_ROD)
  translate([-chargerTravel*chargeAF,0,0]) {
    RevolverActuator();
    RevolverActionRod();
    RevolverActuatorBolt();
  }
  
  DisconnectorPivotPin();
  
  if (_SHOW_DISCONNECTOR)
  Disconnector(pivotFactor=disconnectorAF);

  // Linear Hammer
  if (_SHOW_HAMMER)
  translate([Animate(ANIMATION_STEP_FIRE)*hammerTravelX,0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGE, start=hammerChargeStart)*-(hammerTravelX+hammerOvertravelX),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1)*(hammerOvertravelX-disconnectDistance),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.97, end=1)*disconnectDistance,0,0]) {
    Hammer();
    HammerBolt();
  }
 
  if (_SHOW_FIRING_PIN)
  translate([(3/32)*SubAnimate(ANIMATION_STEP_FIRE, start=0.95),0,0])
  translate([-(3/32)*SubAnimate(ANIMATION_STEP_CHARGE, start=0.07, end=0.2),0,0])
  FiringPin(cutter=false, debug=false);
  
  if (_SHOW_FIRE_CONTROL_HOUSING)
  FireControlHousing();
  
  
  translate([-LowerMaxX(),0,LowerOffsetZ()])
  Sear(length=SearLength()+abs(LowerOffsetZ())+SearTravel()-0.25);
}



//*************
//* Rendering *
//*************
if (_RENDER == "Assembly") {
  RevolverFireControlAssembly();
  
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
}

scale(25.4) {
  
  if (_RENDER == "FireControlHousing")
  FireControlHousing_print();
  
  if (_RENDER == "Hammer")
  rotate([0,90,0])
  translate([-hammerCockedX,0,0])
  Hammer();
  
  
  if (_RENDER == "RevolverActuator")
  rotate([0,-90,0])
  translate([RecoilSpreaderThickness()+0.5, 0, -ActionRodZ()])
  RevolverActuator();

  if (_RENDER == "Disconnector")
  rotate([90,0,0])
  translate([-disconnectorPivotX,0.5,-disconnectorPivotZ])
  Disconnector();
}
