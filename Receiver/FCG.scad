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
use <Lower/LowerMount.scad>;

use <Receiver.scad>;

/* [Print] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "FCG_Housing", "FCG_ChargingHandle", "FCG_Disconnector", "FCG_Hammer", "FCG_HammerTail", "FCG_FiringPinCollar", "FCG_RecoilPlateJig", "FCG_RecoilPlate_Projection"]

/* [Assembly] */
_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_FCG_Disconnector = true;
_SHOW_FCG_Hammer = true;
_SHOW_ACTION_ROD = true;
_SHOW_FIRING_PIN = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_RECOIL_PLATE_BOLTS = true;
_SHOW_RECEIVER      = true;
_SHOW_LOWER         = true;
_SHOW_LOWER_LEFT    = false;

_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]
_ALPHA_RECOIL_PLATE = 1; // [0:0.1:1]
_ALPHA_FCG_Hammer = 1; // [0:0.1:1]

_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_FCG_Disconnector = false;
_CUTAWAY_FCG_Hammer = false;
_CUTAWAY_FCG_Hammer_CHARGER = false;
_CUTAWAY_RECEIVER = true;
_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_FIRING_PIN = false;
_CUTAWAY_FIRING_PIN_SPRING = false;

/* [Vitamins] */
FCG_Hammer_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"] 
FCG_Hammer_BOLT_CLEARANCE = 0.015;

CHARGING_HANDLE_BOLT = "#8-32"; // ["M4", "#8-32"]
CHARGING_HANDLE_BOLT_CLEARANCE = 0.015;

ACTION_ROD_BOLT = "#8-32"; // ["M4", "#8-32"]
ACTION_ROD_BOLT_CLEARANCE = 0.015;

RECOIL_PLATE_BOLT = "#8-32"; // ["M4", "#8-32"]
RECOIL_PLATE_BOLT_CLEARANCE = 0.015;

FCG_Disconnector_SPRING_DIAMETER = 0.23;
FCG_Disconnector_SPRING_CLEARANCE = 0.005;

// Firing pin head thickness
FIRING_PIN_HEAD_THICKNESS = 0.025; // 6D Box Nail

// Firing pin diameter
FIRING_PIN_DIAMETER = 0.095; // 6D Box Nail

// Firing pin clearance
FIRING_PIN_CLEARANCE = 0.01;

// Shaft collar diameter
FIRING_PIN_BODY_DIAMETER = 0.3125;

// Shaft collar width
FIRING_PIN_BODY_LENGTH = 1;

FCG_RECOIL_PLATE_CONTOURED = true;

// Measured: Vitamins
function RecoilPlateLength() = 1/4;
function RecoilPlateWidth() = 2;
function RecoilPlateHeight() = 2.375;
function RecoilPlateTopZ() = 0.625;

function RecoilPlateBolt() = BoltSpec(RECOIL_PLATE_BOLT);
function RecoilPlateBoltOffsetY() = 0.5;


// Settings: Vitamins
function FCG_HammerBolt() = BoltSpec(FCG_Hammer_BOLT);
assert(FCG_HammerBolt(), "FCG_HammerBolt() is undefined. Unknown FCG_Hammer_BOLT?");

function FCG_ChargingHandleBolt() = BoltSpec(CHARGING_HANDLE_BOLT);
assert(FCG_ChargingHandleBolt(), "FCG_HammerBolt() is undefined. Unknown FCG_Hammer_BOLT?");

function FCG_DisconnectorTripBolt() = BoltSpec(ACTION_ROD_BOLT);
assert(FCG_DisconnectorTripBolt(), "FCG_DisconnectorTripBolt() is undefined. Unknown ACTION_ROD_BOLT?");

function RecoilPlateBolt() = BoltSpec(RECOIL_PLATE_BOLT);
assert(RecoilPlateBolt(), "RecoilPlateBolt() is undefined. Unknown RECOIL_PLATE_BOLT?");

// Settings: Lengths
function ActionRodWidth() = 0.25;
function ChamferRadius() = 1/16;
function CR() = 1/16;
chargerTravel = 2;

function FiringPinHeadThickness() = FIRING_PIN_HEAD_THICKNESS;
function FiringPinDiameter(clearance=0) = FIRING_PIN_DIAMETER+clearance;
function FiringPinRadius(clearance=0) = FiringPinDiameter(clearance)/2;

