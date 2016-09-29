include <../../../Meta/Animation.scad>;

use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Meta/Resolution.scad>;

use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../../../Vitamins/Double Shaft Collar.scad>;

use <../../../Reference.scad>;

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
  }
}

// Lugs
*!scale(25.4)
translate([0,0,1])
rotate([0,90,0])
BarrelLugs(length=1);
