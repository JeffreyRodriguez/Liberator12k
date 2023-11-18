include <../../Meta/Common.scad>;

use <../../Vitamins/Pipe.scad>;

//Spec_TubingThreeQuarterByFiveEighthInch
//Spec_PipeThreeQuarterInchSch80
//Spec_PipeThreeQuarterInchSch80Stainless
//Spec_PipeOneInchSch80

module InternalThreadCutter(tee=Spec_AnvilForgedSteel_TeeThreeQuarterInch(),
                            pipe=Spec_PipeThreeQuarterInchSch80(),
                            length=1,
                            wall=0.125) {
  render()
  union() {
    cylinder(r1=TeeInnerRadius(tee),
             r2=PipeTaperedRadius(pipe),
             h=PipeThreadLength(pipe),
           $fn=PipeFn(pipe));

    translate([0,0,PipeThreadLength(pipe)])
    cylinder(r=PipeOuterRadius(pipe=pipe, clearance=PipeClearanceLoose()),
             h=length,
           $fn=PipeFn(pipe));
  }
}

ScaleToMillimeters()
InternalThreadCutter();
