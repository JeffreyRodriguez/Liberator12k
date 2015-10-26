//include <Components.scad>;
use <Vitamins/Grip.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;
use <Forend Rail.scad>;
use <Trigger.scad>;
use <Reference.scad>;


module side_tee_housing(receiverTee=Spec_TeeThreeQuarterInch(), angles=[180, 50,-50],
                          wall = 3/16) {

  block_length = TeeWidth(receiverTee)
               - (TeeRimWidth(receiverTee)*2) - 0.03;

  translate([0,0,0])
  render(convexity=4)
  difference() {

    // Forend Rail
    translate([-block_length/2,0,0])
    rotate([0,90,0])
    linear_extrude(height=block_length)
    ForendRail(angles=angles, enableBottomInfill=false, wall=wall + 0.03);

    // Bottom Tee Rim
    TeeRim(receiverTee, height=TeeHeight(receiverTee));

    // Tee
    Tee(tee=receiverTee);
  }
}

scale([25.4, 25.4, 25.4]) {
  %Reference();

  translate([0,0,-TeeCenter(Spec_TeeThreeQuarterInch())])
  side_tee_housing();
}
