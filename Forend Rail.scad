include <Vitamins/Pipe.scad>;
include <Vitamins/Angle Stock.scad>;
include <Components.scad>;

function ForendRailOffset(receiverTee=receiverTee,
                          teeOverlap=tee_overlap,
                          railRod=railRod) =
      (lookup(TeeRimDiameter, receiverTee)/2) + teeOverlap
     + lookup(RodRadius, railRod);


module ForendRods(receiverTee=receiverTee, railRod=railRod,
                  clearance=undef, angles=[180,50,-50], rodFnAngle=90) {
    for (angle = angles)
    rotate([0,0,angle])
    translate([-ForendRailOffset(railRod=railRod), 0])
    rotate([0,0,-angle+rodFnAngle])
    Rod2d(rod=railRod, clearance=clearance);
}

module ForendRail(receiverTee=receiverTee, barrelPipe=barrelPipe,
                  railRod=railRod, railClearance=RodClearanceLoose,
                  wall=tee_overlap,angles=[180,50,-50]) {

  // Debugging reference
  *%TeeRim(receiverTee);

  difference() {
    hull()
    union() {
      for (angle = angles)
      rotate([0,0,angle])
      translate([-ForendRailOffset(railRod=railRod, teeOverlap=tee_overlap), 0])
      circle(r=RodRadius(railRod) + wall, $fn=24);

    }

    ForendRods(angles=angles, clearance=railClearance);
  }
}

render(convexity=2)
linear_extrude(height=1)
ForendRail();
