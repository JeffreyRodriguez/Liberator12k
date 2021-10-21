use <../Meta/Resolution.scad>;
use <../Meta/Manifold.scad>;
use <Semicircle.scad>;


module BearingSurface2D(r=4, depth=1, segments=6) {
  diameter = 2*r;
  circumference = PI * diameter;
  circle(r);

  for (i = [0:segments-1])
  rotate(360/segments*i)
  semicircle(od=(r+depth)*2, angle=360/segments/2, center=true);
}

module BearingSurface(r=4, depth=1, segments=6, length=30, taperDepth=2, center=true) {

  translate([0,0,(center ? -length/2 : 0)]) {
    linear_extrude(height=length)
    BearingSurface2D(r, depth, segments);

    for (m = [0,1]) mirror([0,0,m])
    translate([0,0,(m ? 0 : length)])
    translate([0,0,-taperDepth+ManifoldGap()])
    linear_extrude(height=(r+depth)*2, scale=2)
    BearingSurface2D(r, depth, segments);
  }
}

BearingSurface(r=4, depth=1, segments=6, length=30, taperDepth=2, center=true);
