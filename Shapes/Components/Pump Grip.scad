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
                channels=true, channelRadius=3/16, channelAngle=60,
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
    if (channels)
    for (R = [0:channelAngle:360]) rotate([0,0,R])
    translate([r, 0, -ManifoldGap()])
    scale([0.8,1.2,1])
    ChamferedCircularHole(r1=channelRadius, r2=CR, h=h+ManifoldGap(2));
  }
}

scale(25.4)
Cutaway(enabled=false)
PumpGrip(doRender=true);