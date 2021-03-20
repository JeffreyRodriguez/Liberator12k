use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Meta/Debug.scad>;
use <../Meta/Resolution.scad>;
use <../Meta/RenderIf.scad>;

use <../Shapes/Chamfer.scad>;
use <../Shapes/Semicircle.scad>;
use <../Shapes/Teardrop.scad>;

use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;

use <Receiver.scad>;

_SHOW_RECEIVER = true;
_SHOW_RECEIVER_RODS = true;


_CUTAWAY_RECEIVER = false;

FRAME_SPACER_LENGTH = 4.5;

COUPLING_BOLT = "1/4\"-20";    // ["1/4\"-20", "M4", "#8-32"]
COUPLING_BOLT_NUT = "heatset"; // ["hex", "heatset"]
COUPLING_BOLT_CLEARANCE = 0.015;
COUPLING_BOLT_Z = -0.8750;
COUPLING_BOLT_Y = 1.1250;

// Settings: Lengths
function FrameBoltLength() = 10;
function FrameReceiverLength() = 2.5;
function FrameBackLength() = 0.5;
function ReceiverCouplingLength() = 1;
function LogoTextSize() = 11/32;
function LogoTextDepth() = 1/32;

// Settings: Walls
function WallFrameBolt() = 0.1875;

// Settings: Vitamins
function FrameBolt() = Spec_BoltOneHalf();

function CouplingBolt() = BoltSpec(COUPLING_BOLT);
assert(CouplingBolt(), "CouplingBolt() is undefined. Unknown COUPLING_BOLT?");


// Shorthand: Measurements
function FrameBoltRadius(clearance=0)
    = BoltRadius(FrameBolt(), clearance);

function FrameBoltDiameter(clearance=0)
    = BoltDiameter(FrameBolt(), clearance);

// Settings: Positions
function FrameBoltZ() = 7/8;
function FrameBoltY() = 1.25;
function FrameWidth() = (FrameBoltY()
                       + FrameBoltRadius()
                       + WallFrameBolt()) * 2;
function FrameTopZ() = FrameBoltZ()
                     + FrameBoltRadius()
                     + WallFrameBolt();
function FrameBottomZ() = FrameBoltZ()
                        - FrameBoltRadius()
                        - WallFrameBolt();

function FrameExtension(length=FrameBoltLength()) = length
                                                  - FrameReceiverLength()
                                                  - NutHexHeight(FrameBolt());

// ************
// * Vitamins *
// ************
module FrameBoltIterator() {
    for (Y = [FrameBoltY(),-FrameBoltY()])
    translate([-FrameReceiverLength()-FrameBackLength()-ManifoldGap(),
               Y, FrameBoltZ()])
    rotate([0,-90,0])
    children();
}

module FrameBolts(length=FrameBoltLength(), debug=false, cutter=false, clearance=0.008, alpha=1) {
  clear = cutter ? clearance : 0;

  color("Silver", alpha) RenderIf(!cutter)
  DebugHalf(enabled=debug) {
    FrameBoltIterator()
    NutAndBolt(bolt=FrameBolt(), boltLength=length,
         head=(cutter?"none":"hex"), nut=(cutter?"none":"hex"), clearance=clear,
         capOrientation=true);
  }
}

module CouplingBolts(yz = [COUPLING_BOLT_Y, COUPLING_BOLT_Z], boltHead="flat", nutType=COUPLING_BOLT_NUT, extension=0.5, clearance=0.005, cutter=false, teardrop=false, debug=false) {
                         for (Y = [-1,1])
  translate([-ReceiverCouplingLength()-ManifoldGap(),
             yz[0]*Y,
             yz[1]])
  rotate([0,90,0])
  NutAndBolt(bolt=CouplingBolt(),
             boltLength=ReceiverCouplingLength()+extension+ManifoldGap(2),
             head=boltHead,
             nut=nutType,
             teardrop=cutter&&teardrop,
             clearance=cutter?clearance:0);
}

// **********
// * Shapes *
// **********
module FrameSupport(length=FRAME_SPACER_LENGTH, width=(FrameBoltY()+FrameBoltRadius()+WallFrameBolt())*2, height=(FrameBoltRadius()+WallFrameBolt())*2, extraBottom=0, $fn=Resolution(20,60)) {
  translate([0, -width/2, FrameBoltZ()-(height/2)-extraBottom])
  rotate([90,0,90])
  linear_extrude(height=length)
  ChamferedSquare(xy=[width,height+extraBottom], r=1/4,
                  teardropBottom=false,
                  teardropTop=false);
}

module CouplingSupport(yz = [COUPLING_BOLT_Y, COUPLING_BOLT_Z], length=1) {
  
