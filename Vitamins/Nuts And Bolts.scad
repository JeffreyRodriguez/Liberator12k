use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;
use <../Components/Teardrop.scad>;

BoltDiameter         = 1;
BoltCapDiameter      = 2;
BoltCapHeight        = 3;
BoltNutDiameter      = 4;
BoltNutHeight        = 5;
BoltClearance        = 6;
BoltFn               = 7;

BoltCapTypeNone   = 1;
BoltCapTypeFlat   = 2;
BoltCapTypeSocket = 3;
BoltCapTypeButton = 4;

function BoltClearance() = BoltClearance;

function Spec_BoltM2() = [ // these are all a total guess
  [BoltDiameter,    UnitsMetric(2)],
  [BoltCapDiameter, UnitsMetric(4.4)],
  [BoltCapHeight,   UnitsMetric(1.6)],
  [BoltNutDiameter, UnitsMetric(4.28)],
  [BoltNutHeight,   UnitsMetric(1.5)],
  [BoltClearance,   UnitsMetric(0.4)],
  [BoltFn, 10]
];
function Spec_BoltM3() = [
  [BoltDiameter,    UnitsMetric(3)],
  [BoltCapDiameter, UnitsMetric(5.4)],
  [BoltCapHeight,   UnitsMetric(2.6)],
  [BoltNutDiameter, UnitsMetric(6.28)],
  [BoltNutHeight,   UnitsMetric(2.5)],
  [BoltClearance,   UnitsMetric(0.2)],
  [BoltFn, 10]
];

function Spec_BoltM4() = [
  [BoltDiameter,    UnitsMetric(4)],
  [BoltCapDiameter, UnitsMetric(7.4+0.3)],
  [BoltCapHeight,   UnitsMetric(3.9)],
  [BoltNutDiameter, UnitsMetric(7.7)],
  [BoltNutHeight,   UnitsMetric(3)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 10]
];

function Spec_BoltM5() = [
  [BoltDiameter,    UnitsMetric(5)],
  [BoltCapDiameter, UnitsMetric(7.4+0.3)],
  [BoltCapHeight,   UnitsMetric(3.9)],
  [BoltNutDiameter, UnitsMetric(7.7)],
  [BoltNutHeight,   UnitsMetric(3)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 12]
];

function Spec_BoltM8() = [
  [BoltDiameter,    UnitsMetric(8)],
  [BoltCapDiameter, UnitsMetric(13.1)],
  [BoltCapHeight,   UnitsMetric(8)],
  [BoltNutDiameter, UnitsMetric(14.75)],
  [BoltNutHeight,   UnitsMetric(6.3)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 20]
];

function Spec_BoltOneHalf() = [
  [BoltDiameter,    UnitsImperial(0.5)],
  [BoltCapDiameter, UnitsImperial(0.85)],
  [BoltCapHeight,   UnitsImperial(0.310)],
  [BoltNutDiameter, UnitsImperial(0.85)],
  [BoltNutHeight,   UnitsImperial(0.310)],
  [BoltClearance,   UnitsImperial(0.04)],
  [BoltFn, 30]
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
            hex=false, cap=true, capRadiusExtra=0, capHeightExtra=0, $fn=undef,
            capOrientation=false) {
  
  capFn = hex ? 6 : BoltFn(bolt, $fn)*2;
  zOrientation = capOrientation ? -length : 0;
  
  translate([0,0,zOrientation])
  union() {
    linear_extrude(height=length)
    Bolt2d(bolt, clearance, teardrop=teardrop, teardropAngle=teardropAngle);

    // Cap
    if (cap) {
      if (teardrop) {
        translate([0,0,length-ManifoldGap()])
        linear_extrude(height=BoltCapHeight(bolt)+capHeightExtra)
        Teardrop(r=BoltCapRadius(bolt, clearance)+capRadiusExtra,
                 rotation=teardropAngle,
                 $fn=capFn);
      } else {
        translate([0,0,length-ManifoldGap()])
        cylinder(r=BoltCapRadius(bolt, clearance)+capRadiusExtra,
                h=BoltCapHeight(bolt)+capHeightExtra,
                $fn=capFn);

      }
    }

    children();
  }
}

module BoltCapFlat() {
}

module BoltCapSocket() {
}

module BoltCapButton() {
}

module BoltCapHex() {
}

