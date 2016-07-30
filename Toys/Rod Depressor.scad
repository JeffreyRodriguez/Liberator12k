use <../Vitamins/Rod.scad>;

module RodDepressor(rod=Spec_RodOneQuarterInch(), od=1, depth=1, height=1.5, $fn=50) {
  difference() {
    // Body
    cylinder(r=od/2, h=height);
    
    translate([0,0,height-depth])
    Rod(rod, RodClearanceSnug());
  }
}

scale(25.4)
RodDepressor(rod=Spec_RodFiveSixteenthInch());