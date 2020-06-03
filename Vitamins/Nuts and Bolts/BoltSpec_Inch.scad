use <../../Meta/Units.scad>;
use <BoltSpec.scad>;

function Spec_Bolt8_32() = [
  ["BoltDiameter",    UnitsImperial(0.1640)],

  ["BoltSocketCapDiameter", UnitsImperial(0.270)],
  ["BoltSocketCapHeight",   UnitsImperial(0.164)],

  ["BoltFlatHeadDiameter", UnitsImperial(0.359)],
  ["BoltFlatHeadHeight",   UnitsImperial(0.112)],

  ["NutHexDiameter", UnitsImperial(0.34375)],
  ["NutHexHeight",   UnitsImperial(0.125)],

  ["NutHeatsetMajorDiameter", UnitsImperial(0.234)],
  ["NutHeatsetMinorDiameter", UnitsImperial(0.226)],
  ["NutHeatsetHeight",        UnitsImperial(0.185)],

  ["NutHeatsetLongMajorDiameter", UnitsMetric(6.35)],
  ["NutHeatsetLongMinorDiameter", UnitsMetric(5.38)],
  ["NutHeatsetLongHeight",        UnitsMetric(7.92)]
];

function Spec_Bolt10_24() = [
  ["BoltDiameter",    UnitsImperial(0.1900)],

  ["BoltSocketCapDiameter", UnitsImperial(0.270)],
  ["BoltSocketCapHeight",   UnitsImperial(0.164)],

  ["BoltFlatHeadDiameter", UnitsImperial(0.411)],
  ["BoltFlatHeadHeight",   UnitsImperial(0.127)],

  ["NutHexDiameter", UnitsImperial(0.34375)],
  ["NutHexHeight",   UnitsImperial(0.125)],

  ["NutHeatsetMajorDiameter", UnitsMetric(7.52)],
  ["NutHeatsetMinorDiameter", UnitsMetric(6.90)],
  ["NutHeatsetHeight",        UnitsMetric(5.72)],

  ["NutHeatsetLongMajorDiameter", UnitsMetric(7.54)],
  ["NutHeatsetLongMinorDiameter", UnitsMetric(6.38)],
  ["NutHeatsetLongHeight",        UnitsMetric(9.53)]
];

function Spec_BoltOneHalf() = [
  ["BoltDiameter",    UnitsImperial(0.5)],
  ["BoltHexDiameter", UnitsImperial(0.85)], // WRONG
  ["BoltHexHeight",   UnitsImperial(0.325)],  // WRONG
  
  ["BoltSocketCapDiameter", UnitsImperial(0.85)],
  ["BoltSocketCapHeight",   UnitsImperial(0.310)],

  ["NutHexDiameter", UnitsImperial(0.85)],
  ["NutHexHeight",   UnitsImperial(0.45)],
];

function Spec_BoltOneQuarter() = [
  ["BoltDiameter",    UnitsImperial(0.25)],
  
  ["BoltSocketCapDiameter", UnitsImperial(0.375)],
  ["BoltSocketCapHeight",   UnitsImperial(0.25)],
  
  ["BoltFlatHeadDiameter", UnitsImperial(0.505)],
  ["BoltFlatHeadHeight",   UnitsImperial(0.161)],
  
  ["BoltHexDiameter", UnitsImperial(0.566)],
  ["BoltHexHeight",   UnitsImperial(0.25)],
  
  ["NutHexDiameter", UnitsImperial(0.566)],
  ["NutHexHeight",   UnitsImperial(0.25)],

  ["NutHeatsetMajorDiameter", UnitsMetric(9.53)],
  ["NutHeatsetMinorDiameter", UnitsMetric(9.0)],
  ["NutHeatsetHeight",        UnitsMetric(7.62)],

  ["NutHeatsetLongMajorDiameter", UnitsMetric(9.52)],
  ["NutHeatsetLongMinorDiameter", UnitsMetric(8.0)],
  ["NutHeatsetLongHeight",        UnitsMetric(12.7)]
];

function Spec_BoltFiveSixteenths() = [
  ["BoltDiameter",    UnitsImperial(0.3125)],

  // TODO: Verify
  //["BoltSocketCapDiameter", UnitsImperial(0.567)],
  //["BoltSocketCapHeight",   UnitsImperial(0.212)],

  //["BoltFlatHeadDiameter", UnitsImperial(0.411)],
  //["BoltFlatHeadHeight",   UnitsImperial(0.127)],

  ["NutHexDiameter", UnitsImperial(0.557)],
  ["NutHexHeight",   UnitsImperial(0.263)],

  //["NutHeatsetMajorDiameter", UnitsMetric(6.35)],
  //["NutHeatsetMinorDiameter", UnitsMetric(5.38)],
  //["NutHeatsetHeight",        UnitsMetric(7.92)]


  ["BoltDiameter",    UnitsImperial(0.3125)],
  ["BoltSocketCapDiameter", UnitsImperial(0.567)], // Verify?
  ["BoltSocketCapHeight",   UnitsImperial(0.212)],// Verify?
  ["NutHexDiameter", UnitsImperial(0.557)],
  ["NutHexHeight",   UnitsImperial(0.263)],
];

function Spec_BoltThreeEighths() = [
  ["BoltDiameter",    UnitsImperial(3/8)],
  ["BoltSocketCapDiameter", UnitsImperial(0.5625)], // Verify?
  ["BoltSocketCapHeight",   UnitsImperial(0.25)],// Verify?
  ["NutHexDiameter", UnitsImperial(0.5625)],
  ["NutHexHeight",   UnitsImperial(0.25)],
];
