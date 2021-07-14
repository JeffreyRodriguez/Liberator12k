use <../../Meta/Units.scad>;
use <BoltSpec.scad>;

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
  ["BoltDiameter",            UnitsMetric(2.00)],
  
  // DIN912
  ["BoltSocketCapDiameter",   UnitsMetric(3.80)],  // +- 0.18mm
  ["BoltSocketCapHeight",     UnitsMetric(1.93)],  // +- 0.07mm
  
  // DIN933
  ["BoltHexDiameter",         UnitsMetric(4.515)], // +- 0.104mm 
  ["BoltHexHeight",           UnitsMetric(1.4)],   // +- 0.12mm
  
  // DIN934
  ["NutHexDiameter",          UnitsMetric(4.503)], // +- 0.116mm 
  ["NutHexHeight",            UnitsMetric(1.5)],   // +- 0.1mm
  
  // DIN982 Unavailable
  
  // DIN7991 Unavailable
  
  // Heatset Nut Short: M2xD4xL3
  ["NutHeatsetMajorDiameter",           UnitsMetric(4.00)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(3.25)],
  ["NutHeatsetHeight",                  UnitsMetric(3.00)],
  
  // Heatset Nut Long:  M2xD4xL4.5
  ["NutHeatsetLongMajorDiameter",       UnitsMetric(4.00)],
  ["NutHeatsetLongMinorDiameter",       UnitsMetric(3.25)],
  ["NutHeatsetLongHeight",              UnitsMetric(4.5)]
];

function Spec_BoltM2pt5() = [
  ["BoltDiameter",            UnitsMetric(2.50)],
  
  // DIN912
  ["BoltSocketCapDiameter",   UnitsMetric(4.50)],  // +- 0.18mm
  ["BoltSocketCapHeight",     UnitsMetric(2.43)],  // +- 0.07mm
  
  // DIN933
  ["BoltHexDiameter",         UnitsMetric(5.67)],  // +- 0.104mm 
  ["BoltHexHeight",           UnitsMetric(1.7)],   // +- 0.12mm
  
  // DIN934
  ["NutHexDiameter",          UnitsMetric(5.658)], // +- 0.116mm
  ["NutHexHeight",            UnitsMetric(1.7)],   // +- 0.1mm
  
  // DIN982 Unavailable
  
  // DIN7991 Unavailable
  
  // Heatset Nut Short: M2.5x4.2x2.5
  ["NutHeatsetMajorDiameter",           UnitsMetric(4.20)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(3.60)],
  ["NutHeatsetHeight",                  UnitsMetric(2.50)],
  
  // Heatset Nut Long:  M2.5x4.2x5.0
  ["NutHeatsetLongMajorDiameter",       UnitsMetric(4.20)],
  ["NutHeatsetLongMinorDiameter",       UnitsMetric(3.45)],
  ["NutHeatsetLongHeight",              UnitsMetric(5.00)]
];


function Spec_BoltM3() = [
  ["BoltDiameter",          UnitsMetric(3.00)],
  
  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(5.50)],  // +- 0.18mm
  ["BoltSocketCapHeight",   UnitsMetric(2.93)],  // +- 0.07mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(6.247)], // +- 0.104mm 
  ["BoltHexHeight",         UnitsMetric(2)],     // +- 0.12mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(6.235)], // +- 0.116mm
  ["NutHexHeight",          UnitsMetric(2.3)],   // +- 0.1mm
  
  // DIN982 Unavailable
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(5.85)],  // +- 0.15mm
  ["BoltFlatHeadHeight",    UnitsMetric(1.7)],   // Only MAX value was provided
  
  
  // Heatset Nut Short: M3xD5xL3
  ["NutHeatsetMajorDiameter",           UnitsMetric(5.00)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(4.10)],
  ["NutHeatsetHeight",                  UnitsMetric(3.00)],
  
  /*
  // Heatset Nut Short: M3xD5xL4
  ["NutHeatsetMajorDiameter",           UnitsMetric(5.00)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(4.10)],
  ["NutHeatsetHeight",                  UnitsMetric(4.00)],
  */
  
  // Heatset Nut Long:  M3xD5xL7
  ["NutHeatsetLongMajorDiameter",       UnitsMetric(5.00)],
  ["NutHeatsetLongMinorDiameter",       UnitsMetric(4.1)],
  ["NutHeatsetLongHeight",              UnitsMetric(7.00)]
];

