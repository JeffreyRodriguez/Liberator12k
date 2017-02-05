use <../Meta/Debug.scad>;
use <../Meta/Manifold.scad>;
use <../Meta/Units.scad>;
use <../Vitamins/Nuts And Bolts.scad>;
use <../Vitamins/Pipe.scad>;
use <../Vitamins/Rod.scad>;
use <../Vitamins/Spring.scad>;
use <../Reference.scad>;

module PrintableShaftCollar(pipeSpec=Spec_TubingOnePointOneTwoFive(),
                             setScrewSpec=Spec_BoltM4(), screwOffsetZ=0.25,
                             length=0.25, wall=0.125, height=0.5,
                             teardropAngle=90) {

  render()
  difference() {

    // Rod Holder Block
    union() {
      difference() {
        hull() {

          cylinder(r=PipeOuterRadius(pipeSpec)+wall,
                 h=height,
               $fn=PipeFn(pipeSpec)*2);

          // Nut/bolt support
          rotate(-90)
          translate([PipeOuterRadius(pipeSpec, PipeClearanceLoose()),
                    -BoltNutRadius(setScrewSpec)-wall,
                    0])
          cube([BoltNutHeight(setScrewSpec)+length,
                BoltNutDiameter(setScrewSpec)+(wall*2),
                height]);
        }

        Pipe(pipe=pipeSpec,
           length=height*3,
        clearance=PipeClearanceLoose(),
           center=true);
      }
    }

    // Set-screw
    rotate([0,0,-90])
    translate([PipeOuterRadius(pipeSpec)+0.02,0,screwOffsetZ])
    rotate([0,90,0])
    rotate([0,0,90])
    NutAndBolt(bolt=setScrewSpec, boltLength=UnitsImperial(2),
               nutHeightExtra=PipeOuterRadius(pipeSpec),
               teardrop=true, teardropAngle=teardropAngle, clearance=true);
  }
}


scale(25.4)
PrintableShaftCollar(pipeSpec=Spec_TubingZeroPointSevenFive(),
                 screwOffsetZ=0.75,
                       height=2);
