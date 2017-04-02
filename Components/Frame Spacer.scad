use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;
use <Upper/Cross/Striker.scad>;

module FrameSpacer2D(od=StrikerRadius()*2, rod=FrameRod(), $fn=Resolution(12, 30)) {
  difference() {
    circle(r=StrikerRadius());
    Rod2d(FrameRod(), clearance=RodClearanceLoose());
  }
}

module FrameSpacer(height=1) {
  linear_extrude(height=height)
  FrameSpacer2D();
}

scale([25.4, 25.4, 25.4]) {
  FrameSpacer();
}
