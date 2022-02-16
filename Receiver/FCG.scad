include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Cutaway.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Conditionals/RenderIf.scad>;

use <../Shapes/Teardrop.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Components/Pivot.scad>;

use <../Tooling/Jigs/Square Rod Jig.scad>;

use <../Vitamins/Bearing.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Springs/Springs.scad>;
use <../Vitamins/Springs/SpringSpec.scad>;

use <Lower.scad>;
use <Receiver.scad>;

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/FCG_Housing", "Prints/FCG_ChargingHandle", "Prints/FCG_Disconnector", "Prints/FCG_Hammer", "Prints/FCG_HammerTail", "Prints/FCG_FiringPinCollar", "Prints/FCG_Trigger", "Prints/FCG_TriggerMiddle", "Jigs/FCG_FiringPin", "Jigs/FCG_Sear", "Jigs/FCG_HammerSleeve", "Fixtures/FCG_RecoilPlate", "Fixtures/FCG_RecoilPlate_GangFixture", "Fixtures/FCG_RecoilPlate_TapGuide", "Projections/FCG_RecoilPlate"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_TRIGGER = true;
_SHOW_TRIGGER_MIDDLE = true;
_SHOW_SEAR = true;
_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_FCG_Disconnector = true;
_SHOW_FCG_DISCONNECTOR_HARDWARE = true;
_SHOW_FCG_Hammer = true;
_SHOW_CHARGING_HANDLE = true;
_SHOW_HAMMER_TAIL = true;
_SHOW_ACTION_ROD = false;
_SHOW_FIRING_PIN = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_RECOIL_PLATE_BOLTS = true;
_SHOW_RECEIVER      = true;
_SHOW_LOWER         = true;

/* [Transparency] */
_ALPHA_RECEIVER = 0.15; // [0:0.1:1]
_ALPHA_LOWER = 0.15; // [0:0.1:1]
_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]
_ALPHA_RECOIL_PLATE = 1; // [0:0.1:1]
_ALPHA_FCG_Hammer = 1; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_FCG_Disconnector = false;
_CUTAWAY_FCG_Hammer = false;
_CUTAWAY_FCG_Hammer_CHARGER = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_LOWER = false;
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

// Spring Clearances
FCG_Disconnector_SPRING_CLEARANCE = 0.005;
HAMMER_SPRING_CLEARANCE = 0.0125;

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

function HammerSpringSpec() = [
    ["SpringSpec", "Hammer Spring"],

    ["SpringOuterDiameter", Inches(0.6)],
    ["SpringPitch", Inches(0.2139)],

    ["SpringFreeLength", Inches(3.059)],
    ["SpringSolidHeight", Inches(0.903)],

    ["SpringWireDiameter", Inches(0.059)]
  ];

function FiringPinSpringSpec() = [
    ["SpringSpec", "Firing Pin Spring"],

    ["SpringOuterDiameter", Inches(0.22)],
    ["SpringPitch", Inches(0.1)],

    ["SpringFreeLength", Inches(0.8)],
    ["SpringSolidHeight", Inches(0.5)],

    ["SpringWireDiameter", Inches(0.02)]
  ];

function DisconnectorSpringSpec() = [
    ["SpringSpec", "Disconnector Spring"],

    ["SpringOuterDiameter", Inches(0.23)],
    ["SpringPitch", Inches(0.05)],

    ["SpringFreeLength", Inches(0.4)],
    ["SpringSolidHeight", Inches(0.3125)],

    ["SpringWireDiameter", Inches(0.025)]
  ];

function SearReturnSpringSpec() = [
    ["SpringSpec", "Sear Return Spring"],

    ["SpringOuterDiameter", Inches(0.25)],
    ["SpringPitch", Inches(0.075)],

    ["SpringFreeLength", Inches(1.2)],
    ["SpringSolidHeight", Inches(0.3)],

    ["SpringWireDiameter", Inches(0.025)]
  ];

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

FCG_HammerSpringHammerInsetLength = 11/16;
FCG_HammerSpringHammerTailInsetLength = 0.25;

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
                        + SpringOuterDiameter(spring=DisconnectorSpringSpec())
                        + (1/16);



