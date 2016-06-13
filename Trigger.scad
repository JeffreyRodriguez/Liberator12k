//$t=0.999999999;
$t=0;
include <Components/Animation.scad>;

use <Components/Receiver Insert.scad>;
use <Components/Semicircle.scad>;
use <Components/Manifold.scad>;
use <Components/Debug.scad>;

use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Spring.scad>;

use <Firing Pin.scad>;
use <Striker.scad>;
use <Charger.scad>;

use <Reset Spring.scad>;

use <Reference.scad>;

//function TriggerSpring() = Spec_BicSoftFeelFinePenSpring();
function TriggerSpring() = Spec_BicLighterThumbSpring();


//function SearTowerHeight() = TeeCenter(ReceiverTee()) - 0.35;


function TriggerAngle() = 360/16;
function TriggerWidth() = 0.25;
function TriggerPinX() = -1/4;
function TriggerPinZ() = -TeeCenter(ReceiverTee())-RodRadius(TriggerRod());

function TriggerMaxMajor() = 2.63;

function SafetyPinX() = TriggerPinX() - (TriggerMaxMajor()/2*sqrt(2));
function SafetyPinZ() = TriggerPinZ();
function SafetyMajorOD() = 3;
function SafetyInterfaceOD() = 2.63;
function SafetyMinorRadius() = 0.45;
function SafetyHoleRadius() = 0.2;
function SafetyBarAngle() = 32;
function SafetyBackAngle() = 3;
function SafetyAngle() = 15;


module Spindle(pin=SafetyRod(), center=false, cutter=false,
               radius=0.2, clearance=0.015, height=0.27,
               $fn=Resolution(12,12)) {
    difference() {
      cylinder(r=radius+(cutter==true ? clearance : 0), h=height, center=center);

      if (cutter==false)
      Rod(rod=pin, clearance=RodClearanceLoose(), length=height*3, center=true);
    }
}



module SearArm() {
  translate([RodRadius(SearRod()),0,-RodDiameter(StrikerRod())*Animate(ANIMATION_STEP_TRIGGER)])
  // Sear Arm
  color("Lime")
  mirror([0,0,1])
  difference() {
    union() {
      translate([0,-RodRadius(SearRod()),ReceiverIR()])
      mirror([1,0,0])
      cube([0.25,
            RodDiameter(SearRod()),
            TeeCenter(ReceiverTee())-ReceiverIR()+0.32]);
      
      translate([0,-RodRadius(SearRod()),ReceiverIR()])
      mirror([1,0,0])
      cube([RodRadius(SearRod())+(ReceiverIR()*.9),
            RodDiameter(SearRod()),
            RodDiameter(StrikerRod())]);
    }
    
    translate([0,0,-RodRadius(StrikerRod())-ManifoldGap()])
    Rod(rod=SearRod(),
  clearance=RodClearanceLoose(),
     length=TeeCenter(ReceiverTee())+RodRadius(StrikerRod()));
    
    translate([-RodRadius(SearRod()),0,TeeCenter(ReceiverTee()) +0.15])
    rotate([90,0,0])
    Rod(PivotRod(), center=true);
    
  }
}

module Sear(clearance=undef) {
  // Sear Rod
  translate([0,0,-RodDiameter(StrikerRod())*Animate(ANIMATION_STEP_TRIGGER)])
  mirror([0,0,1])
  color("Orange")
  translate([RodRadius(SearRod()),0,-RodRadius(StrikerRod())])
  Rod(rod=SearRod(),
   length=TeeCenter(ReceiverTee())+RodRadius(StrikerRod()));
  
  SearArm();
}

module SearGuide() {
  
  color("LightSeaGreen", 0.5)
  render(convexity=4)
  translate([0,0,-TeeCenter(ReceiverTee())])
  difference() {
    ReceiverInsert();
    
    // Sear hole
    translate([RodRadius(SearRod()),0,-ManifoldGap()])
    cylinder(r=RodRadius(SearRod(), RodClearanceLoose()),
        length=TeeWidth(ReceiverTee()),
           $fn=RodFn(SearRod()));
    
    // Sear hole slot
    translate([RodRadius(SearRod()),-0.15, -ManifoldGap()])
    mirror([1,0,0])
    cube([0.27, 0.30, TeeCenter(ReceiverTee())]);
    
    translate([RodRadius(SearRod()),-0.15, TeeCenter(ReceiverTee())-ReceiverIR()-(RodDiameter(StrikerRod())*2)])
    mirror([1,0,0])
    cube([ReceiverID(), 0.30, TeeCenter(ReceiverTee())]);
    
    translate([-RodRadius(PivotRod()),0,TeeCenter(ReceiverTee())-ReceiverIR()-RodRadius(PivotRod())])
    rotate([90,0,0])
    Rod(PivotRod(), center=true);
  }
}



module Trigger(pin=Spec_RodOneEighthInch(), height=0.24) {
  safetyAngle = 70;

