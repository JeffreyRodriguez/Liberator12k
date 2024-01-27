include <../Meta/Common.scad>;

use <../Shapes/Teardrop.scad>;
use <../Shapes/Chamfer.scad>;
use <../Shapes/Components/Pivot.scad>;
use <../Tooling/Jigs/Square Rod Jig.scad>;
use <../Vitamins/Bearing.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Springs.scad>;
use <Lower.scad>;
use <Receiver.scad>;

// POV -50,350,125,-75,0,-10

/* [Export] */

// Select a part, Render (F6), then Export to STL (F7)
_RENDER = ""; // ["", "Prints/Housing", "Prints/ChargingHandle", "Prints/Disconnector", "Prints/Hammer", "Prints/HammerTail", "Prints/FiringPinCollar", "Prints/Trigger", "Prints/TriggerMiddle", "Jigs/FiringPin", "Jigs/Sear", "Jigs/HammerSleeve", "Fixtures/RecoilPlate", "Fixtures/RecoilPlate_GangFixture", "Fixtures/RecoilPlate_TapGuide", "Projections/RecoilPlate"]

// Reorient the part for printing?
_RENDER_PRINT = true;

/* [Assembly] */
_SHOW_TRIGGER = true;
_SHOW_TRIGGER_MIDDLE = true;
_SHOW_SEAR = true;
_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_HOUSING_BOLTS = true;
_SHOW_DISCONNECTOR = true;
_SHOW_DISCONNECTOR_HARDWARE = true;
_SHOW_HAMMER = true;
_SHOW_CHARGING_HANDLE = true;
_SHOW_HAMMER_TAIL = true;
_SHOW_ACTION_ROD = false;
_SHOW_FIRING_PIN = true;
_SHOW_RECOIL_PLATE = true;
_SHOW_RECOIL_PLATE_BOLTS = true;
_SHOW_RECEIVER      = true;
_SHOW_LOWER         = true;
_SHOW_LOWER_HARDWARE = false;

/* [Transparency] */
_ALPHA_RECEIVER = 0.15; // [0:0.1:1]
_ALPHA_LOWER = 0.15; // [0:0.1:1]
_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]
_ALPHA_RECOIL_PLATE = 1; // [0:0.1:1]
_ALPHA_Hammer = 1; // [0:0.1:1]
_ALPHA_TRIGGER = 0.15; // [0:0.1:1]

/* [Cutaway] */
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_Disconnector = false;
_CUTAWAY_Hammer = false;
_CUTAWAY_Hammer_CHARGER = false;
_CUTAWAY_RECEIVER = false;
_CUTAWAY_LOWER = false;
_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_FIRING_PIN = false;
_CUTAWAY_FIRING_PIN_SPRING = false;

/* [Vitamins] */
VITAMIN_UNITS = "Inches";  // ["Inches", "Millimeters"]
Hammer_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"]
Hammer_BOLT_CLEARANCE_ = 0.015;
Hammer_BOLT_CLEARANCE = UnitSelect(Hammer_BOLT_CLEARANCE_, UnitType(VITAMIN_UNITS));

CHARGING_HANDLE_BOLT = "#8-32"; // ["M4", "#8-32"]
CHARGING_HANDLE_BOLT_CLEARANCE_ = 0.015;
CHARGING_HANDLE_BOLT_CLEARANCE = UnitSelect(CHARGING_HANDLE_BOLT_CLEARANCE_, UnitType(VITAMIN_UNITS));

ACTION_ROD_BOLT = "#8-32"; // ["M4", "#8-32"]
ACTION_ROD_BOLT_CLEARANCE_ = 0.015;
ACTION_ROD_BOLT_CLEARANCE = UnitSelect(ACTION_ROD_BOLT_CLEARANCE_, UnitType(VITAMIN_UNITS));

RECOIL_PLATE_BOLT = "#8-32"; // ["M4", "#8-32"]
RECOIL_PLATE_BOLT_CLEARANCE_ = 0.015;
RECOIL_PLATE_BOLT_CLEARANCE = UnitSelect(RECOIL_PLATE_BOLT_CLEARANCE_, UnitType(VITAMIN_UNITS));

// Spring Clearances
Disconnector_SPRING_CLEARANCE_ = 0.005;
Disconnector_SPRING_CLEARANCE = UnitSelect(Disconnector_SPRING_CLEARANCE_, UnitType(VITAMIN_UNITS));

HAMMER_SPRING_CLEARANCE_ = 0.0125;
HAMMER_SPRING_CLEARANCE = UnitSelect(HAMMER_SPRING_CLEARANCE_, UnitType(VITAMIN_UNITS));

HAMMER_BOLT_SLEEVE_DIAMETER_ = 0.28125;
HAMMER_BOLT_SLEEVE_DIAMETER = UnitSelect(HAMMER_BOLT_SLEEVE_DIAMETER_, UnitType(VITAMIN_UNITS));

