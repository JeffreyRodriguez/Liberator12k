use <../Meta/Debug.scad>;
use <../Meta/Units.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Spring.scad>;
use <../Reference.scad>;

module PrintableShaftCollar(pipeSpec=Spec_TubingOnePointOneTwoFive(),
                             rodSpec=Spec_RodOneQuarterInch(),
                             holeSpec=Spec_RodOneEighthInch(),
                             setScrewSpec=Spec_BoltM4(),
                             length=0.25, wall=0.5, height=0.5) {

  render()
  difference() {
    
    // Rod Holder Block
    union() {
      linear_extrude(height=height)
      difference() {
        hull() {
            
          circle(r=PipeOuterRadius(pipeSpec)+wall, $fn=PipeFn(pipeSpec));
          
          // Nut/bolt support
          rotate(-90)
          translate([PipeOuterRadius(pipeSpec, PipeClearanceLoose()),
                    -BoltNutRadius(setScrewSpec)-wall,0])
          square([BoltNutHeight(setScrewSpec)+length,
                  BoltNutDiameter(setScrewSpec)+(wall*2)]);
        }
        
        Pipe2d(pipe=pipeSpec, clearance=PipeClearanceLoose());
      }
    }
    
    // Set-screw
    rotate([0,0,-90])
    translate([PipeOuterRadius(pipeSpec)+0.02,0,
               height/2])
    rotate([0,90,0])
    rotate([0,0,90])
    NutAndBolt(bolt=setScrewSpec, boltLength=UnitsImperial(2),
               nutHeightExtra=PipeOuterRadius(pipeSpec),
               clearance=true);
  }
}


scale(25.4)
PrintableShaftCollar(pipeSpec=Spec_TubingOnePointOneTwoFive());