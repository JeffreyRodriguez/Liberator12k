include <../../Meta/Common.scad>;

use <BoltSpec.scad>;

function Spec_Bolt4_40() = [
  ["BoltDiameter",    Inches(0.1055)],
  ["BoltTappingDrillSize",  Inches(0.0890)],

  /* ["BoltSocketCapDiameter", Inches(0.270)],
  ["BoltSocketCapHeight",   Inches(0.164)], */

  ["BoltFlatHeadDiameter", Inches(0.23)],
  ["BoltFlatHeadHeight",   Inches(0.1)],

  /* ["NutHexDiameter", Inches(0.34375)],
  ["NutHexHeight",   Inches(0.125)], */

  /* ["NutHeatsetMajorDiameter", Inches(0.234)],
  ["NutHeatsetMinorDiameter", Inches(0.226)],
  ["NutHeatsetHeight",        Inches(0.185)], */

  /* ["NutHeatsetLongMajorDiameter", Millimeters(6.35)],
  ["NutHeatsetLongMinorDiameter", Millimeters(5.38)],
  ["NutHeatsetLongHeight",        Millimeters(7.92)] */
];

function Spec_Bolt6_32() = [
  ["BoltDiameter",    Inches(0.135)],
  ["BoltTappingDrillSize",  Inches(0.1065)],

  /* ["BoltSocketCapDiameter", Inches(0.270)],
  ["BoltSocketCapHeight",   Inches(0.164)], */

  ["BoltFlatHeadDiameter", Inches(0.270)],
  ["BoltFlatHeadHeight",   Inches(0.115)],

  /* ["NutHexDiameter", Inches(0.34375)],
  ["NutHexHeight",   Inches(0.125)], */

  /* ["NutHeatsetMajorDiameter", Inches(0.234)],
  ["NutHeatsetMinorDiameter", Inches(0.226)],
  ["NutHeatsetHeight",        Inches(0.185)], */

  /* ["NutHeatsetLongMajorDiameter", Millimeters(6.35)],
  ["NutHeatsetLongMinorDiameter", Millimeters(5.38)],
  ["NutHeatsetLongHeight",        Millimeters(7.92)] */
];


function Spec_Bolt8_32() = [
  ["BoltDiameter",    Inches(0.1640)],
  ["BoltTappingDrillSize",  Inches(0.1360)],

  ["BoltCarriageDiameter", Inches(0.328)],
  ["BoltCarriageHeight",   Inches(0.164)],

  ["BoltSocketCapDiameter", Inches(0.270)],
  ["BoltSocketCapHeight",   Inches(0.164)],

  ["BoltFlatHeadDiameter", Inches(0.359)],
  ["BoltFlatHeadHeight",   Inches(0.112)],

  ["BoltHexDiameter", Inches(0.3095)],
  ["BoltHexHeight",   Inches(0.125)],

  ["NutHexDiameter", Inches(0.3755)],
  ["NutHexHeight",   Inches(0.125)],

  ["NutHeatsetMajorDiameter", Inches(0.234)],
  ["NutHeatsetMinorDiameter", Inches(0.226)],
  ["NutHeatsetHeight",        Inches(0.185)],

  ["NutHeatsetLongMajorDiameter", Millimeters(6.35)],
  ["NutHeatsetLongMinorDiameter", Millimeters(5.38)],
  ["NutHeatsetLongHeight",        Millimeters(7.92)]
];

function Spec_Bolt10_24() = [
  ["BoltDiameter",    Inches(0.1900)],
  ["BoltTappingDrillSize",  Inches(0.1470)],

  ["BoltCarriageDiameter", Inches(0.436)],
  ["BoltCarriageHeight",   Inches(0.19)],

  ["BoltSocketCapDiameter", Inches(0.270)],
  ["BoltSocketCapHeight",   Inches(0.164)],

  ["BoltFlatHeadDiameter", Inches(0.411)],
  ["BoltFlatHeadHeight",   Inches(0.127)],

  ["NutHexDiameter", Inches(0.34375)],
  ["NutHexHeight",   Inches(0.125)],

  ["NutHeatsetMajorDiameter", Millimeters(7.52)],
  ["NutHeatsetMinorDiameter", Millimeters(6.90)],
  ["NutHeatsetHeight",        Millimeters(5.72)],

  ["NutHeatsetLongMajorDiameter", Millimeters(7.54)],
  ["NutHeatsetLongMinorDiameter", Millimeters(6.38)],
  ["NutHeatsetLongHeight",        Millimeters(9.53)]
];

