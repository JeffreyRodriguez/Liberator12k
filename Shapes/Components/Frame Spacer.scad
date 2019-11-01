use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

module FrameSpacer2D(od=0.7, rod=Spec_RodFiveSixteenthInch(), $fn=Resolution(12, 30)) {
  difference() {
    circle(r=od/2);
    Rod2d(rod, clearance=RodClearanceLoose());
  }
}

module FrameSpacer(height=1) {
  linear_extrude(height=height)
  FrameSpacer2D();
}

scale([25.4, 25.4, 25.4]) {
  FrameSpacer();
}