function FiringPinBodyDiameter() = FIRING_PIN_BODY_DIAMETER;
function FiringPinBodyRadius() = FiringPinBodyDiameter()/2;
function FiringPinBodyLength() = 1;

function FiringPinStickout() = 0.05;
function FiringPinTravel() = 0.09375;
function FiringPinHousingLength() = 1;
function FiringPinHousingBack() = 0.25;
function FiringPinHousingWidth() = 0.75;

function FiringPinLength() = FiringPinHousingLength()+0.5
                           + FiringPinStickout();

// Calculated: Positions
function FiringPinMinX() = -FiringPinHousingLength();
function RecoilPlateRearX()  = 0.25;

function ActionRodZ() = 0.75+(ActionRodWidth()/2);


FCG_HammerLength=2;

function FCG_HammerTailLength() = 0.625;
FCG_HammerTailMinX = -ReceiverLength();
FCG_HammerTailMaxX = FCG_HammerTailMinX-FCG_HammerTailLength();

FCG_HammerFiredX  = FiringPinMinX();
FCG_HammerCockedX = -LowerMaxX()-0.125;

FCG_HammerTravelX = abs(FCG_HammerCockedX-FCG_HammerFiredX);
FCG_HammerOvertravelX = 0.25;

FCG_DisconnectorOffsetY = -0.125;
FCG_DisconnectorOffset = 0.825;
FCG_DisconnectorPivotZ = 0.5;
FCG_DisconnectorPivotAngle=-6;
FCG_DisconnectorThickness = 0.5;
FCG_DisconnectorHeight = 0.25;
FCG_DisconnectorTripBackset = 0.1875;
disconnectDistance = 0.125;
FCG_DisconnectorExtension = 0;
FCG_DisconnectorPivotX = -FCG_DisconnectorOffset;
FCG_DisconnectorLength = abs(FCG_HammerCockedX-FCG_DisconnectorPivotX)
                   + disconnectDistance
                   + FCG_DisconnectorExtension;

FCG_DisconnectorSpringY = FCG_DisconnectorOffsetY
                        + FCG_Disconnector_SPRING_DIAMETER
                        + (1/16);

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
  translate([-0.5,0,ActionRodZ()])
  DebugHalf(enabled=debug)
  translate([0,-(ActionRodWidth()/2)-clear,-(ActionRodWidth()/2)-clear])
  cube([length, ActionRodWidth()+clear2, ActionRodWidth()+clear2]);
}
module FCG_DisconnectorTripBolt(debug=false, cutter=false, teardrop=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([-0.3125,
             -(ActionRodWidth()/2),
             ActionRodZ()])
  rotate([-90,0,0])
  NutAndBolt(bolt=FCG_DisconnectorTripBolt(), boltLength=0.25,
             head="socket",
             clearance=clear, teardrop=cutter);
}
module FCG_DisconnectorPivotPin(debug=false, cutter=false, teardrop=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([FCG_DisconnectorPivotX, 0, FCG_DisconnectorPivotZ])
  rotate([90,0,0])
  linear_extrude(height=cutter?ReceiverID():ReceiverTopSlotWidth(), center=true)
  Teardrop(r=(3/32/2)+clear, enabled=teardrop, $fn=20);
}
module FCG_DisconnectorSpring(debug=false, cutter=false, clearance=FCG_Disconnector_SPRING_CLEARANCE) {
  color("SteelBlue")
  RenderIf(!cutter)
  translate([-(3/16),
             FCG_DisconnectorSpringY,
             FCG_DisconnectorPivotZ-0.125-0.125])
  ChamferedCylinder(r1=(FCG_Disconnector_SPRING_DIAMETER/2)+(cutter?clearance:0), r2=1/32, h=0.3125);
}
module FCG_HammerBolt(clearance=0.01, cutter=false, debug=false) {
  color("Silver") RenderIf(!cutter)
  translate([FCG_HammerCockedX+ManifoldGap(),0,0])
  rotate([0,90,0])
  NutAndBolt(bolt=FCG_HammerBolt(), boltLength=4.5+ManifoldGap(2),
             head="flat", nut="heatset", nutBackset=3.25, nutHeightExtra=(cutter?1:0),
             capOrientation=true,
             clearance=(cutter?clearance:0));
}
module FiringPin(radius=FiringPinRadius(), cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  radius = template ? 1/16 : radius;

  if (!template) {
    color("Silver")
    RenderIf(!cutter)
    DebugHalf(enabled=debug)
    translate([-FiringPinHousingLength()-FiringPinTravel(),0,0])
    rotate([0,90,0])
    union() {
      
      // Pin
      cylinder(r=radius+clear,
               h=FiringPinLength()
                +(cutter?FiringPinTravel():0)+ManifoldGap());
      
      // Head
      cylinder(r=(0.3/2)+clear,
               h=0.025);
    }
  } else {
    rotate([0,-90,0])
    cylinder(r=1/16/2);
  }
}

