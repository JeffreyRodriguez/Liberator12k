use <../../Meta/Units.scad>;
use <BoltSpec.scad>;

function Spec_BoltM2() = [ // these are all a total guess
  ["BoltDiameter",            UnitsMetric(2)],

  ["BoltSocketCapDiameter",   UnitsMetric(4.4)],
  ["BoltSocketCapHeight",     UnitsMetric(1.6)],

  ["NutHexDiameter",          UnitsMetric(4.32)],
  ["NutHexHeight",            UnitsMetric(1.6)],
  ["NutHexNylonHeight",       UnitsMetric(4.5)], // ???: Guessed
  ["NutHeatsetMajorDiameter", UnitsMetric(3.12)],
  ["NutHeatsetMinorDiameter", UnitsMetric(2.7)],
  ["NutHeatsetHeight",        UnitsMetric(4.8)],
];

function Spec_BoltM2pt5() = [
  ["NutHexDiameter",    UnitsMetric(4.45)],
  ["NutHexHeight", UnitsMetric(2)],
  ["NutHexNylonHeight",   UnitsMetric(4.5)], // ???: Guessed
  ["NutHeatsetMajorDiameter", UnitsMetric(4.04)],
  ["NutHeatsetMinorDiameter",   UnitsMetric(3.6)],
  ["NutHeatsetHeight",   UnitsMetric(5.6)]
];


function Spec_BoltM3() = [
  ["BoltDiameter",    UnitsMetric(3)],
  ["BoltSocketCapDiameter", UnitsMetric(5.4)],
  ["BoltSocketCapHeight",   UnitsMetric(2.6)],
  ["NutHexDiameter", UnitsMetric(6.28)],
  ["NutHexHeight",   UnitsMetric(2.5)],

  ["NutHexDiameter",    UnitsMetric(6.01)],
  ["NutHexHeight", UnitsMetric(2.4)],
  ["NutHexNylonHeight",   UnitsMetric(4.5)], // ???: Guessed
  ["NutHeatsetMajorDiameter", UnitsMetric(5.31+0.3)],
  ["NutHeatsetMinorDiameter",   UnitsMetric(5.1+0.3)],
  ["NutHeatsetHeight",   UnitsMetric(6.4+0.6)]
];

function Spec_BoltM4() = [

  ["BoltDiameter",    UnitsMetric(4)],

  ["BoltSocketCapDiameter", UnitsMetric(7.4+0.3)],
  ["BoltSocketCapHeight",   UnitsMetric(3.9)],

  ["BoltFlatHeadDiameter", UnitsImperial(0.312)],
  ["BoltFlatHeadHeight",   UnitsImperial(0.100)],

  ["NutHexDiameter",    UnitsMetric(7.7)],
  ["NutHexHeight", UnitsMetric(3.2)],

  ["NutHeatsetMajorDiameter", UnitsMetric(6.35)],
  ["NutHeatsetMinorDiameter", UnitsMetric(5.38)],
  ["NutHeatsetHeight",        UnitsMetric(7.92)]
];

function Spec_BoltM5() = [
  ["BoltDiameter",    UnitsMetric(5)],

  ["BoltSocketCapDiameter", UnitsMetric(7.4+0.3)],
  ["BoltSocketCapHeight",   UnitsMetric(3.9)],


  ["BoltFlatHeadDiameter", UnitsImperial(0.312)],
  ["BoltFlatHeadHeight",   UnitsImperial(0.100)],

  ["NutHexDiameter",    UnitsMetric(8.79)],
  ["NutHexHeight", UnitsMetric(4.7)],
  ["NutHexNylonHeight",   UnitsMetric(4.5)], // ???: Guessed
  ["NutHeatsetMajorDiameter", UnitsMetric(8)],
  ["NutHeatsetMinorDiameter",   UnitsMetric(7.1)],
  ["NutHeatsetHeight",   UnitsMetric(11.5)]
];

function Spec_BoltM8() = [
  ["BoltDiameter",    UnitsMetric(8)],
  ["BoltSocketCapDiameter", UnitsMetric(13.1)],
  ["BoltSocketCapHeight",   UnitsMetric(8)],
  ["NutHexDiameter", UnitsMetric(14.75)],
  ["NutHexHeight",   UnitsMetric(6.3)],
  ["BoltFn", 20]
];
