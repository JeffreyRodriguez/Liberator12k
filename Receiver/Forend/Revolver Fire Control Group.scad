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

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FireControlHousing", "Disconnector", "Hammer"]
//$t = 1; // [0:0.01:1]

_SHOW_ACTION_ROD = true;
_SHOW_RECOIL_PLATE = true;

/* [Assembly Transparency] */
_ALPHA_FIRING_PIN_HOUSING = 1; // [0:0.1:1]

/* [Assembly Cutaways] */
_CUTAWAY_RECOIL_PLATE = false;
_CUTAWAY_FIRING_PIN_HOUSING = false;
_CUTAWAY_DISCONNECTOR = false;
_CUTAWAY_HAMMER = false;

/* [Screws] */
HAMMER_BOLT = "#8-32"; // ["M4", "#8-32"] 
HAMMER_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_TRIP_BOLT = "M3"; // ["M3", "#4-40"] 
DISCONNECTOR_TRIP_BOLT_CLEARANCE = 0.015;

DISCONNECTOR_SPRING_BOLT = "#4-40"; // ["M3", "#4-40"] 
DISCONNECTOR_SPRING_BOLT_CLEARANCE = 0.015;

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

// Measured: Vitamins
function RecoilPlateThickness() = 1/4;
function RecoilPlateWidth() = 1.5;
function RecoilSpreaderThickness() = 0.5;

// Settings: Lengths
function ChargingRodOffset() =  0.75+RodRadius(ChargingRod());
function ChamferRadius() = 1/16;
function CR() = 1/16;

hammerGuideY = 0.5;
hammerGuideZ = 0.125;
hammerGuideLength = 4;
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
disconnectorPivotZ = 3/8;
disconnectorPivotAngle=-7;
disconnectorThickness = 0.25;
disconnectorHeight = 0.25;
disconnectDistance = 0.125;
disconnectorTripX = -RecoilSpreaderThickness()-BearingOuterRadius(DisconnectorTripBearing());
disconnectorPivotX = -RecoilSpreaderThickness()-disconnectorOffset;
disconnectorLength = abs(hammerCockedX-disconnectorPivotX)
                   + disconnectDistance+disconnectorOffset;

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
module DisconnectorPivotPin(debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver")
  translate([disconnectorPivotX, 0, disconnectorPivotZ])
  rotate([90,0,0])
  cylinder(r=(3/32/2)+clear, h=1+clear2, center=true, $fn=20);
}
module DisconnectorSpringBolt(debug=false, cutter=false, clearance=DISCONNECTOR_SPRING_BOLT_CLEARANCE) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  color("Silver") RenderIf(!cutter)
  translate([disconnectorTripX, -0.5, actionRodZ+0.375])
  rotate([90,0,0])
  NutAndBolt(bolt=DisconnectorSpringBolt(), boltLength=1,
             head="flat", capOrientation=true,
             clearance=clear, teardrop=cutter);
}
module DisconnectorTrip(debug=false, cutter=false, clearance=DISCONNECTOR_TRIP_BOLT_CLEARANCE) {
  color("Silver")
  translate([disconnectorTripX, (disconnectorThickness/2), disconnectorPivotZ])
  rotate([-90,0,0])
  Bearing(spec=DisconnectorTripBearing(),
          solid=cutter, clearance=cutter?BearingClearanceSnug():undef,
          extraHeight=cutter?0.0625+0.01:0);
    
