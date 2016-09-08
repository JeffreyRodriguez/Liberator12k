use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Components/Pipe Insert.scad>;

//Spec_PipeThreeQuarterInchSch80
//Spec_PipeOneInchSch80
module BarrelGuide(length=1,
                   pipeSpec=Spec_PipeOneInchSch80(),
                   barrelDiameter=9/16, barrelClearance=0.007) {
  barrelRadius = barrelDiameter/2;

  linear_extrude(height=length)
  PipeInsert2d()
  circle(r=barrelRadius+barrelClearance, $fn=30);
}

scale(25.4)
BarrelGuide(barrelDiameter=5/16, length=1.5);