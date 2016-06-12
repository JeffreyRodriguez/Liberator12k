
include <Components/Animation.scad>;
use <Components/Receiver Insert.scad>;
use <Components/Semicircle.scad>;
use <Components/Manifold.scad>;
use <Debug.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Spring.scad>;
use <Striker.scad>;
use <Reset Spring.scad>;
use <Reference.scad>;
use <Charger.scad>;

//function TriggerSpring() = Spec_BicSoftFeelFinePenSpring();
function TriggerSpring() = Spec_BicLighterThumbSpring();


//function SearTowerHeight() = TeeCenter(ReceiverTee()) - 0.35;

function FiringPinProtrusion() = 3/32;
function FiringPinLength() = BushingHeight(BreechBushing())
                           + FiringPinProtrusion()
                           + 0.4;

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


module Sear() {
  color("Red")
  translate([0,0,-RodDiameter(StrikerRod(), RodClearanceLoose())*Animate(ANIMATION_STEP_TRIGGER)])
  translate([0,0,RodRadius(StrikerRod())])
  mirror([0,0,1])
  //translate([0,0,-TeeCenter(ReceiverTee())-0.4-0.25-0.35])
  Rod(rod=SearRod(), clearance=RodClearanceLoose(), length=3);
}

module SearGuide(debug=false) {
  
  if (debug)
  color("LightSlateGray")
  %Sear();
  
  color("White")
  render(convexity=4)
  translate([0,0,-TeeCenter(ReceiverTee())])
  difference() {
    ReceiverInsert();
    
    // Sear hole
    translate([0,0,-ManifoldGap()])
    cylinder(r=RodRadius(SearRod(), RodClearanceSnug()),
        length=TeeWidth(ReceiverTee()),
           $fn=RodFn(SearRod()));
  }
}


module FiringPin() {
  color("Red")
  render(convexity=4)
  translate([BreechFrontX() - FiringPinLength()+FiringPinProtrusion(),0,0])
  rotate([0,90,0])
  union() {
    
    // Nail Body
    Rod(rod=FiringPinRod(), clearance=RodClearanceLoose(), length=FiringPinLength());
    
    // Nail Double-Head
    for (i = [0,0.31])
    translate([0,0,i])
    cylinder(r=0.15, h=0.08, $fn=RodFn(FiringPinRod()));
  }
}

module FiringPinGuide(od=TeeInnerDiameter(ReceiverTee()),
                   debug=true) {
  height = TeeWidth(ReceiverTee())
         - PipeThreadDepth(StockPipe())
         - BushingDepth(BreechBushing());
  
  if (debug==true)
  color("Red")
  %FiringPin();

  color("Lime",0.25)
  render(convexity=4)
  difference() {
    
    // Body
    translate([BreechRearX(),0,0])
    rotate([0,-90,0])
    linear_extrude(height=height)
    difference() {
      circle(r=od/2,
           $fn=Resolution(20,30));

      // Striker Hole
      Rod2d(rod=StrikerRod(), clearance=RodClearanceLoose());
    }

    // Tapered Striker Entrance
    translate([-height+BreechRearX()+RodDiameter(StrikerRod()),0,0])
    rotate([0,-90,0])
    cylinder(r1=RodRadius(StrikerRod()),
             r2=RodRadius(StrikerRod(),RodClearanceLoose())*1.25,
              h=RodDiameter(StrikerRod()),
            $fn=RodFn(StrikerRod()));

    // Scoop out a path for the charging wheel
    translate([ReceiverIR()+0.06,
               -RodRadius(StrikerRod(), RodClearanceLoose()),
               0])
    mirror([1,0,0])
    cube([TeeWidth(ReceiverTee())+RodDiameter(StrikerRod(), RodClearanceLoose()),
          RodDiameter(StrikerRod(), RodClearanceLoose()),
          ReceiverIR()+ManifoldGap()]);

    // Sear Hole
    mirror([0,0,1])
    translate([0,0,-RodRadius(StrikerRod())*0.9])
    Rod(rod=SearRod(), clearance=RodClearanceLoose(), length=(od/2)+(RodRadius(StrikerRod())*0.9));
    
    // Firing Pin Retaining Pin Holes
    for (i=[1,-1])
    translate([BreechRearX()-0.28,0,
               RodDiameter(FiringPinRod(),RodClearanceLoose())*i*1.23])
    rotate([90,0,0])
    Rod(FiringPinRod(), RodClearanceLoose(), length=1, center=true);
  }
}

module Trigger(pin=Spec_RodOneEighthInch(), height=0.24) {
  safetyAngle = 70;

  color("Gold")
  render(convexity=2)
  linear_extrude(center=true, height=height)
  difference() {
    translate([TriggerPinX(), 0, TriggerPinZ()])
    rotate([-90,(TriggerAngle()*Animate(ANIMATION_STEP_TRIGGER)),0])
    union() {

      // Spindle Body
      circle(r=TriggerMinorRadius(), $fn=20);

      // Finger Body
      rotate(115)
      semidonut(minor=0, major=2.6, angle=114, $fn=Resolution(20,60));

      // Reset Spring-engagement surface
      rotate(122)
      square([1.6,TriggerMinorRadius()]);
    }

    translate([TriggerPinX(), 0, TriggerPinZ()])
    rotate([-90,(TriggerAngle()*Animate(ANIMATION_STEP_TRIGGER)),0]) {

      // Spindle Hole
      Rod2d(rod=SearRod(), clearance=RodClearanceLoose());

      // Trigger Front Curve
      rotate(90)
      rotate(-70)
      translate([1.7,0])
      translate([TeeRimWidth(ReceiverTee()),0])
      circle(r=1.4,$fn=Resolution(20,60));

      // Safety cutout
      rotate(-8-SafetyAngle())
      translate([SafetyPinX(), SafetyPinZ()])
      translate([-TriggerPinX(), -TriggerPinZ()])
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

    
    Striker(debug=debug);

    //DebugHalf(4)
    Charger();
    //!scale(25.4) 
    SearGuide(debug=debug);
  
    //color("lightgreen")
    //render() 
    //!scale(25.4) rotate([0,90,180])
    //DebugHalf(2)
    FiringPinGuide(debug=true);

    Trigger();

    ResetSpring();

    Safety();
  
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
