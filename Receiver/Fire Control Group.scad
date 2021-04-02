include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Teardrop.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Components/Pivot.scad>;

use <../Vitamins/Bearing.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <Lower/Lower.scad>;
use <Lower/Trigger.scad>;
use <Lower/Mount.scad>;

use <Receiver.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FireControlHousing", "Disconnector", "HammerCharger", "Hammer", "RecoilPlateJig"]

_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_DISCONNECTOR = true;
_SHOW_HAMMER = true;
_SHOW_ACTION_ROD = true;
_SHOW_FIRING_PIN = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_RECOIL_PLATE_BOLTS = true;

_SHOW_RECEIVER      = true;
_SHOW_LOWER         = true;
_SHOW_LOWER_LEFT    = false;

/* [Assembly Transparency] */
_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]
_ALPHA_HAMMER = 1; // [0:0.1:1]

/* [Assembly Cutaways] */
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;
_CUTAWAY_HAMMER_CHARGER = false;
_CUTAWAY_RECEIVER = true;
_CUTAWAY_RECOIL_PLATE = true;
_CUTAWAY_FIRING_PIN = false;
_CUTAWAY_FIRING_PIN_SPRING = false;

/* [Screws] */
HAMMER_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"] 
HAMMER_BOLT_CLEARANCE = 0.015;

ACTION_ROD_BOLT = "#8-32"; // ["M4", "#8-32"]
ACTION_ROD_BOLT_CLEARANCE = 0.015;

RECOIL_PLATE_BOLT = "#8-32"; // ["M4", "#8-32"]
RECOIL_PLATE_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_SPRING_DIAMETER = 0.23;
DISCONNECTOR_SPRING_CLEARANCE = 0.01;

// Firing pin diameter
FIRING_PIN_DIAMETER = 0.09375;

// Firing pin clearance
FIRING_PIN_CLEARANCE = 0.01;

// Shaft collar diameter
FIRING_PIN_BODY_DIAMETER = 0.3125;

// Shaft collar width
FIRING_PIN_BODY_LENGTH = 1;

// Measured: Vitamins
function RecoilPlateLength() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilPlateHeight() = 2.25;
function RecoilPlateTopZ() = 0.75;

function RecoilPlateBolt() = BoltSpec(RECOIL_PLATE_BOLT);
function RecoilPlateBoltOffsetY() = 0.375;


// Settings: Vitamins
function HammerBolt() = BoltSpec(HAMMER_BOLT);
assert(HammerBolt(), "HammerBolt() is undefined. Unknown HAMMER_BOLT?");

function ActionRodBolt() = BoltSpec(ACTION_ROD_BOLT);
assert(ActionRodBolt(), "ActionRodBolt() is undefined. Unknown ACTION_ROD_BOLT?");

function RecoilPlateBolt() = BoltSpec(RECOIL_PLATE_BOLT);
assert(RecoilPlateBolt(), "RecoilPlateBolt() is undefined. Unknown RECOIL_PLATE_BOLT?");

// Settings: Lengths
function ActionRodWidth() = 0.25;
function ChargingRodOffset() =  0.75+RodRadius(ChargingRod());
function ChamferRadius() = 1/16;
function CR() = 1/16;
chargerTravel = 2;

function FiringPinDiameter(clearance=0) = FIRING_PIN_DIAMETER+clearance;
function FiringPinRadius(clearance=0) = FiringPinDiameter(clearance)/2;

function FiringPinBodyDiameter() = FIRING_PIN_BODY_DIAMETER;
function FiringPinBodyRadius() = FiringPinBodyDiameter()/2;
function FiringPinBodyLength() = 0.75;

function FiringPinTravel() = 0.05;
function FiringPinHousingLength() = 1;
function FiringPinHousingBack() = 0.25;
function FiringPinHousingWidth() = 0.75;

function FiringPinLength() = FiringPinHousingLength()+0.5
                           + FiringPinTravel();

// Calculated: Positions
function FiringPinMinX() = -FiringPinHousingLength();
function RecoilPlateRearX()  = 0.25;

