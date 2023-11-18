include <../Meta/Common.scad>;

use <Teardrop.scad>;

$fs = 0.01;

module TeardropTaper(h=1, r1=2, r2=1) {
  hull() {
    translate([0,0,h])
    linear_extrude(ManifoldGap())
    Teardrop(r=r2);

    linear_extrude(ManifoldGap())
    Teardrop(r=r1);
  }
}

TeardropTaper();
