include <../../../Meta/Animation.scad>;

use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;

use <../../../Reference.scad>;

use <../Frame.scad>;
use <../Cross Upper.scad>;

use <Forend.scad>;

function BarrelLugAngle() = -35;
function BarrelLugLength() = 1;

module BarrelLugs2d(barrelPipe=BarrelPipe(), barrelHole=true, accessHole=false,
                    lugWidth=0.6, lugDepth=1.35) {
  difference() {
    rotate(15)
    union() {
      rotate(45)
      offset(r=0.1)
      hull()
      DoubleShaftCollar2d(extend1=accessHole);
      
      for (i=[0,90,180,270]) rotate(i)
      intersection() {
        circle(r=lugDepth, $fn=Resolution(20,60));
        
        translate([0,-lugWidth/2])
        square([lugDepth, lugWidth]);
      }
    }
    
    if (barrelHole)
    projection(cut=true)
    rotate([0,-90,0])
    translate([-BreechFrontX()-ManifoldGap(),0,0])
    Barrel(clearance=PipeClearanceSnug());
  }
}

module BarrelLugs(length=BarrelLugLength()) {
  color("DimGrey")
  render()
  difference() {
    rotate([0,90,0])
    linear_extrude(height=length)
    BarrelLugs2d();
    
    translate([-ManifoldGap(),0,0])
    rotate([45+15,0,0])
    DoubleShaftCollar();
  }
}

module BarrelLugTrack(length=1, open=true) {
  angles = open ? [0, BarrelLugAngle()/2, BarrelLugAngle()] : [0];
  
  color("Gold")
  render()
  difference() {
    Forend(alignmentLugs=false, length=length);
    
    rotate([0,90,0])
    translate([0,0,-ManifoldGap()])
    linear_extrude(height=length+ManifoldGap(2))
    for (i=angles)
    rotate(i)
    offset(r=0.02)
    BarrelLugs2d(barrelHole=false); 
  }
}

{
  color("SteelBlue")
  Frame();
  
  UpperReceiverFront();
  
  UpperReceiverBack();

   {
    
    translate([3*Animate(ANIMATION_STEP_UNLOAD),0,0])
    translate([-3*Animate(ANIMATION_STEP_LOAD),0,0]) {

      Barrel();
      
      translate([BreechFrontX()+3.25,0]) {
          
        // Lugs
        rotate([BarrelLugAngle(),0,0])
        rotate([-BarrelLugAngle()*Animate(ANIMATION_STEP_UNLOCK),0,0])
        rotate([BarrelLugAngle()*Animate(ANIMATION_STEP_LOCK),0,0]) {
          BarrelLugs();
          
          rotate([45+15,0,0])
          DoubleShaftCollar();
        }
        
        LuggedForend();
      }
    }
    
  }

  Reference();
}

module LuggedForend(lengthOpen=BarrelLugLength()+0.05, lengthClosed=3) {
  echo("Lugged Forend Length", lengthOpen+lengthClosed);
  
  color("Gold")
  render(convexity=4)
  union() {
    BarrelLugTrack(open=true, length=lengthOpen+ManifoldGap());
  
    translate([lengthOpen,0,0])
    BarrelLugTrack(open=false, length=lengthClosed);
  }
}

// Lugged Forend
*!scale(25.4)
//translate([0,0,1])
rotate([0,90,0])
LuggedForend();

// Lugs
*!scale(25.4)
translate([0,0,1])
rotate([0,90,0])
BarrelLugs(length=1);

// Open Lug track
*!scale(25.4)
rotate([0,-90,0])
BarrelLugTrack(open=true, length=1.55);

// Closed Lug track
*!scale(25.4)
rotate([0,-90,0])
BarrelLugTrack(open=false, length=3);
