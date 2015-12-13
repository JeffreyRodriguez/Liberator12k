use <../Vitamins/Rod.scad>

module RoundCocker(cockerRod = Spec_RodFiveSixteenthInch(),
                   travel=1,
                   length=3,
                   width=0.25) {
                     
  diameter = sqrt(travel*4/3.14)*2;

  difference() {
    union() {
      
      // Main body
      cylinder(r1=diameter/2, r2=diameter/2, h=width*2, $fn=20);
      
      // Crank arm
      translate([0,-diameter/4])
      cube([length, diameter/2, width]);
    }
    
    // Spindle
    Rod(rod=cockerRod, clearance=RodClearanceLoose(), length=2, center=true);
    
    // Rope holes
    *for (i=[0:3])
    rotate(i*90)
    translate([diameter/3,0])
    #cylinder(r=0.1, h=2, center=true);
    
    // Rope slot
    #translate([diameter/4,-0.1,-0.1])
    cube([diameter/4, 0.2, 1]);
  }
}

scale([25.4, 25.4, 25.4])
RoundCocker();