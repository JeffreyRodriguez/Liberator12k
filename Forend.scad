use <Debug.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Frame.scad>;
use <Reference.scad>;

function ForendRearLength() = 0.25;
function ForendFrontLength() = 0.25;
function LugRadius() = TeeRimRadius(ReceiverTee());
function LugAngle() = 45;
function ForendOffset() = 2.8;
function ForendLugLength() = 0.25;
function BarrelLugLength() = 0.5;
function LugSegmentLength() = ForendLugLength() + BarrelLugLength();
function ForendLugCount() = ceil(ForendOffset()/LugSegmentLength());

module BarrelLug(length=BarrelLugLength(), cutter=false) {
  barrelLugDistance = LugRadius() - PipeOuterRadius(BarrelPipe());
  
  echo("Barrel Lug Distance ", barrelLugDistance);
  
  rotate([0,90,0])
  difference() {
    union() {
      cylinder(r=PipeOuterRadius(BarrelPipe()) + (barrelLugDistance/2),
               h=length+ForendLugLength(), $fn=PipeFn(BarrelPipe()));


      for (angle = ForendRodAngles())
      rotate([0,0,angle+(LugAngle()/2)])
      linear_extrude(height=length)
      semicircle(od=LugRadius()*2, angle=LugAngle() +(cutter?2:0), $fn=PipeFn(BarrelPipe()));
    }

    if (cutter==false)
    Pipe(pipe=BarrelPipe(), length=(length+ForendLugLength())*4, center=true);
  }
}

module ForendSegment(wall=3/16, length=1, $fn=50,
                     deepLug=false, shallowLug=false, open=false) {
  scaleFactor = 1.05;

  render(convexity=4)
  difference() {
    rotate([0,-90,180])
    linear_extrude(height=length)
    hull() {
      ForendRail(ReceiverTee(), BarrelPipe(), FrameRod(), wall);

      // Add some more material to the center for ergo and strength
      circle(r=TeeRimRadius(ReceiverTee())+WallFrameRod(),
             $fn=PipeFn(BarrelPipe()));

    }

    // Shallow cut
    if (shallowLug)
    rotate([-1,0,0])
    translate([-0.01,0,0])
    scale([scaleFactor,scaleFactor,scaleFactor])
    BarrelLug(cutter=true);

    // Deep Cut
    if (deepLug)
    rotate([-LugAngle(),0,0])
    translate([-0.1,0,0])
    scale([scaleFactor,scaleFactor,scaleFactor])
    BarrelLug(length=length+0.2, cutter=true);

    // Barrel Hole
    translate([-ForendOffset(),0,0])
    Barrel();

    // Forend Rod Holes
    Frame();

    // Open bottom
    if(open==true)
    translate([-0.1,-0.5,-TeeCenter(ReceiverTee())*1.1])
    cube([length+0.2, 1, TeeCenter(ReceiverTee())]);
  }
}

module Forend() {
  
  // Rear Segment
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset(),0,0])
  render(convexity=4)
  translate([0,0,0])
  ForendSegment(length=ForendRearLength());

  // Locking Segments
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength(),0,0])
  render(convexity=4)
  for (i = [0:ForendLugCount()-1])
  translate([(i*LugSegmentLength())+0.01,0,0])
  ForendSegment(length=LugSegmentLength(), deepLug=true, shallowLug=true);

  // Open Segments
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength()
             +(LugSegmentLength()*ForendLugCount()),0,0])
  render(convexity=4)
  for (i = [0:ForendLugCount()-1])
  translate([(i*LugSegmentLength())+0.01,0,0])
  ForendSegment(length=LugSegmentLength(), deepLug=true, open=true);

  // Front Segment
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength()
             +(LugSegmentLength()*ForendLugCount()),0,0])
  render(convexity=4)
  translate([0.01,0,0])
  ForendSegment(length=ForendFrontLength(), open=false);
  
  echo("Forend OAL: ", ForendRearLength()
             +(LugSegmentLength()*ForendLugCount()*2)
             +ForendFrontLength());
  echo("Forend Travel: ", (LugSegmentLength()*ForendLugCount()));
}

module BarrelLugs() {

  render()
  rotate([-LugAngle()+($t*LugAngle()),0,0])
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength(),0,0])
  render(convexity=4)
  for (i = [0:ForendLugCount()-1])
  translate([(i*LugSegmentLength())+0.01,0,0])
  BarrelLug();
}

*!scale([25.4, 25.4, 25.4]) {

  // Rear Segment
  translate([-TeeRimDiameter(ReceiverTee())*2,-3,0])
  rotate([0,-90,0])
  ForendSegment(length=ForendRearLength());

  // Locking segment
  translate([TeeRimDiameter(ReceiverTee())*2,-3,ForendLugLength()+BarrelLugLength()])
  rotate([0,90,0])
  ForendSegment(length=ForendLugLength()+BarrelLugLength(),
                deepLug=true, shallowLug=true);


  // Open Segments
  translate([TeeRimDiameter(ReceiverTee())*2,3,ForendLugLength()+BarrelLugLength()])
  rotate([0,90,0])
  ForendSegment(length=ForendLugLength()+BarrelLugLength(),
                deepLug=true, open=true);

  // Front Segment
  translate([-TeeRimDiameter(ReceiverTee())*2,3,0])
  rotate([0,-90,0])
  ForendSegment(length=1);

  rotate([0,-90,0])
  BarrelLug();
}


// Scale up to metric for printing
{
  color("Orange")
  BarrelLugs();

  color("Green", 0.5)
  render()
  Forend();

  Reference();
}
