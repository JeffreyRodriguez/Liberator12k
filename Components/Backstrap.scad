include <../Vitamins/Angle Stock.scad>;
include <../Vitamins/Rod.scad>;
include <../Components.scad>;

module backstrap(rod=backstrapRod, rodClearance=RodClearanceSnug,
                 wall = 5/16, length=1, infill_length=1) {
                   
  infill_width = lookup(RodDiameter, rod) + (wall*2);

  render()
  linear_extrude(height=length)
  difference() {
    union() {
      circle(r=lookup(RodRadius, rod) + wall, $fn=20);

      translate([-infill_length,-infill_width/2])
      square([infill_length, infill_width]);
    }

    // Rod Hole
    Rod2d(rod=rod, clearance=rodClearance);
  }
}

*backstrap();