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

module ForendSegment(wall=3/16, length=1, $fn=50, cylinderSpindle=false, track=false, wide=false, open=false) {
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
       
      // Revolver Spindle
      if (cylinderSpindle)
      translate([CylinderChamberOffset(),0])
      circle(r=RodRadius(CylinderRod())+WallFrameRod(),
               $fn=Resolution(10,30));
      
      children();
    }
        
    // Revolver Spindle
    if (cylinderSpindle)
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


module ForendSlotted(length=1, shaftCollar=false) {
  shaftCollarDiameter=1.875+0.02;
  shaftCollarRadius = shaftCollarDiameter/2;
  
  translate([BreechFrontX()+4,0,0])
  render()
  union() {
    difference() {
      ForendSegment(wall=0.375, length=length,open=true);
        
      if (shaftCollar) {
        // Barrel Shaft Collar
        translate([ForendRearLength()+0.001,0,0])
        rotate([0,-90,0])
        cylinder(r=shaftCollarRadius, h=0.55, $fn=Resolution(12,40));
        
        // Side cutout
        rotate([-11,0,0])
        translate([0.45,0,-shaftCollarRadius])
        cube([0.9,2,shaftCollarDiameter]);
      }
    }
  }
}

module Forend() {
  ForendSlotted(shaftCollar=true);
}




ForendSlotted(shaftCollar=true);
Reference();


*!scale(25.4) {
  ReferenceBuildArea();
  
  translate([1.5,1.5,0])
  rotate([0,-90,0])
  Forend();
}
