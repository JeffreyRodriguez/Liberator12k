include <../../../Meta/Animation.scad>;

use <../../../Meta/Manifold.scad>;
use <../../../Meta/Units.scad>;
use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Finishing/Chamfer.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Shapes/Teardrop.scad>;

use <../../../Components/Firing Pin.scad>;
use <../../../Components/Cylinder Redux.scad>;
use <../../../Components/Pipe/Cap.scad>;
use <../../../Components/Pipe/Lugs.scad>;

use <../../../Vitamins/Nuts And Bolts.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;

use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Trigger.scad>;
use <../../../Lower/Lower.scad>;

use <../Linear Hammer.scad>;
use <../Frame.scad>;
use <../Pipe Upper.scad>;


DEFAULT_SPINDLE_OFFSET=1.355;
DEFAULT_CHARGER_TRAVEL = (LowerMaxX()+SearRadius()+0.5);
DEFAULT_CHARGING_ROD_LENGTH = LowerMaxX()+SearRadius()+DEFAULT_CHARGER_TRAVEL;

// Measured: Vitamins
function BreechPlateThickness() = 1/4;
function BreechPlateWidth() = 1.5;

// Settings: Lengths
function BreechBoltRearExtension() = 3.5;

// Settings: Walls
function WallBreechBolt() = 0.1875;
function WallChargingPin() = 1/8;

// Settings: Positions
function BreechFrontX() = 0;
function BreechRearX()  = BreechFrontX()-0.5;

// Settings: Vitamins
function BreechBolt() = Spec_BoltOneHalf();
function BreechBolt() = Spec_BoltThreeEighths();
function BreechBolt() = Spec_BoltFiveSixteenths();
function ChargingRod() = Spec_RodOneQuarterInch();
function ChargingPin() = Spec_RodThreeThirtysecondInch();
function DisconnectorRod() = Spec_RodOneQuarterInch();
function DisconnectorPivotPin() = Spec_RodThreeThirtysecondInch();
function SquareRodFixingBolt() = Spec_BoltM3();

// Calculated: Positions
function BreechBoltOffsetZ() = ReceiverOR()
                            + BreechBoltRadius()
                            + WallBreechBolt();
function BreechBoltOffsetY() = 1
                             - BreechBoltRadius()
                             - WallBreechBolt();
function BreechPlateHeight(spindleOffset=1)
                           = BreechBoltOffsetZ()
                           + BreechBoltRadius()
                           + spindleOffset
                           + RodRadius(CylinderRod())
                           + (2*WallBreechBolt());
function BreechTopZ() = BreechBoltOffsetZ()
                           + WallBreechBolt()
                           + BreechBoltRadius();
function FiringPinMinX() = BreechRearX()-FiringPinBodyLength();


function ChargingRodOffset() = ReceiverOR()+RodDiameter(ChargingRod())+0.0625;
function ChargingRodOffset() = 1.1875+RodDiameter(ChargingRod());
function ChargingPinX() = BreechRearX()-0.25;
function ChargingRodMinX() = ChargingPinX()-WallChargingPin();

function DisconnectorPivotOffsetX() = 0.5;
function DisconnectorPivotX() = BreechRearX()-DisconnectorPivotOffsetX();
function DisconnectorPivotZ() =ChargingRodOffset()-(RodDiameter(ChargingRod())*2);

function DisconnectorFactor() = SubAnimate(ANIMATION_STEP_CHARGE, start=0.36, end=0.75)
                              - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.9);

function ChargingToggleFactor() = SubAnimate(ANIMATION_STEP_CHARGE, start=0.36, end=0.9)
                                - SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.05, end=0.74);

function HammerFactor() = Animate(ANIMATION_STEP_FIRE)
                        - SubAnimate(ANIMATION_STEP_CHARGE, start=0.0, end=0.36);

// Shorthand: Measurements
function BreechBoltRadius(clearance=false)
    = BoltRadius(BreechBolt(), clearance);

function BreechBoltDiameter(clearance=false)
    = BoltDiameter(BreechBolt(), clearance);