NutHexDiameter          = 1;
NutHexClearance         = 2;
NutHexHeight            = 3;
NutHexNylonHeight       = 4;
NutHeatsetMajorDiameter = 5;
NutHeatsetMinorDiameter = 6;
NutHeatsetHeight        = 7;

function NutHexDiameter(spec=undef, clearance=false)
           = lookup(NutHexDiameter, spec)
          + (clearance == true ? lookup(NutHexClearance, spec) : 0);

function NutHexRadius(spec=undef, clearance=false) = NutHexDiameter(spec, clearance)/2;

function NutHexHeight(spec=undef, clearance=false)
           = lookup(NutHexHeight, spec)
          + (clearance == true ? lookup(NutHexClearance, spec) : 0);


function NutHeatsetMajorDiameter(spec=undef)
           = lookup(NutHeatsetMajorDiameter, spec);

function NutHeatsetMajorRadius(spec=undef) = NutHeatsetMajorDiameter(spec)/2;

function NutHeatsetMinorDiameter(spec=undef)
           = lookup(NutHeatsetMinorDiameter, spec);

function NutHeatsetMinorRadius(spec=undef) = NutHeatsetMinorDiameter(spec)/2;

function NutHeatsetHeight(spec=undef)
           = lookup(NutHeatsetHeight, spec);


function Spec_NutM2() = [
  [NutHexDiameter,    UnitsMetric(4.32)],
  [NutHexClearance,  UnitsMetric(0.25)],
  [NutHexHeight, UnitsMetric(1.6)],
  [NutHexNylonHeight,   UnitsMetric(4.5)], // ???: Guessed
  [NutHeatsetMajorDiameter, UnitsMetric(3.12)],
  [NutHeatsetMinorDiameter,   UnitsMetric(2.7)],
  [NutHeatsetHeight,   UnitsMetric(4.8)]
];

function Spec_NutM2pt5() = [
  [NutHexDiameter,    UnitsMetric(4.45)],
  [NutHexClearance,  UnitsMetric(0.25)],
  [NutHexHeight, UnitsMetric(2)],
  [NutHexNylonHeight,   UnitsMetric(4.5)], // ???: Guessed
  [NutHeatsetMajorDiameter, UnitsMetric(4.04)],
  [NutHeatsetMinorDiameter,   UnitsMetric(3.6)],
  [NutHeatsetHeight,   UnitsMetric(5.6)]
];

function Spec_NutM3() = [
  [NutHexDiameter,    UnitsMetric(6.01)],
  [NutHexClearance,  UnitsMetric(0.25)],
  [NutHexHeight, UnitsMetric(2.4)],
  [NutHexNylonHeight,   UnitsMetric(4.5)], // ???: Guessed
  [NutHeatsetMajorDiameter, UnitsMetric(5.31+0.3)],
  [NutHeatsetMinorDiameter,   UnitsMetric(5.1+0.3)],
  [NutHeatsetHeight,   UnitsMetric(6.4+0.6)]
];

function Spec_NutM4() = [
  [NutHexDiameter,    UnitsMetric(7.66)],
  [NutHexClearance,  UnitsMetric(0.25)],
  [NutHexHeight, UnitsMetric(3.2)],
  [NutHexNylonHeight,   UnitsMetric(4.5)], // ???: Guessed
  [NutHeatsetMajorDiameter, UnitsMetric(5.94+0.25)],
  [NutHeatsetMinorDiameter,   UnitsMetric(5.3+0.25)],
  [NutHeatsetHeight,   UnitsMetric(7.9+0.25)]
];

function Spec_NutM5() = [
  [NutHexDiameter,    UnitsMetric(8.79)],
  [NutHexClearance,  UnitsMetric(0.25)],
  [NutHexHeight, UnitsMetric(4.7)],
  [NutHexNylonHeight,   UnitsMetric(4.5)], // ???: Guessed
  [NutHeatsetMajorDiameter, UnitsMetric(8)],
  [NutHeatsetMinorDiameter,   UnitsMetric(7.1)],
  [NutHeatsetHeight,   UnitsMetric(11.5)]
];

module NutHex(spec=Spec_NutM5(),
              nutRadiusExtra=0, nutHeightExtra=0, nutBackset=0,
              nutSideExtra=0,
              nutSideAngle=0,
              clearance=false) {
    translate([0,0,-(clearance?nutHeightExtra:0)+nutBackset]) {
      cylinder(r=NutHexRadius(spec, clearance)+(clearance?nutRadiusExtra:0),
               h=NutHexHeight(spec)+(clearance?nutHeightExtra:0), $fn=6);

      // Insertion side-cut
      if (clearance && nutSideExtra > 0)
      rotate(nutSideAngle)
      translate([-NutHexRadius(spec, clearance),0,0])
      cube([NutHexDiameter(spec, clearance),
            NutHexDiameter(spec, clearance)+nutSideExtra,
            NutHexHeight(spec)+nutHeightExtra]);
    }
};


