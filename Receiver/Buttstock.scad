include <../Meta/Animation.scad>;

use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Components/Firing Pin.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../Vitamins/Pipe.scad>;

use <Lower/Receiver Lugs.scad>;
use <Lower/Trigger.scad>;
use <Lower/Lower.scad>;

use <Linear Hammer.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "Buttstock", "ButtstockTab"]
_DEBUG_ASSEMBLY = false;

/* [Receiver Tube] */
RECEIVER_TUBE_OD = 1.9101;

GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

$fs = UnitsFs()*0.25;

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function ButtstockBolt() = GPBolt();
function ButtstockHeight() = 2;
function ButtstockSleeveLength() = 1;
function ButtstockWall() = 0.1875;

function ButtstockTabRingLength() = 0.5;
function ButtstockTabWidth() = 0.75;
function ButtstockTabHeight() = 1.25;
function ButtstockTabLength() = ButtstockSleeveLength();

module ButtstockBolt(od=RECEIVER_TUBE_OD,
                     debug=false, cutter=false, teardrop=true,
                     clearance=0.005, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (R = [180]) rotate([R,0,0])
  translate([(ButtstockSleeveLength()/2), 0, ButtstockTabHeight()+ButtstockWall()-(1/2)])
  NutAndBolt(bolt=ButtstockBolt(),
             boltLength=1/2, nutHeightExtra=(cutter?ButtstockTabHeight():0),
             head="flat", nut="heatset",
             clearance=clear,
             teardrop=cutter&&teardrop, teardropAngle=teardropAngle);
}

module ButtstockTab(od=RECEIVER_TUBE_OD,
                    cutter=false, clearance=0.01,
                    chamferRadius=1/16, debug=false, alpha=1) {
  clear = cutter?clearance:0;
  clear2 = clear*2;

  color("SaddleBrown", alpha) RenderIf(!cutter) DebugHalf(enabled=debug)
  difference() {
    union() {
      hull() {

        // Around the receiver tube
        translate([ButtstockSleeveLength(),0,0])
        rotate([0,90,0])
        ChamferedCylinder(r1=(od/2)+ButtstockWall(),
                          r2=chamferRadius, h=ButtstockTabRingLength(),
                          teardropTop=true, $fn=Resolution(30,90));

        // Tab support
        translate([ButtstockTabLength(),-(ButtstockTabWidth()/2)-ButtstockWall(),0])
        mirror([0,0,1])
        ChamferedCube([ButtstockTabRingLength(),
                       ButtstockTabWidth()+(ButtstockWall()*2),
                       ButtstockTabHeight()],
                      r=chamferRadius);
      }

      // Tab body
      translate([0,-(ButtstockTabWidth()/2)-clear,0])
      mirror([0,0,1])
      ChamferedCube([ButtstockTabLength()+ButtstockTabRingLength()+clear,
                     ButtstockTabWidth()+clear2,
                     ButtstockTabHeight()],
                    r=chamferRadius);
    }


    if (!cutter) {

      // Receiver tube cutout
      rotate([0,90,0])
      ChamferedCircularHole(r1=(od/2),
                            r2=chamferRadius,
                            h=ButtstockTabLength()+ButtstockTabRingLength()+clear,
                            chamferBottom=false,
                            teardropTop=false,
                            $fn=Resolution(20,80));

      ButtstockBolt(cutter=true, teardropAngle=180);
    }
  }
}

module ButtstockTab_print(od=RECEIVER_TUBE_OD) {
  rotate([0,90,0])
  translate([-ButtstockSleeveLength()-ButtstockTabRingLength(),0,0])
  ButtstockTab(od=od);
}
module Buttstock(od=RECEIVER_TUBE_OD,
                 debug=false, alpha=1) {
  receiverRadius=od/2;
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  spacerDepth=1.5;
  baseHeight = ButtstockHeight();
  ribDepth=0.1875;
  extensionHull = ButtstockSleeveLength();
  outsideRadius = receiverRadius+ButtstockWall();



  color("Tan", alpha) render() DebugHalf(enabled=debug)
  difference() {

    // Stock and extension hull
    hull() {

      // Foot of the stock
      translate([-baseHeight,0,0])
      rotate([0,90,0])
      for (L = [0,1]) translate([(length*L)-(outsideRadius/2),0,0])
      ChamferedCylinder(r1=outsideRadius/2, r2=chamferRadius,
                         h=base,
                         $fn=Resolution(20,50));

      // Around the receiver tube
      rotate([0,90,0])
      ChamferedCylinder(r1=outsideRadius,
                        r2=chamferRadius, h=extensionHull,
                        teardropTop=true, $fn=Resolution(30,90));

      // Tab support
      translate([0,-(ButtstockTabWidth()/2)-ButtstockWall(),0])
      mirror([0,0,1])
      ChamferedCube([ButtstockTabLength(),
                     ButtstockTabWidth()+(ButtstockWall()*2),
                     ButtstockTabHeight()+ButtstockWall()],
                    r=chamferRadius);
    }

    // Utility slot
    translate([base-baseHeight, -0.51/2, -(ButtstockTabHeight()+ButtstockWall())])
    mirror([0,0,1])
    ChamferedCube([length, 0.51, baseHeight+extensionHull], r=chamferRadius);


    // Gripping Ridges
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    for (M = [0,1]) mirror([0,M,0])
    for (X = [0:outsideRadius/2:length-(outsideRadius/2)])
    translate([X-(outsideRadius/4),
               (outsideRadius/2)+(outsideRadius/10),
               -ManifoldGap()])
    cylinder(r1=outsideRadius/4, r2=0, h=base);

    // Receiver Pipe hole
    translate([chamferRadius,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=receiverRadius,
                          r2=chamferRadius,
                          h=extensionHull,
                          chamferBottom=false,
                          teardropTop=false,
                          $fn=Resolution(20,80));

    // Linear hammer spacer hole
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    translate([0,0,(0.5)-chamferRadius])
    ChamferedCircularHole(r1=HammerTailInnerRadius(),
                          r2=chamferRadius,
                          h=spacerDepth+chamferRadius, chamferBottom=false,
                          teardropTop=false,
                          $fn=Resolution(20,50));
    ButtstockTab(od=od, cutter=true);

    ButtstockBolt(od=od, cutter=true, teardropAngle=0);

  }
}

module Buttstock_print(od=RECEIVER_TUBE_OD)
rotate([0,-90,0]) translate([ButtstockHeight(),0,0])
Buttstock(od=od);

module ButtstockAssembly(od=RECEIVER_TUBE_OD, debug=false, alpha=1) {
  ButtstockBolt(od=od);

  ButtstockTab(od=od, debug=debug, alpha=alpha);

  Buttstock(od=od, debug=debug, alpha=alpha);
}


scale(25.4) {
  if (_RENDER == "Assembly") {
    ButtstockAssembly(debug=_DEBUG_ASSEMBLY);
  }

  if (_RENDER == "Buttstock")
  Buttstock_print();

  if (_RENDER == "ButtstockTab")
  ButtstockTab_print();
}
