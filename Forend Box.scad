use <Components/Debug.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Reference.scad>;
use <Reference Build Area.scad>;
use <Ammo/Magazines/Box Magazine.scad>;
use <Ammo/Cartridges/Cartridge_12GA.scad>;

function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function ForendOffset() = 4;
function ForendTravel() = 2;

module ForendSegment(wall=3/16, length=1, $fn=50, track=false, wide=false, open=false) {
  render(convexity=4)
  difference() {
    rotate([0,90,0])
    linear_extrude(height=length)
    hull() {
      FrameRodSleeves();
      //ForendRail(ReceiverTee(), BarrelPipe(), FrameRod(), wall);

      // Add some more material to the center for ergo and strength
      circle(r=TeeRimRadius(ReceiverTee())+wall,
             $fn=PipeFn(BarrelPipe()));
      
      children();
    }

    // Barrel Hole
    translate([-ForendOffset(),0,0])
    Barrel();

    // Forend Rod Holes
    Frame();

    // Open bottom
    if(open==true)
    translate([-0.1,-0.625,-TeeCenter(ReceiverTee())])
    cube([length+0.2, 1.25, TeeCenter(ReceiverTee())]);
  }
}

module Forend(debug=false) {

  // Rear Faceplace
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing()),0,0])
  render(convexity=4)
  ForendSegment(length=3, open=true);
  
  // 12ga
  color("Gold")
  translate([BreechFrontX(),0,-0.89*6])
  rotate([0,0,-90])
  render()
  BoxMagazine(cartridge=Spec_Cartridge_12GAx3(), capacity=5, angle=0,
                   wallSide=1/8, wallFront=1/8, wallBack=1/8,
                   floorHeight=1/8);
}

Forend(debug=true);
Reference();


// Plate
*!scale(25.4) {
  ReferenceBuildArea();

  // Rear (user-end) Segment
  translate([-2,-2,ForendRearLength()])
  rotate([0,90,180])
  ForendRear();

  // Lock Segment
  translate([2,-2,BarrelLugLength()+0.01])
  rotate([0,90,0])
  ForendSegment(length=BarrelLugLength()+0.01,
                track=true, wide=true);

  // Track Segment
  translate([2,2,ForendOffset()])
  rotate([0,90,0])
  ForendSegment(length=ForendOffset(),
                track=true);

  // Front (business-end) Segment
  translate([-2,2,0])
  rotate([0,-90,0])
  difference() {
    ForendSegment(length=0.8);

    for (angle = FrameRodAngles())
    rotate([180+angle,0,0])
    translate([0.54, 0,FrameRodOffset()])
    rotate([0,90,0])
    cylinder(r=0.59/2, h=0.28, $fn=6);
  }
}