use <../../Meta/Debug.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Spring.scad>;
use <../../Reference.scad>;

module RodDrillingJig(rodSpec=Spec_RodOneQuarterInch(),
                      holeSpec=Spec_RodOneEighthInch(),
                      setScrewSpec=Spec_BoltM3(),
                      extension=0.75, extensionWidth=0.75,
                      supportHeight=0.5, supportWidth=1.5,
                      length=1) {
  render()
  difference() {

    // Rod Holder Block
    linear_extrude(height=length)
    difference() {
      union() {

        // Vertical
        translate([0, -extensionWidth/2])
        square([extension, extensionWidth]);

        circle(r=supportHeight, $fn=30);
      }

      Rod2d(rod=rodSpec, clearance=RodClearanceSnug());
    }


    // Drill hole
    translate([0,0,length/2])
    rotate([0,90,0])
    Rod(rod=holeSpec, clearance=RodClearanceSnug(),
         center=true, length=(supportWidth+extension)*2);

    // Set-screw
    translate([RodRadius(rodSpec)+0.01,0,length/4])
    rotate([0,90,0])
    NutAndBolt(bolt=setScrewSpec,
               nutHeightExtra=RodRadius(rod=rodSpec, clearance=RodClearanceLoose()),
               clearance=true);
  }
}



/*
Spec_RodOneQuarterInch
Spec_RodFiveSixteenthInch
*/
scale(25.4)
RodDrillingJig(rodSpec=Spec_RodFiveSixteenthInch());