HAMMER_BOLT_SLEEVE_CLEARANCE_ = 0.01;
HAMMER_BOLT_SLEEVE_CLEARANCE = UnitSelect(HAMMER_BOLT_SLEEVE_CLEARANCE_, UnitType(VITAMIN_UNITS));

HAMMER_BOLT_HEAD = "flat"; // ["flat", "hex", "socket"]
HAMMER_BOLT_NUT = "heatset"; // ["heatset", "none"]

// Firing pin head thickness
FIRING_PIN_HEAD_THICKNESS_ = 0.025; // 6D Box Nail
FIRING_PIN_HEAD_THICKNESS = UnitSelect(FIRING_PIN_HEAD_THICKNESS_, UnitType(VITAMIN_UNITS));

// Firing pin diameter
FIRING_PIN_DIAMETER_ = 0.095; // 6D Box Nail
FIRING_PIN_DIAMETER = UnitSelect(FIRING_PIN_DIAMETER_, UnitType(VITAMIN_UNITS));

// Firing pin clearance
FIRING_PIN_CLEARANCE_ = 0.01;
FIRING_PIN_CLEARANCE = UnitSelect(FIRING_PIN_CLEARANCE_, UnitType(VITAMIN_UNITS));

// Shaft collar diameter
FIRING_PIN_BODY_DIAMETER_ = 0.3125;
FIRING_PIN_BODY_DIAMETER = UnitSelect(FIRING_PIN_BODY_DIAMETER_, UnitType(VITAMIN_UNITS));

// Shaft collar width
FIRING_PIN_BODY_LENGTH_ = 1;
FIRING_PIN_BODY_LENGTH = UnitSelect(FIRING_PIN_BODY_LENGTH_, UnitType(VITAMIN_UNITS));

RECOIL_PLATE_CONTOURED = true;

SEAR_WIDTH_ = 0.2501; // TODO: Allow picking metric version? 0.23622in or 6mm?
SEAR_WIDTH = UnitSelect(SEAR_WIDTH_, UnitType(VITAMIN_UNITS));

SEAR_CLEARANCE_ = 0.005;
SEAR_CLEARANCE = UnitSelect(SEAR_CLEARANCE_, UnitType(VITAMIN_UNITS));

SEAR_PIN_DIAMETER_ = 0.09375;
SEAR_PIN_DIAMETER = UnitSelect(SEAR_PIN_DIAMETER_, UnitType(VITAMIN_UNITS));

SEAR_PIN_CLEARANCE_ = 0.01;
SEAR_PIN_CLEARANCE = UnitSelect(SEAR_PIN_CLEARANCE_, UnitType(VITAMIN_UNITS));

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
function HammerBolt() = BoltSpec(Hammer_BOLT);
assert(HammerBolt(), "HammerBolt() is undefined. Unknown Hammer_BOLT?");

function ChargingHandleBolt() = BoltSpec(CHARGING_HANDLE_BOLT);
assert(ChargingHandleBolt(), "HammerBolt() is undefined. Unknown Hammer_BOLT?");

function DisconnectorTripBolt() = BoltSpec(ACTION_ROD_BOLT);
assert(DisconnectorTripBolt(), "DisconnectorTripBolt() is undefined. Unknown ACTION_ROD_BOLT?");

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

/* [Fine Tuning] */
HammerLength=2;

function HammerTailLength() = 0.625;
HammerTailMinX = -ReceiverLength();
HammerTailMaxX = HammerTailMinX-HammerTailLength();

HammerFiredX  = FiringPinMinX();
HammerCockedX = -(1.6+0.5)-0.125;

HammerTravelX = abs(HammerCockedX-HammerFiredX);
HammerOvertravelX = 0.25;

HammerSpringHammerInsetLength = 11/16;
HammerSpringHammerTailInsetLength = 0.25;

DisconnectorOffsetY = -0.125;
DisconnectorOffset = 0.825;
DisconnectorPivotZ = 0.5;
DisconnectorPivotAngle=-6;
DisconnectorThickness = 0.5;
DisconnectorHeight = 0.25;
DisconnectorTripBackset = 0.1875;
disconnectDistance = 0.125;
DisconnectorExtension = 0;
DisconnectorPivotX = -DisconnectorOffset;
DisconnectorLength = abs(HammerCockedX-DisconnectorPivotX)
                   + disconnectDistance
                   + DisconnectorExtension;

DisconnectorSpringY = DisconnectorOffsetY
                        + SpringOuterDiameter(spring=DisconnectorSpringSpec())
                        + (1/16);



// Animation timing
HammerChargeStart = 0.25;


