include <../Vitamins/Pipe.scad>;

wall = 1/4;

module TeeHalf(receiverTee=TeeThreeQuarterInch, wall=1/4) {
  rotate([-90,0,0])
  translate([0,-TeeRimRadius(receiverTee) -wall,wall])
  difference() {
    translate([-TeeWidth(receiverTee)/2 - wall,0,-wall])
    cube([TeeWidth(receiverTee) + wall*2,TeeRimDiameter(receiverTee)/2 + wall,TeeHeight(receiverTee) + (TeeRimDiameter(receiverTee) - TeeOuterDiameter(receiverTee))/2 + wall*2]);

    Tee(receiverTee);
  }
}

scale([25.4, 25.4, 25.4])
TeeHalf();