function Spec_BoltM3pt5() = [
  ["BoltDiameter",            UnitsMetric(3.50)],
  
  // DIN912 (this is somewhat of a guess for M3.5)
  ["BoltSocketCapDiameter",   UnitsMetric(6.25)],  // +- 0.2mm
  ["BoltSocketCapHeight",     UnitsMetric(3.41)],  // +- 0.09mm
  
  // DIN933
  ["BoltHexDiameter",         UnitsMetric(6.824)], // +- 0.104mm 
  ["BoltHexHeight",           UnitsMetric(2.4)],   // +- 0.12mm
  
  // DIN934
  ["NutHexDiameter",          UnitsMetric(6.813)], // +- 0.115mm
  ["NutHexHeight",            UnitsMetric(2.7)],   // +- 0.1mm
  
  // DIN982 Unavailable
  
  // DIN7991 Unavailable
  
  // Heatset Nut Not Available For Measure
];

function Spec_BoltM4() = [
  ["BoltDiameter",          UnitsMetric(4.00)],

  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(7.00)],  // +- 0.22mm
  ["BoltSocketCapHeight",   UnitsMetric(3.91)],  // +- 0.09mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(7.956)], // +- 0.127mm 
  ["BoltHexHeight",         UnitsMetric(2.8)],   // +- 0.12mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(7.967)], // +- 0.116mm
  ["NutHexHeight",          UnitsMetric(3.05)],  // +- 0.15mm
  
  // DIN982 Unavailable
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(7.82)],  // +- 0.18mm
  ["BoltFlatHeadHeight",    UnitsMetric(2.3)],   // Only MAX value was provided
  
  // Heatset Nut Short: M4xD7xL5
  ["NutHeatsetMajorDiameter",           UnitsMetric(7.00)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(5.80)],
  ["NutHeatsetHeight",                  UnitsMetric(5.00)],
  
  // Heatset Nut Long:  M4xD7xL8
  ["NutHeatsetLongMajorDiameter",       UnitsMetric(7.00)],
  ["NutHeatsetLongMinorDiameter",       UnitsMetric(5.80)],
  ["NutHeatsetLongHeight",              UnitsMetric(8.00)]
];

function Spec_BoltM5() = [
  ["BoltDiameter",          UnitsMetric(5.00)],

  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(8.50)],  // +- 0.22mm
  ["BoltSocketCapHeight",   UnitsMetric(4.91)],  // +- 0.09mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(9.111)], // +- 0.127mm 
  ["BoltHexHeight",         UnitsMetric(3.5)],   // +- 0.15mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(9.122)], // +- 0.116mm
  ["NutHexHeight",          UnitsMetric(4.55)],  // +- 0.15mm
  
  // DIN982
  ["NutHexNylonHeight",     UnitsMetric(6.15)],  // +- 0.15mm
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(9.82)],  // +- 0.18mm
  ["BoltFlatHeadHeight",    UnitsMetric(2.8)],   // Only MAX value was provided
  
  // Heatset Nut Short: M5xD8xL5
  ["NutHeatsetMajorDiameter",           UnitsMetric(8.00)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(6.80)],
  ["NutHeatsetHeight",                  UnitsMetric(5.00)],
  
  // Heatset Nut Long:  M5xD8xL9
  ["NutHeatsetLongMajorDiameter",       UnitsMetric(8.00)],
  ["NutHeatsetLongMinorDiameter",       UnitsMetric(6.80)],
  ["NutHeatsetLongHeight",              UnitsMetric(9.00)]
];

