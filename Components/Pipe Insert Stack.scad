use <Manifold.scad>;
use <Pipe Insert.scad>;
use <Firing Pin Retainer.scad>;

use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;

//Spec_TubingThreeQuarterByFiveEighthInch
//Spec_PipeThreeQuarterInchSch80
//Spec_PipeThreeQuarterInchSch80Stainless
//Spec_PipeOneInchSch80
module PipeInsertStack(bigPipeSpec=Spec_PipeThreeQuarterInchSch80Stainless(),
                       smallPipeSpec=Spec_TubingThreeQuarterByFiveEighthInch(),
                       bigLength=0.25, smallLength=0.25) {                         
  union() {
    
    // Big pipe
    linear_extrude(height=bigLength)
    PipeInsert2d(pipeSpec=bigPipeSpec, pipeClearance=undef)
    children();
      
    // Small pipe
    translate([0,0,bigLength-ManifoldGap()])
    linear_extrude(height=smallLength)
    PipeInsert2d(pipeSpec=smallPipeSpec, pipeClearance=undef)
    children();
  }

}

scale(25.4) render()
difference() {
  PipeInsertStack(bigLength=0.5, smallLength=0.9)
  circle(r=0.08, $fn=12);
}
