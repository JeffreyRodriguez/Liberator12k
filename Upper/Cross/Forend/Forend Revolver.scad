use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Ammo/Shell Slug.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Components/Cylinder.scad>;
use <../../../Lower/Receiver Lugs.scad>;
use <../../../Lower/Lower.scad>;
use <../../../Finishing/Chamfer.scad>;
use <../Frame.scad>;
use <../Reference.scad>;
use <Forend.scad>;


function ForendRearLength() = 1;
function ForendFrontLength() = 0.6;
function LugRadius() = TeeRimRadius(ReceiverTee())+(WallFrameRod()*0.6);
function LugAngle() = 45;
function ForendOffset() = 4;
function ForendTravel() = 2;
function BarrelLugLength() = 1;

module ForendRevolverSpindle() {
  color("Silver")
  render()
  translate([ReceiverLugFrontMaxX(),0,-CylinderChamberOffset()])
  rotate([0,90,0])
  linear_extrude(height=5)
  Rod2d(CylinderRod(), clearance=RodClearanceLoose());
}

module ForendSegment(wall=3/16, length=1, $fn=50) {
  render(convexity=4)
  difference() {
    rotate([0,90,0])
    linear_extrude(height=length)
    union() {
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

module ForendRevolverTop() {
  revolverTopLength =ForendOffset()+BreechFrontX()-ReceiverLugFrontMaxX();
  
  render()
  difference() {
    ForendSegment(length=revolverTopLength);
    
    // Revolver Cylinder
    translate([-ManifoldGap(),0,-CylinderChamberOffset()])
    rotate([0,90,0])
    linear_extrude(height=revolverTopLength+ManifoldGap(2))
    circle(r=CylinderRadius()+0.005, $fn=Resolution(40,60));
    
    // Revolver clearance
    translate([-ManifoldGap(),-2,0])
    cube([revolverTopLength+ManifoldGap(2), 4, PipeOuterRadius(BarrelPipe())]);
  }
}

module ForendRevolverBottom() {
  revolverBottomLength = ForendOffset()+BreechFrontX()-LowerMaxX()+1;
  
  render()
  difference() {
    union() {
      translate([0,-0.625,-ReceiverCenter()-LowerGuardHeight()])
      ChamferedCube([revolverBottomLength, 0.625*2, 1.0],
                    r=0.125, chamferXYZ=[1,0,0]);
      
      translate([revolverBottomLength-1,-0.625,-ReceiverCenter()-LowerGuardHeight()])
      ChamferedCube([2, 0.625*2, LowerGuardHeight()],
                    r=0.125, chamferXYZ=[1,0,0]);
      
      translate([revolverBottomLength-1,0,-ReceiverCenter()-LowerGuardHeight()+0.625])
      rotate([90,0,0])
      linear_extrude(height=1.25, center=true)
      RoundedBoolean(edgeOffset=0, r=0.5, teardrop=false, $fn=40);
    }
    
    translate([revolverBottomLength+1,0,-ReceiverCenter()-LowerGuardHeight()])
    rotate([90,0,0])
    linear_extrude(height=2, center=true)
    RoundedBoolean(edgeOffset=0, r=1.5, teardrop=true, $fn=40);
  }
}

module ForendRevolverPump() {
  pumpLength = 4;
  
  color("Green")
  translate([BreechFrontX()+ForendOffset()+3,0,0])
  difference() {
    
    // Add some more material to the center for ergo and strength
    rotate([0,90,0])
    linear_extrude(height=pumpLength)
    hull() {
      circle(r=TeeRimRadius(ReceiverTee())+0.125,
           $fn=PipeFn(BarrelPipe()));
      
      for (r = [1,-1]) rotate([0,0,r*FrameRodMatchedAngle()])
      translate([FrameRodOffset(),0,0])
      circle(r=RodRadius(FrameRod())+WallFrameRod(), $fn=Resolution(20,40));
    }
    
    for (m = [0,1]) mirror([0,m,0]) {
    
      // Vertical cutouts
      for (X = [1:pumpLength]) translate([X-0.5,0,0])
      for (r = [1,-1]) rotate([0,0,0])
      rotate([-FrameRodMatchedAngle(),0,0])
      translate([-ManifoldGap(),FrameRodOffset()+0.375,0])
      cylinder(r=0.25, h=1, center=true, $fn=Resolution(20,60));
    }
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


module ForendRevolverAssembly(barrelLength=14, frontLength=1, alpha=.5) {
  
  ForendRevolverPump();
  
  translate([ReceiverLugFrontMaxX(),0,0])
  ForendRevolverTop();
  
  translate([LowerMaxX(),0,0])
  ForendRevolverBottom();
  
  translate([BushingExtension(BreechBushing())+(TeeWidth(ReceiverTee())/2)+WallFrameFront(),0,-CylinderChamberOffset()])
  rotate([0,90,0])
  //rotate(360/6)
  RevolverCylinder(debug=true);
  
  translate([ForendOffset(),0,0])
  Barrel(barrelLength=barrelLength-ForendOffset(), hollow=true);
  
  ForendRevolverSpindle();
  
  color("Tomato", alpha=alpha) {

    // Rear Faceplace
    translate([BreechFrontX()+ForendOffset(),0,0])
    render(convexity=4)
    ForendRevolverSegment();

    // Front Faceplace
    translate([(TeeWidth(ReceiverTee())/2)
               +BushingExtension(BreechBushing())
               +ForendOffset()
               +ForendRearLength()
               +0.03,0,0])
    render(convexity=4)
    ForendSegment(length=2, shaftCollar=false);
  }
}

ForendRevolverAssembly();
Reference();

// Plate
*!scale(25.4) {
  ReferenceBuildArea();

  // Rear (user-end) Segment
  translate([-2,-2,0])
  rotate([0,-90,180])
  ForendRevolverSegment();
}
