use <../../Meta/Units.scad>;
use <../../Meta/slookup.scad>;

function Spec_BoltTemplate() = [ // these are all a total guess
  ["BoltSpec",        "Template"],
  ["BoltDiameter",    UnitsMetric(1)],
  
  ["BoltSocketCapDiameter", UnitsMetric(2)], // WRONG
  ["BoltSocketCapHeight",   UnitsMetric(2)],  // WRONG

  ["NutHexDiameter",   UnitsImperial(2)], // WRONG
  ["NutHexHeight",      UnitsImperial(2)], // WRONG
  ["NutHexNylonHeight", UnitsMetric(2)], // WRONG

  ["NutHeatsetMajorDiameter", UnitsMetric(3)],
  ["NutHeatsetMinorDiameter", UnitsMetric(2)],
  ["NutHeatsetHeight",        UnitsMetric(3)],

  ["NutHeatsetLongMajorDiameter", UnitsMetric(3)],
  ["NutHeatsetLongMinorDiameter", UnitsMetric(2)],
  ["NutHeatsetLongHeight",        UnitsMetric(4)]
];

/**
 * Lookup the diameter of a bolt.
 * @param bolt The bolt to lookup.
 * @param clearance Add clearance for holes with 'true'
 */
function BoltDiameter(bolt=undef, clearance=0, threaded=false)
           = slookup("BoltDiameter", bolt)
           + clearance
           * (threaded ? 0.9 : 1);

/**
 * Lookup the radius of a bolt.
 * @param bolt The bolt to lookup.
 * @param clearance Add clearance for holes with 'true'
 */
function BoltRadius(bolt, clearance=0, threaded=false)
         = BoltDiameter(bolt, clearance, threaded)/2;

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

function NutHeatsetMajorRadius(spec=undef) = NutHeatsetMajorDiameter(spec)/2;

function NutHeatsetMinorDiameter(spec=undef)
          = slookup("NutHeatsetLongMinorDiameter", spec);

function NutHeatsetLongMinorRadius(spec=undef) = NutHeatsetLongMinorDiameter(spec)/2;

function NutHeatsetLongHeight(spec=undef)
          = slookup("NutHeatsetLongHeight", spec);
