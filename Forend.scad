use <Debug.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Frame.scad>;
use <Reference.scad>;
use <Reference Build Area.scad>;
use <Ammo/Shell Slug.scad>;

function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function LugRadius() = TeeRimRadius(ReceiverTee())+(WallFrameRod()*0.6);
function LugAngle() = 45;
function ForendOffset() = 2.5;
function ForendTravel() = 3;
function BarrelLugLength() = 1;

module BarrelLug(length=BarrelLugLength(), wide=false, cutter=false) {
  barrelLugDistance = LugRadius() - PipeOuterRadius(BarrelPipe());
  minorOR = PipeOuterRadius(BarrelPipe(), clearance=PipeClearanceSnug())
              +WallBarrelLug();

  echo("Barrel Lug Distance ", barrelLugDistance);

  rotate([0,90,0])
  render()
  difference() {
    linear_extrude(height=length)
    union() {
      circle(r=minorOR +(cutter?0.02:0),
           $fn=Resolution(PipeFn(BarrelPipe()), PipeFn(BarrelPipe())*2));

      for (angle = ForendRodAngles())
      rotate(wide?LugAngle():0)
      rotate(-LugAngle()*.7)
      rotate(angle)
      hull() {
        semicircle(od=(LugRadius()*2)+(cutter?0.03:0),
                   angle=(wide?LugAngle()*2:LugAngle()) +(cutter?2:0),
                   $fn=Resolution(PipeFn(BarrelPipe()), PipeFn(BarrelPipe())*2));

        rotate(LugAngle()/4)
        semicircle(od=(minorOR*2),
                   angle=(wide?LugAngle()*2:LugAngle()) +(cutter?2:0) +(LugAngle()/2),
                   $fn=Resolution(PipeFn(BarrelPipe()), PipeFn(BarrelPipe())*2));
      }
    }

    if (cutter==false)
    Pipe(pipe=BarrelPipe(), clearance=PipeClearanceSnug(),
         length=(ForendOffset())*4, center=true);
  }
}

module ForendSegment(wall=3/16, length=1, $fn=50, track=false, wide=false, open=false) {
  render(convexity=4)
  difference() {
    rotate([0,-90,180])
    linear_extrude(height=length)
    hull() {
      ForendRail(ReceiverTee(), BarrelPipe(), FrameRod(), wall);

      // Add some more material to the center for ergo and strength
      circle(r=TeeRimRadius(ReceiverTee())+0.25,
             $fn=PipeFn(BarrelPipe()));
    }

    // Lug track
    if (track)
    //rotate([-LugAngle(),0,0])
    translate([-0.1,0,0])
    BarrelLug(length=length+0.2, wide=wide, cutter=true);

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

module ForendRear() {
  render()
  difference() {
    ForendSegment(length=ForendRearLength());

    // Tapered insertion hole
    translate([ForendRearLength()-0.19,0,0])
    rotate([0,-90,0])
    cylinder(r1=PipeOuterRadius(BarrelPipe()),
             r2=TeeRimRadius(ReceiverTee()) +(WallFrameRod()/2),
              h=ForendRearLength(),
            $fn=PipeFn(BarrelPipe()));

    // Side cutouts
    difference() {
      for (i= [1,-1])
      rotate([(FrameRodAngles()[1]+165)*i,0,0])
      translate([-0.3,-2,0])
      cube([ForendRearLength(), 4, 2]);

      // Taper the spacers
      for (angle = FrameRodAngles())
      rotate([angle,0,0])
      translate([ForendRearLength()+0.001,0,FrameRodOffset()])
      rotate([0,-90,0])
      cylinder(r1=RodDiameter(FrameRod()) + (WallFrameRod()*2),
               r2=RodRadius(FrameRod()) + WallFrameRod(),
              h=ForendRearLength()+0.002,
              $fn=RodFn(FrameRod())*2);
    }
  }
}

module Forend() {

  // Rear Faceplace
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset(),0,0])
  render(convexity=4)
  ForendRear();

  // Lock Segment
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength()
             +0.01,0,0])
  render(convexity=4)
  ForendSegment(length=BarrelLugLength()+0.01, track=true, wide=true);

  // Track Segment
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength()
             +BarrelLugLength()
             +0.03,0,0])
  render(convexity=4)
  ForendSegment(length=ForendTravel(), track=true);

  // Front Faceplace
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength()
             +ForendTravel()
             +BarrelLugLength()
             +0.04,0,0])
  render(convexity=4)
  ForendSegment(length=ForendFrontLength());

  echo("Forend OAL: ", ForendRearLength()
             +ForendTravel()
             +BarrelLugLength()
             +ForendFrontLength());
  echo("Forend Travel: ", ForendTravel());
}

module BarrelLugs() {

  render()
  rotate([LugAngle()-($t*LugAngle()),0,0])
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset()
             +ForendRearLength(),0,0])
  render(convexity=4)
  translate([0.01,0,0])
  BarrelLug(length=BarrelLugLength());
}


// Plate
scale([25.4, 25.4, 25.4]) {
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
    ForendSegment(length=0.6);

    for (angle = ForendRodAngles())
    rotate([180+angle,0,0])
    translate([0.34, 0,ForendRailOffset()])
    rotate([0,90,0])
    cylinder(r=0.59/2, h=0.28, $fn=6);
  }

  rotate([0,-90,0])
  BarrelLug();
}


*!render()
//DebugHalf()
{
  color("Orange")
  BarrelLugs();

  color("Green", 0.5)
  render()
  Forend();

  Frame();
  Reference();
}
