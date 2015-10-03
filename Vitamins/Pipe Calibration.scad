include <Pipe.scad>;

$fn=60;

module TeeCalibration(tee, wall=1/8) {

  // 3/4" Tee Rim
  // Calibration model for TeeRimDiameter(receiverTee) and TeeRimWidth(receiverTee)
  // Press the bottom rim of the tee into the print so it's flush.
  // It should fit snugly around the tee, but not so tight you can't remove it without tools.
  // It should also be tall enough to extend above any tapered portion of the tee rim.
  difference() {
    cylinder(r=TeeRimDiameter(tee)/2 + wall, h=TeeRimWidth(tee));

    cylinder(r=TeeRimDiameter(tee)/2, h=TeeRimWidth(tee) + 1, center=true);
  }
}


module PipeOuterCalibration(pipe, clearance, wall=3/32, height=1/2) {
  difference() {
    cylinder(r=PipeOuterRadius(pipe) + wall, h=height);
    #Pipe(pipe=pipe, length=height*3, clearance=clearance, center=true);
  }
}

module PipeInnerCalibration(pipe, clearance, wall=3/32, height=1/2) {
  difference() {
    cylinder(r=PipeInnerRadius(pipe) + wall, h=height);

    cylinder(r=PipeInnerRadius(pipe, clearance), h=height + 1, center=true);
  }
}

module PipeCalibration(pipe=undef, clearance=PipeClearanceSnug, height=1/4, wall=3/32, inner=true, outer=true) {
  
  if (outer)
  PipeOuterCalibration(pipe=pipe, clearance=clearance, height=height, wall=wall);
  
  if (inner)
  PipeInnerCalibration(pipe=pipe, clearance=clearance, height=height, wall=wall);
}
scale([25.4,25.4,25.4]) {
  PipeCalibration(pipe=TubingOnePointOneTwoFive, clearance=PipeClearanceLoose,
                  height=1/2, wall=1/4,
                  inner=false, outer=true);
}