module ChargingRod(clearance=RodClearanceLoose(),
                   length=LowerMaxX()+SearRadius()+DEFAULT_CHARGER_TRAVEL,
                   bolt=true, actuator=true,
                   travel=DEFAULT_CHARGER_TRAVEL,
                   animationFactor=0,
                   toggleAnimationFactor=ChargingToggleFactor(),
                   cutter=false, debug=false) {

  translate([-travel*animationFactor,0,0]) {
    
    if (!cutter) {
      ChargingToggle(animationFactor=toggleAnimationFactor);
      
      color("Silver")
      translate([ChargingPinX(), 0, ChargingRodOffset()])
      hull() {
        rotate([90,0,0])
        Rod(ChargingPin(), length=0.76, center=true, clearance=cutter?clearance:undef);

        if (cutter) {
          translate([-travel,0,0])
          rotate([90,0,0])
          Rod(ChargingPin(), length=0.76, center=true, clearance=cutter?clearance:undef);
        }
      }
    }

    color("SteelBlue") DebugHalf(enabled=debug) {

      // Charging rod
      translate([ChargingRodMinX()-(cutter?travel:0),0,ChargingRodOffset()])
      rotate([0,90,0])
      SquareRod(ChargingRod(), length=length+(cutter?travel:0)+ManifoldGap(),
                clearance=cutter?clearance:undef);

      // Charging Rod Fixing Bolt
      if (bolt)
      translate([ChargingRodMinX()+length-0.5,0,BreechTopZ()])
      Bolt(bolt=SquareRodFixingBolt(), capOrientation=true,
           length=cutter?BreechTopZ():1, clearance=cutter, teardrop=cutter);

      // Actuator rod
      if (actuator)
      translate([travel+(ZigZagWidth()/2),0,ChargingRodOffset()-RodRadius(ChargingRod())])
      mirror([0,0,1])
      hull() {
        Rod(ActuatorRod(), clearance=cutter?RodClearanceSnug():undef,
            length=0.49);

        if (cutter) {
          translate([-travel-ZigZagWidth(),0,0])
          Rod(ActuatorRod(), clearance=cutter?RodClearanceLoose():undef,
              length=0.49);
        }
      }
    }
  }
}

module ChargingToggle(angle=-110, animationFactor=ChargingToggleFactor(), length=ChargingRodOffset()-RodRadius(ChargingRod()), backsetLength=0.125) {
    for(M = [0,1]) mirror([0,M,0])
    translate([ChargingPinX(), RodDiameter(ChargingRod()), ChargingRodOffset()])
    rotate([0,-90-30+(angle*animationFactor),0]) {
      color("Yellow")
      translate([0,0,-backsetLength])
      SquareRod(ChargingRod(),
                length=length);
  
      translate([0, 0.13, 0.475])
      rotate([90,0,0])
      Rod(DisconnectorPivotPin(), length=0.76, center=false);
    }
  
}

module Disconnector(angle=10, animationFactor=1) {
  
  backsetLength = DisconnectorPivotOffsetX()-(1/16);
  extensionLength = (LowerMaxX()+DisconnectorPivotX()+backsetLength+(0.25)) * cos(angle);
  length = extensionLength+backsetLength;
  
  
  translate([DisconnectorPivotX(), 0, DisconnectorPivotZ()])
  rotate([90,0,0])
  Rod(DisconnectorPivotPin(), length=1.25, center=true);
  
  color("LimeGreen")
  translate([DisconnectorPivotX(), 0, DisconnectorPivotZ()]) {
    rotate([0,-90-(angle*animationFactor),0])
    translate([0,0,-backsetLength])
    SquareRod(DisconnectorRod(),
              length=length);
    
  }
}

module BreechFiringPinAssembly(template=false,
         cutter=false, debug=false) {
  translate([BreechRearX(),0,0])
  rotate([0,-90,0])
  FiringPinAssembly(cutter=cutter, debug=debug, template=template);
}

module BreechPlate(cutter=false, debug=false,
                   spindleOffset=DEFAULT_SPINDLE_OFFSET) {
  color("LightSteelBlue")
  DebugHalf(enabled=debug)
  difference() {
    translate([-BreechPlateThickness(), -1-ManifoldGap(2), -BreechPlateWidth()/2])
    ChamferedCube([BreechPlateThickness()+(cutter?(1/8):ManifoldGap(2)),
                   2+ManifoldGap(4),
                   BreechPlateWidth()],
                  r=1/32,
                  chamferXYZ=[0,1,0],
                  teardropXYZ=[false, false, false],
                  teardropTopXYZ=[false, false, false]);
    
    if (!cutter) {
      BreechFiringPinAssembly(cutter=true);
    }
  }
}

