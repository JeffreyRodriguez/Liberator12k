use <../Meta/Manifold.scad>;
use <../Vitamins/Pipe.scad>;

PIPE_SPEC = Spec_TubingZeroPointSevenFive();

module PipeCap(pipeSpec=PIPE_SPEC,
          pipeClearance=PipeClearanceLoose(),
                   base=0.25,
                   wall=0.125,
              extension=0.125) {
  render()
  difference() {

    // Sleeve around the pipe
    cylinder(r=PipeOuterRadius(pipeSpec, undef)+wall,
             h=base+extension,
           $fn=PipeFn(pipeSpec)*2);

    // Pipe Cutout
    translate([0,0,base])
    Pipe(pipe=pipeSpec,
       length=extension+ManifoldGap()
       clearance=pipeClearance);
  }
}

scale(25.4)
PipeCap();