// Shorthand: Measurements
function SearWidth(clearance=0) = SEAR_WIDTH+(clearance*2);
function SearRadius(clearance=0)   = SearWidth(clearance)/2;

function SearPinDiameter(clearance=0) = SEAR_PIN_DIAMETER+(clearance*2);
function SearPinRadius(clearance=0) = SearPinDiameter(clearance)/2;

function SearPinOffsetZ() = -0.25;
function SearBottomOffset() = 0.25;



function TriggerFingerDiameter() = 1;
function TriggerFingerRadius() = TriggerFingerDiameter()/2;

function TriggerFingerOffsetZ() = GripCeilingZ();
function TriggerFingerWall() = 0.3;

function TriggerHeight() = GripCeiling()+TriggerFingerDiameter();
function TriggerWidth() = 0.50;
function SearTravel() = 0.25;
function TriggerTravel() = SearTravel()*1.5;
function SearLength() = 1.625;// abs(SearPinOffsetZ()) + SearTravel();

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
//

//************
//* Vitamins *
//************
module ActionRod(length=10, cutaway=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Action Rod
  color("Silver")
  translate([-0.5,0,ActionRodZ()])
  Cutaway(cutaway)
  translate([0,-(ActionRodWidth()/2)-clear,-(ActionRodWidth()/2)-clear])
  cube([length, ActionRodWidth()+clear2, ActionRodWidth()+clear2]);
}
module FCG_DisconnectorTripBolt(cutaway=false, cutter=false, teardrop=false, clearance=0.01) {
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
module FCG_DisconnectorPivotPin(cutaway=false, cutter=false, teardrop=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver")
  translate([FCG_DisconnectorPivotX, 0, FCG_DisconnectorPivotZ])
  rotate([90,0,0])
  linear_extrude(height=cutter?ReceiverID():ReceiverTopSlotWidth(), center=true)
  Teardrop(r=(3/32/2)+clear, enabled=teardrop);
}
module FCG_DisconnectorSpring(cutaway=false, cutter=false, clearance=FCG_Disconnector_SPRING_CLEARANCE) {
  color("Silver") RenderIf(!cutter)
  translate([-(3/16),
             FCG_DisconnectorSpringY,
             FCG_DisconnectorPivotZ-0.125-0.125])
  Spring(spring=DisconnectorSpringSpec(), compressed=true, cutter=cutter, clearance=clearance);
}
module FCG_HammerBolt(clearance=FCG_Hammer_BOLT_CLEARANCE, head=HAMMER_BOLT_HEAD, nut=HAMMER_BOLT_NUT, cutter=false, cutaway=false) {
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
module FCG_HammerSpring() {
  color("Silver")
  translate([FCG_HammerCockedX-FCG_HammerLength + 11/16,0,0])
  rotate([0,-90,0])
  Spring(spring=HammerSpringSpec(), compressed=true, cutter=false, clearance=HAMMER_SPRING_CLEARANCE);
}
module Sear(animationFactor=0, length=SearLength(), cutter=false, clearance=SEAR_CLEARANCE) {
  clear = cutter ? clearance : 0;

