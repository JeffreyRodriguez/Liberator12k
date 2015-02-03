include <Pipe.scad>;

$fn=60;

scale([25.4,25.4,25.4]) {

  // 3/4" Tee Rim
  // Calibration model for 3_4_tee_rim_od and 3_4_tee_rim_width
  // Press the bottom rim of the tee into the print so it's flush.
  // It should fit snugly around the tee, but not so tight you can't remove it without tools.
  // It should also be tall enough to extend above any tapered portion of the tee rim.
  difference() {
    cylinder(r=3_4_tee_rim_od/2 + 1/8, h=3_4_tee_rim_width);

    cylinder(r=3_4_tee_rim_od/2, h=3_4_tee_rim_width + 1, center=true);
  }

  // 3/4" Pipe
  translate([-2,0,0])
  3_4_pipe_sleeve(wall=1/8, length=1/2);


  // 1" Pipe
  translate([2,0,0])
  1_pipe_sleeve(wall=1/8, length=1/2);
}


