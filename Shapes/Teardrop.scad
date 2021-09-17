use <../Meta/Resolution.scad>;
use <../Meta/Units.scad>;

// *********
// * Setup *
// *********
$fa = ResolutionFa();
$fs = UnitsFs()*ResolutionFs();

module Teardrop(r=1, rotation=0, enabled=true, truncated=false) {
  side = r*sqrt(2)/2;

  render()
  difference() {
    hull() {
      circle(r);
      
      if (enabled)
      rotate(rotation)
      polygon(points=[
               [side,-side],
               [(r*cos(side))*sqrt(2),0],
               [side,side]
      ]);
    }

    if (enabled && truncated)
    rotate(rotation)
    translate([r,-r])
    square([r, r*2]);
  }
}

Teardrop(truncated=true);
