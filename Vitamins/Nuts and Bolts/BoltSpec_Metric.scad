use <../../Meta/Units.scad>;
use <BoltSpec.scad>;

// Bolt tapping drill sizes: https://web.archive.org/web/20210406172745/https://www.natool.com/wp-content/uploads/2019/06/tapdrillsizes-inmet_web_catp113-116.pdf

// DIN912 spec: https://en.torqbolt.com/din-912-dimensions-standards-specifications/#
// BoltSocketCapDiameter -> dk
// BoltSocketCapHeight   -> k

// DIN7991 spec: https://www.fasteners.eu/standards/DIN/7991/
// BoltFlatHeadDiameter  -> dk
// BoltFlatHeadHeight    -> k

// DIN933 spec: http://fpg-co.com/Standards/DIN933.pdf
// BoltHexDiameter       -> (2*S)/SQRT(3)

// DIN934 spec: https://aspenfasteners.com/content/pdf/Metric_DIN_934_spec.pdf
// NutHexDiameter        -> (2*S)/SQRT(3)
// NutHexHeight          -> M

// DIN982 spec: https://www.singhaniainternational.com/products-details/Nylock_Nuts_-DIN_982_-_DIN_985-/100
// NutHexNylonHeight     -> h

// Heatset Nut Measures
// Minor Diameter took measure on bottom lip
// Above Lip Minor Diameter took measure above bottom lip


function Spec_BoltM2() = [ // these are all a total guess
  ["BoltDiameter",            Millimeters(2.00)],
  ["BoltTappingDrillSize",    Millimeters(1.60)],

  // DIN912
  ["BoltSocketCapDiameter",   Millimeters(3.80)],  // +- 0.18mm
  ["BoltSocketCapHeight",     Millimeters(1.93)],  // +- 0.07mm

  // DIN933
  ["BoltHexDiameter",         Millimeters(4.515)], // +- 0.104mm
  ["BoltHexHeight",           Millimeters(1.4)],   // +- 0.12mm

  // DIN934
  ["NutHexDiameter",          Millimeters(4.503)], // +- 0.116mm
  ["NutHexHeight",            Millimeters(1.5)],   // +- 0.1mm

  // DIN982 Unavailable

  // DIN7991 Unavailable

  // Heatset Nut Short: M2xD4xL3
  ["NutHeatsetMajorDiameter",           Millimeters(4.00)],
  ["NutHeatsetMinorDiameter",           Millimeters(3.25)],
  ["NutHeatsetHeight",                  Millimeters(3.00)],

  // Heatset Nut Long:  M2xD4xL4.5
  ["NutHeatsetLongMajorDiameter",       Millimeters(4.00)],
  ["NutHeatsetLongMinorDiameter",       Millimeters(3.25)],
  ["NutHeatsetLongHeight",              Millimeters(4.5)]
];

function Spec_BoltM2pt5() = [
  ["BoltDiameter",            Millimeters(2.50)],
  ["BoltTappingDrillSize",    Millimeters(2.05)],

  // DIN912
  ["BoltSocketCapDiameter",   Millimeters(4.50)],  // +- 0.18mm
  ["BoltSocketCapHeight",     Millimeters(2.43)],  // +- 0.07mm

  // DIN933
  ["BoltHexDiameter",         Millimeters(5.67)],  // +- 0.104mm
  ["BoltHexHeight",           Millimeters(1.7)],   // +- 0.12mm

  // DIN934
  ["NutHexDiameter",          Millimeters(5.658)], // +- 0.116mm
  ["NutHexHeight",            Millimeters(1.7)],   // +- 0.1mm

  // DIN982 Unavailable

  // DIN7991 Unavailable

  // Heatset Nut Short: M2.5x4.2x2.5
  ["NutHeatsetMajorDiameter",           Millimeters(4.20)],
  ["NutHeatsetMinorDiameter",           Millimeters(3.60)],
  ["NutHeatsetHeight",                  Millimeters(2.50)],

  // Heatset Nut Long:  M2.5x4.2x5.0
  ["NutHeatsetLongMajorDiameter",       Millimeters(4.20)],
  ["NutHeatsetLongMinorDiameter",       Millimeters(3.45)],
  ["NutHeatsetLongHeight",              Millimeters(5.00)]
];


