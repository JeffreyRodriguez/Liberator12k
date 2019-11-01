use <../../Meta/Debug.scad>;
use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <Set Screw.scad>;

module PrintableShaftCollar(pipeSpec=Spec_TubingOnePointOneTwoFive(),
                            pipeClearance=PipeClearanceLoose(),
                            length=UnitsMetric(10), height=UnitsMetric(12),
                            wall=UnitsMetric(5),
                            nutEnable=true,
                            setScrewSpec=Spec_BoltM4(), setScrewLength=UnitsMetric(8),
                            screwOffsetZ=UnitsMetric(6),
                            teardropAngle=90, cutter=false, cutterClearance=0.007) {

  clear = cutter ? cutterClearance : 0;

  render()
  rotate(-90)
  difference() {

    // Holder Block
    union() {
      difference() {
        hull() {

          cylinder(r=PipeOuterRadius(pipeSpec)+wall+clear,
                 h=height,
               $fn=PipeFn(pipeSpec)*2);

          SetScrewSupport(radius=PipeOuterRadius(pipeSpec, PipeClearanceLoose()),
                          length=length, height=height, wall=wall,
                          boltSpec=setScrewSpec);
        }

        if (cutter==false)
        Pipe(pipe=pipeSpec,
           length=height*3,
        clearance=pipeClearance,
           center=true);
      }
    }

    if (cutter==false)
    translate([0,0,screwOffsetZ])
    SetScrew(boltSpec=Spec_BoltM4(),
             radius=PipeOuterRadius(pipeSpec),
             length=setScrewLength,
             capHeightExtra=wall,
             nutEnable=nutEnable,
             teardrop=true, teardropAngle=teardropAngle,
             cutter=true);
  }
}


scale(25.4)
PrintableShaftCollar(pipeSpec=Spec_TubingZeroPointSevenFive());