function Spec_BoltM6() = [
  ["BoltDiameter",          UnitsMetric(6.00)],

  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(10.00)],  // +- 0.22mm
  ["BoltSocketCapHeight",   UnitsMetric(5.85)],   // +- 0.15mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(11.42)],  // +- 0.127mm 
  ["BoltHexHeight",         UnitsMetric(4)],      // +- 0.15mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(11.432)], // +- 0.115mm
  ["NutHexHeight",          UnitsMetric(5.05)],   // +- 0.15mm
  
  // DIN982
  ["NutHexNylonHeight",     UnitsMetric(7.85)],   // +- 0.15mm
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(11.785)], // +- 0.215mm
  ["BoltFlatHeadHeight",    UnitsMetric(3.3)],    // Only MAX value was provided
  
  // Heatset Nut Short: M6xD9.5xL6
  ["NutHeatsetMajorDiameter",           UnitsMetric(9.50)],
  ["NutHeatsetMinorDiameter",           UnitsMetric(8.00)],
  ["NutHeatsetHeight",                  UnitsMetric(6.00)],
  
  // Heatset Nut Long:  M6xD9.5xL9.5
  ["NutHeatsetLongMajorDiameter",       UnitsMetric(9.50)],
  ["NutHeatsetLongMinorDiameter",       UnitsMetric(8.00)],
  ["NutHeatsetLongHeight",              UnitsMetric(9.50)]
];

function Spec_BoltM8() = [
  ["BoltDiameter",          UnitsMetric(8.00)],
  
  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(13.00)],  // +- 0.27mm
  ["BoltSocketCapHeight",   UnitsMetric(7.82)],   // +- 0.18mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(14.855)], // +- 0.156mm 
  ["BoltHexHeight",         UnitsMetric(5.3)],    // +- 0.15mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(14.838)], // +- 0.173mm 
  ["NutHexHeight",          UnitsMetric(6.6)],    // +- 0.2mm
  
  // DIN982
  ["NutHexNylonHeight",     UnitsMetric(9.32)],   // +- 0.18mm
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(15.785)], // +- 0.215mm
  ["BoltFlatHeadHeight",    UnitsMetric(4.4)],    // Only MAX value was provided
  
  // Heatset Nut Not Available For Measure
];


function Spec_BoltM10() = [
  ["BoltDiameter",          UnitsMetric(10.00)],

  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(16.00)],  // +- 0.27mm
  ["BoltSocketCapHeight",   UnitsMetric(9.82)],   // +- 0.18mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(19.474)], // +- 0.156mm 
  ["BoltHexHeight",         UnitsMetric(6.4)],    // +- 0.16mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(18.302)], // +- 0.173mm
  ["NutHexHeight",          UnitsMetric(8.2)],    // +- 0.2mm
  
  // DIN982
  ["NutHexNylonHeight",     UnitsMetric(11.32)],  // +- 0.18mm
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(19.74)],  // +- 0.26mm
  ["BoltFlatHeadHeight",    UnitsMetric(5.5)],    // Only MAX value was provided
  
  // Heatset Nut Not Available For Measure
];


function Spec_BoltM12() = [
  ["BoltDiameter",          UnitsMetric(12.00)],

  // DIN912
  ["BoltSocketCapDiameter", UnitsMetric(18.00)],  // +- 0.27mm
  ["BoltSocketCapHeight",   UnitsMetric(11.785)], // +- 0.215mm
  
  // DIN933
  ["BoltHexDiameter",       UnitsMetric(21.749)], // +- 0.19mm 
  ["BoltHexHeight",         UnitsMetric(7.5)],    // +- 0.18mm
  
  // DIN934
  ["NutHexDiameter",        UnitsMetric(20.611)], // +- 0.174mm
  ["NutHexHeight",          UnitsMetric(10.6)],   // +- 0.2mm
  
  // DIN982
  ["NutHexNylonHeight",     UnitsMetric(13.82)],  // +- 0.18mm
  
  // DIN7991
  ["BoltFlatHeadDiameter",  UnitsMetric(23.74)],  // +- 0.26mm
  ["BoltFlatHeadHeight",    UnitsMetric(6.5)],    // Only MAX value was provided
  
  // Heatset Nut Not Available For Measure
];
