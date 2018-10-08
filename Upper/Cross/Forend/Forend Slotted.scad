use <../../../Meta/Debug.scad>;
use <../../../Meta/Manifold.scad>;
use <../../../Shapes/Semicircle.scad>;
use <../../../Vitamins/Pipe.scad>;
use <../../../Vitamins/Rod.scad>;
use <../Frame.scad>;
use <../Reference.scad>;
use <Forend.scad>;

DEFAULT_BARREL = Spec_PipeThreeQuarterInch();
DEFAULT_BARREL = Spec_PipeOneInch();
DEFAULT_BARREL = Spec_TubingZeroPointSevenFive();
DEFAULT_BARREL = Spec_TubingOnePointOneTwoFive();

function ForendSlottedLength() = 3;

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

module ForendSlotted(length=1, barrelSpec=DEFAULT_BARREL,
                      semiAngle=90,
                     slotAngles=[0,180],
                     flatAngles=[0,180],
                     scallopAngles=[90,-90]) {
  render()
  difference() {
    Forend(barrelSpec=barrelSpec, length=length,
           flatAngles=flatAngles,
           scallopAngles=scallopAngles)
    children();
  
    translate([ForendX()-ManifoldGap(),0,0])
    rotate([0,90,0])
    color("Gold")
    render()
    linear_extrude(height=length+ManifoldGap(2))
    for (slotAngle = slotAngles)
    rotate(slotAngle)
    ForendSlotCutter2d(width=PipeOuterDiameter(pipe=barrelSpec, clearance=PipeClearanceLoose()),
                        semiAngle=semiAngle);
  }
}

!scale(25.4) {
  ForendSlotted(width=ReceiverOD(),
                slotAngles=[0,180],
                semiAngle=90);
  
  %ForendSlotCutter2d(width=ReceiverOD(),
                      semiAngle=90);
}
