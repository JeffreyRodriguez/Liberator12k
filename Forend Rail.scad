include <Vitamins/Pipe.scad>;
include <Vitamins/Angle Stock.scad>;
include <Components.scad>;

function ForendRailOffset(receiverTee=receiverTee,
                          teeOverlap=tee_overlap,
                          railRod=undef) =
      (lookup(TeeRimDiameter, receiverTee)/2) + teeOverlap
     + lookup(RodRadius, railRod);


module ForendRods(receiverTee=receiverTee, barrelPipe=barrelPipe,
                  topRailRod=topRailRod, bottomRailRod=bottomRailRod,
                  clearance=undef,
                  lowerGap=1.5, wall=tee_overlap,
                  bottomAngle=bottomRailAngle) {
  rail_offset_top    = ForendRailOffset(railRod=topRailRod, teeOverlap=tee_overlap);
  rail_offset_bottom = ForendRailOffset(railRod=bottomRailRod, teeOverlap=wall);

  // Debugging reference
  *%TeeRim(receiverTee);

  // Top Rail Hole
  translate([rail_offset_top,0])
  Rod2d(rod=topRailRod, clearance=clearance);

  // Bottom Rail Holes
  for (angle = [bottomAngle, -bottomAngle])
  rotate([0,0,angle])
  translate([-rail_offset_bottom, 0])
  Rod2d(rod=bottomRailRod, clearance=clearance);
}

module ForendRail(receiverTee=receiverTee, barrelPipe=barrelPipe,
                  topRailRod=topRailRod, bottomRailRod=bottomRailRod,
                  railClearance=RodClearanceLoose,
                  wall=tee_overlap, infill=2.285, bottomAngle=bottomRailAngle,
                  enableTop=true, enableBottomInfill=true) {


  rail_offset_top    = ForendRailOffset(railRod=topRailRod, teeOverlap=tee_overlap);
  rail_offset_bottom = ForendRailOffset(railRod=bottomRailRod, teeOverlap=tee_overlap);
  infill_width       = RodDiameter(topRailRod) + (wall*3);

  // Debugging reference
  *%TeeRim(receiverTee);

  difference() {
    union() {

      // Top Rail
      if(enableTop == true)
      translate([rail_offset_top,0]) {
        circle(r=RodRadius(topRailRod) + wall*1.5, $fn=50);

        translate([-infill,-infill_width/2])
        square([infill, infill_width]);
      }

      // Bottom Rails
      for (angle = [bottomAngle, -bottomAngle])
      rotate([0,0,angle]) {

        // Infill
        if (enableBottomInfill)
        translate([-rail_offset_bottom, -RodRadius(bottomRailRod) -wall])
        square([rail_offset_bottom + wall,RodDiameter(bottomRailRod)+wall*2]);

        // Sleeve
        translate([-rail_offset_bottom, 0])
        circle(r=RodRadius(bottomRailRod) + wall);
      }
    }

    ForendRods(bottomAngle=bottomAngle, clearance=railClearance);
  }
}

render(convexity=2)
linear_extrude(height=1)
ForendRail();
