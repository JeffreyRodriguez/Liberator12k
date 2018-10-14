use <../Meta/Resolution.scad>;

module Pivot(factor=1,
             angle=45,
             pivotX=1,
             pivotZ=-1) {

  translate([pivotX,0,pivotZ])
  rotate([0,angle*factor,0])
  translate([-pivotX,0,-pivotZ]) {
    children();
    
    %translate([pivotX,0,pivotZ])
    rotate([90,0,0])
    cylinder(r=0.1, h=1, center=true);
  }
}

module PivotHull(angle=45, steps=Resolution(4, 2)) {
  pivotStep = 1/steps*angle;

  render()
  union()
  for (i = [0:steps])
  hull() {
    if (i > 0)
    Pivot(factor=pivotStep*(i-1))
    children();

    Pivot(factor=pivotStep*i)
    children();
  }
}

Pivot(factor=$t);