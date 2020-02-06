include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Rod.scad>;

use <Lower/Receiver Lugs.scad>;
use <Lower/Trigger.scad>;
use <Lower/Lower.scad>;

use <Firing Pin.scad>;


/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Head", "Tail"]


// Firing pin housing bolt
HAMMER_BOLT = "#8-32"; // ["M4", "#8-32"]
HAMMER_BOLT_CLEARANCE = 0.015;

/* [Receiver Tube] */
RECEIVER_TUBE_ID = 1.5;

// Settings: Lengths
function HammerBoltLength() = 5;
function HammerSpringLength() = 2.75;
function HammerCollarDiameter() = 0.625;
function HammerCollarRadius() = HammerCollarDiameter()/2;
function HammerCollarWidth() = 0.31;

// Settings: Vitamins
function HammerBolt() = BoltSpec(HAMMER_BOLT);
echo(HAMMER_BOLT, HammerBolt());

DEFAULT_HAMMER_TRAVEL = 1;
DEFAULT_HAMMER_CLEARANCE = 0.005;


function HammerOffset() = 0;
function SearOffset() = 2.875;
function HammerTravel() = 1;
function HammerWidth() = 0.25;

function HammerHeadLength() = 1;

function HammerTailcapLength() = 0.75;
function HammerTailcapBaseLength() = 0.25;
function HammerSpacerLength() = SearOffset()
                              + HammerSpringLength()
                              + HammerHeadLength();

function HammerTailcapInnerDiameter() = 1.07;
function HammerTailcapInnerRadius() = (HammerTailcapInnerDiameter()/2);

module HammerBolt(cutter=false, clearance=DEFAULT_HAMMER_CLEARANCE) {
  clear = cutter?clearance:0;
  clear2 = clear*2;


  color("Silver")
  translate([-SearOffset(),0,HammerWidth()/2])
  rotate([180,0,0])
  Bolt(bolt=HammerBolt(),
       length=HammerWidth()+0.125+ManifoldGap(),
       head="socket", capHeightExtra=(cutter?1:0));
}

module HammerRod(cutter=false, clearance=DEFAULT_HAMMER_CLEARANCE) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("CornflowerBlue") RenderIf(!cutter)
  translate([HammerOffset(),-(HammerWidth()/2)-clear,-(HammerWidth()/2)-clear])
  rotate([0,-90,0])
  cube([HammerWidth()+clear2, HammerWidth()+clear2,
        HammerBoltLength()]);
}

module HammerSpacer(cutter=false, clearance=0.01,
                    debug=false, alpha=0.15) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("Beige", alpha) RenderIf(!cutter)
  DebugHalf(enabled=debug)
  rotate([0,-90,0])
  difference() {
    cylinder(r=HammerTailcapInnerRadius(),
             h=HammerSpacerLength(),
             $fn=Resolution(20,40));

    if (!cutter)
    cylinder(r=0.8/2, h=HammerSpacerLength(), $fn=Resolution(20,40));
  }
}

module HammerHead(debug=false, alpha=1, $fn=Resolution(20,60)) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {

    // Body
    translate([-SearOffset(), 0, 0])
    rotate([0,-90,0])
    ChamferedCylinder(r1=0.75/2, h=HammerHeadLength(), r2=1/16);

    HammerBolt(cutter=true);

    HammerRod(cutter=true);
  }
}

module HammerHead_print()
rotate([0,90,0])
HammerHead();

module HammerTailcap(debug=false, alpha=1, $fn=Resolution(20,40)) {

  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    translate([-HammerSpacerLength()-0.125,0,0])
    rotate([0,90,0])
    union() {

      // Insert
      ChamferedCylinder(r1=0.8/2, r2=1/16,
                        h=0.5, chamferBottom=false);
      // Flange
      ChamferedCylinder(r1=1.07/2, r2=1/16,
                        h=0.125, chamferTop=false);
    }

    translate([-HammerTravel(),0,0])
    HammerRod(cutter=true);
  }
}

module HammerTailcap_print(insertRadius=(RECEIVER_TUBE_ID/2))
rotate([0,-90,0])
translate([HammerSpacerLength()-0.125,0,0])
HammerTailcap(insertRadius=insertRadius);

module HammerAssembly(travel=DEFAULT_HAMMER_TRAVEL, travelFactor=sin(180*$t),
                    debug=false, alpha=1) {


  rotate([180,90,0])
  *FiringPinAssembly();

  translate([-travel*travelFactor,0,0]) {
    HammerRod();

    HammerBolt();

    HammerHead();
  }

  color("Tan", alpha) render()
  mirror([0,0,1])
  HammerTailcap(debug=debug);

  // Spring
  color("Silver") render()
  translate([-HammerSpacerLength()+0.375,0,0])
  rotate([0,90,0])
  cylinder(r=0.625/2, h=HammerSpringLength()-(travel*travelFactor), $fn=Resolution(20,50));

  *HammerSpacer();

}

if (_RENDER == "Assembly")
HammerAssembly();

scale(25.4) {

  if (_RENDER == "Head")
  HammerHead_print();

  if (_RENDER == "Tail")
  HammerTailcap_print();

}
