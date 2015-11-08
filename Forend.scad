use <Debug.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Frame.scad>;
use <Reference.scad>;

function BarrelLugLength() = 0.5;
function ForendOffset() = 1;
function ForendLugCount() = 3;
function ForendLugLength() = 0.25;



module BarrelLug(wall=2/16, tabLength=0.12, length=BarrelLugLength(), hollow=true) {
  tabRadius = PipeOuterRadius(BarrelPipe()) +wall+tabLength;
  rotate([0,90,0])
  difference() {
    union() {
      cylinder(r=PipeOuterRadius(BarrelPipe()) + wall,
               h=length+ForendLugLength(), $fn=PipeFn(BarrelPipe()));


      for (angle = ForendRodAngles())
      rotate([0,0,90+angle+180-15])
      intersection() {
        cylinder(r=tabRadius, h=length, $fn=PipeFn(BarrelPipe()));

        translate([-tabRadius/4,0, -0.1])
        cube([tabRadius/2, tabRadius, length+0.2]);
      }
    }

    if (hollow)
    Pipe(pipe=BarrelPipe(), length=(length+ForendLugLength())*4, center=true);
  }
}

module ForendSegment(wall=3/16, length=1, $fn=50, deepLug=false, shallowLug=false, lugAngle=15) {
  scaleFactor = 1.02;
  
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
    rotate([lugAngle-0.5,0,0])
    translate([-0.01,0,0])
    scale([scaleFactor,scaleFactor,scaleFactor])
    BarrelLug(hollow=false);

    // Deep Cut
    if (deepLug)
    rotate([-lugAngle+0.5,0,0])
    translate([-0.1,0,0])
    scale([scaleFactor,scaleFactor,scaleFactor])
    BarrelLug(length=length+0.2, hollow=false);

    // Barrel Hole
    Barrel();

    // Forend Rod Holes
    Frame();
  }
}

module Forend() {
  lugLength = ForendLugLength()+BarrelLugLength();
  
  // Forend Segments
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset(),0,0])
  render(convexity=4)
  for (i = [0:ForendLugCount()-1])
  translate([(i*lugLength)+0.01,0,0])
  ForendSegment(length=lugLength, deepLug=true, shallowLug=true);
}

module BarrelLugs() {
  lugLength = ForendLugLength()+BarrelLugLength();
  
  render()
  rotate([-14.5,0,0])
  translate([(TeeWidth(ReceiverTee())/2)
             +BushingExtension(BreechBushing())
             +ForendOffset(),0,0])
  render(convexity=4)
  for (i = [0:ForendLugCount()-1])
  translate([(i*lugLength)+0.01,0,0])
  BarrelLug();
}

*!scale([25.4, 25.4, 25.4]) {
  ForendSegment(length=ForendLugLength()+BarrelLugLength(),
                deepLug=true, shallowLug=true);
  
  translate([ForendLugLength(),0,0])
  rotate([-14.5,0,0])
  BarrelLug();
}


// Scale up to metric for printing
{
  BarrelLugs();
  
  Forend();

  Reference();
}
