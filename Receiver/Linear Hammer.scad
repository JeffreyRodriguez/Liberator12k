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


/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Head", "Tail"]


// Firing pin housing bolt
HAMMER_BOLT = "5/16\"-18"; // ["5/16\"-18", "M8"]

/* [Receiver Tube] */
RECEIVER_TUBE_ID = 1.5;

// Settings: Lengths
function HammerBoltLength() = 7.5;
function HammerSpringLength() = 7 + (1/32);
function HammerCollarDiameter() = 0.625;
function HammerCollarRadius() = HammerCollarDiameter()/2;
function HammerCollarWidth() = 0.31;

// Settings: Vitamins
function HammerBolt() = BoltSpec(HAMMER_BOLT);
echo(HAMMER_BOLT, HammerBolt());

DEFAULT_HAMMER_TRAVEL = 1;
DEFAULT_HAMMER_CLEARANCE = 0.005;

function HammerHeadLength() = 1;
function HammerTailLength() = 0.75;
function HammerTailBaseLength() = 0.25;

function HammerTailInnerDiameter() = 1.07;
function HammerTailInnerRadius() = (HammerTailInnerDiameter()/2);

function HammerTravelFactor() = Animate(ANIMATION_STEP_FIRE)
                                    - SubAnimate(ANIMATION_STEP_CHARGE, start=0.18, end=0.36);

module HammerBolt(cutter=false, clearance=0.004) {
  translate([HammerCollarWidth()+ManifoldGap(2),0,0])
  color("CornflowerBlue") RenderIf(!cutter)
  rotate([0,90,0])
  NutAndBolt(bolt=HammerBolt(),
             boltLength=HammerBoltLength()+ManifoldGap(4), nutBackset=0.03125,
             head="hex", capOrientation=true, clearance=cutter?clearance:0);

  color("Silver") RenderIf(!cutter)
  for (X = [HammerCollarWidth(),-HammerHeadLength(),-HammerBoltLength()+(HammerCollarWidth()*2)]) translate([X,0,0])
  rotate([0,-90,0])
  cylinder(r=HammerCollarRadius(), h=HammerCollarWidth(), $fn=30);
}

module HammerHead(insertRadius=(RECEIVER_TUBE_ID/2)-DEFAULT_HAMMER_CLEARANCE,
                          holeRadius=(5/16/2)+0.005,
                          length=HammerHeadLength(),
                          chamferRadius=1/16,
                          debug=false, alpha=1, $fn=Resolution(20,60)) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {

    // Body
    rotate([0,-90,0])
    hull() {
      ChamferedCylinder(r1=insertRadius, r2=chamferRadius,
                        h=chamferRadius*2, chamferTop=false);

      translate([0,0,length-HammerCollarWidth()])
      cylinder(r=HammerCollarRadius(), h=HammerCollarWidth());
    }

    HammerBolt(cutter=true);

    // Valleys to allow air to pass freely
    rotate([0,-90,0])
    translate([ManifoldGap(),0,0])
    for (R = [0:20:360])
    rotate(R)
    translate([insertRadius+chamferRadius,0,0])
    cylinder(r=chamferRadius*1.5, h=0.5, $fn=Resolution(15,25));
  }
}

module HammerHead_print(insertRadius=(RECEIVER_TUBE_ID/2))
rotate([0,90,0])
HammerHead(insertRadius=insertRadius);

module HammerTail(insertRadius=(RECEIVER_TUBE_ID/2)-DEFAULT_HAMMER_CLEARANCE,
                  baseHeight=HammerTailBaseLength(),
                  holeRadius=(5/16/2)+0.008,
                  innerRadius=HammerTailInnerRadius(),
                  length=HammerTailLength(),
                  minorChamferRadius=1/32,
                  debug=false, alpha=1, $fn=Resolution(20,90)) {

  bigHoleChamferRadius = (insertRadius-innerRadius);

  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {

    // Body
    rotate([0,-90,0])
    ChamferedCylinder(r1=insertRadius, r2=minorChamferRadius,
                      h=length);

    HammerBolt(cutter=true);

    // Main hole for spacer
    rotate([0,-90,0])
    translate([0,0,bigHoleChamferRadius+baseHeight])
    ChamferedCircularHole(r1=innerRadius, r2=bigHoleChamferRadius,
                          h=length-baseHeight-bigHoleChamferRadius,
                          chamferBottom=false);

    // Valleys to allow air to pass freely
    rotate([0,-90,0])
    for (R = [0:20:360])
    rotate(R)
    translate([insertRadius+0.125,0,-ManifoldGap()]) {
      cylinder(r1=3/16, r2=0, h=0.5, $fn=Resolution(15,25));

      cylinder(r=5/32, h=length+ManifoldGap(2), $fn=Resolution(15,25));
    }
  }
}

module HammerTail_print(insertRadius=(RECEIVER_TUBE_ID/2))
rotate([0,90,0])
HammerTail(insertRadius=insertRadius);

module HammerCompressor(insertRadius=(RECEIVER_TUBE_ID/2)-DEFAULT_HAMMER_CLEARANCE,
                        hammerTravel=2,
                        length=3, debug=false, alpha=1) {

  translate([hammerTravel-HammerSpringLength()+0.03125+HammerTailBaseLength()+ManifoldGap(),0,0]) {

    color("Tan", alpha)
    HammerTail(insertRadius=insertRadius, debug=debug);

    color("Beige", alpha)
    DebugHalf(enabled=debug) render()
    translate([-HammerTailBaseLength(),0,0])
    rotate([0,-90,0])
    difference() {
      cylinder(r=HammerTailInnerRadius(), h=length, $fn=Resolution(20,50));

      cylinder(r=0.75/2, h=length, $fn=Resolution(20,50));
    }
  }
}

module HammerAssembly(travel=2, travelFactor=HammerTravelFactor(),
                    insertRadius = (RECEIVER_TUBE_ID/2),
                    length=3.25,
                    debug=false, alpha=1) {

  translate([-HammerCollarWidth()+travel*travelFactor,0,0]) {
    HammerBolt();

    HammerHead(insertRadius=insertRadius, debug=debug, alpha=alpha);

  }

  HammerCompressor(insertRadius=insertRadius, length=length, debug=debug, alpha=alpha);
}

if (_RENDER == "Assembly")
HammerAssembly();

if (_RENDER == "Head")
HammerHead_print();

if (_RENDER == "Tail")
HammerTail_print();
