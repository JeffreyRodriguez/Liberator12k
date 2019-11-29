use <../Meta/Units.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/slookup.scad>;
use <../Shapes/Teardrop.scad>;

//use <Nuts and Bolts/NutSpec.scad>;
use <Nuts and Bolts/BoltSpec.scad>;
use <Nuts and Bolts/BoltSpec_Inch.scad>;
use <Nuts and Bolts/BoltSpec_Metric.scad>;

// Bolt Head Type
HEAD = ""; // ["", "flat", "hex", "socket"]

// Nut Type
NUT = ""; // ["", "hex", "heatset"]

BOLTS = [
  ["#8-32", Spec_Bolt8_32()],
  ["#10-24", Spec_Bolt10_24()],
  ["5/16\"-18", Spec_BoltFiveSixteenths()],
  ["1/2\"-13", Spec_BoltOneHalf()],
  ["M4", Spec_BoltM4()],
  ["M5", Spec_BoltM5()],

];

function BoltSpec(bolt) = slookup(bolt, BOLTS);

$fs = UnitsFs()*0.5;


/**
 * A 2D bolt (circle).
 * @param bolt The bolt to render.
 * @param clearance Add clearance for holes with 'true'
 */
module Bolt2d(bolt=Spec_BoltTemplate(),
              clearance=0, threaded=false,
              teardrop=false, teardropAngle=0) {
  if (teardrop) {
    Teardrop(r=BoltRadius(bolt, clearance, threaded),
             rotation=teardropAngle);
  } else {
    circle(r=BoltRadius(bolt, clearance, threaded));
  }
}

module Bolt(bolt=Spec_BoltTemplate(), length=1,
            head=undef,
            clearance=0, threaded=false,
            teardrop=false, teardropAngle=0,
            capHeightExtra=0, $fn=undef,
            capOrientation=false) {

  zOrientation = capOrientation ? -length : 0;

  translate([0,0,zOrientation])
  union() {
    linear_extrude(height=length)
    Bolt2d(bolt=bolt, clearance=clearance,
    threaded=threaded,
    teardrop=teardrop, teardropAngle=teardropAngle);

    // Bolt head
    translate([0,0,length])
    if (head == "flat") {
      BoltFlatHead(bolt=bolt, clearance=clearance,
                   capHeightExtra=capHeightExtra);
    } else if (head == "socket") {
      BoltSocketCap(bolt=bolt, clearance=clearance,
                    capHeightExtra=capHeightExtra);
    } else if (head == "button") {
      BoltHeadButton(bolt=bolt, clearance=clearance,
                     capHeightExtra=capHeightExtra);
    } else if (head == "hex") {
      BoltHeadHex(bolt=bolt, clearance=clearance,
                  capHeightExtra=capHeightExtra);
    }

    children();
  }
}

module BoltFlatHead(bolt, clearance=0, capHeightExtra=0, teardrop=false) {
  hull() {

    // Taper
    mirror([0,0,1])
    cylinder(r1=BoltFlatHeadRadius(bolt, clearance),
             r2=BoltRadius(bolt, clearance),
              h=BoltFlatHeadHeight(bolt));

    // Taper teardrop hack
    linear_extrude(height=(clearance?capHeightExtra:ManifoldGap()))
    if (teardrop) {
      Teardrop(r=BoltFlatHeadRadius(bolt, clearance));

    } else {
      circle(r=BoltFlatHeadRadius(bolt, clearance));
    }
  }
}

module BoltSocketCap(bolt, capHeightExtra=0, clearance=0, teardrop=false) {
  if (teardrop) {
    linear_extrude(height=BoltSocketCapHeight(bolt)+capHeightExtra)
    Teardrop(r=BoltSocketCapRadius(bolt, clearance),
             rotation=teardropAngle);
  } else {
    cylinder(r=BoltSocketCapRadius(bolt, clearance),
            h=BoltSocketCapHeight(bolt)+capHeightExtra);

  }
}

module BoltHeadButton() {
}

module BoltHeadHex(bolt, clearance=0, capHeightExtra=0) {
  cylinder(r=BoltSocketCapRadius(bolt, clearance),
          h=BoltSocketCapHeight(bolt)+capHeightExtra,
          $fn=6);
}

module NutHex(spec,
              nutRadiusExtra=0, nutHeightExtra=0, nutBackset=0,
              nutSideExtra=0,
              nutSideAngle=0,
              clearance=0) {
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


module NutHeatset(spec, extraLength=0) {
      cylinder(r1=NutHeatsetMajorRadius(spec), r2=NutHeatsetMinorRadius(spec),
               h=NutHeatsetHeight(spec));

      if (extraLength > 0) {
        translate([0,0,-extraLength])
        cylinder(r=NutHeatsetMajorRadius(spec),
                 h=extraLength+ManifoldGap());
      }
};


module NutAndBolt(bolt=Spec_BoltTemplate(), boltLength=1, boltLengthExtra=0,
                  head="socket", nut=undef,
                  capHeightExtra=0,
                  nutHeightExtra=0, nutBackset=0,
                  nutSideExtra=0,
                  nutSideAngle=0,
                  clearance=0, teardrop=false, teardropAngle=0,
                  capOrientation=false) {
  zOrientation = capOrientation ? -boltLength : 0;

  translate([0,0,zOrientation])
  union() {

    // Bolt Body
    translate([0,0,-boltLengthExtra])
    Bolt(bolt=bolt, length=boltLength+boltLengthExtra,
         head=head,
         capHeightExtra=capHeightExtra,
         clearance=clearance, teardrop=teardrop, teardropAngle=teardropAngle)

    translate([0,0,nutBackset])
    if (nut == "hex") {
      NutHex(bolt, nutHeightExtra=nutHeightExtra, clearance=clearance);
    } else if (nut == "heatset") {
      NutHeatset(bolt, extraLength=nutHeightExtra);
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
      Teardrop(r=radius+(cutter?clearance:0));
    } else {
      cylinder(r=radius+(cutter?clearance:0), h=length);
    }

    hull() {

      // Taper
      cylinder(r1=headRadius+(cutter?clearance:0), r2=0,
                h=headRadius+(cutter?clearance:0));

      // Taper teardrop hack
      linear_extrude(height=ManifoldGap())
      if (teardrop) {
        Teardrop(r=headRadius+(cutter?clearance:0));
      } else {
        circle(r=headRadius+(cutter?clearance:0));
      }
    }

    if (cutter)
    translate([0,0,-extraHead])
    linear_extrude(height=extraHead+ManifoldGap())
    if (teardrop) {
      Teardrop(r=headRadius+(cutter?clearance:0));
    } else {
      circle(r=headRadius+(cutter?clearance:0));
    }
  }
}

NutAndBolt(bolt=Spec_Bolt8_32(),
           head=HEAD,
           nut=NUT,
           clearance=0);
