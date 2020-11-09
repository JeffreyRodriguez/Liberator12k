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
_RENDER = "Assembly"; // ["Assembly", "FireControlHousing", "Disconnector", "RevolverActuator", "Hammer", "HammerGuiderod", "RecoilPlateMockup"]
//$t = 1; // [0:0.01:1]

_SHOW_FIRE_CONTROL_HOUSING = true;
_SHOW_DISCONNECTOR = true;
_SHOW_HAMMER = true;
_SHOW_HAMMER_GUIDEROD = true;
_SHOW_ACTION_ROD = true;
_SHOW_FIRING_PIN = true;

_SHOW_RECOIL_PLATE = true;

/* [Assembly Transparency] */
_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]
_ALPHA_HAMMER = 1; // [0:0.1:1]

/* [Assembly Cutaways] */
_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;

/* [Screws] */
HAMMER_BOLT = "#8-32"; // ["M4", "#8-32", "1/4\"-20"] 
HAMMER_BOLT_CLEARANCE = 0.015;

REVOLVER_ACTUATOR_BOLT = "#8-32"; // ["M4", "#8-32"]
REVOLVER_ACTUATOR_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_TRIP_BOLT = "M3"; // ["M3", "#4-40"] 
DISCONNECTOR_TRIP_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_SPRING_BOLT = "#4-40"; // ["M3", "#4-40"] 
DISCONNECTOR_SPRING_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_SPRING_CLEARANCE = 0.01;

// Firing pin housing bolt
HOUSING_BOLT = "#8-32"; // ["M4", "#8-32"]

// Housing bolt clearance
HOUSING_BOLT_CLEARANCE = 0.015;

// Firing pin diameter
FIRING_PIN_DIAMETER = 0.09375;

// Firing pin clearance
FIRING_PIN_CLEARANCE = 0.015;

// Shaft collar diameter
FIRING_PIN_COLLAR_DIAMETER = 0.375;

// Shaft collar width
FIRING_PIN_COLLAR_WIDTH = 0.1875;

HAMMER_GUIDE_DIAMETER = 0.125;

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 1.5;
function RecoilSpreaderThickness() = 0.5;

// Settings: Lengths
function ChargingRodOffset() =  0.75+RodRadius(ChargingRod());
function ChamferRadius() = 1/16;
function CR() = 1/16;
chargerTravel = 2;

// Calculated: Positions
function FiringPinMinX() = -RecoilSpreaderThickness()-FiringPinHousingLength();


function FireControlGroupBolt() = BoltSpec(HOUSING_BOLT);
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


// Settings: Vitamins
function HammerBolt() = BoltSpec(HAMMER_BOLT);
assert(HammerBolt(), "HammerBolt() is undefined. Unknown HAMMER_BOLT?");

function RevolverActuatorBolt() = BoltSpec(REVOLVER_ACTUATOR_BOLT);
assert(RevolverActuatorBolt(), "RevolverActuatorBolt() is undefined. Unknown REVOLVER_ACTUATOR_BOLT?");

function DisconnectorTripBolt() = BoltSpec(DISCONNECTOR_TRIP_BOLT);
assert(DisconnectorTripBolt(), "DisconnectorTripBolt() is undefined. Unknown DISCONNECTOR_TRIP_BOLT?");

function DisconnectorSpringBolt() = BoltSpec(DISCONNECTOR_SPRING_BOLT);
assert(DisconnectorSpringBolt(), "DisconnectorSpringBolt() is undefined. Unknown DISCONNECTOR_SPRING_BOLT?");

function DisconnectorTripBearing() = Spec_Bearing623();

// Calculated: Positions
function RecoilPlateRearX()  = -RecoilSpreaderThickness();
actionRodZ = 0.75+RodRadius(ActionRod());

hammerFiredX  = FiringPinMinX();
hammerCockedX = -RecoilSpreaderThickness()-LowerMaxX()-0.125;

hammerTravelX = abs(hammerCockedX-hammerFiredX);
hammerOvertravelX = 0.25;
echo("hammerOvertravelX", hammerOvertravelX);

