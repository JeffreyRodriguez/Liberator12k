use <../../Vitamins/Pipe.scad>;

//Spec_TubingThreeQuarterByFiveEighthInch
//Spec_PipeThreeQuarterInchSch80
//Spec_PipeThreeQuarterInchSch80Stainless
//Spec_PipeOneInchSch80
module PipeInsert2d(pipeSpec=Spec_PipeThreeQuarterInchSch80Stainless(),
                    pipeClearance=PipeClearanceSnug(),
                    length=1) {
  outsideRadius = PipeInnerRadius(pipe=pipeSpec, clearance=pipeClearance, clearanceSign=-1);
  
  difference() {
    circle(r=outsideRadius, $fn=PipeFn(pipeSpec));
    children();
  }
}

scale(25.4)
render()
linear_extrude(height=1.5)
PipeInsert2d(pipeClearance=undef)
circle(r=(3/8/2)+0.002, $fn=20);
