//$t=0;
//$t=0;
include <Components.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Rod.scad>;
use <Vitamins/Pipe.scad>;
use <Striker.scad>;
use <Reference.scad>;

$fn=50;

function sear_height() = 1/4;

slot_width = 0.27;

searPin = RodOneEighthInch;
sear_arc_angle = 40;
sear_height = sear_height();
sear_major_od = 53/64;
sear_minor_od = 0.52; //0.372;
sear_interface_extension = 0.414;


triggerPin = RodOneEighthInch;
trigger_offset = 18/32; // 19/32; // Offset from center_z
trigger_backset = TeeInnerDiameter(receiverTee)/2  -3/16;
trigger_height = 1/4;
trigger_body_od = 1.17;
trigger_major_od = .88;
trigger_arc_angle = 24.5;

function TriggerWidth() = 0.25;
function SearPinX() = 0;
function SearRadius() = TeeInnerRadius(ReceiverTee());
function SearPinZ() = -TeeInnerRadius(ReceiverTee())
                      -SearRadius()/2;
function TriggerPinX() = -1/4;
function TriggerPinZ() = -TeeCenter(ReceiverTee())-RodRadius(TriggerRod());
function TriggerHyp() = sqrt(pow(abs(TriggerPinX()), 2) + pow(abs(TriggerPinZ())-abs(SearPinZ()), 2));
function TriggerRadius() = (TriggerHyp()-SearRadius());

echo("Trigger hyp: ", TriggerHyp());

function SearArc() = 25;

module SearPin() {
    translate([0,0,SearPinZ()])
    rotate([90,0,0])
    Rod(rod=SearRod(), length=TeeInnerDiameter(ReceiverTee()) + 0.2, center=true);
}

module TriggerPin() {
    translate([TriggerPinX(),0,TriggerPinZ()])
    rotate([90,0,0])
    Rod(rod=SearRod(), length=TeeInnerDiameter(ReceiverTee()) + 0.2, center=true);
}

module SearSpindle(clearance=0) {
  rotate([90,0,0])
  cylinder(r=SearRadius()+clearance, h=TriggerWidth(), center=true);
}

module TriggerSpindle(clearance=0) {
  rotate([90,0,0])
  cylinder(r=TriggerRadius()+clearance, h=TriggerWidth(), center=true);

  children();
}

module Sear() {
  triggerInterfaceOffset = 0.2;

  difference() {
      translate([0,0,SearPinZ()])
      rotate([0,(SearArc()*(1-$t)),0])
      difference() {
        union() {
          SearSpindle();

          // Striker Interface Wedge
          rotate([0,-90-SearArc(),0])
          translate([0,-0.125,0])
          cube([TeeInnerRadius(ReceiverTee()),0.25,TeeInnerRadius(ReceiverTee())*.9]);

          // Trigger Interface Bar Front
          mirror([1,0,0])
          translate([-TeeInnerRadius(ReceiverTee()),-0.125,-TeeCenter(ReceiverTee()) - SearPinZ()])
          cube([TeeInnerRadius(ReceiverTee()), 0.25, TeeCenter(ReceiverTee())+SearPinZ()]);

          // Trigger Interface Bar Rear
          *rotate([0,-SearArc(),0])
          mirror([1,0,0])
          translate([0,-0.125,-TeeCenter(ReceiverTee()) - SearPinZ()+triggerInterfaceOffset])
          cube([TeeInnerRadius(ReceiverTee()), 0.25, TeeCenter(ReceiverTee())+SearPinZ()-triggerInterfaceOffset]);
        }

        // Striker clearance
        translate([0,0,-SearPinZ()])
        rotate([0,-90,0])
        cylinder(r=StrikerRadius() + 0.02, h=TeeWidth(ReceiverTee()), center=true);
      }

    SearPin();

    // Trigger clearance
    translate([0,0,SearPinZ()])
    rotate([0,180+SearArc()-(SearArc()*$t),0])
    translate([-0.1,-(TriggerWidth()/2)-0.1,SearRadius()])
    *cube([TriggerRadius()+0.2, TriggerWidth()+0.2, SearRadius()]);
  }
}

module Trigger() {
  difference() {
    translate([TriggerPinX(),0,TriggerPinZ()])
    union() {
        // Spindle
        TriggerSpindle();

        rotate([0,(SearArc()*$t),0])
        translate([0,-TriggerWidth()/2,0])
        #cube([TriggerRadius(), TriggerWidth(), TriggerRadius()]);
    }

    TriggerPin();
  }
}




interface_clearance=0.005;

