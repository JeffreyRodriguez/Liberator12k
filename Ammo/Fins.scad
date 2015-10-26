module Fins(count=2, major=1, minor=0.75, width=.4, slices=20, twist=20, height=1.5, $fn=20) {
  color("Orange")
  linear_extrude(height=height, twist=twist, slices=slices)
  intersection() {

    // Main fin geometry
    union() {

      for(i = [0 : count-1]) {
        // Fin
        rotate([0,0,180/count*i])
        translate([-width/2, -major*1.5])
        square([width, major*3]);
      }

      // Fin Wall
      circle(r=minor);
    }

    // Intersect with major radius to smooth the edges
    circle(r=major);
  }
}

scale([25.4, 25.4, 25.4])
difference() {
  Fins();

  *translate([-2, 0, -1])
  cube([4,4,4]);
}
