use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;

module forend_single(receiver=Spec_TeeThreeQuarterInch(),
                     barrel=Spec_PipeThreeQuarterInch(),
                     rod=Spec_RodFiveSixteenthInch(),
                     wall=3/16, length=1.5, $fn=50) {
  render(convexity=2)
  linear_extrude(height=length)
  difference() {
    union() {
      hull() {
        ForendRail(receiver, barrel, rod, wall);
        
        // Add some more material to the center for ergo and strength
        circle(r=TeeRimRadius(receiver)+wall);
        
      }
    }
    
    // Barrel Hole
    Pipe2d(pipe=barrel, clearance=PipeClearanceLoose());
    
    // Forend Rod Holes
    ForendRods(receiver, rod, wall=wall, clearance=RodClearanceSnug());
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  forend_single();
}
