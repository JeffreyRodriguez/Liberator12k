use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Nuts And Bolts.scad>;

DEFAULT_BREECH = Spec_BushingThreeQuarterInch();
DEFAULT_FRAME_BOLT = Spec_BoltM8();

module FingerWrench(breechSpec=DEFAULT_BREECH, height=0.3, length=4, 
                    od=1.2, id=0.59,
                    $fn=50) {
  linear_extrude(height=height)
  difference() {
    hull() {
      circle(r=od/2);

      translate([length,0])
      circle(r=(BushingCapWidth(breechSpec)/2)+0.3);
    }

    translate([length,0])
    circle(r=BushingCapWidth(breechSpec)/2,
           $fn=6);

    circle(r=0.59/2, $fn=6);
  }
}

FingerWrench();