module Breech(debug=false, chargingRodLength=LowerMaxX()+SearRadius(),
              spindleOffset=DEFAULT_SPINDLE_OFFSET,
              alpha=0.5) {
  color("LightSteelBlue", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {
      translate([BreechFrontX(),0,0])
      translate([BreechRearX(),
                 -1,
                 BreechBoltOffsetZ()+BreechBoltRadius()+WallBreechBolt()])
      mirror([0,0,1])
      ChamferedCube([BreechFrontX()-BreechRearX(),
                     2,
                     BreechPlateHeight(spindleOffset)],
                    r=1/16);

      children();
    }
    
    BreechPlate(cutter=true);

    BreechFiringPinAssembly(cutter=true);

    BreechBolts(cutter=true);

    translate([BreechRearX()-LowerMaxX(),0,0])
    FrameBolts(cutter=true);
    
    ChargingRod(length=chargingRodLength, cutter=true, actuator=false, pin=false);

  }
}

module BreechBoltIterator() {
    for (Y = [BreechBoltOffsetY(),-BreechBoltOffsetY()])
    translate([BreechRearX()-BreechBoltRearExtension()-ManifoldGap(), Y, BreechBoltOffsetZ()])
    rotate([0,90,0])
    children();
}

module BreechBolts(length=abs(BreechRearX())+BreechBoltRearExtension(),
              debug=false, cutter=false, alpha=1) {

  color("Silver", alpha)
  DebugHalf(enabled=debug) {
    BreechBoltIterator()
    NutAndBolt(bolt=BreechBolt(), boltLength=length+ManifoldGap(2),
         capHex=true, clearance=cutter);
  }
}

module FrameSupport(length=2.5, width=0.125+0.01,
                    height=3/4, wall=1/8,
                    clearance=0.01, debug=false, alpha=1) {
  color("Purple", alpha)
  DebugHalf(enabled=debug)
  for (M = [0,1]) mirror([0,M,0])
  translate([0,-1-width-wall,BreechTopZ()-wall-height])
  difference() {
    ChamferedCube([length, width+(wall*3), height+(wall*2)], r=1/16);
    
    translate([wall, wall-clearance,wall-clearance])
    cube([length, width+(wall*2)+clearance+ManifoldGap(), height+(clearance*2)]);
    
    translate([0, width+wall,-ManifoldGap()])
    cube([length, (wall*2)+ManifoldGap(), height+wall+clearance]);
  }
}

module FrameSupportRear(debug=false, alpha=1) {
  translate([BreechRearX()-BreechBoltRearExtension()+0.3,0,0])
  FrameSupport(debug=debug, alpha=alpha);
}

module BreechAssembly(breechBoltLength=abs(BreechRearX())+BreechBoltRearExtension(),
                      breechBoltAlpha=0.3,
                      showBreech=true,
                      chargingRodAnimationFactor=0,
                      chargingRodLength=DEFAULT_CHARGING_ROD_LENGTH,
                      chargingRodTravel=DEFAULT_CHARGER_TRAVEL,
                      hammerTravelFactor=HammerFactor(),
                      debug=false) {
  BreechFiringPinAssembly(breechBoltLength=breechBoltLength, debug=debug);

  chargingRodAnimationFactor = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);

  ChargingRod(length=chargingRodLength,
              travel=chargingRodTravel,
              animationFactor=chargingRodAnimationFactor, cutter=false);

  Disconnector(animationFactor=DisconnectorFactor());

  translate([BreechRearX()-LowerMaxX(),0,0])
  FrameBolts(debug=debug);
                        
  *FrameSupportRear(debug=debug);
  
  BreechPlate(debug=debug);
  
  if (showBreech)
  Breech(debug=debug)
  children();
  
  BreechBolts(length=breechBoltLength, debug=debug, alpha=breechBoltAlpha);

  translate([FiringPinMinX()-LinearHammerTravel(),0,0])
  LinearHammerAssembly(travelFactor=hammerTravelFactor);
}


BreechAssembly(debug=true);

*translate([BreechRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  chargingHandle=false,
                  frameUpper=false,
                  stock=true, tailcap=false,
                  debug=false);

//$t=AnimationDebug(ANIMATION_STEP_CHARGE, T=$t);

*!scale(25.4)
for (M = [0,1]) mirror([0,M,0])
rotate([90,0,0])
translate([0,1.25,-BreechTopZ()-0.1875])
FrameSupport(debug=true);


*!scale(25.4)
difference() {
  translate([-1,-1-0.25-ManifoldGap(),-0.25])
  cube([2, 2+0.25, 0.25]);
  
  rotate([0,90,0])
  BreechPlate(cutter=true);
  
  rotate([0,-90,0])
  BreechFiringPinAssembly(template=true);
}