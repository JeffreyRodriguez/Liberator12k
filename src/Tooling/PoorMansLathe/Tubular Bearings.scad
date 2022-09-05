use <../../Vitamins/Square Tube.scad>;
use <../../Vitamins/Bearing.scad>;

module TubularBearings2D(tube=Spec_SquareTubeOneInch(), tubeClearance=SquareTubeClearanceSnug(),
                         bearing=Spec_Bearing608(), bearingOffset=1.4,
                         pivot=0.18,
                         backHeight=0.13, wall=0.4) {

  bearingOffsetY = wall+(SquareTubeOuter(tube)/2);
  difference() {
    hull() {
      square([SquareTubeOuter(tube)+(wall*2), SquareTubeOuter(tube)+(wall*2)]);

      *translate([(SquareTubeOuter(tube)/2)+(wall*1.5),(SquareTubeOuter(tube)/2) + wall,0])
      circle(r=(SquareTubeOuter(tube)/2)+(wall*1.5), $fn=20);

      translate([-bearingOffset,bearingOffsetY])
      circle(r=BearingOuterRadius(bearing, clearance=undef)+wall, $fn=BearingFn(bearing));
    }

    // Bolt holes
    for (i = [bearingOffsetY])
    translate([0,i])
    circle(r=0.18, $fn=12);

    // Bearing race hole
    translate([-bearingOffset,bearingOffsetY])
    circle(r=BearingRaceRadius(bearing),
           $fn=BearingFn(bearing)/2);

    // Tubing hole
    translate([wall,wall])
    Tubing2D(solid=true, clearance=tubeClearance, spec=tube);
  }
}

module TubularBearingsBack(tube=Spec_SquareTubeOneInch(), bearing=Spec_Bearing608(),
                       backHeight=0.13, bearingOffset=1.4, wall=0.4) {

  bearingOffsetY = wall+(SquareTubeOuter(tube)/2);
  difference() {
    linear_extrude(height=BearingHeight(bearing)+backHeight)
    TubularBearings2D();

    translate([-bearingOffset,bearingOffsetY,backHeight+0.0001])
    Bearing(spec=Spec_Bearing608(), clearance=BearingClearanceSnug(), solid=true);
  }
}

module TubularBearingsFront(tube=Spec_SquareTubeOneInch(), bearing=Spec_Bearing608(),
                            bearingOffset=1.4, wall=0.4) {

  linear_extrude(height=0.5)
  TubularBearings2D();
}

scale([25.4, 25.4, 25.4]) {
  TubularBearingsBack();

  translate([0,0,0.5])
  *TubularBearingsFront();
}
