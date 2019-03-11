include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;

use <../../Components/Firing Pin.scad>;
use <../../Components/Pipe/Lugs.scad>;

use <../../Finishing/Chamfer.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Trigger.scad>;
use <../../Lower/Lower.scad>;

use <Frame.scad>;


// Settings: Lengths
function HammerBoltLength() = 8.25;
function HammerSpringLength() = 7.25;

// Settings: Vitamins
function LinearHammerBolt() = Spec_BoltFiveSixteenths();

DEFAULT_HAMMER_TRAVEL = 1;
DEFAULT_HAMMER_CLEARANCE = 1/32;

function LinearHammerTravelFactor() = Animate(ANIMATION_STEP_FIRE)
                                    - SubAnimate(ANIMATION_STEP_CHARGE, start=0.18, end=0.36);
function LinearHammerTravel() = LowerMaxX()
                              - BoltCapHeight(LinearHammerBolt())
                              + RodRadius(SearRod())
                              + FrameExtension()
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

module LinearHammerInsert(insertRadius=ReceiverIR()-DEFAULT_HAMMER_CLEARANCE,
                          baseHeight=0.25, holeRadius=(5/16/2)+(0.008), 
                          innerRadius=(1.07/2), length=1,
                          minorChamferRadius=1/32, majorChamferRadius=1/8,
                          debug=false, $fn=Resolution(20,50)) {
  DebugHalf(enabled=debug)
  difference() {
    
    // Body
    ChamferedCylinder(r1=insertRadius, r2=minorChamferRadius,
                      h=length, chamferTop=false);
  
    // Hammer Hole
    ChamferedCircularHole(r1=holeRadius, r2=minorChamferRadius,
                          h=baseHeight);
    
          
    translate([0,0,length])
    mirror([0,0,1])
    CircularOuterEdgeChamfer(r1=insertRadius, r2=majorChamferRadius*2,
                             teardrop=true);
    
    // Cut out the insides
    translate([0,0,baseHeight])
    difference() {
      translate([0,0,majorChamferRadius])
      ChamferedCircularHole(r1=innerRadius, r2=majorChamferRadius,
                            h=length-baseHeight-majorChamferRadius,
                            chamferBottom=false);
      
      CircularOuterEdgeChamfer(r1=innerRadius, r2=majorChamferRadius,
                               teardrop=false);
    }
    
    // Valleys to allow air to pass freely
    translate([ManifoldGap(),0,0])
    for (R = [0:20:360])
    rotate(R)
    translate([insertRadius+0.125-0.0375,0,0])
    ChamferedCircularHole(r1=0.125, r2=minorChamferRadius,
                          h=length+ManifoldGap(2), $fn=Resolution(15,25));
  }
}

module LinearHammerGuide(insertRadius=ReceiverIR()-DEFAULT_HAMMER_CLEARANCE, length=1,
                         debug=false) {
  color("Orange")
  translate([-BoltCapHeight(LinearHammerBolt()),0,0])
  rotate([0,-90,0])
  LinearHammerInsert(debug=debug);
}

module LinearHammerCompressor(insertRadius=ReceiverIR()-DEFAULT_HAMMER_CLEARANCE,
                              length=3,
                              base=0.25, debug=false) {
  
  translate([LinearHammerTravel()-HammerSpringLength()+0.03125+base+ManifoldGap(),0,0]) {
  
    color("Orange")
    rotate([0,-90,0])
    LinearHammerInsert(debug=debug);
                                  
    color("Orange")
    translate([-length-0.5,0,0])
    rotate([0,90,0])
    LinearHammerInsert(debug=debug);
    
    color("Beige")
    DebugHalf(enabled=debug)
    translate([-0.25,0,0])
    rotate([0,-90,0])
    difference() {
      cylinder(r=1.06/2, h=length, $fn=20);
      cylinder(r=0.75/2, h=length, $fn=20);
    }
  }
}

module LinearHammerAssembly(travelFactor=LinearHammerTravelFactor(),
                    insertRadius = ReceiverIR(),
                    length=3.25,
                    debug=false) {
  
  translate([LinearHammerTravel()*travelFactor,0,0]) {
    color("CornflowerBlue")
    render() {
      translate([-BoltCapHeight(LinearHammerBolt()),0,0])
      rotate([0,90,0])
      NutAndBolt(bolt=LinearHammerBolt(),
                 boltLength=HammerBoltLength(),
                 nutEnable=false, nutBackset=0.03125,
                 capHex=true, capOrientation=true, clearance=false);
    }
    
    LinearHammerGuide(debug=debug);
    
  }
  
  LinearHammerCompressor(length=length, debug=debug);
}

LinearHammerAssembly(travelFactor=$t, debug=true);

*!scale(25.4)
LinearHammerInsert();