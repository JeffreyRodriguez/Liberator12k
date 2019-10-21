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

  ["NutHeatsetMajorDiameter", UnitsMetric(6.35)],
  ["NutHeatsetMinorDiameter", UnitsMetric(5.38)],
  ["NutHeatsetHeight",        UnitsMetric(7.92)]
];

function Spec_Bolt10_24() = [
  ["BoltDiameter",    UnitsImperial(0.1900)],

  ["BoltSocketCapDiameter", UnitsImperial(0.270)],
  ["BoltSocketCapHeight",   UnitsImperial(0.164)],

  ["BoltFlatHeadDiameter", UnitsImperial(0.411)],
  ["BoltFlatHeadHeight",   UnitsImperial(0.127)],

  ["NutHexDiameter", UnitsImperial(0.34375)],
  ["NutHexHeight",   UnitsImperial(0.125)],

  ["NutHeatsetMajorDiameter", UnitsMetric(6.35)],
  ["NutHeatsetMinorDiameter", UnitsMetric(5.38)],
  ["NutHeatsetHeight",        UnitsMetric(7.92)]
];

function Spec_BoltOneHalf() = [
  ["BoltDiameter",    UnitsImperial(0.5
  )],
  ["BoltSocketCapDiameter", UnitsImperial(0.85)],
  ["BoltSocketCapHeight",   UnitsImperial(0.310)],

  ["NutHexDiameter", UnitsImperial(0.85)],
  ["NutHexHeight",   UnitsImperial(0.45)],
];

function Spec_BoltOneQuarter() = [
  ["BoltDiameter",    UnitsImperial(0.25)],
  ["BoltSocketCapDiameter", UnitsImperial(0.566)], // Verify?
  ["BoltSocketCapHeight",   UnitsImperial(0.25)],// Verify?
  ["NutHexDiameter", UnitsImperial(0.566)],
  ["NutHexHeight",   UnitsImperial(0.25)],
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
