use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;

use <Frame.scad>;

use <Receiver.scad>;

/* [What to Render] */

// Assembly is not for printing.
_RENDER = "StockAssembly"; // ["StockAssembly", "Stock", "Buttpad"]
_SHOW_BUTTPAD_BOLT = true;
_SHOW_STOCK = true;
_SHOW_BUTTPAD = true;

/* [Assembly Transparency] */
_ALPHA_STOCK = 1; // [0:0.1:1]
_ALPHA_BUTTPAD = 1; // [0:0.1:1]


/* [Assembly Cutaway] */
_CUTAWAY_STOCK = false;
_CUTAWAY_BUTTPAD = false;

_DEBUG_ASSEMBLY = false;



BUTTPAD_BOLT = "1/4\"-20"; // ["M6", "1/4\"-20"]
BUTTPAD_BOLT_CLEARANCE = 0.015;

$fs = UnitsFs()*0.25;

function ButtpadBolt() = BoltSpec(BUTTPAD_BOLT);
assert(ButtpadBolt(), "ButtpadBolt() is undefined. Unknown BUTTPAD_BOLT?");

function StockLength() = 6;
function ButtpadSleeveLength() = 1;
function ButtpadLength() = 2.5;
function ButtpadWall() = 0.1875;
function ButtpadX() = -(ReceiverLength()+StockLength()+1.5);

module ButtpadBolt(debug=false, cutter=false, teardrop=true, clearance=0.01, teardropAngle=0) {
  clear = cutter ? clearance : 0;

  color("Silver") RenderIf(!cutter) DebugHalf(enabled=debug)
  for (Z = [0, -2])
  translate([ButtpadX()-ButtpadLength(), 0, Z])
  rotate([0,-90,0])
  NutAndBolt(bolt=ButtpadBolt(),
             boltLength=3.5,
             head="flat", capHeightExtra=(cutter?ButtpadLength():0),
             nut="heatset", nutHeightExtra=(cutter?1:0), capOrientation=true,
             clearance=clear);
}

module Stock(length=StockLength(), doRender=true, debug=_CUTAWAY_STOCK, alpha=1) {
topCoverHeight = 1;
  color("Chocolate", alpha=alpha)
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    translate([-ReceiverLength(),0,0])
    union() {
      
      // Merge high-top receiver to into the body
      hull() {
        
        // Merge to body
        ReceiverSegment(length=0.25, highTop=true);
        
        // Merge to body
        ReceiverSegment(length=1.5, highTop=false);
      }
      
      // Main body
      ReceiverSegment(length=length, highTop=false);
      
      // Buttpad attachment
      translate([-length,0,0])
      hull() {
        ReceiverSegment(length=1-0.25, highTop=false);
        
        translate([-1,0,0])
        scale([1,1.1,1.1])
        mirror([1,0,0])
        ReceiverSegment(length=ManifoldGap(), highTop=false);
        
        translate([-1,0,-2])
        rotate([0,90,0])
        cylinder(r=0.5, h=0.5, $fn=50);
      }
    }
    
    // Spring seat
    translate([-ReceiverLength(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=0.65/2, r2=1/16, chamferTop=false,
                          h=0.1875, $fn=40);
    
    // Slot
    translate([-(ReceiverLength()+ReceiverBackLength()),0,0])
    translate([-length,-0.75/2, -3])
    cube([length-1, 0.75, 3]);
    
    // Slot Taper
    translate([-(ReceiverLength()+ReceiverBackLength()),0,0])
    translate([-1,0, -3])
    linear_extrude(height=3)
    Teardrop(r=0.375);
    
    // Center Hole
    translate([-(ReceiverLength()+ReceiverBackLength())-0.75,0,0])
    rotate([0,-90,0])
    cylinder(r=0.75, h=length-0.75, $fn=80);
    
    // Center Hole Taper
    translate([-(ReceiverLength()+ReceiverBackLength()),0,0])
    rotate([0,-90,0])
    cylinder(r1=0, r2=0.75, h=0.75, $fn=80);
    
    TensionBolts(nutType="none", headType="none", cutter=true);
    
    ButtpadBolt(cutter=true);
  }
}

module Stock_print() {
  rotate([0,-90,0])
  translate([ReceiverLength()+StockLength()+ButtpadSleeveLength(),0,0])
  Stock();
}
module Buttpad(doRender=true, debug=_CUTAWAY_BUTTPAD, alpha=1) {
  receiverRadius=ReceiverOR();
  outsideRadius = receiverRadius+ButtpadWall();
  chamferRadius = 1/16;
  length = 4;
  base = 0.375;
  baseRadius = 9/16;
  spacerDepth=1.5;
  baseHeight = ButtpadLength();
  ribDepth=0.1875;

  color("Tan", alpha) RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {

    // Stock and extension hull
    translate([ButtpadX(),0,0])
    hull() {

      // Foot of the stock
      translate([-baseHeight,0,-0.5])
      rotate([0,90,0])
      for (L = [0,1]) translate([(length*L)-(outsideRadius/2),0,0])
      ChamferedCylinder(r1=baseRadius, r2=chamferRadius,
                         h=base,
                         $fn=Resolution(20,50));
      scale([1,1.1,1.1])
      mirror([1,0,0])
      ReceiverSegment(length=0.5, highTop=false);
      
      translate([0,0,-2])
      rotate([0,90,0])
      cylinder(r=0.5, h=0.5, $fn=50);
      
    }

    // Gripping Ridges
    translate([ButtpadX(),0,-0.5])
    translate([-baseHeight,0,0])
    rotate([0,90,0])
    for (M = [0,1]) mirror([0,M,0])
    for (X = [0:baseRadius:length-(baseRadius/2)])
    translate([X-(baseRadius/2),
               baseRadius+(baseRadius/5),
               -ManifoldGap()])
    cylinder(r1=baseRadius/2, r2=0, h=base);
    
    ButtpadBolt(cutter=true);
    
    translate([ButtpadX()+0.5,0,0])
    TensionBoltIterator()
    cylinder(r=NutHexRadius(TensionBolt(), 0.02), h=0.5, $fn=20);
  }
}


module Buttpad_print() {
  rotate([0,-90,0]) translate([StockLength()+ReceiverLength()+ButtpadLength()+0.5,0,0])
  Buttpad();
}

module StockAssembly(debug=_DEBUG_ASSEMBLY) {
  if (_SHOW_BUTTPAD_BOLT)
  ButtpadBolt();
  
  if (_SHOW_STOCK)
  Stock(alpha=_ALPHA_STOCK, debug=debug);
  
  if (_SHOW_BUTTPAD)
  Buttpad(alpha=_ALPHA_BUTTPAD, debug=debug);
}

if (_RENDER == "StockAssembly") {
  ReceiverAssembly();
  StockAssembly();
}

scale(25.4) {

  if (_RENDER == "Stock")
  Stock_print();
  
  if (_RENDER == "Buttpad")
  Buttpad_print();
}
