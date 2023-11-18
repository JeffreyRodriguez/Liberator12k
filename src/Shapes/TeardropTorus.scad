include <../Meta/Common.scad>;

use <Teardrop.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();


module TeardropTorus(majorRadius=3/8, minorRadius=1/16) {
  rotate_extrude()
  translate([majorRadius,0]) {
    Teardrop(r=minorRadius, rotation=90);
  }
}


TeardropTorus(majorRadius=3/8, minorRadius=1/16);
