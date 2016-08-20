use <../Vitamins/Pipe.scad>;

//Spec_PipeThreeQuarterInchSch80
//Spec_PipeOneInchSch80
module PipeInsert2d(pipeSpec=Spec_PipeOneInchSch80(), length=1) {
  difference() {
    circle(r=PipeInnerRadius(pipe=pipeSpec, clearance=PipeClearanceSnug(), clearanceSign=-1),
           $fn=50);
    children();
  }
}

scale(25.4)
linear_extrude(height=0.5)
PipeInsert2d() {
  circle(r=(5/16/2)+0.005, $fn=30);
}