module FiringPinSpring(cutter=false, clearance=0.005, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("SteelBlue")
  DebugHalf(enabled=debug)
  translate([-0.25,0,0])
  rotate([0,90,0])
  cylinder(r=(0.22/2)+clear,
           h=0.5);
  
  if (cutter)
  translate([-0.25,0,0])
  rotate([0,-90,0])
  cylinder(r1=(0.22/2)+clear, r2=FiringPinRadius(),
           h=(0.22/2)+clear);
}



module RecoilPlateBolts(bolt=RecoilPlateBolt(), boltLength=1.5, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  bolt     = template ? BoltSpec("Template") : bolt;
  boltHead = template ? "none"               : "flat";
  
  color("Silver")
  RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  translate([0.5+ManifoldGap(),RecoilPlateBoltOffsetY(),0])
  rotate([0,-90,0])
  Bolt(bolt=bolt, length=1.5+ManifoldGap(2),
        head=boltHead, capHeightExtra=(cutter?1:0),
        clearance=cutter?clearance:0);
  
  color("Silver") RenderIf(!cutter)
  translate([0.5,0,0])
  TensionBoltIterator()
  NutAndBolt(bolt=bolt,
             boltLength=0.5+ManifoldGap(2),
             head="flat",
             nut="none",
             clearance=cutter?clearance:0);
}

module RecoilPlate(spindleZ=-1, contoured=true, cutter=false, debug=false, alpha=1, clearance=0.005, template=false, templateHoleDiameter=0.08) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  TemplateHoles = [
    [0, 0, 0], // Firing Pin
    [0, 0, spindleZ], // ZZR Spindle
  
    // Recoil plate bolts
    [0, RecoilPlateBoltOffsetY(), 0],
    [0, -RecoilPlateBoltOffsetY(), 0],
  
    // Tension rod bolts
    [0, TensionRodTopOffsetSide(),TensionRodTopZ()],
    [0, -TensionRodTopOffsetSide(),TensionRodTopZ()],
    [0, TensionRodBottomOffsetSide(),TensionRodBottomZ()],
    [0, -TensionRodBottomOffsetSide(),TensionRodBottomZ()]
  ];
  
  
  color("LightSteelBlue", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    
    // Contoured or simplified (rectangular) plate
    if (contoured) {
      translate([0.5-RecoilPlateLength(),0,0])
      rotate([0,90,0])
      linear_extrude(RecoilPlateLength(), center=false)
      offset(r=(cutter?clearance:0))
      hull() {
        projection()
        rotate([0,-90,0])
        ReceiverSegment(highTop=false);
      
        // 12ga cylinder spindle support
        translate([1,0])
        circle(r=0.375+clear2);
      }
    } else {
      translate([0.5-RecoilPlateLength(),-1-clear,ReceiverBottomZ()-0.25-clear])
      cube([RecoilPlateLength(),
            RecoilPlateWidth()+clear2,
            RecoilPlateHeight()+clear2]);
    }
      
    hull() for (Y = [0,-0.25, 0.25]) translate([0,Y,(cutter?clear:0)])
    ActionRod(cutter=!cutter);
    
    if (template) {
      for (Hole = TemplateHoles)
      translate([0.5-RecoilPlateLength()-clear,Hole.y,Hole.z])
      rotate([0,90,0])
      cylinder(r=templateHoleDiameter/2, h=RecoilPlateLength(), $fn=8);
      
    } else if (!cutter) {
      FiringPin(cutter=true);
      RecoilPlateBolts(cutter=true);
      
      // ZZR cylinder spindle
      translate([0,0,-1])
      rotate([0,-90,0])
      cylinder(r=5/16/2, h=RecoilPlateLength());
    }
  }
}

