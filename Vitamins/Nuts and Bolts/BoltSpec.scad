use <../../Meta/Units.scad>;
use <../../Meta/slookup.scad>;

function Spec_BoltTemplate() = [ // these are all a total guess
  ["BoltSpec",        "Template"],
  ["BoltDiameter",    Millimeters(1)],

  ["BoltHexDiameter", Millimeters(2)], // WRONG
  ["BoltHexHeight",   Millimeters(2)],  // WRONG

  // Carriage Bolts: Round Head, Square Neck (ASME B18.5-1990)
  // DIN 603
  ["BoltCarriageDiameter", Millimeters(2)], // WRONG
  ["BoltCarriageHeight",   Millimeters(2)],  // WRONG

  ["BoltSocketCapDiameter", Millimeters(2)], // WRONG
  ["BoltSocketCapHeight",   Millimeters(2)],  // WRONG

  ["NutHexDiameter",   Inches(2)], // WRONG
  ["NutHexHeight",      Inches(2)], // WRONG
  ["NutHexNylonHeight", Millimeters(2)], // WRONG

  ["NutHeatsetMajorDiameter", Millimeters(3)],
  ["NutHeatsetMinorDiameter", Millimeters(2)],
  ["NutHeatsetHeight",        Millimeters(3)],

  ["NutHeatsetLongMajorDiameter", Millimeters(3)],
  ["NutHeatsetLongMinorDiameter", Millimeters(2)],
  ["NutHeatsetLongHeight",        Millimeters(4)]
];

/**
 * Lookup the diameter of a bolt.
 * @param bolt The bolt to lookup.
 * @param clearance Add clearance for holes with 'true'
 */
function BoltDiameter(bolt=undef, clearance=0, threaded=false)
           = (threaded ? BoltTappingDrillSize(bolt) : (slookup("BoltDiameter", bolt) + clearance));

/**
 * Lookup the radius of a bolt.
 * @param bolt The bolt to lookup.
 * @param clearance Add clearance for holes with 'true'
 */
function BoltRadius(bolt, clearance=0, threaded=false)
         = BoltDiameter(bolt, clearance, threaded)/2;

function BoltTappingDrillSize(bolt=undef) = slookup("BoltTappingDrillSize", bolt);

function BoltCarriageDiameter(bolt=undef, clearance=0)
          = slookup("BoltCarriageDiameter", bolt)
          + clearance;

function BoltCarriageRadius(bolt=undef, clearance=0)
         = BoltCarriageDiameter(bolt, clearance)/2;

function BoltCarriageHeight(bolt=undef) = slookup("BoltCarriageHeight", bolt);

function BoltHexDiameter(bolt=undef, clearance=0)
          = slookup("BoltHexDiameter", bolt)
          + clearance;

function BoltHexRadius(bolt=undef, clearance=0)
         = BoltHexDiameter(bolt, clearance)/2;

function BoltHexHeight(bolt=undef) = slookup("BoltHexHeight", bolt);

function BoltSocketCapDiameter(bolt=undef, clearance=0)
          = slookup("BoltSocketCapDiameter", bolt)
          + clearance;

function BoltSocketCapRadius(bolt=undef, clearance=0)
         = BoltSocketCapDiameter(bolt, clearance)/2;

function BoltSocketCapHeight(bolt=undef) = slookup("BoltSocketCapHeight", bolt);


function BoltFlatHeadDiameter(bolt=undef, clearance=0)
          = slookup("BoltFlatHeadDiameter", bolt)
          + clearance;

function BoltFlatHeadRadius(bolt=undef, clearance=0) = BoltFlatHeadDiameter(bolt, clearance)/2;

function BoltFlatHeadHeight(bolt=undef) = slookup("BoltFlatHeadHeight", bolt);

function NutHexDiameter(bolt=undef, clearance=0)
           = slookup("NutHexDiameter", bolt)
           + clearance;

function NutHexRadius(bolt=undef, clearance=0) = NutHexDiameter(bolt, clearance)/2;

function NutHexHeight(bolt=undef) = slookup("NutHexHeight", bolt);

function NutHexDiameter(spec=undef, clearance=0)
           = slookup("NutHexDiameter", spec)
           + clearance;

function NutHexRadius(spec=undef, clearance=0) = NutHexDiameter(spec, clearance)/2;

function NutHexHeight(spec=undef, clearance=0)
           = slookup("NutHexHeight", spec)
           + clearance;

function NutHeatsetMajorDiameter(spec=undef)
           = slookup("NutHeatsetMajorDiameter", spec);

function NutHeatsetMajorRadius(spec=undef) = NutHeatsetMajorDiameter(spec)/2;

function NutHeatsetMinorDiameter(spec=undef)
           = slookup("NutHeatsetMinorDiameter", spec);

function NutHeatsetMinorRadius(spec=undef) = NutHeatsetMinorDiameter(spec)/2;

function NutHeatsetHeight(spec=undef)
           = slookup("NutHeatsetHeight", spec);

function NutHeatsetLongMajorDiameter(spec=undef)
          = slookup("NutHeatsetLongMajorDiameter", spec);

function NutHeatsetLongMajorRadius(spec=undef) = NutHeatsetLongMajorDiameter(spec)/2;

function NutHeatsetLongMinorDiameter(spec=undef)
          = slookup("NutHeatsetLongMinorDiameter", spec);

function NutHeatsetLongMinorRadius(spec=undef) = NutHeatsetLongMinorDiameter(spec)/2;

function NutHeatsetLongHeight(spec=undef)
          = slookup("NutHeatsetLongHeight", spec);