  //color("Gold")
  //render(convexity=6)
  translate([TriggerPinX(), 0, TriggerPinZ()])
  rotate([-90,(TriggerAngle()*Animate(ANIMATION_STEP_TRIGGER))])
  linear_extrude(center=true, height=height)
  difference() {
    union() {

      // Spindle Body
      circle(r=TriggerMinorRadius(), $fn=20);

      // Finger Body
      rotate(120)
      semidonut(minor=0, major=2.6, angle=114, $fn=Resolution(20,60));

      // Reset Spring-engagement surface
      rotate(122)
      square([1.6,TriggerMinorRadius()]);
    }

    // Spindle Hole
    Rod2d(rod=PivotRod(), clearance=RodClearanceLoose());

    // Trigger Front Curve
    rotate(90)
    rotate(-70)
    translate([1.0,-0.5])
    translate([TeeRimWidth(ReceiverTee()),0])
    circle(r=1.4,$fn=Resolution(20,60));

    // Safety cutout
    rotate(-8-SafetyAngle())
    translate([SafetyPinX(), SafetyPinZ()])
    rotate(SafetyBarAngle()+1.8)
    semicircle(od=SafetyInterfaceOD()+0.02, angle=30, $fn=Resolution(20, 60));

    // Test Rope Hole
    rotate(90)
    rotate(-18)
    translate([0.8,0])
    translate([TeeRimWidth(ReceiverTee()),0])
    circle(r=0.1, $fn=8);
  }
}

module Safety(width=0.24) {
  springAngle = 20;

  color("Lime")
  render(convexity=3)
  translate([SafetyPinX(), 0, SafetyPinZ()])
  rotate([90,-(SafetyAngle()*Animate(ANIMATION_STEP_SAFETY)),0])
  difference() {
    linear_extrude(height=width, center=true)
    union() {

      // Body
      circle(r=SafetyMinorRadius(), $fn=Resolution(12, 30));

      // Trigger-engagement surface
      rotate(134)
      mirror()
      semicircle(od=SafetyInterfaceOD()-0.08, angle=10, $fn=Resolution(30, 100));

      // Trigger Trap Top
      rotate(142)
      mirror()
      semicircle(od=SafetyInterfaceOD(), angle=SafetyBarAngle()-10, $fn=Resolution(30, 100));

      // Trigger Trap Bottom
      rotate(135-SafetyBackAngle())
      mirror()
      semicircle(od=SafetyInterfaceOD(), angle=SafetyBackAngle(), $fn=Resolution(30, 100));

      // Bottom Infill
      rotate(162)
      translate([SafetyMinorRadius()*sqrt(2)/2,0])
      mirror()
      square([(SafetyInterfaceOD()*0.35)+SafetyMinorRadius()*sqrt(2)/2,SafetyMinorRadius()]);

      // Hand Tab
      rotate(90+30+SafetyAngle()) {

        difference() {

          // Hand-web tab
          square([SafetyMinorRadius(), SafetyMajorOD()/2]);

          // Cut off sharp back tip
          translate([SafetyMinorRadius()*0.3, SafetyMajorOD()/2])
          rotate(45)
          translate([0.15,-0.75])
          square([1,1]);
        }

        // Travel stop
        rotate(-90)
        mirror()
        semidonut(major=SafetyMajorOD(), minor=0, angle=SafetyAngle()/2);
      }

    }

    // Spindle hole
    Spindle(center=true, cutter=true, height=1);
  }
}




module SafetyPin(clearance=RodClearanceSnug()) {
  translate([SafetyPinX(),0,SafetyPinZ()])
  rotate([90,0,0])
  Rod(rod=SafetyRod(), clearance=clearance,
      length=0.5,
      center=true);
}

module ResetPin(clearance=RodClearanceSnug()) {
  translate([ResetPinX(),0,ResetPinZ()])
  rotate([90,0,0])
  Rod(rod=ResetRod(), clearance=clearance,
      length=0.5,
      center=true);
}


module FireControlPins(clearance=RodClearanceSnug()) {

    // Trigger Pin
    translate([TriggerPinX(),0,TriggerPinZ()])
    rotate([90,0,0])
    Rod(rod=TriggerRod(), clearance=clearance,
        length=TeeRimDiameter(ReceiverTee()),
        center=true);
}

//$t=0.0;

module TriggerGroup(debug=true) {

    *Trigger();
  
    Striker(debug=debug);

    //DebugHalf(4)
    Charger();
  
    Sear();
    //!scale(25.4)
    //DebugHalf(3)
    SearGuide(debug=debug);
  
    //!scale(25.4) rotate([90,0,0])
    SearArm();
  
    //color("lightgreen")
    //render() 
    //!scale(25.4) rotate([0,90,180])
    //DebugHalf(2)
    FiringPinInsert(debug=true);

    *ResetSpring();

    *Safety();
  
    echo("Striker Travel: ", StrikerTravel());
}

//scale([25.4, 25.4, 25.4])
{

  TriggerGroup();
  *Reference();
}

module trigger_plater($t=0) {
  scale([25.4, 25.4, 25.4]) {
    for (i=[[0, SafetyRod()], [1, ResetRod()]])
    translate([i[0],-1/4,0])
    Spindle(pin=i[1], height=0.28, center=false);

    translate([1/8,1/2,1/8])
    rotate([90,0,0])
    Trigger();

    translate([1/8,-1/8,1/8])
    rotate([90,0,0])
    Sear();

    translate([0,0,1/8])
    rotate([90,0,0])
    Safety();

    translate([3,-5,1/8])
    rotate([90,0,0])
    ResetSpring(left=false, right=true);

    translate([0,-SafetyPinZ(),1/8])
    rotate([-90,0,0])
    ResetSpring(left=true, right=false);
  }
}

*!trigger_plater();
