use <../../Meta/Debug.scad>;
use <../../Meta/Units.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Vitamins/Spring.scad>;

module PipeSlotDrillingJig(pipeSpec=Spec_TubingOnePointOneTwoFive(),
                      holeSpec=Spec_RodOneEighthInch(),
                      setScrewSpec=Spec_BoltM4(),
                      extension=0.75, extensionWidth=0.5,
                      supportHeight=0.5, supportWidth=1.5,
                      wall=1.125, length=0.3, width=0.55) {

  drillingWidth = width-RodDiameter(holeSpec); // account for the drill bit's width
  drillingAngle = 2*asin(drillingWidth/PipeOuterDiameter(pipeSpec));

  echo("Drilling Angle", drillingAngle, PipeInnerCircumference(pipeSpec));

  render()
  difference() {

    // Pipe Holder Block
    union() {
      linear_extrude(height=length+(wall*2))
      difference() {
        union() {

          circle(r=PipeOuterRadius(pipeSpec)+wall, $fn=PipeFn(pipeSpec));


          // Vertical
          translate([0, -extensionWidth/2])
          *square([extension, extensionWidth]);

          // Horizontal
          for (a = [0,drillingAngle])
          *#rotate([0,0,a])
          translate([-supportHeight,-supportWidth])
          square([supportHeight, supportWidth*2]);

          circle(r=supportHeight, $fn=20);
        }

        Pipe2d(pipe=pipeSpec, clearance=PipeClearanceLoose());
      }

      rotate([0,0,-90])
      translate([PipeOuterRadius(pipeSpec, PipeClearanceLoose()),
                -NutHexRadius(setScrewSpec)-wall,0])
      cube([NutHexHeight(setScrewSpec)+(wall*2),NutHexDiameter(setScrewSpec)+(wall*2),NutHexDiameter(setScrewSpec)+(wall*2)]);
    }


    // Drill hole
    for (l = [0, length])
    translate([0,0,l])
    for (a = [0,drillingAngle])
    #rotate([0,0,a])
    translate([0,0,wall])
    rotate([0,90,0])
    Rod(rod=holeSpec, clearance=RodClearanceSnug(),
        length=PipeOuterRadius(pipeSpec)+(wall*2));

    // Set-screw
    rotate([0,0,-90])
    translate([PipeOuterRadius(pipeSpec)+0.02,0,
               NutHexRadius(setScrewSpec)+wall])
    rotate([0,90,0])
    rotate([0,0,90])
    NutAndBolt(bolt=setScrewSpec, boltLength=UnitsImperial(2),
               nutHeightExtra=PipeOuterRadius(pipeSpec),
               clearance=true);
  }
}


scale(25.4)
PipeSlotDrillingJig(pipeSpec=Spec_PipeThreeQuarterInch());
//PipeSlotDrillingJig(pipeSpec=Spec_PipeOneInch());
