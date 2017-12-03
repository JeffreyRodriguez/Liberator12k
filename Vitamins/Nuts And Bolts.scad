use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;
use <../Components/Teardrop.scad>;

BoltDiameter         = 1;
BoltCapDiameter      = 2;
BoltCapHeight        = 3;
BoltNutDiameter = 4;
BoltNutMinorDiameter = 5;
BoltNutHeight        = 6;
BoltClearance        = 7;
BoltFn               = 8;

BoltCapTypeNone   = 1;
BoltCapTypeFlat   = 2;
BoltCapTypeSocket = 3;
BoltCapTypeButton = 4;

function BoltClearance() = BoltClearance;

function Spec_BoltM3() = [
  [BoltDiameter,    UnitsMetric(3)],
  [BoltCapDiameter, UnitsMetric(5.4)],
  [BoltCapHeight,   UnitsMetric(2.6)],
  [BoltNutDiameter, UnitsMetric(6.28)],
  [BoltNutMinorDiameter, UnitsMetric(6.28)],
  [BoltNutHeight,   UnitsMetric(2.5)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 8]
];

function Spec_BoltM4() = [
  [BoltDiameter,    UnitsMetric(4)],
  [BoltCapDiameter, UnitsMetric(7.4+0.3)],
  [BoltCapHeight,   UnitsMetric(3.9)],
  [BoltNutDiameter, UnitsMetric(7.7)],
  [BoltNutMinorDiameter, UnitsMetric(7.7)],
  [BoltNutHeight,   UnitsMetric(3)],
  [BoltClearance,   UnitsMetric(0.7)],
  [BoltFn, 8]
];

function Spec_BoltM5() = [
  [BoltDiameter,    UnitsMetric(5)],
  [BoltCapDiameter, UnitsMetric(7.4+0.3)],
  [BoltCapHeight,   UnitsMetric(3.9)],
  [BoltNutDiameter, UnitsMetric(7.7)],
  [BoltNutHeight,   UnitsMetric(3)],
  [BoltClearance,   UnitsMetric(0.7)],
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
    
    children();
  }
}

module BoltCapFlat() {
}

module BoltCapSocket() {
}

module BoltCapButton() {
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
  [NutHeatsetMajorDiameter, UnitsMetric(5.31)],
  [NutHeatsetMinorDiameter,   UnitsMetric(5.1)],
  [NutHeatsetHeight,   UnitsMetric(6.4)]
];

function Spec_NutM4() = [
  [NutHexDiameter,    UnitsMetric(7.66)],
  [NutHexClearance,  UnitsMetric(0.25)],
  [NutHexHeight, UnitsMetric(3.2)],
  [NutHexNylonHeight,   UnitsMetric(4.5)], // ???: Guessed
  [NutHeatsetMajorDiameter, UnitsMetric(5.94)],
  [NutHeatsetMinorDiameter,   UnitsMetric(5.3)],
  [NutHeatsetHeight,   UnitsMetric(7.9)]
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


module NutHeatset(spec=Spec_NutM5()) {
      cylinder(r1=NutHeatsetMajorRadius(spec), r2=NutHeatsetMinorRadius(spec),
               h=NutHeatsetHeight(spec),
               $fn=12);
};


module NutAndBolt(bolt=Spec_BoltM3(), boltLength=1, boltLengthExtra=0,
                  cap=true, capRadiusExtra=0, capHeightExtra=0,
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



translate([1,0,0])
Bolt(bolt=Spec_BoltM4(), clearance=false)
NutHeatset(spec=Spec_NutM4(), clearance=true);

translate([0,1,0])
Bolt(bolt=Spec_BoltM4(), clearance=false)
NutHex(spec=Spec_NutM4(), clearance=true);

NutAndBolt(bolt=Spec_BoltM3(), clearance=true);



// M5x10 FIXME
module FlatHeadBolt(diameter=0.193, headDiameter=0.353, extraHead=1, length=0.3955,
                    sink=0.01, teardrop=true) {
  radius = diameter/2;
  headRadius = headDiameter/2;
  
  render()
  scale(25.4)
  translate([0,0,sink])
  union() {
    
    if (teardrop) {
      linear_extrude(height=length)
      Teardrop(r=radius, $fn=20);
    } else {
      cylinder(r=radius, h=length, $fn=20);
    }
    
    hull() {
      
      // Taper
      cylinder(r1=headDiameter/2, r2=0, h=headDiameter/2);
      
      // Taper teardrop hack      
      linear_extrude(height=ManifoldGap())
      if (teardrop) {
        Teardrop(r=headRadius, $fn=20);
      } else {
        circle(r=headRadius, $fn=20);
      }
    }
    
    translate([0,0,-extraHead])
    linear_extrude(height=extraHead+ManifoldGap())
    if (teardrop) {
      Teardrop(r=headRadius, $fn=20);
    } else {
      circle(r=headRadius, $fn=20);
    }
  }
}