disconnectorOffset = 0.875;
disconnectorPivotZ = -0.125;
disconnectorPivotAngle=-7;
disconnectorThickness = 0.5;
disconnectorHeight = 0.25;
disconnectDistance = 0.125;
disconnectorExtension = 0.25;
disconnectorTripX  = -RecoilSpreaderThickness()-BearingOuterRadius(DisconnectorTripBearing());
disconnectorPivotX = -RecoilSpreaderThickness()-disconnectorOffset;
disconnectorLength = abs(hammerCockedX-disconnectorPivotX)
                   + disconnectDistance
                   + disconnectorExtension;
                   
hammerGuideY = 0.375;
hammerGuideZ = -0.25;
hammerGuideRadius = HAMMER_GUIDE_DIAMETER/2;
hammerGuideLength = 4;

//$t= AnimationDebug(ANIMATION_STEP_CHARGE);
//$t= AnimationDebug(ANIMATION_STEP_CHARGER_RESET, start=0.85);

$fs = UnitsFs()*0.25;

/************
 * Vitamins *
 ************/
module RevolverActionRod(length=10, debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Action Rod
  color("Silver")
  translate([-RecoilSpreaderThickness()-0.5-(cutter?1:0),0,actionRodZ])
  DebugHalf(enabled=debug)
  ActionRod(length=length+ManifoldGap(), clearance=clear, cutter=true);
}
module RevolverActuatorBolt(debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([-RecoilSpreaderThickness()-0.25,
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
module DisconnectorSpringBolt(debug=false, cutter=false, clearance=DISCONNECTOR_SPRING_BOLT_CLEARANCE) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  *color("Silver") RenderIf(!cutter)
  translate([disconnectorTripX, -0.5, actionRodZ+0.375])
  rotate([90,0,0])
  NutAndBolt(bolt=DisconnectorSpringBolt(), boltLength=1,
             head="flat", capOrientation=true,
             clearance=clear, teardrop=cutter);
}

module DisconnectorSpring(debug=false, cutter=false, clearance=DISCONNECTOR_SPRING_CLEARANCE) {
  translate([-RecoilSpreaderThickness()-0.0625,-0.1875+0.01,disconnectorPivotZ-0.125-0.3125])
  mirror([0,1,0])
  mirror([1,0,0])
  ChamferedCube([0.25, 0.25, 0.375+0.02], r=1/32);
}
module DisconnectorTrip(debug=false, cutter=false, clearance=DISCONNECTOR_TRIP_BOLT_CLEARANCE) {
  *color("Silver")
  translate([disconnectorTripX, (disconnectorThickness/2), disconnectorPivotZ])
  rotate([-90,0,0])
  Bearing(spec=DisconnectorTripBearing(),
          solid=cutter, clearance=cutter?BearingClearanceSnug():undef,
          extraHeight=cutter?0.0625+0.01:0);
    
  *color("Silver")
  translate([disconnectorTripX,
             (disconnectorThickness/2)
               +BearingHeight(DisconnectorTripBearing())
               +(BoltFlatHeadHeight(DisconnectorTripBolt())/2),
             disconnectorPivotZ])
  rotate([-90,0,0])
  Bolt(bolt=DisconnectorTripBolt(), length=0.7+ManifoldGap(2),
        head="flat",
        capOrientation=true, clearance=cutter?clearance:0);
}
module RevolverRecoilPlate(firingPinAngle=0, cutter=false, debug=_CUTAWAY_RECOIL_PLATE) {
  color("LightSteelBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([-RecoilPlateThickness()-(cutter?0.01:0),
               -RecoilPlateWidth()/2,
               FrameTopZ()])
    mirror([0,0,1])
    cube([RecoilPlateThickness()+(cutter?(1/8+0.01):0),
          RecoilPlateWidth(),
          FrameTopZ()+1+1]);
    
    echo("Recoil Plate Length: ", FrameTopZ()+1+1);

    if (!cutter) {
      FiringPin(cutter=true);
      FireControlGroupBolts(cutter=true);
    }
  }
}
module HammerBolt(clearance=0.01, cutter=false, debug=false) {
  color("Silver") RenderIf(!cutter)
  translate([hammerCockedX+ManifoldGap(),0,0])
  rotate([0,90,0])
  NutAndBolt(bolt=HammerBolt(), boltLength=2.5, head="flat",
             capOrientation=true, clearance=(cutter?clearance:0));
}
module FiringPin(radius=FiringPinRadius(), cutter=false, clearance=FIRING_PIN_CLEARANCE, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  // Pin
  color("DarkGoldenrod")
  translate([-RecoilSpreaderThickness()-FiringPinHousingLength()-FiringPinTravel(),0,0])
  rotate([0,90,0])
  cylinder(r=radius+clear,
           h=FiringPinLength());

  // Back Collar
  color("Silver")
  DebugHalf(enabled=debug)
  translate([-RecoilSpreaderThickness()-FiringPinHousingLength()-FiringPinTravel(),0,0])
  rotate([0,-90,0])
  cylinder(r=FiringPinCollarRadius()+clear,
           h=FiringPinCollarWidth());

  // Spring
  color("Silver")
  DebugHalf(enabled=debug)
  translate([-(RecoilSpreaderThickness()
            +FiringPinHousingLength()
            -FiringPinHousingBack()),0,0])
  rotate([0,90,0])
  cylinder(r=0.125+clear,
           h=RecoilPlateThickness()
            +FiringPinHousingLength()
            -FiringPinHousingBack());
}
module FireControlGroupBolts(bolt=FireControlGroupBolt(), boltLength=FiringPinHousingLength()+0.5, template=false, cutter=false, clearance=HOUSING_BOLT_CLEARANCE) {
  
