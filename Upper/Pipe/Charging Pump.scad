include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Cylinder Redux.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <Pipe Upper.scad>;
use <Frame.scad>;
use <Frame - Upper.scad>;
use <Linear Hammer.scad>;
use <Recoil Plate.scad>;

// Settings: Vitamins
function ChargingRod() = Spec_RodOneQuarterInch();
function ChargingPin() = Spec_RodThreeThirtysecondInch();
function SquareRodFixingBolt() = Spec_BoltM3();

// Settings: Lengths
function UpperLength() =  5.75;
function ForegripLength() = 5.25;
function ForegripChargingGap() = 0.5;
function ChargingRodLength() = 12;
function ChargerTowerLength() = 0.5;

/* How far does the stationary portion of the square rod
 extend into the part that holds it? */
function ChargingRodStaticLength() = 1;
function ChargingRodOffset() = ReceiverOR()+RodRadius(ChargingRod());
//function ChargingRodOffset() = 1.0375; // 1.075;

// Settings: Walls
function WallChargingPin() = 1/8;


function ChargingPinX() = RecoilPlateRearX()-0.25;
function ChargingRodMinX() = ChargingPinX()-0.25;
function ChargingRodMaxX() = ChargingRodMinX()+ChargingRodLength();

// Calculated: Lengths
function ChargerTravel() = 2.0625;

// Calculated: Positions
echo("Charging Rod Length: ", ChargingRodLength());

function ForegripFrontX() = ChargingRodMinX()
                    + ChargingRodLength()
                    - ChargingRodStaticLength();
function ForegripRearX() = ForegripFrontX()-ForegripLength();

function ChargerAnimationFactor() = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);


module ChargingPin(cutter=false, teardrop=false, clearance=RodClearanceSnug()) {
  color("Silver")
  translate([ChargingPinX(), 0, 0.5])
  Rod(ChargingPin(),
      length=ChargingRodOffset()+0.25,
      clearance=cutter?clearance:undef,
      teardrop=teardrop, teardropTruncated=false, teardropRotation=180);
}

module ChargingRod(clearance=RodClearanceLoose(),
                   length=ChargingRodLength(),
                   minX=ChargingRodMinX(),
                   bolt=true,
                   actuator=true, actuatorRadius=(1/4)/2,
                   travel=ChargerTravel(),
                   cutter=false, debug=false) {
  color("SteelBlue") DebugHalf(enabled=debug) {

    // Charging rod
    translate([minX-(cutter?ChargerTravel():0),0,ChargingRodOffset()])
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=length+(cutter?ChargerTravel():0)+ManifoldGap(),
              clearance=cutter?clearance:undef);

    // Charging Rod Fixing Bolt
    if (bolt)
    translate([ChargingRodMaxX()-0.5,0,RodRadius(ChargingRod())+0.25])
    Bolt(bolt=SquareRodFixingBolt(),
         length=cutter?1.5:1, clearance=cutter, teardrop=cutter);

    // Actuator rod
    if (actuator)
    translate([ChargerTravel()+(actuatorRadius),0,ChargingRodOffset()-RodRadius(ChargingRod())])
    mirror([0,0,1])
    hull() {
      Rod(ActuatorRod(), clearance=cutter?RodClearanceSnug():undef,
          length=0.49);

      if (cutter) {
        translate([-ChargerTravel()-(actuatorRadius*2),0,0])
        Rod(ActuatorRod(), clearance=cutter?RodClearanceLoose():undef,
            length=0.49);
      }
    }
  }
}

module Charger(clearance=RodClearanceLoose(),
               bolt=true,
               cutter=false, debug=false) {

  color("OrangeRed") DebugHalf(enabled=debug) {
    difference() {

      // Charging Pusher
      union() {

        // Tower
        translate([RecoilPlateRearX(),-0.5/2,0.375])
        mirror([1,0,0])
        ChamferedCube([ChargerTowerLength(), 0.5, ChargingRodOffset()-0.25], r=1/32);

        // Top wings
        translate([RecoilPlateRearX(),-1/2,ChargingRodOffset()])
        mirror([1,0,0])
        ChamferedCube([ChargerTowerLength(), 1, 0.25], r=1/32);

        // Charging Pusher Wide Base
        translate([RecoilPlateRearX(),0,0])
        intersection() {

          translate([0,-0.5,0.375])
          mirror([1,0,0])
          ChamferedCube([1.125, 1, ReceiverIR()-0.375], r=1/32);

          // Rounded base
          rotate([0,-90,0])
          cylinder(r=ReceiverIR()-0.02, h=1.125, $fn=Resolution(30,60));
        }
      }

      translate([RecoilPlateRearX()-0.625,-0.1875,0])
      mirror([1,0,0])
      ChamferedCube([1, 0.375, ReceiverOR()], r=1/16);

      translate([ChargerTravel(),0,0])
      ChargingRod(cutter=true, clearance=RodClearanceSnug());

      ChargingPin(cutter=true, teardrop=true);

    }
  }
}

