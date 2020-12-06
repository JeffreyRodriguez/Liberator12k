use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;

use <../Vitamins/Nuts And Bolts.scad>;

use <Receiver.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "StockAssembly"; // ["StockAssembly",  "TubeStockAssembly", "TubeStockSegment", "StockMonolith", "Buttstock"]
_DEBUG_ASSEMBLY = false;

/* [Receiver Tube] */
STOCK_TUBE_OD = 1.7501;

GP_BOLT = "#8-32"; // ["M4", "#8-32"]
GP_BOLT_CLEARANCE = 0.015;

$fs = UnitsFs()*0.25;

function GPBolt() = BoltSpec(GP_BOLT);
assert(GPBolt(), "GPBolt() is undefined. Unknown GP_BOLT?");

function StockLength() = 8;
function TubeStockOverlapLength() = 2;

function ButtstockBolt() = GPBolt();
function ButtstockLength() = 2;
function ButtstockSleeveLength() = 1;
function ButtstockWall() = 0.1875;
function ButtstockX() = -(ReceiverLength()+ReceiverBackLength()+StockLength());

function StockTabRingLength() = 0.5;
function StockTabWidth() = 0.75;
function StockTabHeight() = 1.25;
function StockTabLength() = ButtstockSleeveLength();

module ButtstockBolt(od=STOCK_TUBE_OD,
                     debug=false, cutter=false, teardrop=true,
                     clearance=0.005, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (R = [180]) rotate([R,0,0])
  translate([(ButtstockSleeveLength()/2), 0, StockTabHeight()+ButtstockWall()-(1/2)])
  NutAndBolt(bolt=ButtstockBolt(),
             boltLength=1/2, nutHeightExtra=(cutter?StockTabHeight():0),
             head="flat", nut="heatset",
             clearance=clear,
             teardrop=cutter&&teardrop, teardropAngle=teardropAngle);
}



module TubeStockSegment(id=1.75, length=TubeStockOverlapLength(), doRender=true) {
  color("Chocolate") RenderIf(doRender)
  translate([-(ReceiverLength()+ReceiverBackLength()),0,0])
  difference() {
    ReceiverSegment(length=length,
                    chamferFront=true);
    
    ReceiverRods(length=ReceiverLength()+ReceiverBackLength()+length,
                 nutType="none", headType="none", cutter=true);
    
    // Stock tube cutout
    rotate([0,-90,0])
    cylinder(r=id/2, h=length, $fn=80);
  }
}

module TubeStockSegment_print() {
  rotate([0,90,0])
  translate([(ReceiverLength()+ReceiverBackLength()),0,0])
  TubeStockSegment();
}

module StockSpacer(wall=0.125, doRender=true, debug=false, alpha=1, length=StockLength()) {
  color("Chocolate", alpha=alpha)
  RenderIf(doRender)
  TubeStockSegment(length=length, doRender=false);
}
module Buttstock(od=STOCK_TUBE_OD, doRender=true,
                 debug=false, alpha=1) {
  receiverRadius=od/2;
  outsideRadius = receiverRadius+ButtstockWall();
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseRadius = 0.625;
  spacerDepth=1.5;
  baseHeight = ButtstockLength();
  ribDepth=0.1875;
  extensionHull = ButtstockSleeveLength();



  color("Tan", alpha) RenderIf(doRender) DebugHalf(enabled=debug)
  translate([-(ReceiverLength()+ReceiverBackLength()+StockLength()),0,0])
  difference() {

    // Stock and extension hull
    hull() {

      // Foot of the stock
      translate([-baseHeight,0,0])
      rotate([0,90,0])
      for (L = [0,1]) translate([(length*L)-(outsideRadius/2),0,0])
      ChamferedCylinder(r1=baseRadius, r2=chamferRadius,
                         h=base,
                         $fn=Resolution(20,50));

      ReceiverSegment(length=extensionHull,
                      chamferFront=true);
    }

    // Utility slot
    translate([base-baseHeight, -0.51/2, -(StockTabHeight()+ButtstockWall())])
    mirror([0,0,1])
    ChamferedCube([length, 0.51, baseHeight+extensionHull], r=chamferRadius);


    // Gripping Ridges
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    for (M = [0,1]) mirror([0,M,0])
    for (X = [0:baseRadius:length-(baseRadius/2)])
    translate([X-(baseRadius/2),
               baseRadius+(baseRadius/5),
               -ManifoldGap()])
    cylinder(r1=baseRadius/2, r2=0, h=base);

    // Receiver Pipe hole
    translate([chamferRadius,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=receiverRadius,
                          r2=chamferRadius,
                          h=extensionHull,
                          chamferBottom=false,
                          teardropTop=false,
                          $fn=Resolution(20,80));

    // Hammer spacer hole
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    translate([0,0,(0.5)-chamferRadius])
    ChamferedCircularHole(r1=ReceiverIR(),
                          r2=chamferRadius,
                          h=spacerDepth+chamferRadius, chamferBottom=false,
                          teardropTop=false,
                          $fn=Resolution(20,50));

    //translate([-1,0,0])
    //mirror([1,0,0])
    ReceiverRods(cutter=true);
  }
}


module Buttstock_print()
  rotate([0,-90,0]) translate([StockLength()+ReceiverLength()+ButtstockLength()+0.5,0,0])
  Buttstock();

module StockMonolith(od=STOCK_TUBE_OD, wall=0.125, debug=false, alpha=1, length=StockLength()) {
  color("Tan", alpha=alpha)
  render()
  union() {
    Buttstock(od=od, doRender=false, debug=debug, alpha=alpha);
    
    // Receiver Extension Tube
    StockSpacer(length=length, doRender=false);
  }
}

module StockMonolith_print() {
  translate([0,0,-ButtstockX()])
  rotate([0,-90,0])
  StockMonolith();
}

module StockAssembly() {
  StockSpacer();
  Buttstock();
}

module TubeStockAssembly() {
  ReceiverAssembly();
  TubeStockSegment();
  Buttstock();
  
  color("Grey", 0.1)
  render()
  translate([-(ReceiverLength()+ReceiverBackLength()),0,0])
  rotate([0,-90,0])
  difference() {
    cylinder(r=STOCK_TUBE_OD/2, h=StockLength());
    cylinder(r=ReceiverIR(), h=StockLength());
  }
}

scale(25.4) {
  if (_RENDER == "StockAssembly") {
    ReceiverAssembly();
    StockAssembly();
  }
  
  if (_RENDER == "TubeStockAssembly") {
    ReceiverAssembly();
    TubeStockAssembly();
  }

  if (_RENDER == "StockMonolith")
  StockMonolith_print();

  if (_RENDER == "Buttstock")
  Buttstock_print();

  if (_RENDER == "TubeStockSegment")
  TubeStockSegment_print();

  if (_RENDER == "StockTab")
  StockTab_print();
}
