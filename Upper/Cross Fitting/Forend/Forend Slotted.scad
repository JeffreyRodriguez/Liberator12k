use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Components/Semicircle.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../Frame.scad>;
use <../../../Reference.scad>;

module ForendSlotCutter2d(barrelSpec=BarrelPipe(), semiAngle=90) {
                            
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

module ForendSlotted2d(barrelSpec=BarrelPipe(),
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

ForendSlotted2d();