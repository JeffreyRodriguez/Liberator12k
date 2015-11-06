use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Frame.scad>;
use <Reference.scad>;
use <Trigger Guard.scad>; //use <Tee Housing.scad>;

module forend_single(receiver=Spec_TeeThreeQuarterInch(),
                     barrel=Spec_PipeThreeQuarterInch(),
                     rod=Spec_RodFiveSixteenthInch(),
                     wall=3/16, length=3, $fn=50) {
  render(convexity=2)
  difference() {
    translate([(TeeWidth(receiver)/2)+TeeHousingFrontExtension(),0,0])
    rotate([0,-90,180])
    linear_extrude(height=length)
    hull() {
      ForendRail(receiver, barrel, rod, wall);
      
      // Add some more material to the center for ergo and strength
      circle(r=TeeRimRadius(receiver)+wall);
      
    }
    
    // Barrel Hole
    Barrel(receiver=receiver, barrel=barrel);
    
    // Forend Rod Holes
    Frame(receiver, rod, wall=wall);
  }
}

// Scale up to metric for printing
scale([25.4,25.4,25.4]) {
  barrel = Spec_TubingOnePointOneTwoFive();
  forend_single(barrel=barrel);
  
  Reference(barrel=barrel);
}
