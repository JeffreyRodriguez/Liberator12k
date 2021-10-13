include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Teardrop.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Components/Pivot.scad>;

use <../Vitamins/Bearing.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <Lower.scad>;
use <Receiver.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "FCG_Housing", "FCG_ChargingHandle", "FCG_Disconnector", "FCG_Hammer", "FCG_HammerTail", "FCG_FiringPinCollar", "FCG_TriggerLeft", "FCG_TriggerRight", "FCG_TriggerMiddle", "FCG_RecoilPlate_Fixture", "FCG_RecoilPlate_GangFixture", "FCG_RecoilPlate_TapGuide", "FCG_RecoilPlate_Projection", "FCG_SearJig"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_TRIGGER_LEFT = true;
_SHOW_TRIGGER_RIGHT = true;
_SHOW_TRIGGER_MIDDLE = true;
_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_FCG_Disconnector = true;
_SHOW_FCG_Hammer = true;
_SHOW_CHARGING_HANDLE = true;
_SHOW_HAMMER_TAIL = true;
_SHOW_ACTION_ROD = true;
_SHOW_FIRING_PIN = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_RECOIL_PLATE_BOLTS = true;
_SHOW_RECEIVER      = true;
_SHOW_LOWER         = true;

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

HAMMER_BOLT_SLEEVE_DIAMETER = 0.28125;
HAMMER_BOLT_SLEEVE_CLEARANCE = 0.01;

HAMMER_BOLT_HEAD = "flat"; // ["flat", "hex", "socket"]
HAMMER_BOLT_NUT = "heatset"; // ["heatset", "none"]

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

SEAR_WIDTH = 0.2501; // TODO: Allow picking metric version? 0.23622in or 6mm?
SEAR_CLEARANCE = 0.005;
SEAR_PIN_DIAMETER = 0.09375;
SEAR_PIN_CLEARANCE = 0.01;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

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

function FiringPinSpringDiameter() = 0.22;
function FiringPinSpringRadius() = FiringPinSpringDiameter()/2;

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
FCG_HammerCockedX = -(1.6+0.5)-0.125;

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



// Shorthand: Measurements
function SearDiameter(clearance=0) = SEAR_WIDTH+(clearance*2);
function SearRadius(clearance=0)   = SearDiameter(clearance)/2;

function SearPinDiameter(clearance=0) = SEAR_PIN_DIAMETER+(clearance*2);
function SearPinRadius(clearance=0) = SearPinDiameter(clearance)/2;

function SearSpringCompressed() = 0.3;

function SearPinOffsetZ() = -0.25-SearPinRadius();
function SearBottomOffset() = 0.25;



function TriggerFingerDiameter() = 1;
function TriggerFingerRadius() = TriggerFingerDiameter()/2;

function TriggerFingerOffsetZ() = GripCeilingZ();
function TriggerFingerWall() = 0.3;

function TriggerHeight() = GripCeiling()+TriggerFingerDiameter();
function TriggerWidth() = 0.50;
function SearTravel() = 0.25;
function TriggerTravel() = SearTravel()*1.5;
function SearLength() = 1.67188;// abs(SearPinOffsetZ()) + SearTravel();

function TriggerAnimationFactor() = SubAnimate(ANIMATION_STEP_TRIGGER)-SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1);