module FCG_ChargingHandleBolt(bolt=FCG_ChargingHandleBolt(), boltLength=0.25, cutter=false, clearance=CHARGING_HANDLE_BOLT_CLEARANCE) {
  color("Silver")
  RenderIf(!cutter)
  translate([-0.75,-0.25,ReceiverTopSlotHeight()])
  mirror([0,0,1])
  NutAndBolt(bolt=bolt, boltLength=boltLength+ManifoldGap(2),
        head="socket", nut="heatset",
        clearance=cutter?clearance:0);
  
  color("Silver")
  RenderIf(!cutter)
  translate([-ReceiverLength()+(ReceiverBackLength()/2),
             1-0.25,
             ReceiverTopSlotHeight()-ReceiverTopSlotHorizontalHeight()])
  NutAndBolt(bolt=bolt, boltLength=boltLength+ManifoldGap(2),
        head="socket", nut="heatset",
        clearance=cutter?clearance:0);
}


module FCG_ChargingHandleSpring(cutter=false, clearance=0.002) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("SteelBlue")
  translate([-ReceiverLength(),
             0,//(ReceiverTopSlotHorizontalWidth()/2)-0.125,
             ReceiverIR()-0.125])
  rotate([0,90,0])
  cylinder(r=(0.22/2)+clear, h=1.625);
}
//*****************
//* Printed Parts *
//*****************
module FCG_FiringPinCollar(cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  flareRadius = FiringPinBodyRadius()+(1/16);
  
  color("Olive")
  RenderIf(!cutter)
  DebugHalf(enabled=debug)
  difference() {
    
    union() {
      
      // Body
      translate([-FiringPinHousingLength()-FiringPinTravel()+0.025,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=FiringPinBodyRadius()+clear, r2=1/32,
               h=FiringPinBodyLength() -0.025
                + (cutter?0.25+FiringPinTravel():0)
                + ManifoldGap());
      
      // Flare
      intersection() {
        union() {
          translate([-FiringPinTravel()-(1/8),0,0])
          rotate([0,-90,0])
          cylinder(r1=flareRadius+clear, r2=FiringPinBodyRadius()+clear,
                   h=(1/8));
          
          // Flare travel cutter
          translate([-FiringPinTravel()-(1/8),0,0])
          rotate([0,90,0])
          cylinder(r=flareRadius+clear,
                   h=(cutter?(1/4):0.125+ManifoldGap(2)));
        }
        
        // Square it off
        translate([0,-flareRadius-clear,-FiringPinBodyRadius()-clear])
        mirror([1,0,0])
        cube([(1/8)+(1/8)+FiringPinTravel()+ManifoldGap(),
              (flareRadius*2)+clear2,
              (FiringPinBodyRadius()*2)+clear2]);
      }
    }
    
    if (!cutter) {
      FiringPinSpring(cutter=true);
      FiringPin(cutter=true, clearance=0.004);
    }
  } 
}
module FCG_ChargingHandle(clearance=0.005) {
  clear = clearance;
  clear2 = clear*2;
  
  width = ReceiverTopSlotHorizontalWidth();
  
  rearExtension = 1.5;
  bottomZ = ReceiverTopSlotHeight()
          - ReceiverTopSlotHorizontalHeight();
  prongWidth = (ReceiverTopSlotHorizontalWidth()-ReceiverTopSlotWidth()-clear2)/2;
  fingerHoleDiameter = rearExtension-0.375;
  fingerHoleRadius = fingerHoleDiameter/2;
  fingerHoleHeight = min(ReceiverTopZ()
                   - ReceiverTopSlotHeight()
                   + ReceiverTopSlotHorizontalHeight(), 0.625);
  fingerHoleX = -ReceiverLength()-(rearExtension/2);
  rearLength = (rearExtension/2) + ReceiverLength();
  
  color("Olive") render()
  difference() {
    union() {
      
      // Solid section
      translate([fingerHoleX,-(width/2)+clear,bottomZ+clear])
      ChamferedCube([rearLength, 
                     width-clear2,
                     ReceiverTopSlotHorizontalHeight()-clear2], r=1/32);
      
      // Extended finger section
      translate([fingerHoleX,0,bottomZ+clear])
      ChamferedCylinder(r1=rearExtension/2,
                        r2=1/32,
                        h=fingerHoleHeight-clear2, $fn=50);
    }
    
    *hull() for (Z = [0,0.25])
    translate([-ReceiverLength()+0.25,0,bottomZ+(0.22/2)+Z])
    rotate([0,90,0])
    cylinder(r=0.22/2, h=ReceiverLength()-0.5);
    
    *translate([-ReceiverLength()+0.25,-(0.25/2)-clearance,bottomZ+clear])
    ChamferedSquareHole([FCG_HammerTravelX+0.5, 0.25+(clearance*2)],
                          ReceiverTopSlotHorizontalHeight()-clear2,
                          corners=false, center=false, chamferRadius=1/32);
    
    translate([fingerHoleX,0,bottomZ+clear])
    ChamferedCircularHole(r1=fingerHoleRadius, r2=1/16,
                          h=fingerHoleHeight-clear2, $fn=50);
    
    FCG_ChargingHandleSpring(cutter=true);
    
    FCG_ChargingHandleBolt(cutter=true);
  }
}

module FCG_ChargingHandleMiddle(clearance=0.005) {
  clear = clearance;
  clear2 = clear*2;
  
  width = ReceiverTopSlotHorizontalWidth();
  
  rearExtension = ReceiverTopSlotHorizontalWidth();
  bottomZ = ReceiverTopSlotHeight()
          - ReceiverTopSlotHorizontalHeight();
  prongWidth = (ReceiverTopSlotHorizontalWidth()-ReceiverTopSlotWidth()-clear2)/2;
  fingerHoleDiameter = ReceiverTopSlotHorizontalWidth()-0.25;
  fingerHoleRadius = fingerHoleDiameter/2;
  fingerHoleHeight = min(ReceiverTopZ()
                   - ReceiverTopSlotHeight()
                   + ReceiverTopSlotHorizontalHeight(), 0.375);
  fingerHoleX = -ReceiverLength()-(rearExtension/2);
  rearLength = (rearExtension/2) + ReceiverLength();
  
  color("Olive") render()
  difference() {
    
    // Solid section
    translate([fingerHoleX,-(width/2)+clear,bottomZ+clear])
    ChamferedCube([rearLength, 
                   width-clear2,
                   ReceiverTopSlotHorizontalHeight()-clear2], r=1/32);
    
    
    hull() for (Z = [0,0.25])
    translate([-ReceiverLength()+0.25,0,bottomZ+(0.22/2)+Z])
    rotate([0,90,0])
    cylinder(r=0.22/2, h=ReceiverLength()-0.5);
    
    translate([-ReceiverLength()+0.25,-(0.25/2)-clearance,bottomZ+clear])
    ChamferedSquareHole([FCG_HammerTravelX+0.5, 0.25+(clearance*2)],
                          ReceiverTopSlotHorizontalHeight()-clear2,
                          corners=false, center=false, chamferRadius=1/32);
    
    translate([fingerHoleX,0,bottomZ+clear])
    ChamferedCircularHole(r1=fingerHoleRadius, r2=1/16, h=fingerHoleHeight-clear2);
    
  }
}

module FCG_Hammer(cutter=false, clearance=UnitsImperial(0.01), debug=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Head
  color("Olive", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      
      // Body
      translate([FCG_HammerCockedX,0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/8,
                         h=FCG_HammerLength,
                       teardropTop=true, teardropBottom=true, $fn=80);
      
      // Charging Tip
      hull()
      for (XYZ = [[0.125, ReceiverTopSlotWidth(), ActionRodZ()+0.125-0.25],
                  [ActionRodZ(), ReceiverTopSlotWidth(), 0.25-(1/8)]])
      translate([FCG_HammerCockedX, -(XYZ.y/2)+clearance, 0.25+clearance])
      mirror([1,0,0])
      ChamferedCube([XYZ.x, XYZ.y-(clearance*2), XYZ.z-(clearance*2)],
                     r=1/32, teardropFlip=[false,true,true]);
      
      // Wings
      translate([FCG_HammerCockedX,
                 -(ReceiverIR()+ReceiverSideSlotDepth()-clearance),
                 -(ReceiverSideSlotHeight()/2)+clearance])
      mirror([1,0,0])
      ChamferedCube([FCG_HammerLength,
                     (ReceiverIR()+ReceiverSideSlotDepth()-clearance)*2,
                     ReceiverSideSlotHeight()-(clearance*2)],
                    r=1/16,teardropFlip=[true, true, true]);
    }
    
    // Trigger Slot
    translate([FCG_HammerCockedX+0.125,-0.375/2,-BoltFlatHeadRadius(FCG_HammerBolt())])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([FCG_HammerLength+0.25, 0.375, ReceiverIR()], r=1/32);
    
    // Main Spring Hole
    translate([FCG_HammerCockedX-FCG_HammerLength,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=0.65/2, r2=1/16, chamferTop=false,
                          h=11/16, $fn=40);
    
    // Disconnector chamfered hole
    translate([FCG_HammerCockedX,0,FCG_DisconnectorPivotZ])
    rotate([0,-90,0])
    ChamferedSquareHole(sides=[FCG_DisconnectorHeight+(clearance*2),
                               FCG_DisconnectorHeight+(clearance*2)],
                        length=FCG_DisconnectorLength, chamferRadius=1/16,
                        center=true, corners=false, chamferTop=false);
    
    
    translate([-FCG_HammerTravelX,0,0])
    FCG_Disconnector(cutter=true, debug=false);
    
    FCG_HammerBolt(cutter=true);
  }
}


module FCG_HammerTail(clearance=UnitsImperial(0.01), debug=false, alpha=1) {
  color("Chocolate", alpha)
  render() DebugHalf(enabled=debug)
  difference() {
    union() {
      intersection() {
      
        // Body
        translate([FCG_HammerTailMinX,0,0])   
        rotate([0,90,0])
        ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/8,
                           h=FCG_HammerTailLength(),
                          teardropTop=true, teardropBottom=true, $fn=80);
    
        // Only the top half
        translate([FCG_HammerTailMinX,-(ReceiverIR()), 0])
        cube([FCG_HammerTailLength(), ReceiverID(),ReceiverIR()]);
      }
      
      // Top Stop
      translate([FCG_HammerTailMinX,
                 -((ReceiverTopSlotWidth()/2)-clearance),
                 0])
      ChamferedCube([FCG_HammerTailLength(),
                     (ReceiverTopSlotWidth()-(clearance*2)),
                     ReceiverTopSlotHeight()-ReceiverTopSlotHorizontalHeight()-clearance],
                    r=1/16, teardropFlip=[true, true, true]);
      
      // Wings
      translate([FCG_HammerTailMinX,
                 -(ReceiverIR()+ReceiverSideSlotDepth()-clearance),
                 -(ReceiverSideSlotHeight()/2)+clearance])
      ChamferedCube([FCG_HammerTailLength(),
                     (ReceiverIR()+ReceiverSideSlotDepth()-clearance)*2,
                     ReceiverSideSlotHeight()-(clearance*2)],
                    r=1/16,teardropFlip=[true, true, true]);
    }
    
    // Hammer Bolt Hole
    translate([FCG_HammerTailMinX,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=0.28/2, r2=1/32, $fn=40,
                          h=FCG_HammerTailLength());
    
    // Main Spring Hole
    translate([FCG_HammerTailMinX+FCG_HammerTailLength(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=0.65/2, r2=1/16, chamferTop=false,
                          h=0.125, $fn=40);
  }
}
module FCG_Disconnector(pivotFactor=0, cutter=false, clearance=0.005, alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  Pivot(factor=pivotFactor,
        pivotX=FCG_DisconnectorPivotX,
        pivotZ=FCG_DisconnectorPivotZ,
        angle=FCG_DisconnectorPivotAngle) {
          
    children();
    
    color("Olive", alpha)
    RenderIf(!cutter)
    DebugHalf(enabled=debug)
    difference() {
      union() {
        
        // Trip
        hull() {
          
          // Peak
          translate([(cutter?(1/64):-FCG_DisconnectorTripBackset+clear),
                     FCG_DisconnectorOffsetY+0.25-clear,
                     FCG_DisconnectorPivotZ-0.125-clear])
          mirror([1,0,0])
          ChamferedCube([(cutter?FCG_DisconnectorTripBackset+clear2:(1/16)),
                0.25+clear2,
                ActionRodZ()-FCG_DisconnectorPivotZ+clear2],
          r=1/64);
          
          // Base
          translate([clear,
                     FCG_DisconnectorOffsetY+0.25-clear,
                     FCG_DisconnectorPivotZ-0.125-clear])
          mirror([1,0,0])
          ChamferedCube([0.375+clear2,
                0.25+clear2,
                0.25+clear2], r=1/64);
        }
        
        // Pivot Extension
        translate([-1,
                   FCG_DisconnectorOffsetY-clear,
                   FCG_DisconnectorPivotZ-0.125-clear])
        ChamferedCube([1+(cutter?(1/16):0),
              (5/16)+clear2,
              0.25+clear2], r=1/64);
        
        // Hammer Stop Prong
        translate([clear,
                   FCG_DisconnectorOffsetY-clear,
                   FCG_DisconnectorPivotZ-0.125-clear])
        mirror([1,0,0])
        ChamferedCube([abs(FCG_DisconnectorPivotX)+FCG_DisconnectorLength+clear2,
              0.25+clear2,
              FCG_DisconnectorHeight+clear2], r=1/64);
      }
      
      if (!cutter) {
        FCG_DisconnectorPivotPin(cutter=true, clearance=0.002);
        FCG_DisconnectorSpring(cutter=true);
      
        // Trim the back edge to clear pivot
        translate([0,-ReceiverIR(),FCG_DisconnectorPivotZ+0.125])
        rotate([0,-FCG_DisconnectorPivotAngle,0])
        mirror([0,0,1])
        cube([1, ReceiverID(), 1]);
      }
    }
  }
}
module FCG_Housing(clearance=0.01, debug=false, alpha=1) {
  
  color("Chocolate", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    
    // Insert plug
    union() {
        
      // FCG_Disconnector support
      translate([-FiringPinHousingLength(),-(0.75/2),clearance])
      ChamferedCube([FiringPinHousingLength()/*0.625*/, 0.75, ActionRodZ()-0.125-(clearance*2)],
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
    
    // Firing pin hole chamfer
    translate([-FiringPinHousingLength(),0,0])
    rotate([0,90,0])
    HoleChamfer(r1=FiringPinBodyRadius()+FIRING_PIN_CLEARANCE,
                 r2=1/32, teardrop=true);
    
    // Disconnector spring access
    translate([0.125,
               FCG_DisconnectorSpringY-(FCG_Disconnector_SPRING_DIAMETER/2)-0.005,
               FCG_DisconnectorPivotZ-0.125-0.125])
    mirror([1,0,0])
    ChamferedCube([0.3125, FCG_Disconnector_SPRING_DIAMETER+0.01, 0.25], r=1/32);
    
    FiringPin(cutter=true);
    FCG_FiringPinCollar(cutter=true);
    
    for (PF = [0,1])
    FCG_Disconnector(pivotFactor=PF, cutter=true);
    
    FCG_DisconnectorSpring(cutter=true);
    FCG_DisconnectorPivotPin(cutter=true, teardrop=true);
    
    ActionRod(cutter=true);
    
    RecoilPlateBolts(cutter=true);
  }
}

module FCG_Housing_print() {
  rotate([0,-90,0])
  translate([FiringPinHousingLength(),0,0])
  FCG_Housing(debug=false);
}



//****************
//* Printed Jigs *
//****************
module FCG_RecoilPlateJig(firingPinRadius=1/32, clearance=0.005, extend=0.125) {
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
module SimpleFireControlAssembly(actionRod=_SHOW_ACTION_ROD, recoilPlate=_SHOW_RECOIL_PLATE, debug=false) {
  disconnectStart = 0.8;
  disconnectLetdown = 0.2;
  connectStart = 0.99;
  FCG_HammerChargeStart = 0.25;
  
  FCG_DisconnectorTripAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.0, end=0.2)
                     - SubAnimate(ANIMATION_STEP_CHARGER_RESET,
                                  start=connectStart);
  
  FCG_DisconnectorAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.99)
                 - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=connectStart, end=1);
  
  chargeAF = Animate(ANIMATION_STEP_CHARGE)
           - Animate(ANIMATION_STEP_CHARGER_RESET);

  *FCG_ChargingHandleSpring();

  translate([SubAnimate(ANIMATION_STEP_CHARGE, start=FCG_HammerChargeStart)*-(FCG_HammerTravelX+FCG_HammerOvertravelX),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET)*(FCG_HammerTravelX+FCG_HammerOvertravelX),0,0]) {
    FCG_ChargingHandle();
    FCG_ChargingHandleBolt();
  }

  if (actionRod)
  translate([-chargerTravel*chargeAF,0,0]) {
    ActionRod();
    FCG_DisconnectorTripBolt();
    children();
  }
  
  FCG_DisconnectorSpring();
  
  FCG_DisconnectorPivotPin();
  
  if (_SHOW_FCG_Disconnector)
  FCG_Disconnector(pivotFactor=FCG_DisconnectorAF);
  
  // Linear FCG_Hammer
  if (_SHOW_FCG_Hammer) {
  
    translate([Animate(ANIMATION_STEP_FIRE)*FCG_HammerTravelX,0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGE, start=FCG_HammerChargeStart)*-(FCG_HammerTravelX+FCG_HammerOvertravelX),0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1)*(FCG_HammerOvertravelX-disconnectDistance),0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.97, end=1)*disconnectDistance,0,0]) {
      FCG_HammerBolt();
      FCG_Hammer(debug=_CUTAWAY_FCG_Hammer, alpha=_ALPHA_FCG_Hammer);
    }
  }
 
  if (_SHOW_FIRING_PIN) {
    translate([(3/32)*SubAnimate(ANIMATION_STEP_FIRE, start=0.95),0,0])
    translate([-(3/32)*SubAnimate(ANIMATION_STEP_CHARGE, start=0.07, end=0.2),0,0]) {
      FiringPin(debug=_CUTAWAY_FIRING_PIN);
      FCG_FiringPinCollar(debug=_CUTAWAY_FIRING_PIN);
    }
    
    FiringPinSpring();
  }
  
  FCG_HammerTail(debug=_CUTAWAY_FCG_Hammer, alpha=_ALPHA_FCG_Hammer);
  
  if (_SHOW_RECOIL_PLATE_BOLTS)
  RecoilPlateBolts();
  
  if (_SHOW_FIRE_CONTROL_HOUSING)
  FCG_Housing(alpha=_ALPHA_FIRING_PIN_HOUSING, debug=_CUTAWAY_FIRING_PIN_HOUSING);
  
  if (recoilPlate)
  RecoilPlate(contoured=FCG_RECOIL_PLATE_CONTOURED, debug=_CUTAWAY_RECOIL_PLATE, alpha=_ALPHA_RECOIL_PLATE);
}



