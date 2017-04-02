use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Vitamins/Pipe.scad>;
use <Reference.scad>;

module Sidebars2d(width=0.25, height=0.75, angles=[90,270],
                  clearance=0.005, cutter=false) {
  render()
  for (a = angles)
  rotate(a) {
    translate([-ReceiverOR()-(WallTee()/2)-(width/2)-clearance,
               -(height/2)-clearance])
    square([width+(clearance*2), height+(clearance*2)]);

    // Alignment Cutout
    if (cutter)
    translate([-ReceiverOR()-(WallTee()/2)-(width/2)+ManifoldGap(),
               -clearance])
    mirror([1,0])
    translate([0, -0.5])
    square([1, 1]);
    }
}

module Sidebars(width=0.25, height=0.75, length=1.25,
                    angles=[90,270], cutter=false, clearance=0, alpha=1) {
  color("SteelBlue", alpha)
  render()
  rotate([0,90,0])
  linear_extrude(height=length)
  Sidebars2d(width=width,
            height=height,
            angles=angles,
            clearance=clearance,
            cutter=cutter);
}

Sidebars();