function FCG_RecoilPlateHoles(spindleZ=-1) = [
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
  
//$t= AnimationDebug(ANIMATION_STEP_CHARGE);
//$t= AnimationDebug(ANIMATION_STEP_CHARGER_RESET, start=0.85);

//**********
//* Shapes *
//**********
module TriggerSearPinTrack() {
  translate([0,SearPinOffsetZ()])
  hull() {
    circle(r=SearPinRadius(SEAR_PIN_CLEARANCE));

    translate([TriggerTravel(), -SearTravel()])
    circle(r=SearPinRadius(SEAR_PIN_CLEARANCE));
  }
}

module TriggerSideCutter(clearance=0) {
  translate([ReceiverLugRearMinX(),ManifoldGap()])
  mirror([0,1])
  square([ReceiverLugFrontMaxX()+abs(ReceiverLugRearMinX()),
          TriggerHeight()+ManifoldGap(2)]);
}
//

module Trigger2d() {
  triggerFront = 0.5;
  triggerBack = abs(ReceiverLugRearMinX())-TriggerTravel()-0.01;
  triggerLength = TriggerTravel()+SearDiameter()+triggerFront+triggerBack;
  triggerHeight = TriggerHeight()-0.01;

  render()
  difference() {

    // Trigger Body
    translate([-triggerBack,0])
    mirror([0,1])
    square([triggerLength,triggerHeight-0.01]);

    TriggerSearPinTrack();

    // Finger curve
    translate([TriggerFingerRadius()+TriggerTravel()+SearDiameter()+triggerFront-0.15,
             -GripCeiling()-TriggerFingerRadius()])
    circle(r=TriggerFingerRadius(), $fn=Resolution(16,30));


    // Retainer cutout
    translate([-triggerBack,ReceiverLugRearZ()-0.375])
    square([ReceiverLugRearLength(),
            abs(ReceiverLugRearZ())+0.375]);

    // Clearance for the receiver lugs
    translate([LowerMaxX(),-LowerOffsetZ()])
    projection(cut=true)
    rotate([-90,0,0]) {
      ReceiverLugFront(cutter=true);

      for (x=[0, TriggerTravel()])
      translate([x,0,0])
      ReceiverLugRear(cutter=true, hole=false);
    }
  }
}
//

//************
//* Vitamins *
//************
module ActionRod(length=10, debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Action Rod
  color("Silver")
  translate([-0.5,0,ActionRodZ()])
  DebugHalf(debug)
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
  Teardrop(r=(3/32/2)+clear, enabled=teardrop);
}
module FCG_DisconnectorSpring(debug=false, cutter=false, clearance=FCG_Disconnector_SPRING_CLEARANCE) {
  color("SteelBlue")
  RenderIf(!cutter)
  translate([-(3/16),
             FCG_DisconnectorSpringY,
             FCG_DisconnectorPivotZ-0.125-0.125])
  ChamferedCylinder(r1=(FCG_Disconnector_SPRING_DIAMETER/2)+(cutter?clearance:0), r2=1/32, h=0.3125);
}
module FCG_HammerBolt(clearance=FCG_Hammer_BOLT_CLEARANCE, head=HAMMER_BOLT_HEAD, nut=HAMMER_BOLT_NUT, cutter=false, debug=false) {
  boltHeadAdjustment = head == "hex"    ? BoltHexHeight(FCG_HammerBolt())
                     : head == "socket" ? BoltSocketCapHeight(FCG_HammerBolt())
                     : 0;
  
  translate([FCG_HammerCockedX+ManifoldGap()
             -boltHeadAdjustment,0,0])
  rotate([0,90,0])
  rotate(30)
  NutAndBolt(bolt=FCG_HammerBolt(), boltLength=4.5+ManifoldGap(2),
             head=head, nut=nut,
             nutBackset=3.25+boltHeadAdjustment,
             nutHeightExtra=(cutter?1:0),
             capOrientation=true,
             clearance=(cutter?clearance:0),
             doRender=!cutter);
}
module Sear(animationFactor=0, length=SearLength(), cutter=false, clearance=SEAR_CLEARANCE) {
  clear = cutter ? clearance : 0;
  
  translate([0,0,-SearTravel()*animationFactor]) {
    
    color("Silver") RenderIf(!cutter)
    difference() {
      translate([-LowerMaxX(),0, LowerOffsetZ()])
      translate([-SearRadius(clear),-SearRadius(clear),SearPinOffsetZ()-SearBottomOffset()-(cutter?SearTravel()+SearSpringCompressed():0)])
      cube([SearDiameter(clear), SearDiameter(clear), length]);
      
      if (!cutter)
      SearPin(cutter=true);
    }
    
    children();
  }
}
module SearPin(cutter=false, clearance=SEAR_PIN_CLEARANCE) {
  clear = cutter ? clearance : 0;
  
  translate([-LowerMaxX(),0, LowerOffsetZ()])
  translate([0,0,SearPinOffsetZ()])
  rotate([90,0,0])
  color("SteelBlue") RenderIf(!cutter)
  cylinder(r=SearPinRadius(clear), h=0.5, center=true);
}


module FiringPin(radius=FiringPinRadius(), cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  radius = template ? 1/16 : radius;

  if (!template) {
    color("Silver")
    RenderIf(!cutter)
    DebugHalf(debug)
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
  DebugHalf(debug)
  translate([-0.25,0,0])
  rotate([0,90,0])
  cylinder(r=FiringPinSpringRadius()+clear,
           h=0.5);
  
  if (cutter)
  translate([-0.25,0,0])
  rotate([0,-90,0])
  cylinder(r1=(0.22/2)+clear, r2=FiringPinRadius(),
           h=(0.22/2)+clear);
}

module RecoilPlateBolts(bolt=RecoilPlateBolt(), boltLength=1.5, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  RecoilPlateCenterBolts(bolt=bolt, boltLength=boltLength,
                         template=template, cutter=cutter, clearance=clearance);
  RecoilPlateSideBolts(bolt=bolt, boltLength=boltLength,
                         template=template, cutter=cutter, clearance=clearance);
}
module RecoilPlateCenterBolts(bolt=RecoilPlateBolt(), boltLength=1.5, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  bolt     = template ? BoltSpec("Template") : bolt;
  boltHead = template ? "none"               : "flat";
  
  color("Silver")
  RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  translate([0.5+ManifoldGap(),RecoilPlateBoltOffsetY(),0]) {
    rotate([0,-90,0])
    Bolt(bolt=bolt, length=boltLength+ManifoldGap(2),
          head=boltHead, capHeightExtra=(cutter?1:0),
          clearance=cutter?clearance:0);
          
    children();
  }
}

module RecoilPlateSideBolts(bolt=RecoilPlateBolt(), boltLength=1.5, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  bolt     = template ? BoltSpec("Template") : bolt;
  boltHead = template ? "none"               : "flat";
  
  color("Silver") RenderIf(!cutter)
  translate([0.5,0,0])
  TensionBoltIterator()
  NutAndBolt(bolt=bolt,
             boltLength=0.5+ManifoldGap(2),
             head="flat",
             nut="none",
             clearance=cutter?clearance:0);
}
module RecoilPlate(length=RecoilPlateLength(), spindleZ=-1, contoured=true, cutter=false, debug=false, alpha=1, clearance=0.005, template=false, templateHoleDiameter=0.08) {
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
  RenderIf(!cutter) DebugHalf(debug)
  difference() {
    
    // Contoured or simplified (rectangular) plate
    if (contoured) {
      translate([0.5-length,0,0])
      rotate([0,90,0])
      linear_extrude(length, center=false)
      offset(r=(cutter?clearance:0))
      hull() {
        projection()
        rotate([0,-90,0])
        Receiver_Segment(highTop=false);
      
        // 12ga cylinder spindle support
        translate([1,0])
        circle(r=0.375+clear2);
      }
    } else {
      translate([0.5-length,-1-clear,ReceiverBottomZ()-0.25-clear])
      cube([length,
            RecoilPlateWidth()+clear2,
            RecoilPlateHeight()+clear2]);
    }
      
    hull() for (Y = [0,-0.25, 0.25]) translate([0,Y,(cutter?clear:0)])
    ActionRod(cutter=!cutter);
    
    if (template) {
      for (Hole = TemplateHoles)
      translate([0.5-length-clear,Hole.y,Hole.z])
      rotate([0,90,0])
      cylinder(r=templateHoleDiameter/2, h=length);
      
    } else if (!cutter) {
      FiringPin(cutter=true);
      RecoilPlateBolts(cutter=true);
      
      // ZZR cylinder spindle
      translate([0,0,-1])
      rotate([0,-90,0])
      cylinder(r=5/16/2, h=length);
    }
  }
}

module FCG_ChargingHandleBolt(bolt=FCG_ChargingHandleBolt(), boltLength=0.25, cutter=false, clearance=CHARGING_HANDLE_BOLT_CLEARANCE) {
  translate([-0.75,-0.25,ReceiverTopSlotHeight()])
  mirror([0,0,1])
  NutAndBolt(bolt=bolt, boltLength=boltLength+ManifoldGap(2),
        head="socket", nut="heatset",
        clearance=cutter?clearance:0,
        doRender=!cutter);
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
///

//*****************
//* Printed Parts *
//*****************
module FCG_FiringPinCollar(cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  flareRadius = FiringPinBodyRadius()+(1/16);
  
  color("Olive")
  RenderIf(!cutter)
  DebugHalf(debug)
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
                        h=fingerHoleHeight-clear2);
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
                          h=fingerHoleHeight-clear2);
    
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
  RenderIf(!cutter) DebugHalf(debug)
  difference() {
    union() {
      
      // Body
      translate([FCG_HammerCockedX,0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/8,
                         h=FCG_HammerLength,
                       teardropTop=true, teardropBottom=true);
      
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
                 -(ReceiverIR()+Receiver_SideSlotDepth()-clearance),
                 -(Receiver_SideSlotHeight()/2)+clearance])
      mirror([1,0,0])
      ChamferedCube([FCG_HammerLength,
                     (ReceiverIR()+Receiver_SideSlotDepth()-clearance)*2,
                     Receiver_SideSlotHeight()-(clearance*2)],
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
                          h=11/16);
    
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
  render() DebugHalf(debug)
  difference() {
    union() {
      intersection() {
      
        // Body
        translate([FCG_HammerTailMinX,0,0])   
        rotate([0,90,0])
        ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/8,
                           h=FCG_HammerTailLength(),
                          teardropTop=true, teardropBottom=true);
    
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
                 -(ReceiverIR()+Receiver_SideSlotDepth()-clearance),
                 -(Receiver_SideSlotHeight()/2)+clearance])
      ChamferedCube([FCG_HammerTailLength(),
                     (ReceiverIR()+Receiver_SideSlotDepth()-clearance)*2,
                     Receiver_SideSlotHeight()-(clearance*2)],
                    r=1/16,teardropFlip=[true, true, true]);
    }
    
    // Hammer Bolt Hole
    translate([FCG_HammerTailMinX,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(
      r1=(HAMMER_BOLT_SLEEVE_DIAMETER/2)+HAMMER_BOLT_SLEEVE_CLEARANCE,
      r2=1/32, h=FCG_HammerTailLength());
    
    // Main Spring Hole
    translate([FCG_HammerTailMinX+FCG_HammerTailLength(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=0.65/2, r2=1/16, chamferTop=false,
                          h=0.125);
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
    DebugHalf(debug)
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
  DebugHalf(debug)
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
                 -(ReceiverIR()+Receiver_SideSlotDepth()-0.01),
                 -(Receiver_SideSlotHeight()/2)+0.01])
      mirror([1,0,0])
      ChamferedCube([FiringPinHousingLength(),
                     (ReceiverIR()+Receiver_SideSlotDepth()-0.01)*2,
                     Receiver_SideSlotHeight()-(0.01*2)],
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

module SearSupportTab(cutter=false, clearance=0.015) {
  clearance2 = clearance*2;
  width = 0.25-clearance*2;
  
  frontExtra = 0.375;
  backHeight = 0.375;

  color("Chocolate")
  render(convexity=4)
  difference() {
    union() {
      
      // Body
      translate([-LowerMaxX()+ReceiverLugRearMaxX(),-(width/2), LowerOffsetZ()-TriggerHeight()+clearance])
      ChamferedCube([ReceiverLugFrontMinX()-0.5-ReceiverLugRearMaxX(),
            width,
            TriggerHeight()-(clearance*2)], r=1/16,
            teardropFlip=[true,true,true]);
      
      // Front Stop
      translate([-LowerMaxX(),
                  -(width/2),
                   LowerOffsetZ()-GripCeiling()])
      ChamferedCube([ReceiverLugFrontMinX(),
            width,
            GripCeiling()], r=1/16,
            teardropFlip=[true,true,true]);
      
      // Front Leg
      translate([-LowerMaxX(),
                  -(width/2),
                   LowerOffsetZ()-GripCeiling()])
      ChamferedCube([ReceiverLugFrontMinX()+frontExtra,
            width,
            0.25], r=1/16,
            teardropFlip=[true,true,true]);
        
      
      // Back Leg
      translate([ReceiverLugRearMinX()-LowerMaxX(),
                  -(width/2),
                   LowerOffsetZ()+ReceiverLugRearZ()-backHeight])
      ChamferedCube([abs(ReceiverLugRearMinX()),
            width,
            backHeight-clearance], r=1/16,
            teardropFlip=[true,true,true]);
    }
    
    
    // Sear cutout
    translate([-LowerMaxX()-SearRadius(),
                (width/2)-clearance,
                 -SearLength()-SearTravel()-SearSpringCompressed()-SearBottomOffset()])
    rotate([90,0,0])
    ChamferedSquareHole([width+clearance2, SearLength()], length=width+clearance2,
                         corners=false, center=false,
                         chamferRadius=1/16);

  }
}

module TriggerBody() {
  sideplateWidth = (TriggerWidth()/2)
                 - SearRadius(SEAR_CLEARANCE);
  
  color("Gold")
  render()
  difference() {
    translate([0,(TriggerWidth()/2),0])
    rotate([90,0,0])
    linear_extrude(height=TriggerWidth())
    Trigger2d();

    // Trigger finger chamfer
    translate([TriggerFingerRadius()+TriggerTravel()+SearDiameter()+0.5-0.15,
               -TriggerWidth()/2, -GripCeiling()-TriggerFingerRadius()])
    rotate([-90,0,0])
    ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                          h=TriggerWidth(), $fn=Resolution(16,30));

    // Sear Slot (extended)
    translate([ReceiverLugRearMaxX(),-SearRadius(SEAR_CLEARANCE),ManifoldGap()])
    mirror([0,0,1])
    cube([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.385,
          SearDiameter(SEAR_CLEARANCE), 2+ManifoldGap()]);

    // Sear Support Slot Front
    translate([0,-SearRadius(SEAR_CLEARANCE),GripCeilingZ()-0.01])
    cube([ReceiverLugFrontMaxX(),
          SearDiameter(SEAR_CLEARANCE),
          GripCeiling()+0.01+ManifoldGap()]);
  }
}

module Trigger(animationFactor=TriggerAnimationFactor(), left=true, leftAlpha=1, right=true, rightAlpha=1) {
  sideplateWidth = (TriggerWidth()/2)
                 - SearRadius();

  translate([-LowerMaxX(),0, LowerOffsetZ()])
  translate([-(TriggerTravel()*animationFactor),0,0]) {

    if (right)
    color("Olive", rightAlpha)
    render()
    difference() {
      translate([0,SearRadius(SEAR_CLEARANCE),0])
      rotate([90,0,0])
      linear_extrude(height=TriggerWidth()-sideplateWidth, center=false)
      Trigger2d();

      // Trigger finger chamfer
      translate([TriggerFingerRadius()+TriggerTravel()+SearDiameter()+0.5-0.15,
                 -TriggerWidth()/2, -GripCeiling()-TriggerFingerRadius()])
      rotate([-90,0,0])
      ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                            h=TriggerWidth(), $fn=Resolution(16,30));

      // Sear Slot (extended)
      translate([ReceiverLugRearMaxX(),-SearRadius(SEAR_CLEARANCE),ManifoldGap()])
      mirror([0,0,1])
      cube([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.385,
            SearDiameter(SEAR_CLEARANCE), 2+ManifoldGap()]);

      // Sear Support Slot Front
      translate([0,-SearRadius(SEAR_CLEARANCE),GripCeilingZ()-0.01])
      cube([ReceiverLugFrontMaxX(),
            SearDiameter(SEAR_CLEARANCE),
            GripCeiling()+0.01+ManifoldGap()]);
    }

    if (left)
    color("Olive", leftAlpha)
    render()
    difference() {
      translate([0,(TriggerWidth()/2),0])
      rotate([90,0,0])
      linear_extrude(height=sideplateWidth)
      Trigger2d();

      // Trigger finger chamfer
      translate([TriggerFingerRadius()+TriggerTravel()+SearDiameter()+0.5-0.15,
                 -TriggerWidth()/2, -GripCeiling()-TriggerFingerRadius()])
      rotate([-90,0,0])
      ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                            h=TriggerWidth(), $fn=Resolution(16,30));
    }
  }
}
///

//*********************
//* Fixtures and Jigs *
//*********************
module FCG_SearJig(width=0.75, height=1) {
  translate([0,0,SearPinOffsetZ()-SearBottomOffset()])
  difference() {
    translate([-SearRadius()-0.125,-width/2,0])
    ChamferedCube([height,width,SearLength()], r=1/16);

    // Sear Pin Hole
    translate([-1,0,SearBottomOffset()])
    rotate([0,90,0])
    cylinder(r=SearPinRadius()+SEAR_PIN_CLEARANCE, h=3);

    // Sear Rod Hole
    translate([0,0,-ManifoldGap()])
    cube([0.25+SEAR_CLEARANCE, 0.25+SEAR_CLEARANCE, SearLength()*2]);

    // Set screw hole
    translate([0,0,SearLength()-0.5])
    rotate([0,90,0])
    NutAndBolt(bolt=Spec_BoltM3(),
            teardrop=true, teardropAngle=180,
            nutBackset=SearRadius(),
            nutHeightExtra=SearRadius(),
            boltLength=3);
  }
}
module FCG_RecoilPlate_TapGuide(xyz = [0.25,0.25,1.5], holeRadius=0.1770/2, spindleZ=-1, contoured=FCG_RECOIL_PLATE_CONTOURED) {
  width = RecoilPlateWidth() + (xyz.x*2);
  length = RecoilPlateHeight() + (xyz.y*2);
  height = xyz.z;
  

  TemplateHoles = FCG_RecoilPlateHoles(spindleZ=spindleZ);
  
  render()
  difference() {
    translate([-(length/2)+0.125, -(width/2), 0])
    ChamferedCube([length, width, height], r=1/16);

    rotate([0,-90,0])
    translate([height-0.5,0,0])
    RecoilPlate(contoured=contoured, cutter=true, clearance=0.005);

    ChamferedCircularHole(r1=0.25, r2=1/8, h=height-RecoilPlateLength(),
                          teardropTop=true,teardropBottom=true);

    for (hole = TemplateHoles)
    translate([-hole.z,hole.y,0])
    cylinder(r=holeRadius, h=height);
  }
}

module FCG_RecoilPlate_Fixture(xyz = [1,0.5,0.5], holeRadius=0.1875, spindleZ=-1, contoured=FCG_RECOIL_PLATE_CONTOURED) {
  width = RecoilPlateWidth() + (xyz.x*2);
  length = RecoilPlateHeight() + (xyz.y*2);
  height = xyz.z;
  

  TemplateHoles = FCG_RecoilPlateHoles(spindleZ=spindleZ);
  
  render()
  difference() {
    translate([-(length/2)+0.125, -(width/2), 0])
    ChamferedCube([length, width, height], r=1/16);

    translate([height-0.5,0,0])
    rotate([0,-90,0])
    RecoilPlate(cutter=true, clearance=0.005);

    // Template holes
    for (hole = TemplateHoles)
    translate([-hole.z,hole.y,0])
    cylinder(r=holeRadius, h=height);
    
    // Fixture holes
    for (M = [0,1]) mirror([0,M,0])
    for (hole = [[0,1.5,0],
                 [1,1.5,0],
                 [-1,1.5,0]])
    translate(hole)
    cylinder(r=(0.2010/2)+0.01, h=height);
    
  }
}

module FCG_RecoilPlate_GangFixture(xyz = [1,0.375,0.375], gang=[5,2], holeRadius=0.25, spindleZ=-1, contoured=FCG_RECOIL_PLATE_CONTOURED) {
  
  offsetGap = 0.125;
  offsetX = RecoilPlateHeight()+offsetGap;
  offsetY = RecoilPlateWidth()+offsetGap;
  
  length = (RecoilPlateHeight()*2)+1;
  width  = (RecoilPlateWidth()*2)+ 1.5;
  height = xyz.z;
  

  TemplateHoles = FCG_RecoilPlateHoles(spindleZ=spindleZ);
  
  render()
  difference() {
    translate([-(length/2)-0.125, -(width/2), 0])
    ChamferedCube([length, width, height], r=1/16);

    translate([offsetX/2, offsetY/2,0])
    %for (X = [0:gang.x-1]) for (Y = [0:gang.y-1])
    translate([X*offsetX,Y*offsetY,0]) {
    
      // Recoil Plate cutout
      translate([height-0.5,0,0])
      rotate([0,-90,0])
      RecoilPlate(contoured=contoured, cutter=true, clearance=0.005);

      // Template holes
      for (hole = TemplateHoles)
      translate([-hole.z,hole.y,0])
      cylinder(r=holeRadius, h=height);
    }
      
    // Fixture holes
    for (X = [-5:1:5]) for (Y = [0,-2.5,2.5,3.75]) translate([X+0.375,Y,0])
    cylinder(r=(0.2010/2)+0.01, h=height);
    
    // Index pin
    cylinder(r=3/32/2, h=height);
  }
}
///

//**************
//* Assemblies *
//**************
module TriggerGroup(animationFactor=TriggerAnimationFactor(),
                    searLength=SearLength()) {
  
  Sear(animationFactor=animationFactor, length=searLength)
  SearPin();
    
  if (_SHOW_TRIGGER_MIDDLE)
  SearSupportTab();
  
  Trigger(animationFactor=animationFactor,
          left=_SHOW_TRIGGER_LEFT, leftAlpha=1,
          right=_SHOW_TRIGGER_RIGHT, rightAlpha=1);
}

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

  if (_SHOW_CHARGING_HANDLE)
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
  
  TriggerGroup(searLength=1.67188);
  
  if(_SHOW_HAMMER_TAIL)
  FCG_HammerTail(debug=_CUTAWAY_FCG_Hammer, alpha=_ALPHA_FCG_Hammer);
  
  if (_SHOW_RECOIL_PLATE_BOLTS)
  RecoilPlateBolts();
  
  if (_SHOW_FIRE_CONTROL_HOUSING)
  FCG_Housing(alpha=_ALPHA_FIRING_PIN_HOUSING, debug=_CUTAWAY_FIRING_PIN_HOUSING);
  
  if (recoilPlate)
  RecoilPlate(contoured=FCG_RECOIL_PLATE_CONTOURED, debug=_CUTAWAY_RECOIL_PLATE, alpha=_ALPHA_RECOIL_PLATE);
}
///

//*************
//* Rendering *
//*************
scale(25.4)
if ($preview) {
  
  SimpleFireControlAssembly();
  
  if (_SHOW_LOWER) {
    LowerMount();
    Lower();
  }
  
  if (_SHOW_RECEIVER)
  ReceiverAssembly(debug=_CUTAWAY_RECEIVER);
} else {
  
  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "FCG_TriggerMiddle")
    if (!_RENDER_PRINT)
      SearSupportTab();
    else
      rotate(180)
      translate([LowerMaxX(),-TriggerHeight()/2,0.12])
      rotate([90,0,00])
      SearSupportTab();

  if (_RENDER == "FCG_TriggerLeft")
    if (!_RENDER_PRINT)
      Trigger(left=true, right=false);
    else
      rotate(180)
      translate([0,-TriggerHeight()/2,0])
      rotate([90,0,0])
      translate([LowerMaxX(),-SearRadius(SEAR_CLEARANCE),0])
      Trigger(left=true, right=false);

  if (_RENDER == "FCG_TriggerRight")
    if (!_RENDER_PRINT)
      Trigger(left=false, right=true);
    else
      rotate(180)
      translate([0,-TriggerHeight()/2,0])
      rotate([90,0,0])
      translate([LowerMaxX(),TriggerWidth()/2,0])
      Trigger(left=false, right=true);
  
  if (_RENDER == "FCG_Housing")
    if (!_RENDER_PRINT)
      FCG_Housing();
    else
      rotate([0,-90,0])
      translate([FiringPinHousingLength(),0,0])
      FCG_Housing();
  
  if (_RENDER == "FCG_Hammer")
    if (!_RENDER_PRINT)
      FCG_Hammer();
    else
      rotate([0,90,0])
      translate([-FCG_HammerCockedX,0,0])
      FCG_Hammer();
  
  if (_RENDER == "FCG_HammerTail")
    if (!_RENDER_PRINT)
      FCG_HammerTail();
    else
      rotate([0,-90,0])
      translate([-FCG_HammerTailMinX,0,0])
      FCG_HammerTail();
  
  if (_RENDER == "FCG_ChargingHandle")
    if (!_RENDER_PRINT)
      FCG_ChargingHandle();
    else
      translate([ReceiverLength(),0,-ReceiverTopSlotHeight()+ReceiverTopSlotHorizontalHeight()])
      FCG_ChargingHandle();
  
  if (_RENDER == "FCG_Disconnector")
    if (!_RENDER_PRINT)
      FCG_Disconnector();
    else
      rotate([90,0,0])
      translate([-FCG_DisconnectorPivotX,-FCG_DisconnectorOffsetY,-FCG_DisconnectorPivotZ])
      FCG_Disconnector();
  
  if (_RENDER == "FCG_FiringPinCollar")
    if (!_RENDER_PRINT)
      FCG_FiringPinCollar();
    else
      rotate([0,90,0])
      translate([FiringPinTravel(),0,0])
      FCG_FiringPinCollar();

  // *********************
  // * Fixtures and Jigs *
  // *********************
  if (_RENDER == "FCG_SearJig")
  FCG_SearJig();
  
  if (_RENDER == "FCG_RecoilPlate_Fixture")
  FCG_RecoilPlate_Fixture();
  
  if (_RENDER == "FCG_RecoilPlate_GangFixture")
  FCG_RecoilPlate_GangFixture();
  
  if (_RENDER == "FCG_RecoilPlate_TapGuide")
  FCG_RecoilPlate_TapGuide();
  
  if (_RENDER == "FCG_RecoilPlate_Projection")
  projection() rotate([0,90,0])
  RecoilPlate(template=true, contoured=FCG_RECOIL_PLATE_CONTOURED);
  
  // ************
  // * Hardware *
  // ************
  if (_RENDER == "FCG_DisconnectorTripBolt")
  FCG_DisconnectorTripBolt();
  
  if (_RENDER == "FCG_DisconnectorPivotPin")
  FCG_DisconnectorPivotPin();
  
  if (_RENDER == "FCG_DisconnectorSpring")
  FCG_DisconnectorSpring();
  
  if (_RENDER == "FCG_HammerBolt")
  FCG_HammerBolt();
  
  if (_RENDER == "FCG_ActionRod")
  ActionRod();
  
  if (_RENDER == "FCG_Sear")
  Sear();
  
  if (_RENDER == "FCG_SearPin")
  SearPin();
  
  if (_RENDER == "FCG_FiringPin")
  FiringPin();
  
  if (_RENDER == "FCG_FiringPinSpring")
  FiringPinSpring();
  
  if (_RENDER == "FCG_RecoilPlateCenterBolts")
  RecoilPlateCenterBolts();
  
  if (_RENDER == "FCG_RecoilPlateSideBolts")
  RecoilPlateSideBolts();
  
  if (_RENDER == "FCG_RecoilPlate")
  RecoilPlate();
  
  if (_RENDER == "FCG_ChargingHandleBolt")
  FCG_ChargingHandleBolt();
  
  if (_RENDER == "FCG_ChargingHandleSpring")
  FCG_ChargingHandleSpring();
}