//*************
//* Rendering *
//*************
scale(25.4)
if ($preview) {
  if (_SHOW_LOWER) {
    LowerMount();
    
    translate([-LowerMaxX(),0,LowerOffsetZ()])
    Lower(showTrigger=true, showLeft=_SHOW_LOWER_LEFT,
          showReceiverLugBolts=true, showGuardBolt=true, showHandleBolts=true,
          searLength=SearLength()+abs(LowerOffsetZ()));
  }
  
  SimpleFireControlAssembly();
  
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
} else {
  
  if (_RENDER == "FCG_Housing")
  FCG_Housing_print();
  
  if (_RENDER == "FCG_Hammer")
  rotate([0,-90,0])
  translate([FCG_HammerLength-FCG_HammerCockedX,0,0])
  FCG_Hammer();
  
  if (_RENDER == "FCG_HammerTail")
  rotate([0,-90,0])
  translate([-FCG_HammerTailMinX,0,0])
  FCG_HammerTail();
  
  if (_RENDER == "FCG_ChargingHandle")
  translate([ReceiverLength(),0,-ReceiverTopSlotHeight()+ReceiverTopSlotHorizontalHeight()])
  FCG_ChargingHandle();
  
  if (_RENDER == "FCG_Disconnector")
  rotate([90,0,0])
  translate([-FCG_DisconnectorPivotX,-FCG_DisconnectorOffsetY,-FCG_DisconnectorPivotZ])
  FCG_Disconnector();
  
  if (_RENDER == "FCG_FiringPinCollar")
  rotate([0,90,0])
  translate([FiringPinTravel(),0,0])
  FCG_FiringPinCollar();
  
  if (_RENDER == "FCG_RecoilPlateJig")
  RecoilPlateJig();
  
  if (_RENDER == "FCG_Receiver_Projection")
  projection()
  rotate([0,90,0])
  difference() {
    ReceiverSegment(highTop=false);
    
    translate([-0.5,0,0])
    ReceiverBottomSlot(length=ReceiverLength()-0.5, chamferBottom=false);
    ReceiverRoundSlot();
    ReceiverSideSlot();
    
    TensionBolts(cutter=true, bolt=Spec_BoltTemplate());
    
    FiringPin(template=template, cutter=true);
    RecoilPlateBolts(template=template, cutter=true);
    Revolver_CylinderSpindle(template=template, cutter=true);
  }
  
  if (_RENDER == "FCG_RecoilPlate_Projection")
  projection() rotate([0,90,0])
  RecoilPlate(template=true);
}