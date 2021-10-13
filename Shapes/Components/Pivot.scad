use <../../Meta/Resolution.scad>;

DEFAULT_PIVOT_X = 5;
DEFAULT_PIVOT_Z = -1;

module Pivot2(xyz=[0,0,0], angle=[0,0,0], factor=1) {
  translate([xyz[0],xyz[1],xyz[2]])
  rotate([angle[0]*factor,angle[1]*factor,angle[2]*factor])
  translate([-xyz[0],-xyz[1],-xyz[2]])
  children();
}

module Pivot(factor=1,
             angle=45,
             pivotX=DEFAULT_PIVOT_X,
             pivotZ=DEFAULT_PIVOT_Z,
             cutaway=false) {

  translate([pivotX,0,pivotZ])
  rotate([0,angle*factor,0])
  translate([-pivotX,0,-pivotZ]) {
    children();

    %if (cutaway)
    translate([pivotX,0,pivotZ])
    rotate([90,0,0])
    cylinder(r=0.1, h=5, center=true);
  }
}

module PivotHull(pivotX=DEFAULT_PIVOT_X, pivotZ=DEFAULT_PIVOT_Z,
                 angle=45, resolution=Resolution(0.25, 1)) {
  steps = angle * resolution;
  pivotStep = 1/(steps);

  render()
  union()
  for (i = [0:steps])
  hull() {
    if (i > 0)
    Pivot(pivotX=pivotX, pivotZ=pivotZ, angle=angle, factor=pivotStep*(i-1))
    children();

    Pivot(pivotX=pivotX, pivotZ=pivotZ, angle=angle, factor=pivotStep*i)
    children();
  }
}

Pivot(factor=$t)
cylinder();

%PivotHull()
cylinder();