  color("Silver")
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
module HammerGuiderods(clearance=0.01, cutter=false, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Hammer Guiderods
  color("Silver")
  for (Y = [-1, 1])
  translate([-RecoilSpreaderThickness()+ManifoldGap(),hammerGuideY*Y,hammerGuideZ])
  rotate([0,-90,0])
  cylinder(r=(3/32/2)+clear, h=hammerGuideLength, $fn=15);

  // Shaft collars
  color("Silver")
  for (X = [0,1]) translate([X*(FiringPinCollarWidth()-hammerGuideLength),0,0])
  for (Y = [-1, 1])
  translate([-RecoilSpreaderThickness()+ManifoldGap(),hammerGuideY*Y,hammerGuideZ])
  rotate([0,-90,0])
  cylinder(r=FiringPinCollarRadius()+clear,
           h=FiringPinCollarWidth()+clear);
}
module HammerBolt(clearance=0.01, cutter=false, debug=false) {
  color("Silver") RenderIf(!cutter)
  translate([hammerCockedX+ManifoldGap(),0,0])
  rotate([0,90,0])
  NutAndBolt(bolt=HammerBolt(), boltLength=1.5, head="flat",
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
module RevolverActuator(debug=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  width = BearingHeight(DisconnectorTripBearing());
  
  color("Green")
  RenderIf(!cutter)
  difference() {
    union() {
      hull() {
        
        // Long segment along the action rod
        translate([-RecoilSpreaderThickness()-0.5,
                   (0.25/2)-clear,
                   actionRodZ+0.125+clear])
        mirror([0,0,1])
        ChamferedCube([0.5, width+clear2, 0.3125+clear2], r=1/32);
        
        // Tall segment
        translate([-RecoilSpreaderThickness()-0.5-(cutter?1:0),
                   (0.25/2)-clear,
                   actionRodZ+0.125+clear])
        mirror([0,0,1])
        ChamferedCube([0.5-BearingOuterRadius(DisconnectorTripBearing())+(cutter?2:0),
                        width+clear2,
                        actionRodZ+0.125
                        -disconnectorPivotZ
                        -BearingOuterRadius(DisconnectorTripBearing())
                        +clear2], r=1/32);
      }
        
      // Block around the action rod
      *translate([-RecoilSpreaderThickness()-0.5,
                 -0.25-clear,
                 actionRodZ+0.25+clear])
      mirror([0,0,1])
      ChamferedCube([0.5, 0.375+width+clear2, 0.5+clear2], r=1/32);
      
      // Tall segment extension
      translate([-RecoilSpreaderThickness()-0.5-(cutter?1:0),
                 (0.25/2)-clear,
                 actionRodZ])
      mirror([0,0,1])
      ChamferedCube([0.5-BearingOuterRadius(DisconnectorTripBearing(), BearingClearanceLoose())+(cutter?1:0),
                    width+clear2,
                    actionRodZ
                    -disconnectorPivotZ
                    -BearingOuterRadius(DisconnectorTripBearing())
                    +0.0625
                    +clear], r=1/32);
    }
    
    *RevolverActionRod(cutter=true);
    
    DisconnectorTrip(cutter=true);
      
  }
}
module Hammer(cutter=false, clearance=UnitsImperial(0.01), debug=_CUTAWAY_HAMMER) {
  
  hammerHeadLength=0.75;
  hammerBodyWidth=0.5;
  hammerHeadHeight=ReceiverIR()+0.25;
  
  clear = cutter ? clearance : 0;
  clear2 = clear*2;
  
  // Head
  color("CornflowerBlue")
  RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    intersection() {
      hull() {
        translate([hammerCockedX, -(hammerBodyWidth/2)-clear,-BoltFlatHeadRadius(HammerBolt())])
        mirror([1,0,0])
        cube([hammerHeadLength, hammerBodyWidth+clear2, hammerHeadHeight+clear2]);
        
        // Guiderod Supports
        for (Y = [-1, 1]) translate([hammerCockedX,hammerGuideY*Y,hammerGuideZ])
        rotate([0,-90,0])
        cylinder(r=BoltFlatHeadRadius(HammerBolt()), h=hammerHeadLength, $fn=25);

      }
        
      rotate([0,-90,0])
      cylinder(r=ReceiverIR()-0.02, h=6, $fn=100);
    }
    
    Disconnector(cutter=true, debug=false);
    
    HammerBolt(cutter=true);
    HammerGuiderods(cutter=true);
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
    
    color("Tan", alpha)
    RenderIf(!cutter)
    DebugHalf(enabled=debug)
    difference() {
      union() {
        translate([disconnectorPivotX+disconnectorOffset+(cutter?1:0),
                   -(disconnectorThickness/2)-clear,
                   disconnectorPivotZ-(disconnectorHeight/2)-clear])
        mirror([1,0,0])
        ChamferedCube([disconnectorLength+(cutter?2:0),
              disconnectorThickness+clear2,
              disconnectorHeight+clear2], r=1/64);
        
        translate([disconnectorPivotX, 0, disconnectorPivotZ])
        rotate([90,0,0])
        ChamferedCylinder(r1=0.125+clear, r2=1/32, teardropBottom=false, teardropTop=false,
                           h=(disconnectorThickness/2)+0.25, $fn=30);
        
        translate([disconnectorPivotX, 0, disconnectorPivotZ-(disconnectorThickness/2)-clear])
        mirror([0,1,0])
        ChamferedCube([disconnectorThickness+0.25+(cutter?0.125:0),
              (disconnectorThickness/2)+0.25,
              disconnectorHeight+clear2], r=1/64);
        
        if (cutter)
        translate([disconnectorPivotX, 0, disconnectorPivotZ-(disconnectorThickness/2)-clear])
        mirror([0,1,0])
        mirror([1,0,0])
        ChamferedCube([disconnectorThickness*1.5,
              (disconnectorThickness/2)+0.25,
              disconnectorHeight+clear2], r=1/64);
      }
      
      if (!cutter) {
        DisconnectorTrip(cutter=true, clearance=0);
        DisconnectorPivotPin(cutter=true);
      }
    }
  }
}
module FireControlHousing(debug=_CUTAWAY_FIRING_PIN_HOUSING, alpha=_ALPHA_FIRING_PIN_HOUSING) {
  color("Olive", alpha) render()
  DebugHalf(enabled=debug)
  difference() {
    union() {
        
      // Lower bolt support
      hull()
      for (Z = [0,-FiringPinBoltOffsetZ()])
      translate([-RecoilSpreaderThickness(),0,Z])
      rotate([0,-90,0])
      ChamferedCylinder(r1=0.25, r2=1/32,
                         h=FiringPinHousingLength(),
                       teardropTop=true, teardropBottom=true);
      
      // Guiderod support
      hull()
      for (Y = [-1, 1])
      translate([-RecoilSpreaderThickness(),hammerGuideY*Y,hammerGuideZ])
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
    
    HammerGuiderods(cutter=true);
    FireControlGroupBolts(cutter=true);
    
    for (PF = [0,1])
    Disconnector(pivotFactor=PF, cutter=true)
    DisconnectorTrip(cutter=true);
    
    // Cutout the disconnector trip path
    majorR = disconnectorTripX
           - disconnectorPivotX
           + BearingOuterRadius(DisconnectorTripBearing(), BearingClearanceSnug())
           + RecoilSpreaderThickness();
    minorR = disconnectorTripX
           - disconnectorPivotX
           - BearingOuterRadius(DisconnectorTripBearing(), BearingClearanceSnug());
    translate([disconnectorPivotX, 0.125, disconnectorPivotZ])
    rotate([-90,0,0])
    linear_extrude(height=BearingHeight(DisconnectorTripBearing())+0.0625+0.01)
    semidonut(major=majorR*2, minor=minorR*2,
               angle=abs(disconnectorPivotAngle), $fn=30);
    
    // Disconnector spring cutout
    translate([-RecoilSpreaderThickness(),-0.125,disconnectorPivotZ-0.125-0.01])
    mirror([0,1,0])
    mirror([1,0,0])
    cube([0.375, 0.25, 1.125+0.02]);
    
    // Additional cutout to remove floater between action rod and disconnector
    translate([-RecoilSpreaderThickness(),-0.375,disconnectorPivotZ-0.125])
    mirror([1,0,0])
    cube([0.375, 0.75, actionRodZ-disconnectorPivotZ]);
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
  }
  
  // Linear Hammer
  translate([Animate(ANIMATION_STEP_FIRE)*hammerTravelX,0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGE, start=hammerChargeStart)*-(hammerTravelX+hammerOvertravelX),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, end=0.1)*(hammerOvertravelX-disconnectDistance),0,0])
  translate([SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.97, end=1)*disconnectDistance,0,0]) {
    Hammer();
    HammerBolt();
  }
  
  DisconnectorPivotPin();
  DisconnectorSpringBolt();
  
  Disconnector(pivotFactor=disconnectorAF)
  DisconnectorTrip();
  
  FireControlGroupBolts();
        
  // Hammer Guiderods
  HammerGuiderods();

  translate([(3/32)*SubAnimate(ANIMATION_STEP_FIRE, start=0.95),0,0])
  translate([-(3/32)*SubAnimate(ANIMATION_STEP_CHARGE, start=0.07, end=0.2),0,0])
  FiringPin(cutter=false, debug=false);
  
  FireControlGroupBolts(bolt=FireControlGroupBolt());
  FireControlHousing();

  if (_SHOW_RECOIL_PLATE)
  RevolverRecoilPlate();
}




if (_RENDER == "Assembly")
RevolverFireControlAssembly();

scale(25.4) {
  if (_RENDER == "FireControlHousing")
  FireControlHousing_print();
  
  if (_RENDER == "Hammer")
  rotate([0,90,0])
  translate([-hammerCockedX,0,0])
  Hammer();

  if (_RENDER == "Disconnector")
  rotate([-90,0,0])
  translate([-disconnectorPivotX,-disconnectorThickness/2,-disconnectorPivotZ])
  Disconnector();
}