module NutHeatset(spec=Spec_NutM5(), extraLength=0) {
      cylinder(r1=NutHeatsetMajorRadius(spec), r2=NutHeatsetMinorRadius(spec),
               h=NutHeatsetHeight(spec),
               $fn=20);

      if (extraLength > 0) {
        translate([0,0,-extraLength])
        cylinder(r=NutHeatsetMajorRadius(spec),
                 h=extraLength+ManifoldGap(),
                 $fn=20);
      }
};


module NutAndBolt(bolt=Spec_BoltM3(), boltLength=1, boltLengthExtra=0,
                  capHex=false, cap=true, capRadiusExtra=0, capHeightExtra=0,
                  nutRadiusExtra=0, nutHeightExtra=0, nutBackset=0,
                  nutSideExtra=0,
                  nutSideAngle=0,
                  nutEnable=true,
                  clearance=true, teardrop=false, teardropAngle=0,
                  capOrientation=false) {
  zOrientation = capOrientation ? -boltLength : 0;

  translate([0,0,zOrientation])
  union() {

    // Bolt Body
    translate([0,0,-boltLengthExtra])
    Bolt(bolt=bolt, length=boltLength+boltLengthExtra,
         cap=cap, capHeightExtra=capHeightExtra, capRadiusExtra=capRadiusExtra,
         hex=capHex,
         clearance=clearance, teardrop=teardrop, teardropAngle=teardropAngle);

    // Nut
    if (nutEnable)
    translate([0,0,-(clearance?nutHeightExtra:0)+nutBackset]) {
      cylinder(r=BoltNutRadius(bolt, clearance)+(clearance?nutRadiusExtra:0),
               h=BoltNutHeight(bolt)+(clearance?nutHeightExtra:0), $fn=6);

      if (clearance && nutSideExtra > 0)
      rotate(nutSideAngle)
      translate([-BoltNutRadius(bolt, clearance),0,0])
      cube([BoltNutDiameter(bolt, clearance),
            BoltNutDiameter(bolt, clearance)+nutSideExtra,
            BoltNutHeight(bolt)+nutHeightExtra]);
    }
  }
}



// M5x10 FIXME
module FlatHeadBolt(diameter=UnitsImperial(0.193),
                headDiameter=UnitsImperial(0.353),
                   extraHead=UnitsImperial(1),
                      length=UnitsImperial(0.3955),
                        sink=UnitsImperial(0.01),
                   clearance=UnitsImperial(0.01),
                    teardrop=true,
                      cutter=false) {
  radius = diameter/2;
  headRadius = headDiameter/2;

  render()
  translate([0,0,sink])
  union() {

    if (teardrop) {
      linear_extrude(height=length)
      Teardrop(r=radius+(cutter?clearance:0), $fn=20);
    } else {
      cylinder(r=radius+(cutter?clearance:0), h=length, $fn=20);
    }

    hull() {

      // Taper
      cylinder(r1=headRadius+(cutter?clearance:0), r2=0, h=headRadius+(cutter?clearance:0));

      // Taper teardrop hack
      linear_extrude(height=ManifoldGap())
      if (teardrop) {
        Teardrop(r=headRadius+(cutter?clearance:0), $fn=20);
      } else {
        circle(r=headRadius+(cutter?clearance:0), $fn=20);
      }
    }

    translate([0,0,-extraHead])
    linear_extrude(height=extraHead+ManifoldGap())
    if (teardrop) {
      Teardrop(r=headRadius+(cutter?clearance:0), $fn=20);
    } else {
      circle(r=headRadius+(cutter?clearance:0), $fn=20);
    }
  }
}



translate([1,0,0])
Bolt(bolt=Spec_BoltM4(), clearance=false)
NutHeatset(spec=Spec_NutM4(), clearance=true);

translate([0,1,0])
Bolt(bolt=Spec_BoltM4(), clearance=false)
NutHex(spec=Spec_NutM4(), clearance=true);

NutAndBolt(bolt=Spec_BoltM3(), clearance=true);