module sear(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, od=sear_major_od, height=sear_height, center=false, angle=230) {

  $fn=30;

  color("Red")
  translate([0,0,center ? -height/2 : 0])
  difference() {

    render(convexity=2)
    linear_extrude(height=height)
    difference() {
      union() {
        // Spindle
        circle(r=sear_minor_od/2);

        // Overtravel Stop
        rotate([0,0,30])
        mirror([0,1])
        square([.39,0.26]);

        // Reset Extension
        rotate(-15)
        translate([0,-0.05])
        mirror([1,0,0])
        square([0.49, 0.45]);
      }

      // Clear the striker when engaged
      translate([-trigger_offset +3/4/2,(sear_minor_od/2)*1.3,0])
      rotate([0,0,180])
      semicircle(od=1, angle=130);

      // Clear the striker when disengaged
      //-od-sear_minor_od/2
      translate([0,-sear_minor_od/2,0])
      rotate([0,0,180+sear_arc_angle])
      translate([0,-od,0])
      square([od, od*2]);

      // Overtravel Trigger Clearance
      translate([-trigger_offset + TeeCenter(receiverTee) + 1/16,trigger_backset])
      circle(r=trigger_major_od/2 + interface_clearance);

    }

    // Pin Hole
    translate([0,0,-0.1])
    Rod(rod=pin, clearance=pin_clearance, length=height + 0.2);
  }
}

module trigger(pin=RodOneEighthInch, pin_clearance=RodClearanceLoose, minor_od=.34, id=7/8, height=trigger_height, center=false, angle=196) {

  od=3/4;

  color("Gold")
  translate([0,0,center ? -height/2 : 0])
    render(convexity=2)
    linear_extrude(height=height)
  difference() {
    union() {

      // Sear Interface Bar
      translate([0.016,-0.05,0])
      mirror([1,0,0])
      square([trigger_body_od/2,minor_od/2 + 0.05]);

      // Reset Stop
      rotate(angle+25)
      square([trigger_body_od/2,0.25]);

      // Spindle Body
      circle(r=minor_od/2);

      // Trigger Bar Infill
      rotate([0,0,-45])
      semicircle(od=trigger_major_od, angle=135);

      // Trigger body
      rotate([0,0,-25])
      translate([-0.0625,0.5,0])
      mirror([0,1])
      square([1.34,0.8]);
    }

    // Spindle Hole
    Rod2d(rod=pin, clearance=pin_clearance, length=height + 0.2);

    // Trigger Front Curve
    rotate([0,0,-25])
    translate([.5,-0.3])
    translate([TeeRimWidth(receiverTee),0])
    circle(r=0.5);

    // Trigger Back Curve
    rotate([0,0,-25])
    translate([0.9,0.6])
    rotate([0,0,-45])
    square([1,1]);

  }
}

module FireControlPins(pin=RodOneEighthInch) {

    // Sear Pin
    translate([0,0,TeeCenter(receiverTee) - trigger_offset])
    rotate([90,0,0])
    Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);

    // Trigger Pin (offset)
    translate([trigger_backset,0,-RodRadius(pin)])
    rotate([90,0,0])
    Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);

    // Trigger Pin (Centered)
    translate([0,0,-RodRadius(pin)])
    rotate([90,0,0])
    Rod(rod=pin, clearance=RodClearanceSnug, length=TeeRimDiameter(receiverTee), center=true);

}

module trigger_insert(pin=RodOneEighthInch,
                      column_height=0.94) {

    // Striker
    translate([-(0.5*$t),0,0])
    color("Orange")
    translate([(sear_minor_od/2) * 1.75,0,TeeCenter(receiverTee)])
    rotate([0,90,0])
    striker();

    translate([0,0,TeeCenter(receiverTee)])
    translate([0,0,-trigger_offset])
    rotate([0,$t*sear_arc_angle,])
    rotate([90,90,0])
    sear(center=true);

    translate([trigger_backset,0, -1/16])
    rotate([90,90,0])
    rotate([0,0,trigger_arc_angle*$t])
    trigger(center=true);
}

scale([25.4, 25.4, 25.4]) {
  translate([0,0,-TeeCenter(ReceiverTee())])
  mirror([1,0,0])
  trigger_insert(debug=false);
  FiringPinGuide();
  Striker();
  *Sear();
  *Trigger();
  *Reference();
}

module trigger_plater() {
  scale([25.4, 25.4, 25.4]) {

    translate([1,-0.4,0])
    rotate([0,0,110])
    trigger();

    translate([-1,0,0])
    rotate([0,0,140])
    sear();
  }
}

*trigger_plater();
