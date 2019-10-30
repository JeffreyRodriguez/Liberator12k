include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Components/Cylinder Redux.scad>;
use <../Components/Pump Grip.scad>;

use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;

use <../Finishing/Chamfer.scad>;

use <../Shapes/Bearing Surface.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/TeardropTorus.scad>;
use <../Shapes/Semicircle.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

use <../Ammo/Shell Slug.scad>;

use <Lugs.scad>;
use <Linear Hammer.scad>;
use <Recoil Plate.scad>;

// Settings: Vitamins
function ChargingRod() = Spec_RodOneQuarterInch();
function ChargingRodBolt() = Spec_BoltM4();

// Settings: Lengths
function ChargingRodLength() = 12;
function ChargerTowerLength() = 0.5;

/* How far does the stationary portion of the square rod
 extend into the part that holds it? */
function ChargingRodStaticLength() = 1;

function ChargingRodOffset() =  0.875+RodRadius(ChargingRod());

// Settings: Walls
function WallCharger() = 1/8;

function ChargingRodWidth() = RodDiameter(ChargingRod());
function ChargingRodMinX() = RecoilPlateRearX()-0.5;
function ChargingRodMaxX() = ChargingRodMinX()+ChargingRodLength();

// Calculated: Lengths
function ChargerTravel() = 2.25;

// Calculated: Positions
echo("Charging Rod Length: ", ChargingRodLength());

function ForegripFrontX() = ChargingRodMinX()
                    + ChargingRodLength()
                    - ChargingRodStaticLength();
function ForegripRearX() = ForegripFrontX()-PumpGripLength();

function ChargerAnimationFactor() = Animate(ANIMATION_STEP_CHARGE)
                             - Animate(ANIMATION_STEP_CHARGER_RESET);

module ZigZagJig() {
  length=ChargerTravel()+ChargerTowerLength()+abs(RecoilPlateRearX())+(ChargerTowerLength()/2);
  height=0.75;
  width=0.75;

  difference() {
    translate([0,-(width/2),0])
    ChamferedCube([length,
                   width,
                   height], r=1/16);

    // Charging rod
    translate([0,0,height-RodRadius(ChargingRod())])
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=length+ManifoldGap(),
              clearance=RodClearanceSnug());

    // ZigZag Actuator
    for (X = [0,ChargerTravel()+abs(RecoilPlateRearX())+(ChargerTowerLength()/2)])
    translate([(ChargerTowerLength()/2)+X,0,-ManifoldGap()])
    cylinder(r=3/32/2, h=height, $fn=8);
  }

}
echo ("Charger wing bottom Z", ChargingRodOffset()+RodRadius(ChargingRod())+WallCharger()+0.071);

module ChargingRodBolts(cutter=false, teardrop=false) {
  clearance = cutter?0.005:0;

  // Charger
  color("SteelBlue")
  translate([ChargingRodMinX()+(WallCharger()*2), 0,
             ChargingRodOffset()+RodRadius(ChargingRod())+WallCharger()+0.071])
  Bolt(bolt=ChargingRodBolt(), head="socket", capOrientation=true,
       length=cutter?1.5:1, clearance=clearance, teardrop=cutter, teardropAngle=180);

  // Pump grip
  translate([ChargingRodMaxX()-0.5,0,
             ChargingRodOffset()+RodRadius(ChargingRod())+WallCharger()])
  Bolt(bolt=ChargingRodBolt(), capOrientation=true, head="socket",
       length=cutter?1.5:1, clearance=clearance, teardrop=cutter);

  // ZigZag Actuator
  translate([ChargerTravel()+(ChargingRodWidth()/2),0,ChargingRodOffset()-RodRadius(ChargingRod())])
  mirror([0,0,1])
  Bolt(bolt=ChargingRodBolt(), capOrientation=true, head="socket",
       length=3/16, clearance=clearance, teardrop=cutter);

}

module ChargingRod(clearance=RodClearanceLoose(),
                   length=ChargingRodLength(),
                   minX=ChargingRodMinX(),
                   bolt=true,
                   travel=ChargerTravel(),
                   cutter=false, debug=false) {
  color("Silver")
  DebugHalf(enabled=debug) {

    // Charging rod
    translate([minX-(cutter?ChargerTravel():0),0,ChargingRodOffset()])
    rotate([0,90,0])
    SquareRod(ChargingRod(), length=length+(cutter?ChargerTravel():0)+ManifoldGap(),
              clearance=cutter?clearance:undef);
  }
}


module ChargingPump(innerRadius=1.1/2,
                    debug=false, alpha=1,
                    $fn=Resolution(20,50)) {

  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
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
      PumpGrip();
    }

    // Barrel hole, but with a bearing profile
    translate([ForegripFrontX()+(PumpGripLength()/2),0,0])
    rotate([0,90,0])
    BearingSurface(r=innerRadius, length=PumpGripLength(),
                   depth=0.0625, segments=6, taperDepth=0.125,
                   center=true);

    ChargingRod(length=ChargingRodLength(),
                travel=ChargerTravel(),
                clearance=RodClearanceSnug(), cutter=true);

    ChargingRodBolts(cutter=true);
  }
}





module ChargingPumpAssembly(animationFactor=ChargerAnimationFactor(),
                            length=ChargingRodLength(), minX=ChargingRodMinX(),
                               pipeAlpha=1, debug=false) {
  translate([-ChargerTravel()*animationFactor,0,0]) {

    color("Silver")
    ChargingRodBolts();

    ChargingRod(length=length, minX=minX, debug=debug);

    *Charger(debug=debug);

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
*!scale(25.4)
rotate([0,-90,0])
translate([-ForegripFrontX(),0,0])
ChargingPump(innerRadius=1.005/2);


// drilling jig for zigzag, charger, pump grip
*!scale(25.4)
//translate([ChargingRodMinX(),0,ChargingRodOffset()])
ZigZagJig();

//
// Charger
//
*!scale(25.4)
rotate([0,90,0])
translate([-RecoilPlateRearX(),0,-ChargingRodOffset()])
Charger();