  hull() {
    
    // Coupling bolt supports
    for (Y = [-1,1])
    translate([0,Y*yz[0],yz[1]])
    rotate([0,90,0])
    ChamferedCylinder(r1=0.3125, r2=1/16, h=length,
                      teardropTop=true, $fn=Resolution(20,40));
    
    // Hull to receiver
    rotate([0,90,0])
    ChamferedCylinder(r1=ReceiverOR(), r2=1/16, h=length,
                      chamferBottom=false, chamferTop=true,
                      $fn=Resolution(30,60));
  }
}


// ****************
// * Printed Parts*
// ****************
module FrameSpacer(length=FRAME_SPACER_LENGTH, debug=false, alpha=1) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    hull()
    FrameSupport(length=length);

    FrameBolts(cutter=true);
  }
}

module FrameSpacer_print() {
  rotate([0,-90,0]) translate([0,0,-FrameBoltZ()])
  FrameSpacer();
}

module FrameBack(length=FrameBackLength(), clearance=0.01, debug=false, alpha=1) {
  color("Chocolate", alpha) render() DebugHalf(enabled=debug)
  difference() {
    translate([-(FrameReceiverLength()+length),0,0])
    FrameSpacer(length=length);
    
    hull()
    Receiver(doRender=false);
  }
}

module FrameBack_print() {
  rotate([0,-90,0])
  translate([(FrameReceiverLength()+FrameBackLength()),0,-FrameBoltZ()])
  FrameBack();
}

module Receiver_LargeFrame(couplingBoltYZ=[COUPLING_BOLT_Y, COUPLING_BOLT_Z], doRender=true, debug=false) {
  
  topCoverHeight = 1;
  
  // Branding text
  color("DimGrey")
  RenderIf(doRender) DebugHalf(enabled=debug) {
      
    // Right-side text
    translate([-FrameReceiverLength()+0.0625,-FrameWidth()/2,FrameBoltZ()-(LogoTextSize()/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    text("Liberator12k", size=LogoTextSize(), font="Impact");

    // Left-side text
    translate([-0.0625,FrameWidth()/2,FrameBoltZ()-(LogoTextSize()/2)])
    rotate([90,0,0])
    linear_extrude(height=LogoTextDepth(), center=true)
    mirror([1,0])
    text("Liberator12k", size=LogoTextSize(), font="Impact");
  }
  
  color("Tan")
  RenderIf(doRender) DebugHalf(enabled=debug)
  difference() {
    Receiver(doRender=false) {
      
      hull() {
        
        // Frame bolt supports
        mirror([1,0,0])
        FrameSupport(length=FrameReceiverLength()+FrameBackLength());

        ReceiverTopSegment(length=FrameReceiverLength());
      }
      
      translate([0,-ReceiverOR(),-1/16])
      mirror([1,0,0])
      cube([FrameReceiverLength()+FrameBackLength(),
            ReceiverOD(),FrameBoltZ()]);
      
      // Fillet
      for (M = [0,1]) mirror([0,M,0])
      mirror([1,0,0])
      translate([0,
                 ReceiverOR()-ManifoldGap(),
                 FrameBottomZ()+ManifoldGap()])
      rotate([0,90,0])
      rotate(-90)
      Fillet(r=WallFrameBolt(),
             h=FrameReceiverLength()+FrameBackLength(),
             taperEnds=true);
    }
    
    ReceiverMlokSlot();
    ReceiverMlokBolts(cutter=true, teardrop=true);
    ReceiverTopSlot(length=ReceiverLength());
    
    CouplingBolts(yz=couplingBoltYZ, cutter=true);
    FrameBolts(cutter=true);
  }
}

module Receiver_LargeFrame_print(couplingBoltYZ=[COUPLING_BOLT_Y, COUPLING_BOLT_Z]) {
  rotate([0,90,0])
  Receiver_LargeFrame(couplingBoltYZ=couplingBoltYZ);
}


// **************
// * Assemblies *
// **************
module Receiver_LargeFrameAssembly(length=FrameBoltLength(), spacerLength=FRAME_SPACER_LENGTH, couplingBoltYZ=[COUPLING_BOLT_Y, COUPLING_BOLT_Z], couplingBoltLength=0.5, debug=_CUTAWAY_RECEIVER, alpha=1) {
  Receiver_LargeFrame(couplingBoltYZ=couplingBoltYZ, debug=debug);
  
  color("Silver")
  render()
  CouplingBolts(yz=couplingBoltYZ, extension=couplingBoltLength);
  
  FrameBolts(length=length);
                       
  FrameBolts(length=length, debug=debug, alpha=alpha);

  *FrameSpacer(length=spacerLength);
}

if ($preview) {
  
  if (_SHOW_RECEIVER_RODS)
  TensionBolts();

  if (_SHOW_RECEIVER) {
  Receiver_LargeFrameAssembly(couplingBoltYZ=[2,-0.5]);
    
    ReceiverMlokBolts();
  }
} else {
  scale(25.4)
  Receiver_LargeFrame_print();
}