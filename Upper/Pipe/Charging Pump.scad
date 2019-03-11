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
function ForegripLength() = 5;
function ForegripChargingGap() = 0.5;
function ChargingRodLength() = 10.5;
function ChargerTowerLength() = 0.5;

/* How far does the stationary portion of the square rod
 extend into the part that holds it? */
function ChargingRodStaticLength() = 1;
function ChargingRodOffset() = ReceiverOR()+RodRadius(ChargingRod());

// Settings: Walls
function WallChargingPin() = 1/8;


function ChargingPinX() = RecoilPlateRearX()-0.25;
function ChargingRodMinX() = ChargingPinX()-WallChargingPin();
function ChargingRodMaxX() = ChargingRodMinX()+ChargingRodLength();

// Calculated: Lengths
function ChargerTravel() = 2.3125;

// Calculated: Positions
echo("Charging Rod Length: ", ChargingRodLength());

function ForegripFrontX() = ChargingRodMinX()
                    + ChargingRodLength()
                    - ChargingRodStaticLength();
function ForegripRearX() = ForegripFrontX()-ForegripLength();
                           
function ChargerAnimationFactor() = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);


module ChargingPin(cutter=false, clearance=RodClearanceSnug()) {
  color("Silver")
  translate([ChargingPinX(), 0, ChargingRodOffset()-0.125])
  Rod(ChargingPin(), length=1, center=true, clearance=cutter?clearance:undef);
}

module ChargingRod(clearance=RodClearanceLoose(),
                   length=ChargingRodLength(),
                   bolt=true,
                   actuator=true, actuatorRadius=(1/4)/2,
                   travel=ChargerTravel(),
                   cutter=false, debug=false) {
  color("SteelBlue") DebugHalf(enabled=debug) {

    // Charging rod
    translate([ChargingRodMinX()-(cutter?ChargerTravel():0),0,ChargingRodOffset()])
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
                   bolt=true, actuator=true,
                   cutter=false, debug=false) {
    
  color("OrangeRed") DebugHalf(enabled=debug) {
    difference() {
      
      // Charging Pusher
      union() {
        translate([RecoilPlateRearX(),-0.5/2,0.375])
        mirror([1,0,0])
        ChamferedCube([ChargerTowerLength(), 0.5, ChargingRodOffset()], r=1/16);
        
        // Charging Pusher Wide Base
        translate([RecoilPlateRearX(),0,0])
        intersection() {
          
          translate([0,-0.5,0.375])
          mirror([1,0,0])
          ChamferedCube([1.125, 1, ReceiverIR()-0.375], r=1/16);
          
          // Rounded base
          rotate([0,-90,0])
          cylinder(r=ReceiverIR()-0.02, h=1.125, $fn=Resolution(30,60));
        }
      }
      
      translate([ChargerTravel(),0,0])
      ChargingRod(cutter=true, clearance=RodClearanceSnug());
      
      ChargingPin(cutter=true);
      
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
                     ChargingRodStaticLength()], r=1/8);
      
      // Body around the barrel
      translate([ForegripFrontX(),0,0])
      rotate([0,90,0])
      ChamferedCylinder(r1=ReceiverOR(), r2=1/16,
               h=ForegripLength());
    }

    // Gripping cutouts
    for (X = [ChargingRodStaticLength()+0.1875:0.75:ForegripLength()-0.75])
    translate([ForegripFrontX()+X,0,0])
    rotate([0,90,0])
    for (M = [0,1]) mirror([0,0,M])
    TeardropTorus(majorRadius=ReceiverOR()-0.125, minorRadius=1/8);

    // Barrel hole, but with a bearing profile
    translate([ForegripFrontX()+(ForegripLength()/2),0,0])
    rotate([0,90,0])
    BearingSurface(r=innerRadius, length=ForegripLength(),
                   depth=0.0625, segment=0.25, taperDepth=0.125, center=true);

    for (R = [0:45:270]) rotate([45+R,0,0])
    translate([ForegripFrontX()-ManifoldGap(), 0, ReceiverOR()])
    rotate([0,90,0])
    cylinder(r=1/8, h=ForegripLength()+ManifoldGap(2));

    ChargingRod(length=ChargingRodLength(),
                travel=ChargerTravel(),
                clearance=RodClearanceSnug(), cutter=true);
  }
}

module ChargingPumpAssembly(animationFactor=ChargerAnimationFactor(),
                               pipeAlpha=1, debug=false) {
  translate([-ChargerTravel()*animationFactor,0,0]) {
    
    color("Silver")
    ChargingPin();
    
    ChargingRod(debug=debug);
    
    Charger(debug=debug);

    ChargingPump(debug=debug, alpha=1);
  }
}

// Barrel mock
color("SteelBlue")
rotate([0,90,0])
Pipe(pipe=Spec_PipeThreeQuarterInch(), hollow=true, length=18);

ChargingPumpAssembly(debug=true);

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

// Foregrip

*!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
ChargingPump();

// Charger
*!scale(25.4)
rotate([0,90,0])
translate([-BreechRearX(),0,0])
Charger();