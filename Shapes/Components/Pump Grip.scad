use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../Bearing Surface.scad>;
use <../Chamfer.scad>;
use <../Teardrop.scad>;
use <../TeardropTorus.scad>;

function PumpGripDiameter() = 2;
function PumpGripRadius() = PumpGripDiameter()/2;

function PumpGripLength() = 5.25;

module PumpGrip(outerRadius=PumpGripRadius(),
                length=PumpGripLength(),
                rings=true, ringRadius=3/32, ringGap=0.75,
                doRender=false, alpha=1, $fn=Resolution(20,100)) {

  color("Tan", alpha)
  RenderIf(doRender)
  difference() {
    ChamferedCylinder(r1=outerRadius, r2=1/16, h=length);

    // Gripping cutout rings
    if (rings)
    for (Z = [ringGap:ringGap:length-ringGap]) translate([0,0,Z])
    for (M = [0,1]) mirror([0,0,M])
    translate([0,0,-ringRadius*1.5]) scale([1,1,1.5]) translate([0,0,ringRadius])
    TeardropTorus(majorRadius=outerRadius,
                  minorRadius=ringRadius);

    // Gripping cutout linear channels
    for (R = [0:60:360]) rotate([0,0,R])
    translate([outerRadius, 0, -ManifoldGap()])
    linear_extrude(height=length+ManifoldGap(2))
    for (R =[1,-1]) rotate(90*R)
    Teardrop(r=ringRadius*2);
  }
}

DebugHalf(enabled=false)
PumpGrip(doRender=true);