function ActionRodZ() = 0.75+(ActionRodWidth()/2);

hammerFiredX  = FiringPinMinX();
hammerCockedX = -LowerMaxX()-0.125;

hammerTravelX = abs(hammerCockedX-hammerFiredX);
hammerOvertravelX = 0.25;
echo("hammerOvertravelX", hammerOvertravelX);

disconnectorOffsetY = -0.125;
disconnectorOffset = 0.825;
disconnectorPivotZ = 0.5;
disconnectorPivotAngle=-6;
disconnectorThickness = 0.5;
disconnectorHeight = 0.25;
disconnectorTripBackset = 0.0625;
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
module ActionRod(length=10, debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Action Rod
  color("Silver")
  translate([-0.5-(cutter?1:0),0,ActionRodZ()])
  DebugHalf(enabled=debug)
  translate([0,-(ActionRodWidth()/2)-clear,-(ActionRodWidth()/2)-clear])
  cube([length, ActionRodWidth()+clear2, ActionRodWidth()+clear2]);
}
module ActionRodBolt(debug=false, cutter=false, teardrop=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([-0.25,
             0,
             ActionRodZ()+0.375])
  NutAndBolt(bolt=ActionRodBolt(), boltLength=0.5,
             head="flat", capOrientation=true,
             clearance=clear, teardrop=cutter);
}
module DisconnectorPivotPin(debug=false, cutter=false, teardrop=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([disconnectorPivotX, 0, disconnectorPivotZ])
  rotate([90,0,0])
  linear_extrude(height=cutter?ReceiverID():ReceiverTopSlotWidth(), center=true)
  Teardrop(r=(3/32/2)+clear, enabled=teardrop, $fn=20);
}
module DisconnectorSpring(debug=false, cutter=false, clearance=DISCONNECTOR_SPRING_CLEARANCE) {
  translate([-(3/16),
             disconnectorOffsetY+DISCONNECTOR_SPRING_DIAMETER,
             disconnectorPivotZ-0.125-(6/32)])
  ChamferedCylinder(r1=(DISCONNECTOR_SPRING_DIAMETER/2), r2=1/32, h=0.3125);
  
  // Disconnector spring access
  if (cutter)
  translate([0.125,
             disconnectorOffsetY+(DISCONNECTOR_SPRING_DIAMETER/2),
             disconnectorPivotZ-0.125-0.125])
  mirror([1,0,0])
  ChamferedCube([0.3125, DISCONNECTOR_SPRING_DIAMETER, 0.125], r=1/32);
}
module HammerBolt(clearance=0.01, cutter=false, debug=false) {
  color("Silver") RenderIf(!cutter)
  translate([hammerCockedX+ManifoldGap(),0,0])
  rotate([0,90,0])
  NutAndBolt(bolt=HammerBolt(), boltLength=2+ManifoldGap(2),
             head="flat", nut="heatset", nutBackset=0.75, nutHeightExtra=0,
             capOrientation=true,
             clearance=(cutter?clearance:0));
}
module FiringPin(radius=FiringPinRadius(), cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, debug=_CUTAWAY_FIRING_PIN) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  radius = template ? 1/16 : radius;

  // Body
  color("Silver")
  RenderIf(!cutter)
  DebugHalf(enabled=debug)
  translate([-FiringPinHousingLength()-FiringPinTravel(),0,0])
  rotate([0,90,0])
  difference() {
    union() {
    
      // Pin
      cylinder(r=radius+clear,
               h=FiringPinLength()+ManifoldGap());
      
      // Body
      cylinder(r=FiringPinBodyRadius()+clear,
               h=FiringPinBodyLength()+(cutter?0.25+FiringPinTravel():0));
    }
    
    translate([FiringPinBodyRadius()-(1/16)+clear,-FiringPinBodyRadius()-clear,0])
    cube([FiringPinBodyDiameter(),FiringPinBodyDiameter()+clear2,0.25+FiringPinTravel()]);
  }
}

