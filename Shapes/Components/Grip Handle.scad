use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Units.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module GripHandle(angle=25, gripWidth=1, gripCeiling=0.75, length=1.3, height=5.5, showPalmSwell=true, showFingerSwell=true) {
  handleOffsetZ = 1.3825-gripCeiling;
  palmSwellOffsetZ=-3.0-gripCeiling;
  fingerSwellOffsetZ=-2.5-gripCeiling;

  render()
  difference() {


    union() {

      // Angled section of the grip
      translate([-0.125,0,handleOffsetZ])
      rotate([0,angle,0]) {

        // Grip Body
        translate([-length/2,0,-height])
        hull()
        for (i=[0,length])
        translate([i,0,0])
        cylinder(r=gripWidth/2, h=height, $fn=Resolution(20, 60));

        // Palm swell
        if (showPalmSwell)
        translate([0,0,palmSwellOffsetZ])
        scale([2.5,1.7,4.5])
        sphere(r=0.45, $fn=Resolution(12, 60));

        // Finger swell
        if (showFingerSwell)
        translate([length/2,0,fingerSwellOffsetZ])
        scale([1,1.05,0.5])
        sphere(r=0.63, $fn=Resolution(12, 60));
      }

      // Backstrap to meet the web of the hand
      hull()
      for (extraX = [0,length/2])
      translate([-length-0.25+extraX, 0, -gripCeiling-1])
      rotate([0,-5,0])
      cylinder(r=gripWidth/2, h=1.1+gripCeiling);
    }

    // Flatten the bottom
    translate([-4.5,-1,handleOffsetZ-6.5])
    rotate([0,5,0])
    cube([4, 2, 2]);

    // Flatten the top
    translate([-3,-2, -ManifoldGap()])
    cube([6, 4, 3]);
  }
}

GripHandle();