module ChargingPump(innerRadius=1.1/2, debug=false, alpha=1, $fn=Resolution(20,50)) {

  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {

      // Body around the charging rod
      translate([ForegripFrontX(),-RodRadius(ChargingRod())-0.25,0])
      rotate([0,90,0])
      mirror([1,0,0])
      ChamferedCube([ChargingRodOffset()+RodRadius(ChargingRod())+0.125,
                     RodDiameter(ChargingRod())+0.5,
                     ChargingRodStaticLength()], r=1/16);

      // Body around the barrel
      translate([ForegripFrontX(),0,0])
      rotate([0,90,0])
      ChargingPumpGripBase();
    }
    
    // Barrel hole, but with a bearing profile
    translate([ForegripFrontX()+(ForegripLength()/2),0,0])
    rotate([0,90,0])
    BearingSurface(r=innerRadius, length=ForegripLength(),
                   depth=0.0625, segments=6, taperDepth=0.125,
                   center=true, $fn=40);

    ChargingRod(length=ChargingRodLength(),
                travel=ChargerTravel(),
                clearance=RodClearanceSnug(), cutter=true);
  }
}



module ChargingPumpGripBase(outerRadius=ReceiverOR(), length=ForegripLength(),
                            rings=true, ringRadius=3/32, ringGap=0.75,
                            debug=false, alpha=1, $fn=Resolution(20,50)) {

  color("Tan", alpha)
  DebugHalf(enabled=debug)
  difference() {
    union() {

      // Body around the barrel
      ChamferedCylinder(r1=outerRadius, r2=1/16, h=length);
    }

    // Gripping cutout rings
    if (rings)
    for (Z = [ringGap:ringGap:length-ringGap]) translate([0,0,Z])
    for (M = [0,1]) mirror([0,0,M])
    translate([0,0,-ringRadius*1.5]) scale([1,1,1.5]) translate([0,0,ringRadius])
    TeardropTorus(majorRadius=outerRadius-ringRadius,
                  minorRadius=ringRadius);

    // Gripping cutout linear channels
    for (R = [0:60:360]) rotate([0,0,R])
    translate([outerRadius, 0, -ManifoldGap()])
    linear_extrude(height=length+ManifoldGap(2))
    for (R =[1,-1]) rotate(90*R)
    Teardrop(r=ringRadius*2);
  }
}

module ChargingPumpAssembly(animationFactor=ChargerAnimationFactor(),
                            length=ChargingRodLength(), minX=ChargingRodMinX(),
                               pipeAlpha=1, debug=false) {
  translate([-ChargerTravel()*animationFactor,0,0]) {

    color("Silver")
    ChargingPin();

    ChargingRod(length=length, minX=minX, debug=debug);

    Charger(debug=debug);

    ChargingPump(debug=debug, alpha=1);
  }
}

// Barrel mock
color("SteelBlue")
rotate([0,90,0])
Pipe(pipe=Spec_PipeThreeQuarterInch(), hollow=true, length=18);

ChargingPumpAssembly(debug=false);

RecoilPlateHousing();
RecoilPlateFiringPinAssembly();

RecoilPlate();

translate([RecoilPlateRearX(),0,0])
PipeUpperAssembly(pipeAlpha=0.3,
                  receiverLength=12,
                  chargingHandle=false,
                  lower=true, frame=true,
                  stock=true, tailcap=false,
                  triggerAnimationFactor=TriggerAnimationFactor(),
                  debug=false);


/*
 * Platers
 */

//
// Foregrip
//

// 3/4" Sch40 pipe
*!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
ChargingPump();

// 1.125" DOM
*!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
ChargingPump(innerRadius=1.15/2);

// 1" 4130
!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
ChargingPump(innerRadius=1.01/2);

//
// Charger
//
*!scale(25.4)
rotate([0,90,0])
translate([-RecoilPlateRearX(),0,-ChargingRodOffset()])
Charger();
