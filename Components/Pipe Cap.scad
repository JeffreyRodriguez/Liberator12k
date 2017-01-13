use <../Meta/Manifold.scad>;
use <../Vitamins/Pipe.scad>;

PIPE_SPEC = Spec_TubingZeroPointSevenFive();

module PipeCap(pipeSpec=PIPE_SPEC, height=1.25,
               wall=0.125, base=0.25) {

  render()
  difference() {

    // Sleeve around the pipe
    cylinder(r=PipeOuterRadius(pipeSpec, PipeClearanceSnug())+wall, h=height, $fn=50);

    // Pipe Cutout
    translate([0,0,base])
    Pipe(pipe=pipeSpec,
       length=height+ManifoldGap(2),
    clearance=PipeClearanceSnug());
  }
}

scale(25.4)
PipeCap();
