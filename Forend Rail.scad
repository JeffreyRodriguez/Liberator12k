use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Reference.scad>;

function ForendRodAngles() = [180, 52, -52];
function ForendRailOffset() = TeeRimRadius(ReceiverTee())
                            + WallFrameRod()
                            + RodRadius(FrameRod());

module ForendRods() {

  // Rods
  for (angle = ForendRodAngles())
  rotate([0,0,angle])
  translate([-ForendRailOffset(), 0])
  rotate([0,0,-angle])
  Rod2d(rod=FrameRod());

  // Debugging aid
  //%TeeRim(receiver);

}

module ForendRail(rodHoles=true,
                  clearance=RodClearanceLoose()) {

  // Rail body
  difference() {
    hull()
    union() {
      for (angle = ForendRodAngles())
      rotate([0,0,angle])
      translate([-ForendRailOffset(), 0])
      circle(r=RodRadius(FrameRod()) + WallFrameRod(), $fn=24);
    }

    if (rodHoles)
    *ForendRods();
  }
}

render(convexity=2)
linear_extrude(height=1)
ForendRail();