module FiringPinSpring(debug=_CUTAWAY_FIRING_PIN_SPRING) {
  color("SteelBlue")
  DebugHalf(enabled=debug)
  translate([-0.375,0,0])
  rotate([0,90,0])
  cylinder(r=0.125,
           h=0.625);
}



module RecoilPlateBolts(bolt=RecoilPlateBolt(), boltLength=1.5, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  bolt     = template ? BoltSpec("Template") : bolt;
  boltHead = template ? "none"               : "flat";
  
  color("Silver")
  RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  translate([0.5+ManifoldGap(),(1/2),0])
  rotate([0,-90,0])
  Bolt(bolt=bolt, length=boltLength+ManifoldGap(2),
        head=boltHead, capHeightExtra=(cutter?1:0),
        clearance=cutter?clearance:0);
}

module RecoilPlate(cutter=false, debug=false) {
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([0.25, -1-ManifoldGap(2), RecoilPlateTopZ()])
    mirror([0,0,1])
    cube([RecoilPlateLength()+(cutter?(1/8):0),
          RecoilPlateWidth()+ManifoldGap(4),
          RecoilPlateHeight()]);

    if (!cutter)
    RecoilPlateBolts(cutter=true);
  }
}

//*****************
//* Printed Parts *
//*****************
module HammerCharger(debug=false, cutter=false, clearance=0.015) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  width = ReceiverTopSlotWidth();
  chamferRadius = 1/32;
  
  color("OliveDrab")
  RenderIf(!cutter)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Top
      translate([-0.5-(cutter?1:0),
                 -(width/2)-clear,
                 ActionRodZ()+0.375+clear])
      mirror([0,0,1])
      ChamferedCube([0.5+(cutter?2:0),
                     width+clear2,
                     0.25+clear2],
                    r=chamferRadius);
    
      // Side Trip
      translate([-0.5-(cutter?1:0),
                 (ActionRodWidth()/2)-clear,
                 ActionRodZ()+0.375+clear])
      mirror([0,0,1])
      ChamferedCube([0.5-disconnectorTripBackset+(cutter?2:0),
                     0.25+clear2,
                     0.5+clear2],
                    r=chamferRadius);
    }
      
    
    if (!cutter) {
      ActionRod(cutter=true, clearance=0.005);
      ActionRodBolt(cutter=true);
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
  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Body
      translate([hammerCockedX,0,0])   
      rotate([0,-90,0])
      intersection () {
        ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/8,
                           h=hammerHeadLength,
                         teardropTop=true, teardropBottom=true, $fn=80);
        
        translate([-BoltFlatHeadRadius(HammerBolt())-0.3125,-ReceiverIR(),0])
        ChamferedCube([ReceiverIR()+BoltFlatHeadRadius(HammerBolt())+0.3125,
                       ReceiverID(), hammerHeadLength], r=1/8);
      }
      
      // Charging Tip
      hull() {
        translate([hammerCockedX, -(0.5/2), 0])
        mirror([1,0,0])
        ChamferedCube([0.25, 0.5, ActionRodZ()+0.125],
                       r=1/32, teardropFlip=[false,true,true]);
        
        translate([hammerCockedX, -(0.5/2), 0])
        mirror([1,0,0])
        ChamferedCube([ActionRodZ()+0.25, 0.5, 0.25],
                       r=1/32, teardropFlip=[false,true,true]);
      }
      
      // Wings
      translate([hammerCockedX,
                 -(ReceiverIR()+ReceiverSideSlotDepth()-clearance),
                 -(ReceiverSideSlotHeight()/2)+clearance])
      mirror([1,0,0])
      ChamferedCube([hammerHeadLength,
                     (ReceiverIR()+ReceiverSideSlotDepth()-clearance)*2,
                     ReceiverSideSlotHeight()-(clearance*2)],
                    r=1/16,teardropFlip=[true, true, true]);

    }
    
    // Trigger Slot
    translate([hammerCockedX+0.125,-0.375/2,-BoltFlatHeadRadius(HammerBolt())])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([hammerHeadLength+0.25, 0.375, ReceiverIR()], r=1/32);
    
    translate([-hammerTravelX,0,0])
    Disconnector(cutter=true, debug=false);
    
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

