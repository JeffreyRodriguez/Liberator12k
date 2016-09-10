use <../Meta/Debug.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Spring.scad>;
use <../Reference.scad>;

module RodDrillingJig(rodSpec=Spec_RodFiveSixteenthInch(),
                      holeSpec=Spec_RodOneEighthInch(),
                      setScrewSpec=Spec_BoltM3(),
                      extension=0.75, extensionWidth=0.5,
                      supportHeight=0.5, supportWidth=1.5,
                      length=1) {
  render()
  difference() {
    
    // Rod Holder Block
    union() {
      linear_extrude(height=length)
      difference() {
        union() {
          
          // Vertical
          translate([0, -extensionWidth/2])
          square([extension, extensionWidth]);
          
          // Horizontal
          translate([-supportHeight,-supportWidth])
          square([supportHeight, supportWidth*2]);
          
          circle(r=supportHeight, $fn=20);
        }
        
        Rod2d(rod=rodSpec, clearance=RodClearanceSnug());
      }
      
      rotate([0,0,45])
      translate([RodRadius(rod=rodSpec, clearance=RodClearanceLoose()),-0.3,0])
      cube([0.5,0.6,length/2]);
    }
    
      
    // Drill hole
    translate([0,0,length/2])
    rotate([0,90,0])
    Rod(rod=holeSpec, clearance=RodClearanceSnug(),
         center=true, length=(supportWidth+extension)*2);
    
    // Set-screw
    rotate([0,0,45])
    translate([RodRadius(rodSpec)+0.01,0,length/4])
    rotate([0,90,0])
    NutAndBolt(bolt=setScrewSpec,
               nutHeightExtra=RodRadius(rod=rodSpec, clearance=RodClearanceLoose()),
               clearance=true);
  }
}


scale(25.4)
RodDrillingJig();