// Shorthand: Measurements
function HammerTravel(overtravel=false) = HammerTravelX + (overtravel?HammerOvertravelX:0);

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

function RecoilPlateHoles(spindleZ=-1) = [
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
module DisconnectorTripBolt(cutaway=false, cutter=false, teardrop=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([-0.3125,
             -(ActionRodWidth()/2),
             ActionRodZ()])
  rotate([-90,0,0])
  NutAndBolt(bolt=DisconnectorTripBolt(), boltLength=0.25,
             head="socket",
             clearance=clear, teardrop=cutter);
}
module DisconnectorPivotPin(cutaway=false, cutter=false, teardrop=false, clearance=0.005) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver")
  translate([DisconnectorPivotX, 0, DisconnectorPivotZ])
  rotate([90,0,0])
  linear_extrude(height=cutter?ReceiverID():ReceiverTopSlotWidth(), center=true)
  Teardrop(r=(3/32/2)+clear, enabled=teardrop);
}
module DisconnectorSpring(cutaway=false, cutter=false, clearance=Disconnector_SPRING_CLEARANCE) {
  color("Silver") RenderIf(!cutter)
  translate([-(3/16),
             DisconnectorSpringY,
             DisconnectorPivotZ-0.125-0.125])
  Spring(spring=DisconnectorSpringSpec(), compressed=true, cutter=cutter, clearance=clearance);
}
module HammerBolt(clearance=Hammer_BOLT_CLEARANCE, head=HAMMER_BOLT_HEAD, nut=HAMMER_BOLT_NUT, boltLength=4.5, cutter=false, cutaway=false) {
  boltHeadAdjustment = head == "hex"    ? BoltHexHeight(HammerBolt())
                     : head == "socket" ? BoltSocketCapHeight(HammerBolt())
                     : 0;

  translate([HammerCockedX+ManifoldGap()
             -boltHeadAdjustment,0,0])
  rotate([0,90,0])
  rotate(30)
  NutAndBolt(bolt=HammerBolt(), boltLength=boltLength+ManifoldGap(2),
             head=head, nut=nut,
             nutBackset=3.25+boltHeadAdjustment,
             nutHeightExtra=(cutter?1:0),
             capOrientation=true,
             clearance=(cutter?clearance:0),
             doRender=!cutter);

  translate([HammerCockedX-boltLength+NutHexHeight(HammerBolt())+ManifoldGap()
             -boltHeadAdjustment,0,0])
  rotate([0,-90,0])
  color("Silver")
  RenderIf(!cutter)
  NutAcorn(spec=HammerBolt());
}
module HammerBoltSleeve(alpha=1) {
  translate([HammerCockedX-1.25,0,0])
  rotate([0,-90,0])
  color("Goldenrod", alpha)
  cylinder(r=9/32/2, h=3);
}

module HammerSpring() {
  color("Silver")
  translate([HammerCockedX-HammerLength + 11/16,0,0])
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
module HousingBolts(bolt=RecoilPlateBolt(), boltLength=6, template=false, cutter=false, clearance=RECOIL_PLATE_BOLT_CLEARANCE) {
  bolt     = template ? BoltSpec("Template") : bolt;
  boltNut = template ? "none"               : "acorn";

  color("Silver")
  RenderIf(!cutter)
  for (M = [0,1]) mirror([0,M,0])
  translate([RecoilPlateLength()+0.25+ManifoldGap(),RecoilPlateBoltOffsetY(),0]) {
    rotate([0,-90,0])
    NutAndBolt(bolt=bolt, boltLength=boltLength+ManifoldGap(2),
          head="none", nut=boltNut, capHeightExtra=(cutter?1:0),
          clearance=cutter?clearance:0);

    children();
  }
}
module RecoilPlate(length=RecoilPlateLength(), spindleZ=-1, contoured=true, cutter=false, cutaway=false, alpha=1, clearance=0.005, template=false, templateHoleDiameter=0.08) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("LightSteelBlue", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  difference() {

    // Contoured plate
		translate([0.25,0,0])
    union() {

      // Body
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/32, h=length);

      // Wings
			wingWidth = (ReceiverIR()+Receiver_SideSlotDepth()-clearance)*2;
			wingHeight = Receiver_SideSlotHeight()-(clearance*2);
      translate([0,
                 -wingWidth/2,
                 -wingHeight/2])
      ChamferedCube([length,
                     wingWidth,
                     wingHeight],
                    r=1/32,
			              teardropFlip=[true, true, true]);
    }

		FiringPin(cutter=true);
		HousingBolts(cutter=true);
  }
}
module ChargingHandleBolt(bolt=ChargingHandleBolt(), boltLength=0.25, cutter=false, clearance=CHARGING_HANDLE_BOLT_CLEARANCE) {
  translate([-0.75,-0.25,ReceiverTopSlotHeight()])
  mirror([0,0,1])
  NutAndBolt(bolt=bolt, boltLength=boltLength+ManifoldGap(2),
        head="socket", nut="heatset",
        clearance=cutter?clearance:0,
        doRender=!cutter);
}
module ChargingHandleSpring(cutter=false, clearance=0.002) {
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

//**********
//* Shapes *
//**********
module TriggerBase(clearance=0.015, frontLeg=true, backLeg=true) {
  frontExtra = 0.3125;
  backHeight = 0.375;

