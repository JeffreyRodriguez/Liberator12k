use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;
use <../Components/Teardrop.scad>;

BoltDiameter    = 1;
BoltCapDiameter = 2;
BoltCapHeight   = 3;
BoltNutDiameter = 4;
BoltNutHeight   = 5;
BoltClearance   = 6;
BoltFn          = 7;

/* M3: radius=0.115/2, capRadius=0.212/2, nutRadius=0.247/2, nutHeight=0.096
   M8: radius=0.3,     capRadius=0.29,    nutRadius=0.29,  nutHeight=0.3,
*/
function BoltClearance() = BoltClearance;

function Spec_BoltM3() = [
  [BoltDiameter,    UnitsMetric(3)],
  [BoltCapDiameter, UnitsMetric(5.4)],
  [BoltCapHeight,   UnitsMetric(2.6)],
  [BoltNutDiameter, UnitsMetric(6.28)],
  [BoltNutHeight,   UnitsMetric(2.5)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 8]
];

function Spec_BoltM4() = [
  [BoltDiameter,    UnitsMetric(4)],
  [BoltCapDiameter, UnitsMetric(7.7)],
  [BoltCapHeight,   UnitsMetric(3.9)],
  [BoltNutDiameter, UnitsMetric(7.2)],
  [BoltNutHeight,   UnitsMetric(3)],
  [BoltClearance,   UnitsMetric(1)],
  [BoltFn, 8]
];

function Spec_BoltM8() = [
  [BoltDiameter,    UnitsMetric(8)],
  [BoltCapDiameter, UnitsMetric(13.1)],
  [BoltCapHeight,   UnitsMetric(8)],
  [BoltNutDiameter, UnitsMetric(14.75)],
  [BoltNutHeight,   UnitsMetric(6.3)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 10]
];

/**
 * Lookup the diameter of a bolt.
 * @param bolt The bolt to lookup.
 * @param clearance Add clearance for holes with 'true'
 */
function BoltDiameter(bolt=undef, clearance=false)
           = lookup(BoltDiameter, bolt)
          + (clearance == true ? lookup(BoltClearance, bolt) : 0);

/**
 * Lookup the radius of a bolt.
 * @param bolt The bolt to lookup.
 * @param clearance Add clearance for holes with 'true'
 */
function BoltRadius(bolt, clearance=false) = BoltDiameter(bolt, clearance)/2;



function BoltCapDiameter(bolt=undef, clearance=false)
          = lookup(BoltCapDiameter, bolt)
          + (clearance == true ? lookup(BoltClearance, bolt) : 0);

function BoltCapRadius(bolt, clearance=false) = BoltCapDiameter(bolt, clearance)/2;

function BoltCapHeight(bolt) = lookup(BoltCapHeight, bolt);

function BoltNutDiameter(bolt=undef, clearance=false)
           = lookup(BoltNutDiameter, bolt)
           + (clearance == true ? lookup(BoltClearance, bolt) : 0);

function BoltNutRadius(bolt, clearance=false) = BoltNutDiameter(bolt, clearance)/2;

function BoltNutMinor(bolt=undef, clearance=false)
          = (BoltNutDiameter(bolt=bolt, clearance=clearance) * sqrt(3))/2;

function BoltNutHeight(bolt) = lookup(BoltNutHeight, bolt);



/**
 * Lookup the $fn value for a bolt, optionally overriding it
 * @param bolt The bolt to lookup.
 * @param $fn Override the BoltFn. If defined, this will be the result. (convenience arg)
 **/
function BoltFn(bolt, $fn=undef) = ($fn == undef) ? lookup(BoltFn, bolt) : $fn;

/**
 * A 2D bolt (circle).
 * @param bolt The bolt to render.
 * @param clearance Add clearance for holes with 'true'
 * @param $fn Override the BoltFn value of the bolt.
 */
module Bolt2d(bolt=Spec_BoltM3(), clearance=false, teardrop=false, teardropAngle=0, $fn=undef) {
  if (teardrop) {
    Teardrop(r=BoltRadius(bolt, clearance), rotation=teardropAngle,
             $fn=BoltFn(bolt, $fn));
  } else {
    circle(r=BoltRadius(bolt, clearance),
           $fn=BoltFn(bolt, $fn));
  }
}


module Bolt(bolt=Spec_BoltM3(), length=1,
            clearance=false, teardrop=false, teardropAngle=0,
            cap=true, capRadiusExtra=0, capHeightExtra=0, $fn=undef) {
  union() {
    linear_extrude(height=length)
    Bolt2d(bolt, clearance, teardrop=teardrop, teardropAngle=teardropAngle, $fn=$fn);

    // Cap
    if (cap) {
      if (teardrop) {
        translate([0,0,length-ManifoldGap()])
        linear_extrude(height=BoltCapHeight(bolt)+capHeightExtra)
        Teardrop(r=BoltCapRadius(bolt, clearance)+capRadiusExtra,
                 rotation=teardropAngle,
                 $fn=BoltFn(bolt, $fn)*2);
      } else {
        translate([0,0,length-ManifoldGap()])
        cylinder(r=BoltCapRadius(bolt, clearance)+capRadiusExtra,
                h=BoltCapHeight(bolt)+capHeightExtra, $fn=BoltFn(bolt, $fn)*2);

      }
    }
  }
}

module NutAndBolt(bolt=Spec_BoltM3(), boltLength=1, boltLengthExtra=0,
                  cap=true, capRadiusExtra=0, capHeightExtra=0,
                  nutRadiusExtra=0, nutHeightExtra=0, nutBackset=0, nutSideExtra=0, nutEnable=true,
                  clearance=true, teardrop=false, teardropAngle=0,
                  capOrientation=false) {
  zOrientation = capOrientation ? -boltLength : 0;

  translate([0,0,zOrientation])
  union() {

    // Bolt Body
    translate([0,0,-boltLengthExtra])
    Bolt(bolt=bolt, length=boltLength+boltLengthExtra,
         cap=cap, capHeightExtra=capHeightExtra, capRadiusExtra=capRadiusExtra,
         clearance=clearance, teardrop=teardrop, teardropAngle=teardropAngle);

    // Nut
    if (nutEnable)
    translate([0,0,-nutHeightExtra+nutBackset]) {
      cylinder(r=BoltNutRadius(bolt, clearance)+nutRadiusExtra,
               h=BoltNutHeight(bolt)+nutHeightExtra, $fn=6);

      if (nutSideExtra > 0)
      translate([-BoltNutRadius(bolt, clearance),0,0])
      cube([BoltNutDiameter(bolt, clearance),
            BoltNutDiameter(bolt, clearance)+nutSideExtra,
            BoltNutHeight(bolt)+nutHeightExtra]);
    }
  }
}


#NutAndBolt(bolt=Spec_BoltM3(), clearance=true);