module Disconnector(pivotFactor=0, cutter=false, clearance=0.01, alpha=1, debug=_CUTAWAY_DISCONNECTOR) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  Pivot(factor=pivotFactor,
        pivotX=disconnectorPivotX,
        pivotZ=disconnectorPivotZ,
        angle=disconnectorPivotAngle) {
          
    children();
    
    color("Olive", alpha)
    RenderIf(!cutter)
    DebugHalf(enabled=debug)
    difference() {
      union() {
        
        // Trip
        hull() {
          translate([clear,
                     disconnectorOffsetY+0.25-clear,
                     disconnectorPivotZ-0.125-clear])
          mirror([1,0,0])
          ChamferedCube([(disconnectorTripBackset),
                0.25+clear2,
                ActionRodZ()-disconnectorPivotZ+clear2], r=1/64);
          
          translate([-clear,
                     disconnectorOffsetY+0.25-clear,
                     disconnectorPivotZ-0.125-clear])
          mirror([1,0,0])
          ChamferedCube([disconnectorTripBackset+0.25+(cutter?0.125:0),
                0.25+clear2,
                0.25+clear2], r=1/64);
        }
        
        // Trip Extension
        translate([-1,
                   disconnectorOffsetY-clear,
                   disconnectorPivotZ-0.125-clear])
        ChamferedCube([1,
              (5/16)+clear2,
              0.25+clear2], r=1/64);
        
        // Prong
        translate([0,
                   disconnectorOffsetY-clear,
                   disconnectorPivotZ-0.125-clear])
        mirror([1,0,0])
        ChamferedCube([abs(disconnectorPivotX)+disconnectorLength+clear,
              0.25+clear2,
              disconnectorHeight+clear2], r=1/64);
      }
      
      if (!cutter) {
        DisconnectorPivotPin(cutter=true, clearance=0.002);
        DisconnectorSpring(cutter=true);
      
        // Trim the back edge to clear pivot
        translate([0,-ReceiverIR(),disconnectorPivotZ+0.125])
        rotate([0,-disconnectorPivotAngle,0])
        mirror([0,0,1])
        cube([1, ReceiverID(), 1]);
      }
    }
  }
}
module FireControlHousing(clearance=0.01, debug=_CUTAWAY_FIRING_PIN_HOUSING, alpha=_ALPHA_FIRING_PIN_HOUSING) {
  
  color("Chocolate", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    
    // Insert plug
    union() {
      intersection() {
          
          // Round body
          rotate([0,-90,0])
          ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/16,
                             h=FiringPinHousingLength(),
                          teardropTop=true, teardropBottom=true, $fn=80);
        
        
        // Flatten the bottom
        translate([-FiringPinHousingLength(),
                   -ReceiverIR()-ReceiverSideSlotDepth(),-0.25+clearance])
        ChamferedCube([FiringPinHousingLength(),
                       ReceiverID()+(ReceiverSideSlotDepth()*2),
                       ReceiverID()+0.25-(clearance*2)],
                      r=1/16, teardropFlip=[false,true,true]);
      }
        
      // Disconnector support
      translate([-FiringPinHousingLength(),-(0.75/2),clearance])
      ChamferedCube([0.75, 0.75, ActionRodZ()-0.125-(clearance*2)],
                     r=1/16, teardropFlip=[false,true,true]);
      
      // Wings
      hull()
      translate([0,
                 -(ReceiverIR()+ReceiverSideSlotDepth()-0.01),
                 -(ReceiverSideSlotHeight()/2)+0.01])
      mirror([1,0,0])
      ChamferedCube([FiringPinHousingLength(),
                     (ReceiverIR()+ReceiverSideSlotDepth()-0.01)*2,
                     ReceiverSideSlotHeight()-(0.01*2)],
                    r=1/16,
                    teardropXYZ=[false, true, true],
                    teardropTopXYZ=[false, true, true],
                    teardropFlip=[false, true, true]);
      }
    
