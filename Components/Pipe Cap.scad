use <../Meta/Manifold.scad>;
use <../Vitamins/Pipe.scad>;
use <../Finishing/Chamfer.scad>;

PIPE_SPEC = Spec_TubingZeroPointSevenFive();

module PipeCap(pipeSpec=PIPE_SPEC,
          pipeClearance=PipeClearanceLoose(),
                   base=0.25,
                   wall=0.125,
              extension=0.25) {

  bodyRadius = PipeOuterRadius(pipeSpec, undef)+wall;
  render()
  difference() {

    // Sleeve around the pipe
    cylinder(r=bodyRadius,
             h=base+extension,
           $fn=PipeFn(pipeSpec)*2);

    // Pipe Cutout
    translate([0,0,base])
    Pipe(pipe=pipeSpec,
       length=extension+ManifoldGap(),
       clearance=pipeClearance);

    // Round the outside edges
    CylinderChamferEnds(r1=bodyRadius, r2=wall/2,
                        h=base+extension,
                       $fn=PipeFn(pipeSpec)*2);

    // Round the inside edge
    translate([0,0,base+extension])
    mirror([0,0,1])
    HoleChamfer(r1=PipeOuterRadius(pipeSpec, undef),
                r2=wall/4,
                $fn=PipeFn(pipeSpec));
  }
}

scale(25.4)
PipeCap();
