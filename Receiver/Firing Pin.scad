include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/slookup.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Rod.scad>;


// Firing pin housing bolt
HOUSING_BOLT = "#8-32"; // ["M3", "M4", "M5", "#8-32", "#10-24"]

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

function FiringPinHousingBolt() = BoltSpec(HOUSING_BOLT);
function FiringPinBoltOffsetY() = 0.5;

function FiringPinDiameter(clearance=0) = FIRING_PIN_DIAMETER+clearance;
function FiringPinRadius(clearance=0) = FiringPinDiameter(clearance)/2;

function FiringPinCollarDiameter() = FIRING_PIN_COLLAR_DIAMETER;
function FiringPinCollarRadius() = FiringPinCollarDiameter()/2;
function FiringPinCollarWidth() = 0.1875;

function FiringPinExtension() = 0.5;
function FiringPinTravel() = 0.03;
function FiringPinHousingLength() = 1;
function FiringPinHousingBack() = 0.25;
function FiringPinHousingWidth() = 0.75;

function FiringPinLength() = FiringPinHousingLength()
                           + FiringPinExtension()
                           + FiringPinTravel();

$fs = UnitsFs()*0.25;
module FiringPin(radius=FiringPinRadius(),
                 cutter=false, clearance=FIRING_PIN_CLEARANCE,
                 debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver")
  DebugHalf(enabled=debug)
  translate([0,0,FiringPinHousingLength()-FiringPinHousingBack()])
  mirror([0,0,1])
  cylinder(r=FiringPinCollarRadius()+clear,
           h=(cutter?FiringPinHousingLength():FiringPinCollarWidth()));

  color("DarkGoldenrod")
  translate([0,0,-FiringPinExtension()])
  cylinder(r=radius+clear,
           h=FiringPinLength());
}

module FiringPinHousingBolts(bolt=FiringPinHousingBolt(),
                              boltLength=0.5,
                              template=false, cutter=false, clearance=HOUSING_BOLT_CLEARANCE) {
  color("CornflowerBlue")
  rotate(90)
  for (Y = [1,-1])
  translate([0,Y*FiringPinBoltOffsetY(),FiringPinHousingLength()+ManifoldGap()])
  Bolt(bolt=bolt, capOrientation=true, head="flat",
       clearance=cutter?clearance:0,
       length=FiringPinHousingLength()+boltLength+ManifoldGap(2));
}

module FiringPinHousing(bolt=FiringPinHousingBolt(), cutter=false,
                        alpha=0.5, debug=false) {

  color("Grey")
  DebugHalf(enabled=debug) render()
  difference() {
    rotate(-90)
    union() {
      hull()
      for (Y = [1,-1])
      translate([0,Y*FiringPinBoltOffsetY(),0])
      ChamferedCylinder(r1=0.25, r2=1/32,
                         h=FiringPinHousingLength(),
                       teardropTop=true, teardropBottom=true);

      difference() {
        ChamferedCylinder(r1=FiringPinHousingWidth()/2, r2=1/32,
                           h=FiringPinHousingLength());

        translate([0,-FiringPinBoltOffsetY()*2,0])
        cube([1,FiringPinBoltOffsetY()*4,1]);
      }
    }

    if (!cutter) {
      // slot
      translate([-0.125,-1,0])
      cube([0.25,1,FiringPinHousingLength()-0.25]);

      FiringPin(cutter=true);

      FiringPinHousingBolts(bolt=bolt, cutter=true);

      // Chamfered Firing Pin Hole
      translate([0,0,FiringPinHousingLength()-FiringPinHousingBack()])
      ChamferedCircularHole(r1=FiringPinRadius(FIRING_PIN_CLEARANCE), r2=FiringPinRadius(), h=FiringPinHousingBack());
    }

  }
}

module FiringPinAssembly(boltLength=0.5,
         retainerBolt=FiringPinHousingBolt(),
         cutter=false, debug=false) {

  rotate(-90) {
    FiringPin(cutter=cutter, debug=debug);
    FiringPinHousingBolts(bolt=retainerBolt, boltLength=boltLength, cutter=cutter);

    if (!cutter)
    FiringPinHousing(debug=debug);
  }
}


if ($preview) {
  FiringPinAssembly(cutter=false, debug=false);

  translate([0,2,0])
  FiringPinAssembly(cutter=false, debug=true);
} else {
  scale(25.4)
  translate([0,0,FiringPinHousingLength()]) rotate([180,0,0])
  FiringPinHousing(cutter=false, debug=false);
}