function Spec_BoltM3() = [
  ["BoltDiameter",          Millimeters(3.00)],
  ["BoltTappingDrillSize",  Millimeters(2.50)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(5.50)],  // +- 0.18mm
  ["BoltSocketCapHeight",   Millimeters(2.93)],  // +- 0.07mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(6.247)], // +- 0.104mm
  ["BoltHexHeight",         Millimeters(2)],     // +- 0.12mm

  // DIN934
  ["NutHexDiameter",        Millimeters(6.235)], // +- 0.116mm
  ["NutHexHeight",          Millimeters(2.3)],   // +- 0.1mm

  // DIN982 Unavailable

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(5.85)],  // +- 0.15mm
  ["BoltFlatHeadHeight",    Millimeters(1.7)],   // Only MAX value was provided


  // Heatset Nut Short: M3xD5xL3
  ["NutHeatsetMajorDiameter",           Millimeters(5.00)],
  ["NutHeatsetMinorDiameter",           Millimeters(4.10)],
  ["NutHeatsetHeight",                  Millimeters(3.00)],

  /*
  // Heatset Nut Short: M3xD5xL4
  ["NutHeatsetMajorDiameter",           Millimeters(5.00)],
  ["NutHeatsetMinorDiameter",           Millimeters(4.10)],
  ["NutHeatsetHeight",                  Millimeters(4.00)],
  */

  // Heatset Nut Long:  M3xD5xL7
  ["NutHeatsetLongMajorDiameter",       Millimeters(5.00)],
  ["NutHeatsetLongMinorDiameter",       Millimeters(4.1)],
  ["NutHeatsetLongHeight",              Millimeters(7.00)]
];

function Spec_BoltM3pt5() = [
  ["BoltDiameter",            Millimeters(3.50)],
  ["BoltTappingDrillSize",    Millimeters(2.90)],

  // DIN912 (this is somewhat of a guess for M3.5)
  ["BoltSocketCapDiameter",   Millimeters(6.25)],  // +- 0.2mm
  ["BoltSocketCapHeight",     Millimeters(3.41)],  // +- 0.09mm

  // DIN933
  ["BoltHexDiameter",         Millimeters(6.824)], // +- 0.104mm
  ["BoltHexHeight",           Millimeters(2.4)],   // +- 0.12mm

  // DIN934
  ["NutHexDiameter",          Millimeters(6.813)], // +- 0.115mm
  ["NutHexHeight",            Millimeters(2.7)],   // +- 0.1mm

  // DIN982 Unavailable

  // DIN7991 Unavailable

  // Heatset Nut Not Available For Measure
];

function Spec_BoltM4() = [
  ["BoltDiameter",          Millimeters(4.00)],
  ["BoltTappingDrillSize",  Millimeters(3.30)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(7.00)],  // +- 0.22mm
  ["BoltSocketCapHeight",   Millimeters(3.91)],  // +- 0.09mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(7.956)], // +- 0.127mm
  ["BoltHexHeight",         Millimeters(2.8)],   // +- 0.12mm

  // DIN934
  ["NutHexDiameter",        Millimeters(7.967)], // +- 0.116mm
  ["NutHexHeight",          Millimeters(3.05)],  // +- 0.15mm

  // DIN982 Unavailable

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(7.82)],  // +- 0.18mm
  ["BoltFlatHeadHeight",    Millimeters(2.3)],   // Only MAX value was provided

  // Heatset Nut Short: M4xD7xL5
  ["NutHeatsetMajorDiameter",           Millimeters(7.00)],
  ["NutHeatsetMinorDiameter",           Millimeters(5.80)],
  ["NutHeatsetHeight",                  Millimeters(5.00)],

  // Heatset Nut Long:  M4xD7xL8
  ["NutHeatsetLongMajorDiameter",       Millimeters(7.00)],
  ["NutHeatsetLongMinorDiameter",       Millimeters(5.80)],
  ["NutHeatsetLongHeight",              Millimeters(8.00)]
];

function Spec_BoltM5() = [
  ["BoltDiameter",          Millimeters(5.00)],
  ["BoltTappingDrillSize",  Millimeters(4.20)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(8.50)],  // +- 0.22mm
  ["BoltSocketCapHeight",   Millimeters(4.91)],  // +- 0.09mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(9.111)], // +- 0.127mm
  ["BoltHexHeight",         Millimeters(3.5)],   // +- 0.15mm

  // DIN934
  ["NutHexDiameter",        Millimeters(9.122)], // +- 0.116mm
  ["NutHexHeight",          Millimeters(4.55)],  // +- 0.15mm

  // DIN982
  ["NutHexNylonHeight",     Millimeters(6.15)],  // +- 0.15mm

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(9.82)],  // +- 0.18mm
  ["BoltFlatHeadHeight",    Millimeters(2.8)],   // Only MAX value was provided

  // Heatset Nut Short: M5xD8xL5
  ["NutHeatsetMajorDiameter",           Millimeters(8.00)],
  ["NutHeatsetMinorDiameter",           Millimeters(6.80)],
  ["NutHeatsetHeight",                  Millimeters(5.00)],

  // Heatset Nut Long:  M5xD8xL9
  ["NutHeatsetLongMajorDiameter",       Millimeters(8.00)],
  ["NutHeatsetLongMinorDiameter",       Millimeters(6.80)],
  ["NutHeatsetLongHeight",              Millimeters(9.00)]
];

