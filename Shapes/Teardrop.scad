use <../Meta/Resolution.scad>;
use <../Meta/Units.scad>;

$fs = UnitsFs()*0.25;

module Teardrop(r=1, rotation=0, truncated=false) {
  side = r*sqrt(2)/2;

  render()
  difference() {
    hull() {
      circle(r);

      rotate(rotation)
      polygon(points=[
               [side,-side],
               [(r*cos(side))*sqrt(2),0],
               [side,side]
      ]);
    }

    if (truncated)
    rotate(rotation)
    translate([r,-r])
    square([r, r*2]);
  }
}

Teardrop(truncated=true);
