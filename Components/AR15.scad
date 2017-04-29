use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;

use <../Vitamins/Rod.scad>;
use <../Vitamins/Nuts And Bolts.scad>;

use <../Toys/AR Trigger Pack.scad>;

function AR15_MatingPinSpec() = Spec_RodOneQuarterInch();
function AR15_PinZ() = 0;

function AR15_MatingPinDistance() = 6.375;
function AR15_RearPinX() = -2;
function AR15_FrontPinX() = AR15_RearPinX() + AR15_MatingPinDistance();


module AR15_MatingPins(length=2, cutter=true) {
  PINS_XZ = [
    [AR15_RearPinX(), AR15_PinZ()],
    [AR15_FrontPinX(), AR15_PinZ()]
  ];

  rotate([90,0,0]) {
  for (XZ = PINS_XZ)

    translate([XZ[0],XZ[1]])
    Rod(rod=AR15_MatingPinSpec(),
          center=true, length=2,
          clearance=(cutter ? RodClearanceSnug() : undef));
  }

}



AR15_MatingPins();
