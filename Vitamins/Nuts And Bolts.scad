use <../Meta/Units.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Conditionals/RenderIf.scad>;
use <../Meta/slookup.scad>;
use <../Shapes/Teardrop.scad>;
use <../Shapes/Teardrop Taper.scad>;

//use <Nuts and Bolts/NutSpec.scad>;
use <Nuts and Bolts/BoltSpec.scad>;
use <Nuts and Bolts/BoltSpec_Inch.scad>;
use <Nuts and Bolts/BoltSpec_Metric.scad>;

// Bolt
BOLT = "#8-32"; // ["#4-40", "#6-32", "#8-32", "#10-24", "1/4\"-20", "5/16\"-18", "1/2\"-13"]

// Bolt Head Type
HEAD = "flat"; // ["", "flat", "hex", "socket"]
CAP_HEIGHT_EXTRA = 1;

// Nut Type
NUT = "heatset"; // ["", "hex", "heatset"]
NUT_HEIGHT_EXTRA = 1;

TEARDROP = false;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

BOLTS = [
  ["Template", Spec_BoltTemplate()],
  ["#4-40", Spec_Bolt4_40()],
  ["#6-32", Spec_Bolt6_32()],
  ["#8-32", Spec_Bolt8_32()],
  ["#10-24", Spec_Bolt10_24()],
  ["1/4\"-20", Spec_BoltOneQuarter()],
  ["5/16\"-18", Spec_BoltFiveSixteenths()],
  ["1/2\"-13", Spec_BoltOneHalf()],
  
  ["M2", Spec_BoltM2()],
  ["M2.5", Spec_BoltM2pt5()],
  ["M3", Spec_BoltM3()],
  ["M3.5", Spec_BoltM3pt5()],
  ["M4", Spec_BoltM4()],
  ["M5", Spec_BoltM5()],
  ["M6", Spec_BoltM6()],
  ["M8", Spec_BoltM8()],
  ["M10", Spec_BoltM10()],
  ["M12", Spec_BoltM12()],
];

function BoltSpec(bolt) = slookup(bolt, BOLTS);


/**
 * A 2D bolt (circle).
 * @param bolt The bolt to render.
 * @param clearance Add clearance for holes with 'true'
 */
module Bolt2d(bolt=Spec_BoltTemplate(),
              clearance=0, threaded=false,
              teardrop=false, teardropTruncated=false, teardropAngle=0) {
  if (teardrop) {
    Teardrop(r=BoltRadius(bolt, clearance, threaded),
             rotation=teardropAngle, truncated=teardropTruncated);
  } else {
    circle(r=BoltRadius(bolt, clearance, threaded));
  }
}

module Bolt(bolt=Spec_BoltTemplate(), length=1,
            head=undef,
            clearance=0, threaded=false,
            teardrop=false, teardropTruncated=false, teardropAngle=0,
            capHeightExtra=0, $fn=undef,
            capOrientation=false, doRender=true) {

  zOrientation = capOrientation ? -length : 0;

  translate([0,0,zOrientation])
  color("Silver") RenderIf(doRender)
  union() {
    linear_extrude(height=length)
    Bolt2d(bolt=bolt, clearance=clearance,
    threaded=threaded,
    teardrop=teardrop, teardropTruncated=teardropTruncated,
    teardropAngle=teardropAngle);

    // Bolt head
    translate([0,0,length])
    if (head == "flat") {
      BoltFlatHead(bolt=bolt, clearance=clearance,
                   teardrop=teardrop,
                   teardropAngle=teardropAngle,
                   capHeightExtra=capHeightExtra);
    } else if (head == "socket") {
      BoltSocketCap(bolt=bolt,
                    clearance=clearance,
                    teardrop=teardrop,
                    teardropAngle=teardropAngle,
                    capHeightExtra=capHeightExtra);
    } else if (head == "button") {
      BoltHeadButton(bolt=bolt, clearance=clearance,
                     capHeightExtra=capHeightExtra);
    } else if (head == "hex") {
      BoltHeadHex(bolt=bolt, clearance=clearance,
                  capHeightExtra=capHeightExtra);
    }
  }
  
  translate([0,0,zOrientation])
  children();
}

module BoltFlatHead(bolt, clearance=0, capHeightExtra=0, teardrop=false, teardropAngle=0) {
  union() {
    if (teardrop) {
      rotate(teardropAngle)
      mirror([0,0,1])
      TeardropTaper(h=BoltFlatHeadHeight(bolt),
                    r1=BoltFlatHeadRadius(bolt, clearance),
                    r2=BoltRadius(bolt, clearance));
    } else {
      mirror([0,0,1])
      cylinder(r1=BoltFlatHeadRadius(bolt, clearance),
               r2=BoltRadius(bolt, clearance),
                h=BoltFlatHeadHeight(bolt));
    }
    
