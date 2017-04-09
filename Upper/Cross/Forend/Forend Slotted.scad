use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../Frame.scad>;
use <../Reference.scad>;

DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
DEFAULT_BARREL = Spec_PipeOneInch();

DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();

module ForendSlotCutter2d(width=PipeOuterDiameter(DEFAULT_BARREL, clearance=PipeClearanceLoose()),
                          semiAngle=90) {
  render()
  union() {

    // Cutout from barrel center to outside
    translate([0, -width/2])
    square([2, width]);

    // Chamfered 'entryway'
    translate([width/2,0])
    rotate()
    semidonut(major=4, minor=0, angle=semiAngle, center=true);
  }
}

module ForendSlotted2d(barrelSpec=DEFAULT_BARREL,
                         length=1,
                      semiAngle=90,
                     slotAngles=[0,180],
                     flatAngles=[0,180],
                     scallopAngles=[90,-90]) {
    render()
    difference() {
      Quadrail2d(flatAngles=flatAngles, scallopAngles=scallopAngles);

      FrameRods();

      Pipe2d(pipe=barrelSpec, clearance=PipeClearanceLoose());

      for (slotAngle = slotAngles)
      rotate(slotAngle)
      ForendSlotCutter2d(width=PipeOuterDiameter(barrelSpec, clearance=PipeClearanceLoose()),
                          semiAngle=semiAngle,
                         slotAngles=slotAngles);
    }
}

scale(25.4)
linear_extrude(height=1) {
  ForendSlotted2d(slotAngles=[0]);

  %ForendSlotCutter2d(width=ReceiverOD(), semiAngle=110);
}
