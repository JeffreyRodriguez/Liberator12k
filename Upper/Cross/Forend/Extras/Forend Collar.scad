//$t=0.8;
use <../../../../Meta/Manifold.scad>;
use <../../../../Meta/Resolution.scad>;
use <../../../../Vitamins/Pipe.scad>;
use <../../../../Vitamins/Rod.scad>;
use <../../../../Vitamins/Double Shaft Collar.scad>;
use <../../../../Lower/Receiver Lugs.scad>;
use <../../../../Reference.scad>;
use <../../Frame.scad>;

module ForendCollar(barrelSpec=BarrelPipe(), length=1, collarAngle=45,
                    wall=WallTee(), $fn=40) {
  color("Purple")
  render()
  difference() {
    linear_extrude(height=length)
    difference() {
      Quadrail2d();

      FrameRods();

      Pipe2d(pipe=barrelSpec, pipeClearance=PipeClearanceLoose());
    }

    translate([0,0,length+ManifoldGap()])
    rotate(collarAngle)
    mirror([0,0,1])
    DoubleShaftCollar(long=false);
  }
}

ForendCollar();

// Plated Forend
*!scale(25.4)
rotate([0,90,0])
translate([-BreechFrontX()-1,0,0])
ForendCollar();