  // Central screw, bottom of FCG housing
  color("CornflowerBlue")
  translate([0,0,-FiringPinBoltOffsetZ()])
  rotate([0,-90,0])
  rotate(90)
  Bolt(bolt=bolt, capOrientation=false, head="flat",
       clearance=cutter?clearance:0,
       length=boltLength+ManifoldGap(2));
                                
  // FCG Top Screw
  color("Silver")
  translate([-1.5-ManifoldGap(),0,FrameTopZ()-0.375])
  rotate([0,-90,0])
  Bolt(bolt=BoltSpec("1/4\"-20"), length=1.5+ManifoldGap(2),
        head="flat", clearance=cutter?clearance:0,
        capOrientation=true);

  // FCG Bottom Screw
  color("Silver")
  translate([-0.5-ManifoldGap(),0,-1.75])
  rotate([0,-90,0])
  Bolt(bolt=BoltSpec("1/4\"-20"), length=0.5+ManifoldGap(2),
        head="flat", clearance=cutter?clearance:0,
        capOrientation=true);
}


/*****************
 * Printed Parts *
 *****************/
module RevolverActuator(debug=false, cutter=false, clearance=0.015) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  width = 0.5;
  chamferRadius = 1/16;
  
  color("Green")
  RenderIf(!cutter)
  difference() {
    
    // Long segment along the action rod
    translate([-RecoilSpreaderThickness()-0.5-(cutter?1:0),
               -(width/2)-0.125-clear,
               actionRodZ+0.25+clear])
    mirror([0,0,1])
    ChamferedCube([0.5+(cutter?2:0), width+0.125+clear2, actionRodZ+clear2], r=chamferRadius);
    
    if (!cutter) {
      RevolverActionRod(cutter=true, clearance=0.005);
      RevolverActuatorBolt(cutter=true);
    }
      
  }
}
module Hammer(cutter=false, clearance=UnitsImperial(0.01), debug=_CUTAWAY_HAMMER, alpha=_ALPHA_HAMMER) {
  
  hammerHeadLength=1.75;
  hammerBodyWidth=0.5;
  hammerHeadHeight=ReceiverIR()+0.25;
  
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Head
  color("CornflowerBlue", alpha)
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    translate([hammerCockedX,0,0])        
    rotate([0,-90,0])
    ChamferedCylinder(r1=ReceiverIR()-0.02, r2=1/16,
                      h=hammerHeadLength, $fn=80);
    
    translate([hammerCockedX+0.125,-0.375/2,-BoltFlatHeadRadius(HammerBolt())])
    mirror([1,0,0])
    mirror([0,0,1])
    ChamferedCube([hammerHeadLength+0.25, 0.375, ReceiverIR()], r=1/32);
    
    Disconnector(cutter=true, debug=false, cutterLength=5);
    Disconnector(pivotFactor=1, cutter=true, debug=false);
    
    HammerBolt(cutter=true);
    HammerGuiderod(cutter=true);
  }
}

