use <../../../Meta/Debug.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Ammo/Shell Slug.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Components/Cylinder.scad>;
use <../Frame.scad>;
use <../../../Reference.scad>;


function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function LugRadius() = TeeRimRadius(ReceiverTee())+(WallFrameRod()*0.6);
function LugAngle() = 45;
function ForendOffset() = 4;
function ForendTravel() = 2;
function BarrelLugLength() = 1;

module ForendSegment(wall=3/16, length=1, $fn=50) {
  render(convexity=4)
  difference() {
    rotate([0,90,0])
    linear_extrude(height=length)
    hull() {
      Quadrail2d();

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

    // Barrel Hole
    translate([-ForendOffset(),0,0])
    Barrel();

    // Forend Rod Holes
    Frame();
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
        
          // Revolver Spindle Wall
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
        translate([ForendRearLength()+0.001,0,0])
        rotate([0,90,0])
        DoubleShaftCollar(extend=3);
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
