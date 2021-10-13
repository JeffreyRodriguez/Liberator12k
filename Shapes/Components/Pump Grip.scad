use <../../Meta/Cutaway.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/Conditionals/RenderIf.scad>;

use <../Bearing Surface.scad>;
use <../Chamfer.scad>;
use <../Teardrop.scad>;
use <../TeardropTorus.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

// Dimensions
function PumpGripDiameter() = 2;
function PumpGripRadius() = PumpGripDiameter()/2;

function PumpGripLength() = 5.25;

module PumpGrip(r=PumpGripRadius(),
                h=PumpGripLength(),
                CR=1/16,
                rings=true, ringRadius=3/32,
                doRender=false, alpha=1) {

  color("Tan", alpha)
  RenderIf(doRender)
  difference() {
    ChamferedCylinder(r1=r, r2=CR, h=h);

    // Gripping cutout rings
    if (rings)
    for (Z = [ringRadius*4:ringRadius*8:h-(ringRadius*4)]) translate([0,0,Z])
    for (M = [0,1]) mirror([0,0,M])
    translate([0,0,-ringRadius*1.5]) scale([1,1,1.5]) translate([0,0,ringRadius])
    TeardropTorus(majorRadius=r,
                  minorRadius=ringRadius);

    // Gripping cutout linear channels
    for (R = [0:60:360]) rotate([0,0,R])
    translate([r, 0, -ManifoldGap()])
    linear_extrude(height=h+ManifoldGap(2))
    for (R =[1,-1]) rotate(90*R)
    Teardrop(r=ringRadius*2);
  }
}

Cutaway(enabled=false)
PumpGrip(doRender=true);