  translate([0,0,-SearTravel()*animationFactor]) {

    color("Silver") RenderIf(!cutter)
    difference() {
      translate([-LowerMaxX(),0, LowerOffsetZ()])
      translate([-SearRadius(clear),-SearRadius(clear),SearPinOffsetZ()-SearBottomOffset()-(cutter?SearTravel()+SpringSolidHeight(spring=SearReturnSpringSpec()):0)])
      cube([SearWidth(clear), SearWidth(clear), length]);

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
  color("Silver") RenderIf(!cutter)
  cylinder(r=SearPinRadius(clear), h=0.5, center=true);
}


module SearReturnSpring() {
  color("Silver")
  Spring(spring=SearReturnSpringSpec(), compressed = true, custom_compression_ratio=0.69);
}
module FiringPin(radius=FiringPinRadius(), cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, cutaway=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  radius = template ? 1/16 : radius;

  if (!template) {
    color("Silver")
    RenderIf(!cutter)
    Cutaway(cutaway)
    translate([-FiringPinHousingLength()-FiringPinTravel(),0,0])
    rotate([0,90,0]) {

      // Pin
      cylinder(r=radius+clear,
               h=FiringPinLength() + (cutter ? FiringPinTravel() : 0) + ManifoldGap());

      // Head
      cylinder(r=(0.3/2)+clear,
               h=0.025);
    }
  } else {
    rotate([0,-90,0])
    cylinder(r=1/16/2);
  }
}
module FiringPinSpring(cutter=false, clearance=0.005, cutaway=false) {
  color("Silver")
  Cutaway(cutaway)
  translate([-0.25,0,0])
  rotate([0,90,0])
  Spring(spring = FiringPinSpringSpec(), compressed = true, cutter = cutter, clearance = clearance);

  if (cutter)
  translate([-0.25,0,0])
  rotate([0,-90,0])
  cylinder(
    r1=(SpringOuterDiameter(FiringPinSpringSpec())/2)+clearance,
    r2=FiringPinRadius(),
    h=(SpringOuterDiameter(FiringPinSpringSpec())/2)+clearance
  );
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
module RecoilPlate(length=RecoilPlateLength(), spindleZ=-1, contoured=true, cutter=false, cutaway=false, alpha=1, clearance=0.005, template=false, templateHoleDiameter=0.08) {
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
  RenderIf(!cutter) Cutaway(cutaway)
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
module FCG_FiringPinCollar(cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  flareRadius = FiringPinBodyRadius()+(1/16);

  color("Olive", alpha)
  RenderIf(!cutter)
  Cutaway(cutaway)
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
module FCG_ChargingHandle(clearance=0.005, alpha=1) {
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

  color("Olive", alpha) render()
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
module FCG_Hammer(cutter=false, clearance=Inches(0.01), cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Head
  color("Olive", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
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
    translate([FCG_HammerCockedX-FCG_HammerLength + FCG_HammerSpringHammerInsetLength,0,0])
    rotate([0,270,0])
    Spring(spring=HammerSpringSpec(), clearance=HAMMER_SPRING_CLEARANCE, cutter=true, compressed=true);

    // Disconnector chamfered hole
    translate([FCG_HammerCockedX,0,FCG_DisconnectorPivotZ])
    rotate([0,-90,0])
    ChamferedSquareHole(sides=[FCG_DisconnectorHeight+(clearance*2),
                               FCG_DisconnectorHeight+(clearance*2)],
                        length=FCG_DisconnectorLength, chamferRadius=1/16,
                        center=true, corners=false, chamferTop=false);


    translate([-FCG_HammerTravelX,0,0])
    FCG_Disconnector(cutter=true, cutaway=false);

    FCG_HammerBolt(cutter=true);
  }
}
module FCG_HammerTail(clearance=Inches(0.01), cutaway=false, alpha=1) {
  color("Chocolate", alpha)
  render() Cutaway(cutaway)
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
    translate([FCG_HammerTailMinX+FCG_HammerTailLength() - FCG_HammerSpringHammerTailInsetLength,0,0])
    rotate([0,90,0])
    Spring(spring=HammerSpringSpec(), clearance=HAMMER_SPRING_CLEARANCE, cutter=true, compressed=true);
  }
}
module FCG_Disconnector(pivotFactor=0, cutter=false, clearance=0.005, alpha=1, cutaway=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  Pivot(factor=pivotFactor,
        pivotX=FCG_DisconnectorPivotX,
        pivotZ=FCG_DisconnectorPivotZ,
        angle=FCG_DisconnectorPivotAngle) {

    children();

    color("Olive", alpha)
    RenderIf(!cutter)
    Cutaway(cutaway)
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
module FCG_Housing(clearance=0.01, cutaway=false, alpha=1) {

  color("Chocolate", alpha) render()
  Cutaway(cutaway)
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
               FCG_DisconnectorSpringY-(SpringOuterDiameter(spring=DisconnectorSpringSpec())/2)-0.005,
               FCG_DisconnectorPivotZ-0.125-0.125])
    mirror([1,0,0])
    ChamferedCube([0.3125, SpringOuterDiameter(spring=DisconnectorSpringSpec())+0.01, 0.25], r=1/32);

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
module SearSupportTab(cutter=false, clearance=0.015, searClearance=SEAR_CLEARANCE, alpha=1) {
  clearance2 = clearance*2;
  width = 0.25-clearance*2;

  frontExtra = 0.375;
  backHeight = 0.375;

  color("Chocolate", alpha)
  render()
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
    translate([-LowerMaxX()-(SearWidth(searClearance)/2),
                (SearWidth()/2),
                 -SearLength()-SearTravel()-SpringSolidHeight(spring=SearReturnSpringSpec())-SearBottomOffset()])
    rotate([90,0,0])
    ChamferedSquareHole([SearWidth(searClearance), SearLength()], length=SearWidth(),
                         corners=false, center=false,
                         chamferRadius=1/16);

  }
}
module Trigger(width=0.5, clearance=0.015, alpha=1) {
  sideplateWidth = (TriggerWidth()/2)
                 - (SearWidth(SEAR_CLEARANCE)/2);
  clearance2 = clearance*2;
  width = TriggerWidth();

  frontExtra = 0.3125;
  backHeight = 0.375;

  color("Olive", alpha)
  render()
  difference() {
    union() {

      // Body
      translate([-LowerMaxX()+ReceiverLugRearMaxX()+TriggerTravel()+clearance,-(width/2), LowerOffsetZ()-TriggerHeight()+clearance])
      ChamferedCube([ReceiverLugFrontMinX()-ReceiverLugRearMaxX()-TriggerTravel()-(clearance*2),
            width,
            TriggerHeight()-(clearance*2)], r=1/16);

      // Front Leg
      translate([-LowerMaxX(),
                  -(width/2),
                   LowerOffsetZ()-TriggerHeight()+clearance])
      ChamferedCube([ReceiverLugFrontMinX()+frontExtra,
            width,
            TriggerHeight()-abs(ReceiverLugFrontZ())-clearance], r=1/16);


      // Back Leg
      translate([-LowerMaxX()+ReceiverLugRearMaxX()-TriggerTravel()-clearance,
                  -(width/2),
                   LowerOffsetZ()-TriggerHeight()+clearance])
      ChamferedCube([abs(ReceiverLugRearMinX()),
            width,
            backHeight-clearance], r=1/16);
    }

    // Trigger finger chamfer
    translate([-LowerMaxX()+TriggerFingerRadius()+TriggerTravel()+SearWidth()+0.5-0.15,
               -TriggerWidth()/2, LowerOffsetZ()-GripCeiling()-TriggerFingerRadius()])
    rotate([-90,0,0])
    ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
                          h=TriggerWidth());

    // Sear Support Slot
    translate([-LowerMaxX()+ReceiverLugRearMaxX(),-(SearWidth(SEAR_CLEARANCE)/2),LowerOffsetZ()+ManifoldGap()])
    mirror([0,0,1])
    ChamferedSquareHole([abs(ReceiverLugRearMaxX())+TriggerTravel()+0.385,
                         SearWidth(SEAR_CLEARANCE)],
                        length=TriggerHeight()+ManifoldGap(),
                        chamferRadius=1/16, corners=false, center=false);

    // Sear Support Slot - Front
    translate([-LowerMaxX(),-(SearWidth(SEAR_CLEARANCE)/2),LowerOffsetZ()+GripCeilingZ()-clearance])
    cube([ReceiverLugFrontMaxX(),
          SearWidth(SEAR_CLEARANCE),
          GripCeiling()+clearance+ManifoldGap()]);

    // Sear Pin Slot
    hull() {
      SearPin(cutter=true);

      translate([TriggerTravel(), 0, -SearTravel()])
      SearPin(cutter=true);
    }
  }
}

///

//*********************
//* Fixtures and Jigs *
//*********************
module FCG_FiringPinJig(width=0.75, height=1.45, clearance=0.005) {
  radius = FiringPinRadius();
  
  // Insert nail, cut flush with Knipex 71 32 200
  // Grind flat and smooth over
  
  render()
  difference() {
    ChamferedCube([width,width,height], r=1/16);
    
    // Straight hole
    translate([width/2,width/2,0])
    ChamferedCircularHole(r1=radius+clearance,
                          r2=1/32, h=height,
                          chamferBottom=false);
    
    // Taper hole
    translate([width/2,width/2,0])
    cylinder(r1=FiringPinRadius()*2,
             r2=FiringPinRadius(),
              h=height*0.75);
    
  }
}
module FCG_HammerSleeveJig(width=1, height=2, clearance=0.005) {
   radius = (HAMMER_BOLT_SLEEVE_DIAMETER/2)+clearance;
  
  render()
  difference() {
    ChamferedCube([width,width,height], r=1/16);
    
    // Straight hole
    translate([width/2,width/2,0])
    ChamferedCircularHole(r1=radius+clearance,
                          r2=1/32, h=height,
                          chamferBottom=false);
    
    // Taper hole
    translate([width/2,width/2,0])
    cylinder(r1=radius*2,
             r2=radius,
              h=radius*2);
    
  }
}

module FCG_SearJig(width=0.75, height=1) {
  SquareRodJig(offset=abs(SearPinOffsetZ()+LowerOffsetZ()));
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
module FCG_RecoilPlate_GangFixture(xyz = [0.25,0.75,0.375], gang=[1,1], holeRadius=0.1, spindleZ=-1, contoured=FCG_RECOIL_PLATE_CONTOURED) {

  offsetPlateX = (RecoilPlateHeight()/2)-0.125;
  offsetGapX = 0.125;
  offsetGapY = 0.1875;
  offsetX = RecoilPlateHeight()+offsetGapX;
  offsetY = Millimeters(59);

  length = (offsetX*gang.x)-offsetGapX+(xyz.x*2);
  width  = (offsetY*gang.y)-offsetGapY+(xyz.y*2);
  height = xyz.z;


  TemplateHoles = FCG_RecoilPlateHoles(spindleZ=spindleZ);

  render()
  difference() {
    ChamferedCube([length, width, height], r=1/16);

    for (X = [0:gang.x-1]) for (Y = [0:gang.y-1])
    translate([X*offsetX,Y*offsetY,0]) {

      // Recoil Plate cutout
      translate([xyz.x+offsetPlateX, xyz.y+(RecoilPlateWidth()/2), 0])
      rotate([0,-90,0])
      RecoilPlate(contoured=contoured, cutter=true, clearance=0.005);
      
      // Hold-down bolts
      translate([xyz.x+offsetPlateX, xyz.y+(RecoilPlateWidth()/2), 0])
      for (hole = [1,-1])
      translate([0,hole*0.5,0])
      NutAndBolt(BoltSpec("M3"), boltLength=height, nut="hex",
                 clearance=0.005);
      
      // Template holes
      translate([xyz.x+offsetPlateX, xyz.y+(RecoilPlateWidth()/2), 0.1875])
      for (hole = TemplateHoles)
      translate([-hole.z,hole.y,0])
      cylinder(r=holeRadius, h=height);

      // Spindle hole
      translate([xyz.x+offsetPlateX, xyz.y+(RecoilPlateWidth()/2), 0])
      translate([1,0,0])
      cylinder(r=3/8/2, h=height);
    }

    // Fixture holes
    for (X = [0:1:5]) for (Y = [0.25, width-0.25])
    translate([(length/2)-2+X,Y,xyz.z])
    NutAndBolt(bolt=RecoilPlateBolt(), boltLength=Inches(1),
               head="flat", nut="heatset",
               capOrientation=true);

    // Index pin
    *cylinder(r=3/32/2, h=height);
  }
}
///

//**************
//* Assemblies *
//**************
module TriggerGroup(hardware=true, prints=true, animationFactor=TriggerAnimationFactor(),
                    searLength=SearLength(), alpha=1) {

  if (hardware && _SHOW_SEAR)
  Sear(animationFactor=animationFactor, length=searLength) {
    SearPin();
  }

  if (prints && _SHOW_TRIGGER_MIDDLE) {
    SearSupportTab(alpha=alpha);

    if (hardware)
    translate([-LowerMaxX(),0, LowerOffsetZ() - SearLength() + SpringSolidHeight(spring=SearReturnSpringSpec())])
    rotate([0, 0, 0])
    SearReturnSpring();
  }

  if (prints && _SHOW_TRIGGER)
  translate([-(TriggerTravel()*animationFactor),0,0])
  Trigger(alpha=alpha);
}

module SimpleFireControlAssembly(hardware=true, prints=true, actionRod=_SHOW_ACTION_ROD, recoilPlate=_SHOW_RECOIL_PLATE, cutaway=false, alpha=1) {
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
    if (prints)
    FCG_ChargingHandle(alpha=alpha);

    if (hardware)
    FCG_ChargingHandleBolt();
  }

  if (actionRod)
  translate([-chargerTravel*chargeAF,0,0]) {
    if (hardware)
    ActionRod();

    if (hardware)
    FCG_DisconnectorTripBolt();

    children();
  }

  if (hardware && _SHOW_FCG_DISCONNECTOR_HARDWARE)
  FCG_DisconnectorSpring();

  if (hardware && _SHOW_FCG_DISCONNECTOR_HARDWARE)
  FCG_DisconnectorPivotPin();

  if (prints && _SHOW_FCG_Disconnector)
  FCG_Disconnector(pivotFactor=FCG_DisconnectorAF, alpha=alpha);

  // Linear FCG_Hammer
  if (_SHOW_FCG_Hammer) {

    translate([Animate(ANIMATION_STEP_FIRE)*FCG_HammerTravelX,0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGE, start=FCG_HammerChargeStart)*-(FCG_HammerTravelX+FCG_HammerOvertravelX),0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1)*(FCG_HammerOvertravelX-disconnectDistance),0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.97, end=1)*disconnectDistance,0,0]) {
      if (hardware)
      FCG_HammerBolt();

      if (hardware)
      FCG_HammerSpring();

      if (prints)
      FCG_Hammer(cutaway=_CUTAWAY_FCG_Hammer, alpha=min(alpha,_ALPHA_FCG_Hammer));
    }
  }

  if (_SHOW_FIRING_PIN) {
    translate([(3/32)*SubAnimate(ANIMATION_STEP_FIRE, start=0.95),0,0])
    translate([-(3/32)*SubAnimate(ANIMATION_STEP_CHARGE, start=0.07, end=0.2),0,0]) {

      if (hardware)
      FiringPin(cutaway=_CUTAWAY_FIRING_PIN);

      if (prints)
      FCG_FiringPinCollar(cutaway=_CUTAWAY_FIRING_PIN, alpha=alpha);
    }

    if (hardware)
    FiringPinSpring();
  }

  TriggerGroup(hardware=hardware, prints=prints, searLength=1.67188, alpha=alpha);

  if(prints && _SHOW_HAMMER_TAIL)
  FCG_HammerTail(cutaway=_CUTAWAY_FCG_Hammer, alpha=min(alpha,_ALPHA_FCG_Hammer));

  if (hardware && _SHOW_RECOIL_PLATE_BOLTS)
  RecoilPlateBolts();

  if (prints && _SHOW_FIRE_CONTROL_HOUSING)
  FCG_Housing(alpha=min(alpha,_ALPHA_FIRING_PIN_HOUSING), cutaway=_CUTAWAY_FIRING_PIN_HOUSING);

  if (hardware && recoilPlate)
  RecoilPlate(contoured=FCG_RECOIL_PLATE_CONTOURED, cutaway=_CUTAWAY_RECOIL_PLATE, alpha=min(alpha,_ALPHA_RECOIL_PLATE));
}
///

//*************
//* Rendering *
//*************
ScaleToMillimeters()
if ($preview) {

  SimpleFireControlAssembly();

  if (_SHOW_LOWER) {
    LowerMount(hardware=false, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
    Lower(hardware=false, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
  }

  if (_SHOW_RECEIVER)
  ReceiverAssembly(hardware=false, cutaway=_CUTAWAY_RECEIVER, alpha=_ALPHA_RECEIVER);
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/FCG_TriggerMiddle")
    if (!_RENDER_PRINT)
      SearSupportTab();
    else
      rotate(180)
      translate([LowerMaxX(),-TriggerHeight()/2,0.12])
      rotate([90,0,00])
      SearSupportTab();

  if (_RENDER == "Prints/FCG_Trigger")
    if (!_RENDER_PRINT)
      Trigger();
    else
      translate([LowerMaxX(),0,-LowerOffsetZ()+TriggerHeight()])
      Trigger();

  if (_RENDER == "Prints/FCG_Housing")
    if (!_RENDER_PRINT)
      FCG_Housing();
    else
      rotate([0,-90,0])
      translate([FiringPinHousingLength(),0,0])
      FCG_Housing();

  if (_RENDER == "Prints/FCG_Hammer")
    if (!_RENDER_PRINT)
      FCG_Hammer();
    else
      rotate([0,90,0])
      translate([-FCG_HammerCockedX,0,0])
      FCG_Hammer();

  if (_RENDER == "Prints/FCG_HammerTail")
    if (!_RENDER_PRINT)
      FCG_HammerTail();
    else
      rotate([0,-90,0])
      translate([-FCG_HammerTailMinX,0,0])
      FCG_HammerTail();

  if (_RENDER == "Prints/FCG_ChargingHandle")
    if (!_RENDER_PRINT)
      FCG_ChargingHandle();
    else
      translate([ReceiverLength(),0,-ReceiverTopSlotHeight()+ReceiverTopSlotHorizontalHeight()])
      FCG_ChargingHandle();

  if (_RENDER == "Prints/FCG_Disconnector")
    if (!_RENDER_PRINT)
      FCG_Disconnector();
    else
      rotate([90,0,0])
      translate([-FCG_DisconnectorPivotX,-FCG_DisconnectorOffsetY,-FCG_DisconnectorPivotZ])
      FCG_Disconnector();

  if (_RENDER == "Prints/FCG_FiringPinCollar")
    if (!_RENDER_PRINT)
      FCG_FiringPinCollar();
    else
      rotate([0,90,0])
      translate([FiringPinTravel(),0,0])
      FCG_FiringPinCollar();

  // *********************
  // * Fixtures and Jigs *
  // *********************  
  if (_RENDER == "Jigs/FCG_FiringPin")
  FCG_FiringPinJig();
  
  if (_RENDER == "Jigs/FCG_Sear")
  FCG_SearJig();
  
  if (_RENDER == "Jigs/FCG_HammerSleeve")
  FCG_HammerSleeveJig();

  if (_RENDER == "Fixtures/FCG_RecoilPlate")
  FCG_RecoilPlate_Fixture();

  if (_RENDER == "Fixtures/FCG_RecoilPlate_GangFixture")
  FCG_RecoilPlate_GangFixture();

  if (_RENDER == "Fixtures/FCG_RecoilPlate_TapGuide")
  FCG_RecoilPlate_TapGuide();

  if (_RENDER == "Projections/FCG_RecoilPlate")
  projection() rotate([0,90,0])
  RecoilPlate(template=true, contoured=FCG_RECOIL_PLATE_CONTOURED);

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/FCG_DisconnectorTripBolt")
  FCG_DisconnectorTripBolt();

  if (_RENDER == "Hardware/FCG_DisconnectorPivotPin")
  FCG_DisconnectorPivotPin();

  if (_RENDER == "Hardware/FCG_DisconnectorSpring")
  FCG_DisconnectorSpring();

  if (_RENDER == "Hardware/FCG_HammerBolt")
  FCG_HammerBolt();

  if (_RENDER == "Hardware/FCG_HammerSpring")
  FCG_HammerSpring();

  if (_RENDER == "Hardware/FCG_ActionRod")
  ActionRod();

  if (_RENDER == "Hardware/FCG_Sear")
  Sear();

  if (_RENDER == "Hardware/FCG_SearPin")
  SearPin();

  if (_RENDER == "Hardware/FCG_SearReturnSpring")
  SearReturnSpring();

  if (_RENDER == "Hardware/FCG_FiringPin")
  FiringPin();

  if (_RENDER == "Hardware/FCG_FiringPinSpring")
  FiringPinSpring();

  if (_RENDER == "Hardware/FCG_RecoilPlateCenterBolts")
  RecoilPlateCenterBolts();

  if (_RENDER == "Hardware/FCG_RecoilPlateSideBolts")
  RecoilPlateSideBolts();

  if (_RENDER == "Hardware/FCG_RecoilPlate")
  RecoilPlate();

  if (_RENDER == "Hardware/FCG_ChargingHandleBolt")
  FCG_ChargingHandleBolt();

  if (_RENDER == "Hardware/FCG_ChargingHandleSpring")
  FCG_ChargingHandleSpring();
}