    FiringPin(cutter=true);
    
    for (PF = [0,1])
    Disconnector(pivotFactor=PF, cutter=true);
    
    DisconnectorSpring(cutter=true);
    DisconnectorPivotPin(cutter=true, teardrop=true);
    
    ActionRod(cutter=true);
    
    RecoilPlateBolts(cutter=true);
  }
}

module FireControlHousing_print() {
  rotate([0,-90,0])
  translate([FiringPinHousingLength(),0,0])
  FireControlHousing(debug=false);
}



//****************
//* Printed Jigs *
//****************
module RecoilPlateJig(firingPinRadius=1/32, clearance=0.005, extend=0.125) {
  render()
  difference() {
    translate([0,-(RecoilPlateWidth()/2)-extend,-(RecoilPlateHeight()/2)-extend])
    cube([RecoilPlateLength()+extend, RecoilPlateWidth()+extend, RecoilPlateHeight()+(+extend*2)]);

    RecoilPlate(cutter=true);
    
    
    RecoilPlateBolts(bolt=BoltSpec("Template"), head="none");
    
    rotate([0,90,0])
    cylinder(r=firingPinRadius+clearance,
             h=RecoilPlateLength()+extend+ManifoldGap(2),
            $fn=8);
  }
}
//**************
//* Assemblies *
//**************
module SimpleFireControlAssembly(recoilPlate=_SHOW_RECOIL_PLATE, debug=false) {
  disconnectStart = 0.8;
  disconnectLetdown = 0.2;
  connectStart = 0.99;
  hammerChargeStart = 0.25;
  
  disconnectorTripAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.0, end=0.2)
                     - SubAnimate(ANIMATION_STEP_CHARGER_RESET,
                                  start=connectStart);
  
  disconnectorAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.99)
                 - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=connectStart, end=1);
  
  chargeAF = Animate(ANIMATION_STEP_CHARGE)
           - Animate(ANIMATION_STEP_CHARGER_RESET);

  if (_SHOW_ACTION_ROD)
  translate([-chargerTravel*chargeAF,0,0]) {
    HammerCharger(debug=_CUTAWAY_HAMMER_CHARGER);
    ActionRod();
    ActionRodBolt();
    children();
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
 
  if (_SHOW_FIRING_PIN) {
    translate([(3/32)*SubAnimate(ANIMATION_STEP_FIRE, start=0.95),0,0])
    translate([-(3/32)*SubAnimate(ANIMATION_STEP_CHARGE, start=0.07, end=0.2),0,0])
    FiringPin(cutter=false, debug=false);
    
    FiringPinSpring();
  }
  
  if (_SHOW_RECOIL_PLATE_BOLTS)
  RecoilPlateBolts();
  
  if (recoilPlate)
  RecoilPlate(debug=_CUTAWAY_RECOIL_PLATE);
  
  if (_SHOW_FIRE_CONTROL_HOUSING)
  FireControlHousing();
}



//*************
//* Rendering *
//*************
  SimpleFireControlAssembly();
  
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
if ($preview && _RENDER == "Assembly") {
  
  if (_SHOW_LOWER) {
    LowerMount();
    
    translate([-LowerMaxX(),0,LowerOffsetZ()])
    Lower(showTrigger=true, showLeft=_SHOW_LOWER_LEFT,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+abs(LowerOffsetZ()));
  }
}

scale(25.4) {
  
  if (_RENDER == "FireControlHousing")
  FireControlHousing_print();
  
  if (_RENDER == "Hammer")
  rotate([0,90,0])
  translate([-hammerCockedX,0,0])
  Hammer();
  
  
  if (_RENDER == "HammerCharger")
  rotate([0,-90,0])
  translate([0.5, 0, -ActionRodZ()])
  HammerCharger();

  if (_RENDER == "Disconnector")
  rotate([90,0,0])
  translate([-disconnectorPivotX,-disconnectorOffsetY,-disconnectorPivotZ])
  Disconnector();
  
  if (_RENDER == "RecoilPlateJig")
  RecoilPlateJig();
}
