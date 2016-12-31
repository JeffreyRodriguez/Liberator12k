use <../../Vitamins/Pipe.scad>;
use <../../Reference.scad>;
//use <../../Vitamins/Nuts.scad>;

module FingerWrench(od=1.2, id=0.75, height=0.3, length=4, open=true, $fn=50) {
  linear_extrude(height=height)
  difference() {
    hull() {
      circle(r=od/2);

      translate([length,0])
      circle(r=(BushingCapWidth(BreechBushing())/2)+0.3);
    }

    translate([length,0])
    circle(r=BushingCapWidth(BreechBushing())/2,
           $fn=6);

    circle(r=0.59/2, $fn=6);
  }
}

FingerWrench();
