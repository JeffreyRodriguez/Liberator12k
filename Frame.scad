use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;

function FrameRodAngles() = [0, 232, -232];
function FrameRodOffset(receiver, rod=Spec_RodFiveSixteenthInch())
           = TeeRimRadius(receiver)
           + RodRadius(rod)
           + WallFrameRod()
           ;

module Frame(receiver=Spec_TeeThreeQuarterInch(),
             rod=Spec_RodFiveSixteenthInch(),
             clearance=RodClearanceSnug(),
             rodLength=10,
             rodFnAngle=90) {

  render(convexity=4)
  translate([-(TeeWidth(receiver)/2)-OffsetFrameBack(),0,0])
  rotate([0,90,0])
  linear_extrude(height=rodLength)
  for (angle = FrameRodAngles())
  rotate([0,0,angle])
  translate([-FrameRodOffset(receiver), 0])
  rotate([0,0,-angle+rodFnAngle])
  Rod2d(rod=rod, clearance=clearance);

}

scale([25.4, 25.4, 25.4]) {
  %Reference();
  Frame();
}
