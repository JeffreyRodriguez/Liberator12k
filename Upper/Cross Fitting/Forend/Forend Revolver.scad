
                   
use <Meta/Debug.scad>;
use <Components/Semicircle.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Frame.scad>;
use <Reference.scad>;
use <Reference Build Area.scad>;
use <Ammo/Shell Slug.scad>;

use <Cylinder.scad>;

function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function LugRadius() = TeeRimRadius(ReceiverTee())+(WallFrameRod()*0.6);
function LugAngle() = 45;
function ForendOffset() = 4;
function ForendTravel() = 2;
function BarrelLugLength() = 1;

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
        
    // Revolver Spindle
    translate([-ForendRearLength(),0,-CylinderChamberOffset()])
    rotate([0,90,0])
    linear_extrude(height=ForendRearLength()*3)
    Rod2d(CylinderRod(), clearance=RodClearanceLoose());

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
    rotate([90-11,0,0])
    translate([-0.1,-PipeOuterRadius(BarrelPipe(), PipeClearanceLoose()),-TeeCenter(ReceiverTee())])
    cube([length+0.2, PipeOuterDiameter(BarrelPipe(), PipeClearanceLoose()), TeeCenter(ReceiverTee())]);
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
  }
}

module ForendRevolverSegment(shaftCollar=true) {
  render()
  union() {
    difference() {
      ForendSegment(length=ForendRearLength()) {
        
          // Revolver Spindle
          translate([CylinderChamberOffset(),0])
          circle(r=RodRadius(CylinderRod())+WallFrameRod(),
                   $fn=Resolution(10,30));
        };
    
    
      // Revolver Spindle
      translate([-ForendRearLength(),0,-CylinderChamberOffset()])
      rotate([0,90,0])
      linear_extrude(height=ForendRearLength()*3)
      Rod2d(CylinderRod(), clearance=RodClearanceLoose());
        
      if (shaftCollar) {
        // Barrel Shaft Collar
        translate([ForendRearLength()+0.001,0,0])
        rotate([0,-90,0])
        cylinder(r=0.9375, h=0.5, $fn=Resolution(12,40));
        
        // Barrel Shaft Collar Screw Holes (single and double)
        for (y = [-0.9375-0.6,0.9375-0.4])
        translate([ForendRearLength() - 0.5,y,-3])
        cube([0.5, 1, 3]);
      }
    }
  }
}


module Forend(frontLength=1) {
  
  color("Tomato") {

    // Rear Faceplace
    translate([(TeeWidth(ReceiverTee())/2)
               +BushingExtension(BreechBushing())
               +ForendOffset(),0,0])
    render(convexity=4)
    ForendRevolverSegment();

    // Front Faceplace
    translate([(TeeWidth(ReceiverTee())/2)
               +BushingExtension(BreechBushing())
               +ForendOffset()
               +ForendRearLength()
               +0.03,0,0])
    render(convexity=4)
    ForendRevolverSegment(shaftCollar=false);
  }
  
  translate([BushingExtension(BreechBushing())+(TeeWidth(ReceiverTee())/2)+WallFrameFront(),0,-CylinderChamberOffset()])
  rotate([0,90,0])
  RevolverCylinder(debug=true);
}

Forend();
Reference();

// Plate
*!scale(25.4) {
  ReferenceBuildArea();

  // Rear (user-end) Segment
  translate([-2,-2,0])
  rotate([0,-90,180])
  ForendRevolverSegment();
}