	difference() {
		union() {

			// Front Leg
			if (frontLeg)
			translate([-LowerMaxX()+ReceiverLugRearMaxX()+TriggerTravel()+clearance,
			           -(TriggerWidth()/2),
			           LowerOffsetZ()-TriggerHeight()+clearance])
			ChamferedCube([ReceiverLugFrontMinX()-ReceiverLugRearMaxX()-TriggerTravel()-(clearance*2),
			               TriggerWidth(),
			               TriggerHeight()-(clearance*2)], r=1/16);

			// Body
			translate([-LowerMaxX(),
			           -(TriggerWidth()/2),
			           LowerOffsetZ()-TriggerHeight()+clearance])
			ChamferedCube([ReceiverLugFrontMinX()+frontExtra,
			               TriggerWidth(),
			               TriggerHeight()-abs(ReceiverLugFrontZ())-clearance], r=1/16);


			// Back Leg
			if (backLeg)
			translate([-LowerMaxX()+ReceiverLugRearMaxX()-TriggerTravel()-clearance,
			           -(TriggerWidth()/2),
			           LowerOffsetZ()-TriggerHeight()+clearance])
			ChamferedCube([abs(ReceiverLugRearMinX()),
			               TriggerWidth(),
			               backHeight-clearance], r=1/16);
		}


		// Trigger finger chamfer
		translate([-LowerMaxX()+TriggerFingerRadius()+TriggerTravel()+SearWidth()+0.5-0.15,
							 -TriggerWidth()/2, LowerOffsetZ()-GripCeiling()-TriggerFingerRadius()])
		rotate([-90,0,0])
		ChamferedCircularHole(r1=TriggerFingerRadius(), r2=1/16,
													h=TriggerWidth());
	}
}
///

//*****************
//* Printed Parts *
//*****************
module FiringPinCollar(cutter=false, clearance=FIRING_PIN_CLEARANCE, template=false, cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  flareRadius = FiringPinBodyRadius()+(1/16);
	cutLength = cutter?FiringPinTravel()+0.25:0;

  color("Olive", alpha)
  RenderIf(!cutter)
  Cutaway(cutaway)
  difference() {

    union() {

      // Body
      translate([-FiringPinHousingLength()-FiringPinTravel()+cutLength+0.025,0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=FiringPinBodyRadius()+clear, r2=1/32,
               h=FiringPinBodyLength() -0.025
                + (cutter?0.25+cutLength:0)
                + ManifoldGap());

      // Flare
      intersection() {
				cutLength = cutter?FiringPinTravel()+0.25:0;
        union() {
          translate([-FiringPinTravel()-(1/8),0,0])
          rotate([0,-90,0])
          cylinder(r1=flareRadius+clear, r2=FiringPinBodyRadius()+clear,
                   h=0.125);

          // Flare travel cutter
          translate([-FiringPinTravel()-(1/8),0,0])
          rotate([0,90,0])
          cylinder(r=flareRadius+clear,
                   h=0.125+cutLength+ManifoldGap(2));
        }

        // Square it off
        translate([cutLength,-flareRadius-clear,-FiringPinBodyRadius()-clear])
        mirror([1,0,0])
        cube([(1/8)+(1/8)+FiringPinTravel()+cutLength+ManifoldGap(),
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
module ChargingHandle(clearance=0.005, alpha=1) {
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
    ChamferedSquareHole([HammerTravelX+0.5, 0.25+(clearance*2)],
                          ReceiverTopSlotHorizontalHeight()-clear2,
                          corners=false, center=false, chamferRadius=1/32);

    translate([fingerHoleX,0,bottomZ+clear])
    ChamferedCircularHole(r1=fingerHoleRadius, r2=1/16,
                          h=fingerHoleHeight-clear2);

    ChargingHandleSpring(cutter=true);

    ChargingHandleBolt(cutter=true);
  }
}
module ChargingHandleMiddle(clearance=0.005) {
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
    ChamferedSquareHole([HammerTravelX+0.5, 0.25+(clearance*2)],
                          ReceiverTopSlotHorizontalHeight()-clear2,
                          corners=false, center=false, chamferRadius=1/32);

    translate([fingerHoleX,0,bottomZ+clear])
    ChamferedCircularHole(r1=fingerHoleRadius, r2=1/16, h=fingerHoleHeight-clear2);

  }
}
module Hammer(cutter=false, clearance=Inches(0.01), cutaway=false, alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

	cutHeight = cutter ? 0.125 : 0;
	cutLength = cutter ? HammerTravel() : 0;
	CR = cutter ? 1/32 : 1/16;

  // Head
  color("Olive", alpha)
  RenderIf(!cutter) Cutaway(cutaway)
  difference() {
    hull() {

      // Body
      translate([HammerCockedX+cutLength,0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=(ReceiverTopSlotWidth()/2)-clearance, r2=CR,
                         h=HammerLength+cutLength,
                       teardropTop=true, teardropBottom=true);

      // Charging Tip
      translate([HammerCockedX+cutLength, -(ReceiverTopSlotWidth()/2)+clearance, 0])
      mirror([1,0,0])
      ChamferedCube([HammerLength+cutLength,
			               ReceiverTopSlotWidth()-(clearance*2),
		                 0.625-clearance+cutHeight],
                     r=CR, teardropFlip=[false,true,true]);

    }

		// Side Tracks
		for (M = [0,1]) mirror([0,M,0])
		translate([HammerCockedX+cutLength+clear,
		          (ReceiverTopSlotWidth()/2)-0.125-clear,
		          0.125-clear])
		rotate([0,-90,0])
		ChamferedSquareHole(sides=[0.1875+clear2,
															 0.25],
												length=HammerLength+cutLength, chamferRadius=CR,
												center=false, corners=false);

		if (!cutter) {

			// Trigger Slot
			translate([HammerCockedX+0.125,-0.375/2,-BoltFlatHeadRadius(HammerBolt())])
			mirror([1,0,0])
			mirror([0,0,1])
			ChamferedCube([HammerLength+0.25, 0.375, ReceiverIR()], r=1/32);

			// Main Spring Hole
			translate([HammerCockedX-HammerLength + HammerSpringHammerInsetLength,0,0])
			rotate([0,270,0])
			Spring(spring=HammerSpringSpec(), clearance=HAMMER_SPRING_CLEARANCE, cutter=true, compressed=true);

			// Disconnector chamfered hole
			translate([HammerCockedX,0,DisconnectorPivotZ])
			rotate([0,-90,0])
			ChamferedSquareHole(sides=[DisconnectorHeight+(clearance*2),
																 DisconnectorHeight+(clearance*2)],
													length=DisconnectorLength, chamferRadius=1/16,
													center=true, corners=false, chamferTop=false);


			translate([-HammerTravelX,0,0])
			Disconnector(cutter=true, cutaway=false);

			HammerBolt(cutter=true);
		}
  }
}
module HammerTail(clearance=Inches(0.01), cutaway=false, alpha=1) {
  color("Chocolate", alpha)
  render() Cutaway(cutaway)
  difference() {
    union() {
      intersection() {

        // Body
        translate([HammerTailMinX,0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=ReceiverIR()-clearance, r2=1/8,
                           h=HammerTailLength(),
                          teardropTop=true, teardropBottom=true);

        // Only the top half
        translate([HammerTailMinX,-(ReceiverIR()), 0])
        cube([HammerTailLength(), ReceiverID(),ReceiverIR()]);
      }

      // Top Stop
      translate([HammerTailMinX,
                 -((ReceiverTopSlotWidth()/2)-clearance),
                 0])
      ChamferedCube([HammerTailLength(),
                     (ReceiverTopSlotWidth()-(clearance*2)),
                     ReceiverTopSlotHeight()-ReceiverTopSlotHorizontalHeight()-clearance],
                    r=1/16, teardropFlip=[true, true, true]);

      // Wings
      translate([HammerTailMinX,
                 -(ReceiverIR()+Receiver_SideSlotDepth()-clearance),
                 -(Receiver_SideSlotHeight()/2)+clearance])
      ChamferedCube([HammerTailLength(),
                     (ReceiverIR()+Receiver_SideSlotDepth()-clearance)*2,
                     Receiver_SideSlotHeight()-(clearance*2)],
                    r=1/16,teardropFlip=[true, true, true]);
    }

    // Hammer Bolt Hole
    translate([HammerTailMinX,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(
      r1=(HAMMER_BOLT_SLEEVE_DIAMETER/2)+HAMMER_BOLT_SLEEVE_CLEARANCE,
      r2=1/32, h=HammerTailLength());

    // Main Spring Hole
    translate([HammerTailMinX+HammerTailLength() - HammerSpringHammerTailInsetLength,0,0])
    rotate([0,90,0])
    Spring(spring=HammerSpringSpec(), clearance=HAMMER_SPRING_CLEARANCE, cutter=true, compressed=true);
  }
}
module Disconnector(pivotFactor=0, cutter=false, clearance=0.005, alpha=1, cutaway=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  Pivot(factor=pivotFactor,
        pivotX=DisconnectorPivotX,
        pivotZ=DisconnectorPivotZ,
        angle=DisconnectorPivotAngle) {

    children();

    color("Olive", alpha)
    RenderIf(!cutter)
    Cutaway(cutaway)
    difference() {
      union() {

        // Trip
        hull() {

          // Peak
          translate([(cutter?(1/64):-DisconnectorTripBackset+clear),
                     DisconnectorOffsetY+0.25-clear,
                     DisconnectorPivotZ-0.125-clear])
          mirror([1,0,0])
          ChamferedCube([(cutter?DisconnectorTripBackset+clear2:(1/16)),
                0.25+clear2,
                ActionRodZ()-DisconnectorPivotZ+clear2],
          r=1/64);

          // Base
          translate([clear,
                     DisconnectorOffsetY+0.25-clear,
                     DisconnectorPivotZ-0.125-clear])
          mirror([1,0,0])
          ChamferedCube([0.375+clear2,
                0.25+clear2,
                0.25+clear2], r=1/64);
        }

        // Pivot Extension
        translate([-1,
                   DisconnectorOffsetY-clear,
                   DisconnectorPivotZ-0.125-clear])
        ChamferedCube([1+(cutter?(1/16):0),
              (5/16)+clear2,
              0.25+clear2], r=1/64);

        // Hammer Stop Prong
        translate([clear,
                   DisconnectorOffsetY-clear,
                   DisconnectorPivotZ-0.125-clear])
        mirror([1,0,0])
        ChamferedCube([abs(DisconnectorPivotX)+DisconnectorLength+clear2,
              0.25+clear2,
              DisconnectorHeight+clear2], r=1/64);
      }

      if (!cutter) {
        DisconnectorPivotPin(cutter=true, clearance=0.002);
        DisconnectorSpring(cutter=true);

        // Trim the back edge to clear pivot
        translate([0,-ReceiverIR(),DisconnectorPivotZ+0.125])
        rotate([0,-DisconnectorPivotAngle,0])
        mirror([0,0,1])
        cube([1, ReceiverID(), 1]);
      }
    }
  }
}
module Housing(clearance=0.01, cutaway=false, alpha=1) {

	CR = 1/16;

  color("Chocolate", alpha) render()
  Cutaway(cutaway)
  difference() {

    // Insert plug
    union() {

			translate([0.25,0,0])
			rotate([0,-90,0])
			ChamferedCylinder(r1=ReceiverIR(), r2=CR, h=4.5);

      // Disconnector support
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
               DisconnectorSpringY-(SpringOuterDiameter(spring=DisconnectorSpringSpec())/2)-0.005,
               DisconnectorPivotZ-0.125-0.125])
    mirror([1,0,0])
    ChamferedCube([0.3125, SpringOuterDiameter(spring=DisconnectorSpringSpec())+0.01, 0.25], r=1/32);

		Hammer(cutter=true);

    FiringPin(cutter=true);
    FiringPinCollar(cutter=true);

    for (PF = [0,1])
    Disconnector(pivotFactor=PF, cutter=true);

    DisconnectorSpring(cutter=true);
    DisconnectorPivotPin(cutter=true, teardrop=true);

    ActionRod(cutter=true);

    HousingBolts(cutter=true);
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
module Trigger(clearance=0.015, alpha=1) {
  clearance2 = clearance*2;

  color("Olive", alpha)
  render()
  difference() {
		TriggerBase();

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
module FiringPinJig(width=0.75, height=1.45, clearance=0.005) {
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
module HammerSleeveJig(width=1, height=2, clearance=0.005) {
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

module SearJig(width=0.75, height=1) {
  SquareRodJig(offset=abs(SearPinOffsetZ()+LowerOffsetZ()));
}
module RecoilPlate_TapGuide(xyz = [0.25,0.25,1.5], holeRadius=0.1770/2, spindleZ=-1, contoured=RECOIL_PLATE_CONTOURED) {
  width = RecoilPlateWidth() + (xyz.x*2);
  length = RecoilPlateHeight() + (xyz.y*2);
  height = xyz.z;


  TemplateHoles = RecoilPlateHoles(spindleZ=spindleZ);

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
module RecoilPlate_Fixture(xyz = [1,0.5,0.5], holeRadius=0.1875, spindleZ=-1, contoured=RECOIL_PLATE_CONTOURED) {
  width = RecoilPlateWidth() + (xyz.x*2);
  length = RecoilPlateHeight() + (xyz.y*2);
  height = xyz.z;


  TemplateHoles = RecoilPlateHoles(spindleZ=spindleZ);

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
module RecoilPlate_GangFixture(xyz = [0.25,0.75,0.375], gang=[1,1], holeRadius=0.1, spindleZ=-1, contoured=RECOIL_PLATE_CONTOURED) {

  offsetPlateX = (RecoilPlateHeight()/2)-0.125;
  offsetGapX = 0.125;
  offsetGapY = 0.1875;
  offsetX = RecoilPlateHeight()+offsetGapX;
  offsetY = Millimeters(59);

  length = (offsetX*gang.x)-offsetGapX+(xyz.x*2);
  width  = (offsetY*gang.y)-offsetGapY+(xyz.y*2);
  height = xyz.z;


  TemplateHoles = RecoilPlateHoles(spindleZ=spindleZ);

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

module Animate_ChargingHandle() {
  translate([SubAnimate(ANIMATION_STEP_CHARGE, start=HammerChargeStart)*-(HammerTravelX+HammerOvertravelX),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET)*(HammerTravelX+HammerOvertravelX),0,0])
  children();
}

module SimpleFireControlAssembly(recoilPlateLength=RecoilPlateLength(), hardware=true, prints=true, actionRod=_SHOW_ACTION_ROD, recoilPlate=_SHOW_RECOIL_PLATE, cutaway=false, alpha=1) {
  disconnectStart = 0.8;
  disconnectLetdown = 0.2;
  connectStart = 0.99;

  DisconnectorTripAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.0, end=0.2)
                     - SubAnimate(ANIMATION_STEP_CHARGER_RESET,
                                  start=connectStart);

  DisconnectorAF = SubAnimate(ANIMATION_STEP_CHARGE, start=0.99)
                 - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=connectStart, end=1);

  chargeAF = Animate(ANIMATION_STEP_CHARGE)
           - Animate(ANIMATION_STEP_CHARGER_RESET);

  *ChargingHandleSpring();

  if (_SHOW_CHARGING_HANDLE){
    if (hardware)
    Animate_ChargingHandle()
    ChargingHandleBolt();

    if (prints)
    Animate_ChargingHandle()
    ChargingHandle(alpha=alpha);
  }

  TriggerGroup(hardware=hardware, prints=prints, searLength=1.67188, alpha=alpha);

  if (actionRod)
  translate([-chargerTravel*chargeAF,0,0]) {
    if (hardware)
    ActionRod();

    if (hardware)
    DisconnectorTripBolt();

    children();
  }

  if (hardware && _SHOW_DISCONNECTOR_HARDWARE)
  DisconnectorSpring();

  if (hardware && _SHOW_DISCONNECTOR_HARDWARE)
  DisconnectorPivotPin();

  if (prints && _SHOW_DISCONNECTOR)
  Disconnector(pivotFactor=DisconnectorAF, alpha=alpha);

  // Linear Hammer
  if (_SHOW_HAMMER) {

    translate([Animate(ANIMATION_STEP_FIRE)*HammerTravelX,0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGE, start=HammerChargeStart)*-(HammerTravelX+HammerOvertravelX),0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1)*(HammerOvertravelX-disconnectDistance),0,0])
    translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.97, end=1)*disconnectDistance,0,0]) {
      if (hardware)
      HammerBolt();

      if (hardware)
      HammerSpring();

      if (hardware)
      HammerBoltSleeve();

      if (prints)
      Hammer(cutaway=_CUTAWAY_Hammer, alpha=min(alpha,_ALPHA_Hammer));
    }
  }

  if (_SHOW_FIRING_PIN) {
    translate([(3/32)*SubAnimate(ANIMATION_STEP_FIRE, start=0.95),0,0])
    translate([-(3/32)*SubAnimate(ANIMATION_STEP_CHARGE, start=0.07, end=0.2),0,0]) {

      if (hardware)
      FiringPin(cutaway=_CUTAWAY_FIRING_PIN);

      if (prints)
      FiringPinCollar(cutaway=_CUTAWAY_FIRING_PIN, alpha=alpha);
    }

    if (hardware)
    FiringPinSpring();
  }

  if (hardware && _SHOW_HOUSING_BOLTS)
  HousingBolts();

  if (hardware && recoilPlate)
  RecoilPlate(length=recoilPlateLength, contoured=RECOIL_PLATE_CONTOURED, cutaway=_CUTAWAY_RECOIL_PLATE, alpha=_ALPHA_RECOIL_PLATE);

  if(prints && _SHOW_HAMMER_TAIL)
  HammerTail(cutaway=_CUTAWAY_Hammer, alpha=min(alpha,_ALPHA_Hammer));

  if (prints && _SHOW_FIRE_CONTROL_HOUSING)
  Housing(alpha=min(alpha,_ALPHA_FIRING_PIN_HOUSING), cutaway=_CUTAWAY_FIRING_PIN_HOUSING);
}
///

//*************
//* Rendering *
//*************
ScaleToMillimeters()
if ($preview) {

  SimpleFireControlAssembly(alpha=_ALPHA_TRIGGER);

  if (_SHOW_LOWER) {
    LowerMount(hardware=_SHOW_LOWER_HARDWARE, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
    Lower(hardware=_SHOW_LOWER_HARDWARE, cutaway=_CUTAWAY_LOWER, alpha=_ALPHA_LOWER);
  }

  if (_SHOW_RECEIVER)
  ReceiverAssembly(hardware=false, cutaway=_CUTAWAY_RECEIVER, alpha=_ALPHA_RECEIVER);
} else {

  // *****************
  // * Printed Parts *
  // *****************
  if (_RENDER == "Prints/TriggerMiddle")
    if (!_RENDER_PRINT)
      SearSupportTab();
    else
      rotate(180)
      translate([LowerMaxX(),-TriggerHeight()/2,0.12])
      rotate([90,0,00])
      SearSupportTab();

  if (_RENDER == "Prints/Trigger")
    if (!_RENDER_PRINT)
      Trigger();
    else
      translate([LowerMaxX(),0,-LowerOffsetZ()+TriggerHeight()])
      Trigger();

  if (_RENDER == "Prints/Housing")
    if (!_RENDER_PRINT)
      Housing();
    else
      rotate([0,-90,0])
      translate([FiringPinHousingLength(),0,0])
      Housing();

  if (_RENDER == "Prints/Hammer")
    if (!_RENDER_PRINT)
      Hammer();
    else
      rotate([0,90,0])
      translate([-HammerCockedX,0,0])
      Hammer();

  if (_RENDER == "Prints/HammerTail")
    if (!_RENDER_PRINT)
      HammerTail();
    else
      rotate([0,-90,0])
      translate([-HammerTailMinX,0,0])
      HammerTail();

  if (_RENDER == "Prints/ChargingHandle")
    if (!_RENDER_PRINT)
      ChargingHandle();
    else
      translate([ReceiverLength(),0,-ReceiverTopSlotHeight()+ReceiverTopSlotHorizontalHeight()])
      ChargingHandle();

  if (_RENDER == "Prints/Disconnector")
    if (!_RENDER_PRINT)
      Disconnector();
    else
      rotate([90,0,0])
      translate([-DisconnectorPivotX,-DisconnectorOffsetY,-DisconnectorPivotZ])
      Disconnector();

  if (_RENDER == "Prints/FiringPinCollar")
    if (!_RENDER_PRINT)
      FiringPinCollar();
    else
      rotate([0,90,0])
      translate([FiringPinTravel(),0,0])
      FiringPinCollar();

  // *********************
  // * Fixtures and Jigs *
  // *********************
  if (_RENDER == "Jigs/FiringPin")
  FiringPinJig();

  if (_RENDER == "Jigs/Sear")
  SearJig();

  if (_RENDER == "Jigs/HammerSleeve")
  HammerSleeveJig();

  if (_RENDER == "Fixtures/RecoilPlate")
  RecoilPlate_Fixture();

  if (_RENDER == "Fixtures/RecoilPlate_GangFixture")
  RecoilPlate_GangFixture();

  if (_RENDER == "Fixtures/RecoilPlate_TapGuide")
  RecoilPlate_TapGuide();

  if (_RENDER == "Projections/RecoilPlate")
  projection() rotate([0,90,0])
  RecoilPlate(template=true, contoured=RECOIL_PLATE_CONTOURED);

  // ************
  // * Hardware *
  // ************
  if (_RENDER == "Hardware/DisconnectorTripBolt")
  DisconnectorTripBolt();

  if (_RENDER == "Hardware/DisconnectorPivotPin")
  DisconnectorPivotPin();

  if (_RENDER == "Hardware/DisconnectorSpring")
  DisconnectorSpring();

  if (_RENDER == "Hardware/HammerBolt")
  HammerBolt();

  if (_RENDER == "Hardware/HammerSpring")
  HammerSpring();

  if (_RENDER == "Hardware/ActionRod")
  ActionRod();

  if (_RENDER == "Hardware/Sear")
  Sear();

  if (_RENDER == "Hardware/SearPin")
  SearPin();

  if (_RENDER == "Hardware/SearReturnSpring")
  SearReturnSpring();

  if (_RENDER == "Hardware/FiringPin")
  FiringPin();

  if (_RENDER == "Hardware/FiringPinSpring")
  FiringPinSpring();

  if (_RENDER == "Hardware/HousingBolts")
  HousingBolts();

  if (_RENDER == "Hardware/RecoilPlate")
  RecoilPlate();

  if (_RENDER == "Hardware/ChargingHandleBolt")
  ChargingHandleBolt();

  if (_RENDER == "Hardware/ChargingHandleSpring")
  ChargingHandleSpring();
}