    // Extension
    linear_extrude(height=(clearance?capHeightExtra:ManifoldGap()))
    if (teardrop) {
      rotate(teardropAngle)
      Teardrop(r=BoltFlatHeadRadius(bolt, clearance));
    } else {
      circle(r=BoltFlatHeadRadius(bolt, clearance));
    }
  }
}

module BoltSocketCap(bolt, capHeightExtra=0, clearance=0, teardrop=false, teardropAngle=0) {
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
  cylinder(r=BoltHexRadius(bolt, clearance),
          h=BoltHexHeight(bolt)+capHeightExtra,
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


module NutHeatset(spec, teardrop=false, teardropAngle=0, extraLength=0) {
  if (teardrop) {
    rotate(teardropAngle)
    TeardropTaper(h=NutHeatsetHeight(spec),
                  r1=NutHeatsetMajorRadius(spec),
                  r2=NutHeatsetMinorRadius(spec));
  } else {
    cylinder(r1=NutHeatsetMajorRadius(spec),
             r2=NutHeatsetMinorRadius(spec),
              h=NutHeatsetHeight(spec));
  }
  
  // Extension
  if (extraLength > 0) {
    mirror([0,0,1])
    linear_extrude(height=extraLength)
    if (teardrop) {
      rotate(teardropAngle)
      Teardrop(r=NutHeatsetMajorRadius(spec));
    } else {
      circle(r=NutHeatsetMajorRadius(spec));
    }
  }
};

module NutHeatsetLong(spec, teardrop=false, teardropAngle=0, extraLength=0) {
  
  if (teardrop) {
    rotate(teardropAngle)
    TeardropTaper(h=NutHeatsetLongHeight(spec),
                  r1=NutHeatsetLongMajorRadius(spec),
                  r2=NutHeatsetLongMinorRadius(spec));
  } else {
    cylinder(r1=NutHeatsetLongMajorRadius(spec),
             r2=NutHeatsetLongMinorRadius(spec),
              h=NutHeatsetLongHeight(spec));
  }
  
  // Extension
  if (extraLength > 0) {
    mirror([0,0,1])
    linear_extrude(height=extraLength)
    if (teardrop) {
      rotate(teardropAngle)
      Teardrop(r=NutHeatsetLongMajorRadius(spec));
    } else {
      circle(r=NutHeatsetLongMajorRadius(spec));
    }
  }
};


module NutAndBolt(bolt=Spec_BoltTemplate(), boltLength=1, boltLengthExtra=0,
                  head="socket", nut=undef,
                  capHeightExtra=0,
                  nutHeightExtra=0, nutBackset=0,
                  nutSideExtra=0,
                  nutSideAngle=0,
                  clearance=0, teardrop=false, teardropAngle=0,
                  capOrientation=false, doRender=false) {
  zOrientation = capOrientation ? -boltLength : 0;

  translate([0,0,zOrientation])

  // Bolt Body
  translate([0,0,-boltLengthExtra])
  Bolt(bolt=bolt, length=boltLength+boltLengthExtra,
       head=head,
       capHeightExtra=capHeightExtra,
       clearance=clearance, teardrop=teardrop, teardropAngle=teardropAngle,
       doRender=doRender) {

    // Nut
    translate([0,0,nutBackset])
    if (nut == "hex") {
      
      color("DimGrey") RenderIf(doRender)
      NutHex(bolt, nutHeightExtra=nutHeightExtra, clearance=clearance);
    } else if (nut == "heatset") {
      
      color("Gold") RenderIf(doRender)
      NutHeatset(bolt, teardrop=teardrop, teardropAngle=teardropAngle, extraLength=nutHeightExtra);
      
    } else if (nut == "heatset-long") {
      
      color("Gold") RenderIf(doRender)
      NutHeatsetLong(bolt, teardrop=teardrop, teardropAngle=teardropAngle, extraLength=nutHeightExtra);
    }
  }
}

NutAndBolt(bolt=BoltSpec(BOLT),
           head=HEAD, capHeightExtra=CAP_HEIGHT_EXTRA,
           nut=NUT, nutHeightExtra=NUT_HEIGHT_EXTRA,
           teardrop=TEARDROP,
           clearance=0.001);
