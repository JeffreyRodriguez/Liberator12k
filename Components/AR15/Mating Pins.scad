use <../../Meta/Clearance.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;

use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

function AR15_MatingPinSpec() = Spec_RodOneQuarterInch();
function AR15_PinZ() = -UnitsImperial(0.252);

function AR15_MatingPinDistance() = UnitsImperial(6.375);
function AR15_RearPinX() = 0;
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
          clearance=(cutter ? RodClearanceLoose() : undef));
  }

}

function AR15_MatingLugWidth() = UnitsImperial(0.49);

module AR15_MatingLugRear(width = AR15_MatingLugWidth(), cutter=false,
                          clearance=UnitsImperial(0.004),
                          extraTop=0) {
  clear = Clearance(clearance, cutter);
  clear2 = clear*2;

  lengthClear = Clearance(0.01, cutter==false);
  lengthClear2 = lengthClear*2;

  translate([AR15_RearPinX() -UnitsImperial(0.25)+lengthClear-clear,
             -(width/2) -clear,
             AR15_PinZ()-UnitsImperial(0.25)])
  cube([UnitsImperial(0.5)-lengthClear2+clear2, width+clear2, UnitsImperial(0.5)+extraTop]);
}

module AR15_MatingLugFront(width = AR15_MatingLugWidth(), cutter=false,
                           clearance=UnitsImperial(0.00375),
                         extraTop=0) {
  clear = Clearance(clearance, cutter);
  clear2 = clear*2;

  lengthClear = Clearance(0.01, cutter==false);
  lengthClear2 = lengthClear*2;

  translate([AR15_RearPinX() -UnitsImperial(0.25)+lengthClear-clear+AR15_MatingPinDistance(),
             -(width/2) -clear,
             AR15_PinZ()-UnitsImperial(0.25)])
  cube([UnitsImperial(0.5)-lengthClear2+clear2, width+clear2, UnitsImperial(0.5)+extraTop]);
}

module AR15_MatingLugs(width = AR15_MatingLugWidth(), cutter=false,
                       clearance=UnitsImperial(0.00375),
                       extraTop=0) {
  AR15_MatingLugFront(cutter=cutter, clearance=clearance, extraTop=extraTop);
  AR15_MatingLugRear(cutter=cutter, clearance=clearance, extraTop=extraTop);
}


AR15_MatingPins();
%AR15_MatingLugs(cutter=true);