module HammerGuiderod(clearance=0.01, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Hammer Guiderod
  color("Silver") RenderIf(!cutter)
  difference() {
    translate([-RecoilSpreaderThickness()+ManifoldGap(),hammerGuideY-clear,hammerGuideZ-clear])
    mirror([1,0,0])
    cube([4.5, 0.25+clear2, 0.25+clear2]);
    
    if (!cutter) {
      DisconnectorPivotPin(cutter=true);
    }
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
        DisconnectorTrip(cutter=true, clearance=0);
        DisconnectorPivotPin(cutter=true);
        DisconnectorSpring(cutter=true);
      
        // Trim the back edge to clear pivot
        translate([-0.5,-0.5-clear,disconnectorPivotZ+0.125])
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
    union() {
      
      // Insert plug
      translate([-RecoilSpreaderThickness(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=ReceiverIR()-0.01, r2=1/32,
                         h=FiringPinHousingLength(),
                       teardropTop=true, teardropBottom=true, $fn=80  );
      
      // Guiderod support
      hull()
      translate([-RecoilSpreaderThickness(),hammerGuideY,hammerGuideZ])
      rotate([0,-90,0])
      ChamferedCylinder(r1=FiringPinCollarRadius(), r2=1/32, h=FiringPinHousingLength(), $fn=40);
    
      // Extend to the top of the frame
      translate([-RecoilSpreaderThickness(),-0.5, FrameTopZ()])
      mirror([1,0,0])
      mirror([0,0,1])
      ChamferedCube([FiringPinHousingLength(), 1, FrameTopZ()-hammerGuideZ], r=1/32);
    }

    FiringPin(cutter=true);
    FireControlGroupBolts(bolt=FireControlGroupBolt(), boltLength=FiringPinHousingLength()+RecoilSpreaderThickness(), cutter=true);

    RevolverActuator(cutter=true);
    RevolverActionRod(cutter=true);
    
    DisconnectorPivotPin(cutter=true);
    DisconnectorSpringBolt(cutter=true);
    
    HammerGuiderod(cutter=true);
    FireControlGroupBolts(cutter=true);
    
    for (PF = [0,1])
    Disconnector(pivotFactor=PF, cutter=true);
    DisconnectorSpring(cutter=true);
    
    // Disconnector spring access
    translate([0,-0.1875+0.01,disconnectorPivotZ-0.125-0.25])
    mirror([0,1,0])
    mirror([1,0,0])
    ChamferedCube([RecoilSpreaderThickness()+0.25, 0.25, 0.375+0.02], r=1/32);
  }
}

module FireControlHousing_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX()+FiringPinHousingLength(),0,0])
  FireControlHousing(debug=false);
}


/**************
 * Assemblies *
 **************/
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
  DisconnectorSpringBolt();
  
  if (_SHOW_DISCONNECTOR)
  Disconnector(pivotFactor=disconnectorAF)
  DisconnectorTrip();
  
  FireControlGroupBolts();

  if (_SHOW_HAMMER_GUIDEROD)
  HammerGuiderod();
  
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
  
  FireControlGroupBolts(bolt=FireControlGroupBolt());
  if (_SHOW_FIRE_CONTROL_HOUSING)
  FireControlHousing();

  if (_SHOW_RECOIL_PLATE)
  RevolverRecoilPlate();
  
  
  translate([-LowerMaxX()-RecoilSpreaderThickness(),0,LowerOffsetZ()])
  Sear(length=SearLength()+abs(LowerOffsetZ())+SearTravel()-0.25);
}


if (_RENDER == "Assembly")
RevolverFireControlAssembly();

scale(25.4) {
  
  if (_RENDER == "FireControlHousing")
  FireControlHousing_print();
  
  if (_RENDER == "RecoilPlateMockup")
  rotate([0,90,0])
  RevolverRecoilPlate();
  
  if (_RENDER == "Hammer")
  rotate([0,90,0])
  translate([-hammerCockedX,0,0])
  Hammer();
  
  if (_RENDER == "HammerGuiderod")
  rotate([90,0,0])
  mirror([1,0,0])
  translate([RecoilSpreaderThickness(),-hammerGuideY,-hammerGuideZ])
  HammerGuiderod();
  
  if (_RENDER == "RevolverActuator")
  rotate([0,-90,0])
  translate([RecoilSpreaderThickness()+0.5, 0, -actionRodZ])
  RevolverActuator();

  if (_RENDER == "Disconnector")
  rotate([90,0,0])
  translate([-disconnectorPivotX,0.5,-disconnectorPivotZ])
  Disconnector();
}