function Spec_BoltM6() = [
  ["BoltDiameter",          Millimeters(6.00)],
  ["BoltTappingDrillSize",  Millimeters(5.00)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(10.00)],  // +- 0.22mm
  ["BoltSocketCapHeight",   Millimeters(5.85)],   // +- 0.15mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(11.42)],  // +- 0.127mm
  ["BoltHexHeight",         Millimeters(4)],      // +- 0.15mm

  // DIN934
  ["NutHexDiameter",        Millimeters(11.432)], // +- 0.115mm
  ["NutHexHeight",          Millimeters(5.05)],   // +- 0.15mm

  // DIN982
  ["NutHexNylonHeight",     Millimeters(7.85)],   // +- 0.15mm

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(11.785)], // +- 0.215mm
  ["BoltFlatHeadHeight",    Millimeters(3.3)],    // Only MAX value was provided

  // Heatset Nut Short: M6xD9.5xL6
  ["NutHeatsetMajorDiameter",           Millimeters(9.50)],
  ["NutHeatsetMinorDiameter",           Millimeters(8.00)],
  ["NutHeatsetHeight",                  Millimeters(6.00)],

  // Heatset Nut Long:  M6xD9.5xL9.5
  ["NutHeatsetLongMajorDiameter",       Millimeters(9.50)],
  ["NutHeatsetLongMinorDiameter",       Millimeters(8.00)],
  ["NutHeatsetLongHeight",              Millimeters(9.50)]
];

function Spec_BoltM8() = [
  ["BoltDiameter",          Millimeters(8.00)],
  ["BoltTappingDrillSize",  Millimeters(6.70)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(13.00)],  // +- 0.27mm
  ["BoltSocketCapHeight",   Millimeters(7.82)],   // +- 0.18mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(14.855)], // +- 0.156mm
  ["BoltHexHeight",         Millimeters(5.3)],    // +- 0.15mm

  // DIN934
  ["NutHexDiameter",        Millimeters(14.838)], // +- 0.173mm
  ["NutHexHeight",          Millimeters(6.6)],    // +- 0.2mm

  // DIN982
  ["NutHexNylonHeight",     Millimeters(9.32)],   // +- 0.18mm

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(15.785)], // +- 0.215mm
  ["BoltFlatHeadHeight",    Millimeters(4.4)],    // Only MAX value was provided

  // Heatset Nut Not Available For Measure
];


function Spec_BoltM10() = [
  ["BoltDiameter",          Millimeters(10.00)],
  ["BoltTappingDrillSize",  Millimeters(8.50)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(16.00)],  // +- 0.27mm
  ["BoltSocketCapHeight",   Millimeters(9.82)],   // +- 0.18mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(19.474)], // +- 0.156mm
  ["BoltHexHeight",         Millimeters(6.4)],    // +- 0.16mm

  // DIN934
  ["NutHexDiameter",        Millimeters(18.302)], // +- 0.173mm
  ["NutHexHeight",          Millimeters(8.2)],    // +- 0.2mm

  // DIN982
  ["NutHexNylonHeight",     Millimeters(11.32)],  // +- 0.18mm

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(19.74)],  // +- 0.26mm
  ["BoltFlatHeadHeight",    Millimeters(5.5)],    // Only MAX value was provided

  // Heatset Nut Not Available For Measure
];


function Spec_BoltM12() = [
  ["BoltDiameter",          Millimeters(12.00)],
  ["BoltTappingDrillSize",  Millimeters(10.20)],

  // DIN912
  ["BoltSocketCapDiameter", Millimeters(18.00)],  // +- 0.27mm
  ["BoltSocketCapHeight",   Millimeters(11.785)], // +- 0.215mm

  // DIN933
  ["BoltHexDiameter",       Millimeters(21.749)], // +- 0.19mm
  ["BoltHexHeight",         Millimeters(7.5)],    // +- 0.18mm

  // DIN934
  ["NutHexDiameter",        Millimeters(20.611)], // +- 0.174mm
  ["NutHexHeight",          Millimeters(10.6)],   // +- 0.2mm

  // DIN982
  ["NutHexNylonHeight",     Millimeters(13.82)],  // +- 0.18mm

  // DIN7991
  ["BoltFlatHeadDiameter",  Millimeters(23.74)],  // +- 0.26mm
  ["BoltFlatHeadHeight",    Millimeters(6.5)],    // Only MAX value was provided

  // Heatset Nut Not Available For Measure
];
