use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../Frame.scad>;

DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();
DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
DEFAULT_BARREL = Spec_PipeOneInch();

DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();


module ForendSlotCutter2d(barrelSpec=DEFAULT_BARREL, semiAngle=90) {
                            
  pipeOD = PipeOuterDiameter(barrelSpec, clearance=PipeClearanceLoose());
  pipeOR = PipeOuterRadius(barrelSpec, clearance=PipeClearanceLoose());

  render()
  union() {
      
    // Cutout from barrel center to outside
    translate([0, -pipeOR])
    square([2, pipeOD]);

    // Chamfered 'entryway'
    translate([pipeOR,0])
    rotate(90-(semiAngle/2))
    semidonut(major=4, minor=0, angle=semiAngle);
  }
}

module ForendSlotted2d(barrelSpec=DEFAULT_BARREL,
                         length=1,
                      semiAngle=90,
                     slotAngles=[0,180]) {
    render()
    difference() {
      Quadrail2d();
      
      FrameRods();
      
      Pipe2d(pipe=barrelSpec, clearance=PipeClearanceLoose());
      
      for (slotAngle = slotAngles)
      rotate(slotAngle)
      ForendSlotCutter2d(barrelSpec=barrelSpec,
                          semiAngle=semiAngle,
                         slotAngles=slotAngles);
    }
}


%ForendSlotCutter2d();

scale(25.4)
linear_extrude(height=1)
ForendSlotted2d(, slotAngles=[0]);