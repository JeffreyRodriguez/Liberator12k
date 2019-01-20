include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <../Firing Pin.scad>;

use <Lugs.scad>;
use <Frame.scad>;


// Settings: Lengths
function HammerBoltLength() = 3.5;
function HammerSpringLength() = 3;

// Settings: Vitamins
function LinearHammerBolt() = Spec_BoltFiveSixteenths();

DEFAULT_HAMMER_TRAVEL = 1;

function LinearHammerTravelFactor() = Animate(ANIMATION_STEP_FIRE)
                                    - Animate(ANIMATION_STEP_CHARGE);
function LinearHammerTravel() = LowerMaxX()
                              - BoltCapHeight(LinearHammerBolt())
                              + RodRadius(SearRod())
                              - FiringPinBodyLength();

module LinearHammerBolt(cutter=false) {
  translate([-BoltCapHeight(LinearHammerBolt()),0,0])
  color("CornflowerBlue")
  render()
  rotate([0,90,0])
  NutAndBolt(bolt=LinearHammerBolt(),
             boltLength=HammerBoltLength(), nutBackset=0.03125,
             capHex=true, capOrientation=true, clearance=cutter);
}

module LinearHammerGuide(insertRadius=ReceiverIR(), length=1.5,
                         debug=false) {
  color("Orange")
  DebugHalf(enabled=debug)
    translate([-BoltCapHeight(LinearHammerBolt()),0,0])
  difference() {
    rotate([0,-90,0])
    ChamferedCylinder(r1=insertRadius, r2=1/16,
             h=length,
             $fn=Resolution(20,50));
    
    // Allow air to pass freely
    translate([ManifoldGap(),0,0])
    for (R = [0:20:360])
    rotate([R,0,0])
    translate([0,0,insertRadius])
    rotate([0,-90,0])
    cylinder(r=0.0625, h=length+ManifoldGap(2), $fn=Resolution(15,25));
  
    translate([BoltCapHeight(LinearHammerBolt()),0,0])
    LinearHammerBolt();
    
    translate([-length,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=0.5, r2=1/4,
                          h=length-BoltCapHeight(LinearHammerBolt())-0.25,
                           chamferTop=false,
                           $fn=Resolution(8,20));
  }
}

module LinearHammerCompressor(insertRadius=ReceiverIR(),
                              pretravel=0.5,
                              overtravel=0.375,
                              base=0.25, debug=false) {
  length=base+pretravel+LinearHammerTravel()+overtravel;
  
  color("Orange")
  DebugHalf(enabled=debug)
  translate([pretravel+LinearHammerTravel()-HammerBoltLength()+0.03125+base+ManifoldGap(),0,0])
                                
  translate([-BoltCapHeight(LinearHammerBolt()),0,0])
  difference() {
    rotate([0,-90,0])
    ChamferedCylinder(r1=insertRadius, r2=1/16,
             h=length,
             $fn=Resolution(20,50));
    
    // Allow air to pass freely
    translate([ManifoldGap(),0,0])
    for (R = [0:20:360])
    rotate([R,0,0])
    translate([0,0,insertRadius])
    rotate([0,-90,0])
    cylinder(r=0.0625, h=length+ManifoldGap(2), $fn=Resolution(15,25));
  
    translate([-BoltCapHeight(LinearHammerBolt()),0,0])
    LinearHammerBolt(cutter=true);
    
    translate([-length,0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=0.5,
                          r2=1/16, h=length-base, chamferTop=false,
                          $fn=Resolution(8,20));
  }
}

module LinearHammerAssembly(travelFactor=0,
                    insertRadius = ReceiverIR(),
                    debug=false) {
  
  translate([LinearHammerTravel()*travelFactor,0,0]) {
    color("CornflowerBlue")
    render() {
      translate([-BoltCapHeight(LinearHammerBolt()),0,0])
      rotate([0,90,0])
      NutAndBolt(bolt=LinearHammerBolt(),
                 boltLength=HammerBoltLength(), nutBackset=0.03125,
                 capHex=true, capOrientation=true, clearance=false);
    }
    
    LinearHammerGuide(debug=debug);
    
  }
  
  LinearHammerCompressor(debug=debug);
}

LinearHammerAssembly(travelFactor=$t, debug=true);



// Guide Plater
*!scale(25.4) rotate([0,90,0]) translate([BoltCapHeight(LinearHammerBolt()),0,0])
LinearHammerGuide();

// Compressor Plater
*!scale(25.4) rotate([0,90,0]) translate([HammerBoltLength()-0.03125,0,0])
LinearHammerCompressor();