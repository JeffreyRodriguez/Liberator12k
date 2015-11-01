use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

FOREND_RAIL_WALL_DEFAULT = 3/16;
function ForendRailWall() = FOREND_RAIL_WALL_DEFAULT;
function ForendRodAngles(receiver, rod, wall) = [180, 52, -52];
function ForendRailOffset(receiver, rod, wall) = TeeRimRadius(receiver) + wall + RodRadius(rod);

module ForendRods(receiver=Spec_TeeThreeQuarterInch(),
                  rod=Spec_RodFiveSixteenthInch(),
                  wall=ForendRailWall(),
                  clearance=RodClearanceSnug(), angles=ForendRodAngles(), rodFnAngle=90) {

  // Rods
  for (angle = angles)
  rotate([0,0,angle])
  translate([-ForendRailOffset(receiver, rod, wall), 0])
  rotate([0,0,-angle+rodFnAngle])
  Rod2d(rod=rod, clearance=clearance);

  // Debugging aid
  //%TeeRim(receiver);

}

module ForendRail(receiver=Spec_TeeThreeQuarterInch(),
                  barrel=Spec_PipeThreeQuarterInch(),
                  rod=Spec_RodFiveSixteenthInch(),
                  rodHoles=true,
                  wall=ForendRailWall(),
                  clearance=RodClearanceLoose(),
                  angles=ForendRodAngles()) {

  // Rail body
  difference() {
    hull()
    union() {
      for (angle = angles)
      rotate([0,0,angle])
      translate([-ForendRailOffset(receiver, rod, wall), 0])
      circle(r=RodRadius(rod) + wall, $fn=24);
    }

    if (rodHoles)
    ForendRods(receiver, rod, wall, clearance, angles);
  }
}

render(convexity=2)
linear_extrude(height=1)
ForendRail();
