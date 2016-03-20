use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;

function StrikerRadius() = 0.375;
function StrikerX() = -TeeInnerRadius(ReceiverTee());

function FiringPinGuideHeight() = 13/32;// (TeeWidth(ReceiverTee())/2)-BushingDepth(BreechBushing())

module FiringPin() {
    Rod(rod=FiringPinRod(), clearance=RodClearanceLoose, length=height+0.2);
}



module FiringPinGuide(height=FiringPinGuideHeight(), od=TeeInnerDiameter(ReceiverTee())) {
  offsetX = (TeeWidth(ReceiverTee())/2) -BushingDepth(BreechBushing());

  color("Orange")
  render()
  difference() {
    translate([offsetX,0,0])
    rotate([0,-90,0])
    cylinder(r=od/2, h=height, $fn=RodFn(FiringPinRod())*Resolution(2, 4));

    // Tapered Entrance
    translate([offsetX - (height/3*2),0,0])
    rotate([0,-90,0])
    cylinder(r1=RodRadius(FiringPinRod()), r2=1/4, h=height/3, $fn=RodFn(FiringPinRod())*Resolution(1, 2));

    // Firing Pin Hole
    translate([offsetX+0.1,0,0])
    rotate([0,-90,0])
    Rod(rod=FiringPinRod(), length=height+0.2, clearance=RodClearanceLoose());
  }
}

module Striker() {
  translate([((-StrikerX())+0.0)*$t,0,0])
  translate([StrikerX(),0,0])
  rotate([0,-90,0])
  striker();
}

module striker(length=4, od=StrikerRadius()*2, id=0.53,
               firingPin = Spec_RodOneEighthInch(),
               linePin = Spec_RodOneEighthInch(),
               depth=0.8,
               rope_width = 1/8, rope_depth=1/4,
               $fn=RodFn(FiringPinRod())*Resolution(2, 4)) {

  difference() {

    // Body
    color("Orange")
    cylinder(r=od/2, h=length);

    // Weight Hole
    translate([0,0,depth])
    cylinder(r=id/2, h=length);

    // Line Pin Hole
    translate([0,od/2 + 0.1,length - RodDiameter(firingPin)*2])
    rotate([90,0,0])
    Rod(rod=firingPin, length=od+0.2);

    // Firing Pin Hole
    translate([0,0,-0.1])
    Rod(rod=firingPin, length=length);

    // Firing Pin
    color("Silver")
    translate([0,0,-1])
    %Rod(rod=firingPin, length=1+depth);

    // Line Pin
    translate([0,od/2 + 0.025,length - RodDiameter(firingPin)*2])
    rotate([90,0,0])
    Rod(rod=firingPin, length=od + 0.05);

    // Line
    cylinder(r=rope_width/2, h=12);
  }
}

//translate([0,50,0])
scale([25.4, 25.4, 25.4]) {
  FiringPinGuide();
  Striker();
  
  color("Grey", 0.15)
  Reference();
}