function Spec_BoltOneHalf() = [
  ["BoltDiameter",    Inches(0.5)],
  ["BoltTappingDrillSize",  Inches(0.4219)],

  ["BoltCarriageDiameter", Inches(1.094)],
  ["BoltCarriageHeight",   Inches(0.5)],

  ["BoltHexDiameter", Inches(0.85)], // WRONG
  ["BoltHexHeight",   Inches(0.325)],  // WRONG

  ["BoltSocketCapDiameter", Inches(0.85)],
  ["BoltSocketCapHeight",   Inches(0.310)],

  ["NutHexDiameter", Inches(0.85)],
  ["NutHexHeight",   Inches(0.45)],
];

function Spec_BoltOneQuarter() = [
  ["BoltDiameter",    Inches(0.25)],
  ["BoltTappingDrillSize",  Inches(0.2010)],

  ["BoltCarriageDiameter", Inches(0.594)],
  ["BoltCarriageHeight",   Inches(0.25)],

  ["BoltSocketCapDiameter", Inches(0.375)],
  ["BoltSocketCapHeight",   Inches(0.25)],

  ["BoltFlatHeadDiameter", Inches(0.49)],
  ["BoltFlatHeadHeight",   Inches(0.191)],

  ["BoltHexDiameter", Inches(0.566)],
  ["BoltHexHeight",   Inches(0.25)],

  ["NutHexDiameter", Inches(0.492)],
  ["NutHexHeight",   Inches(0.217)],

  ["NutHeatsetMajorDiameter", Millimeters(9.53)],
  ["NutHeatsetMinorDiameter", Millimeters(9.0)],
  ["NutHeatsetHeight",        Millimeters(7.62)],

  ["NutHeatsetLongMajorDiameter", Millimeters(9.52)],
  ["NutHeatsetLongMinorDiameter", Millimeters(8.0)],
  ["NutHeatsetLongHeight",        Millimeters(12.7)]
];

function Spec_BoltFiveSixteenths() = [
  ["BoltDiameter",    Inches(0.3125)],
  ["BoltTappingDrillSize",  Inches(0.2570)],

  ["BoltCarriageDiameter", Inches(0.719)],
  ["BoltCarriageHeight",   Inches(0.3125)],

  ["BoltHexDiameter", Inches(0.565)],
  ["BoltHexHeight",   Inches(0.203)],

  // TODO: Verify
  //["BoltSocketCapDiameter", Inches(0.567)],
  //["BoltSocketCapHeight",   Inches(0.212)],

  //["BoltFlatHeadDiameter", Inches(0.411)],
  //["BoltFlatHeadHeight",   Inches(0.127)],

  ["NutHexDiameter", Inches(0.557)],
  ["NutHexHeight",   Inches(0.263)],

  //["NutHeatsetMajorDiameter", Millimeters(6.35)],
  //["NutHeatsetMinorDiameter", Millimeters(5.38)],
  //["NutHeatsetHeight",        Millimeters(7.92)]


  ["BoltDiameter",    Inches(0.3125)],
  ["BoltSocketCapDiameter", Inches(0.567)], // Verify?
  ["BoltSocketCapHeight",   Inches(0.212)],// Verify?
  ["NutHexDiameter", Inches(0.557)],
  ["NutHexHeight",   Inches(0.263)],
];

function Spec_BoltThreeEighths() = [
  ["BoltDiameter",    Inches(3/8)],
  ["BoltTappingDrillSize",  Inches(0.3125)],

  ["BoltCarriageDiameter", Inches(0.8440)],
  ["BoltCarriageHeight",   Inches(0.3750)],

  ["BoltSocketCapDiameter", Inches(0.5625)], // Verify?
  ["BoltSocketCapHeight",   Inches(0.25)],// Verify?
  ["NutHexDiameter", Inches(0.5625)],
  ["NutHexHeight",   Inches(0.25)],
];
