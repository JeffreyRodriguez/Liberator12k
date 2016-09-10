use <../Meta/Debug.scad>;
use <../Meta/Units.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Spring.scad>;
use <../Reference.scad>;

module PipeSlotDrillingJig(pipeSpec=Spec_PipeThreeQuarterInch(),
                      rodSpec=Spec_RodOneQuarterInch(),
                      holeSpec=Spec_RodOneEighthInch(),
                      setScrewSpec=Spec_BoltM8(),
                      extension=0.75, extensionWidth=0.5,
                      supportHeight=0.5, supportWidth=1.5,
                      wall=0.5, length=1.5, width=0.55) {
  
  drillingWidth = width-RodDiameter(holeSpec); // account for the drill bit's width
  drillingAngle = 2*asin(drillingWidth/PipeOuterDiameter(pipeSpec));
  
  echo("Drilling Angle", drillingAngle, PipeInnerCircumference(pipeSpec));

  render()
  difference() {
    
    // Rod Holder Block
    union() {
      linear_extrude(height=length+(wall*2))
      difference() {
        union() {
            
          circle(r=PipeOuterRadius(pipeSpec)+wall, $fn=PipeFn(pipeSpec));
          
          
          // Vertical
          translate([0, -extensionWidth/2])
          *square([extension, extensionWidth]);
          
          // Horizontal
          for (a = [0,drillingAngle])
          *#rotate([0,0,a])
          translate([-supportHeight,-supportWidth])
          square([supportHeight, supportWidth*2]);
          
          circle(r=supportHeight, $fn=20);
        }
        
        Pipe2d(pipe=pipeSpec, clearance=PipeClearanceLoose());
      }
      
      rotate([0,0,-90])
      translate([PipeOuterRadius(pipeSpec, PipeClearanceLoose()),
                -BoltNutRadius(setScrewSpec)-wall,0])
      cube([BoltNutHeight(setScrewSpec)+(wall*2),BoltNutDiameter(setScrewSpec)+(wall*2),BoltNutDiameter(setScrewSpec)+(wall*2)]);
    }
    
      
    // Drill hole
    for (l = [0, length])
    translate([0,0,l])
    for (a = [0,drillingAngle])
    #rotate([0,0,a])
    translate([0,0,wall])
    rotate([0,90,0])
    Rod(rod=holeSpec, clearance=RodClearanceSnug(),
        length=PipeOuterRadius(pipeSpec)+(wall*2));
    
    // Set-screw
    rotate([0,0,-90])
    translate([PipeOuterRadius(pipeSpec)+0.02,0,
               BoltNutRadius(setScrewSpec)+wall])
    rotate([0,90,0])
    rotate([0,0,90])
    NutAndBolt(bolt=setScrewSpec, boltLength=UnitsImperial(2),
               nutHeightExtra=PipeOuterRadius(pipeSpec),
               clearance=true);
  }
}


scale(25.4)
PipeSlotDrillingJig(pipeSpec=Spec_PipeThreeQuarterInch());
//PipeSlotDrillingJig(pipeSpec=Spec_PipeOneInch());