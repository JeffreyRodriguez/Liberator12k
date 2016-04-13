use <Debug.scad>;
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
function ForendOffset() = 3;
function ForendTravel() = 2;
function BarrelLugLength() = 1;


function ForendBreechLength() = 1;


function SingleBreechHandleLength() = 0.5;

module SingleBreech(wall=3/16, length=ForendBreechLength(), $fn=50, track=false, wide=false, open=false) {
  render(convexity=4)
  difference() {
    rotate([0,90,0])
    linear_extrude(height=length)
    hull() {
      FrameRodSleeves();
      //ForendRail(ReceiverTee(), BarrelPipe(), FrameRod(), wall);

      // Add some more material to the center for ergo and strength
      circle(r=TeeRimRadius(ReceiverTee())+0.25,
             $fn=PipeFn(BarrelPipe()));
      
      // Revolver Spindle
      translate([CylinderChamberOffset(),0])
      circle(r=RodRadius(CylinderRod())+WallFrameRod(),
               $fn=Resolution(10,30));
    }
    
    // Revolver Spindle
    translate([-ManifoldGap(),0,-CylinderChamberOffset()])
    rotate([0,90,0])
    linear_extrude(height=length+ManifoldGap(2))
    Rod2d(CylinderRod(), clearance=RodClearanceLoose());

    // Barrel Hole
    translate([-ForendOffset(),0,0])
    Barrel();

    // Forend Rod Holes
    Frame();

    // Open Top
    translate([-ManifoldGap(),-PipeOuterRadius(BarrelPipe(), PipeClearanceSnug()),0])
    cube([length+ManifoldGap(2), PipeOuterDiameter(BarrelPipe(), PipeClearanceSnug()), TeeCenter(ReceiverTee())]);
    
    union() {
      // Open Top for handle
      translate([-ManifoldGap(),-PipeOuterRadius(BarrelPipe())-0.2,0])
      cube([SingleBreechHandleLength()+ManifoldGap(2), PipeOuterDiameter(BarrelPipe())+0.4, TeeCenter(ReceiverTee())]);

      // handle Barrel  Hole
      translate([-ManifoldGap(),0,0])
      rotate([0,90,0])
      cylinder(r=PipeOuterRadius(BarrelPipe())+0.2, h=SingleBreechHandleLength());
    }
  }
}



module SingleBreechHandle() {
  
    rotate([0,90,0])
    linear_extrude(height=SingleBreechHandleLength())
    difference() {
      hull() {
        circle(r=PipeOuterRadius(BarrelPipe())+0.2, $fn=PipeFn(BarrelPipe()));
        
        // Rod
        translate([-2,0])
        circle(r=RodRadius(FrameRod(), RodClearanceLoose())+0.25, $fn=RodFn(FrameRod())*2);
        
        translate([-1.3,-PipeOuterRadius(BarrelPipe())-0.2*0.97])
        square([1, PipeOuterDiameter(BarrelPipe())+0.4*0.97]);
      }
      
      // Barrel
      circle(r=PipeOuterRadius(BarrelPipe(), PipeClearanceLoose()), $fn=PipeFn(BarrelPipe()));
      
      // Rod
      translate([-2,0])
      circle(r=RodRadius(FrameRod(), RodClearanceLoose()), $fn=RodFn(FrameRod()));
    }
  
}

module DoubleStackBreech(width=PipeOuterDiameter(BarrelPipe())+0.4) {
  
    chamber2Offset = [2.06,0,-90];

    rotate([180,0,0])
    translate([SingleBreechHandleLength()+TeeCenter(ReceiverTee())+BushingHeight(BreechBushing())-BushingDepth(BreechBushing()), 0,0])
    rotate([0,90,0])
    linear_extrude(height=SingleBreechHandleLength()*0.98)
    difference() {
      hull() {
        for (i = [[0,0,0], chamber2Offset])
        translate(i)
        circle(r=PipeOuterRadius(BarrelPipe())+0.2, $fn=PipeFn(BarrelPipe()));
      }
      
      // Barrel
      for (i = [[0,0], chamber2Offset])
      translate(i)
      circle(r=PipeOuterRadius(BarrelPipe(), PipeClearanceLoose()), $fn=PipeFn(BarrelPipe()));
      
      // Rod
      for (i = [[2.3,-0.3], [chamber2Offset[0],1], [1, 0]])
      translate(i)
      circle(r=RodRadius(FrameRod(), RodClearanceLoose()), $fn=RodFn(FrameRod()));
      
    }
  
}
module DoubleStackBreechMiddle(width=PipeOuterDiameter(BarrelPipe())) {
  
    chamber2Offset = [2.06,0,-90];

    rotate([180,0,0])
    translate([(SingleBreechHandleLength()*2)+TeeCenter(ReceiverTee())+BushingHeight(BreechBushing())-BushingDepth(BreechBushing())+ManifoldGap(), 0,0])
    rotate([0,90,0])
    linear_extrude(height=1)
    difference() {
      
      // Cube body
      translate([0.25,-width/2])
      square([chamber2Offset[0]-0.5, width]);
      
      // Chamber cutouts
      for (i = [[0,0,0], chamber2Offset])
      translate(i)
      circle(r=PipeOuterRadius(BarrelPipe(), PipeClearanceSnug()), $fn=PipeFn(BarrelPipe()));
      
      // Rod
      for (i = [[2.3,-0.3], [chamber2Offset[0],1], [1, 0]])
      translate(i)
      circle(r=RodRadius(FrameRod(), RodClearanceLoose()), $fn=RodFn(FrameRod()));
      
    }
  
}

module Double90Breech(width=PipeOuterDiameter(BarrelPipe())+0.4) {
  
    chamber2Offset = [2.06,2.06,-90];

    translate([SingleBreechHandleLength()+TeeCenter(ReceiverTee())+BushingHeight(BreechBushing())-BushingDepth(BreechBushing()), 0,0])
    rotate([0,-90,0])
    linear_extrude(height=SingleBreechHandleLength())
    difference() {
      union() {
          for (i = [[0,0,0], chamber2Offset])
          translate(i)
          circle(r=PipeOuterRadius(BarrelPipe())+0.2, $fn=PipeFn(BarrelPipe()));
          
          // Outer Edge
          hull()
          for (i = [[0,0,0], chamber2Offset])
          translate(i)
          rotate(i[2])
          translate([0,-PipeOuterRadius(BarrelPipe())-0.2*0.97])
          square([1.25, PipeOuterDiameter(BarrelPipe())+0.4*0.97]);
      }
      
      // Barrel
      for (i = [[0,0], chamber2Offset])
      translate(i)
      circle(r=PipeOuterRadius(BarrelPipe(), PipeClearanceLoose()), $fn=PipeFn(BarrelPipe()));
      
      // Rod
      for (i = [[2.3,-0.3], [chamber2Offset[0],1], [1, 0]])
      translate(i)
      circle(r=RodRadius(FrameRod(), RodClearanceLoose()), $fn=RodFn(FrameRod()));
      
      // Forend Clearance
      translate([0,width/2])
      #square([width-0.22,2]);
    }
  
}
// Plate
*scale([25.4, 25.4, 25.4]) {
  ReferenceBuildArea();

  // Rear (user-end) Segment
  translate([-2,-2,ForendRearLength()])
  rotate([0,90,180])
  SingleBreech();
  
  *SingleBreechHandle();
}


render()
//DebugHalf()
{
  
  DoubleStackBreech();
  
  DoubleStackBreechMiddle();
  
  *SingleBreechHandle();

  *SingleBreech();

  %Frame();
  %Reference();
}
