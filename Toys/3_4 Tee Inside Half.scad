include <../Vitamins/Pipe.scad>;

wall = 0;
tee = TeeThreeQuarterInch;

scale([25.4, 25.4, 25.4])
rotate([-90,0,0])
translate([0,-lookup(TeeRimDiameter, tee)/2 - wall,wall])
difference() {

  translate([-lookup(TeeWidth, tee)/2 - wall,0,+0.001])
  #cube([TeeWidth(receiverTee) + wall*2,
         TeeRimDiameter(receiverTee)/2 + wall,
         TeeHeight(receiverTee) + (TeeRimDiameter(receiverTee) - TeeOuterDiameter(receiverTee))/2 + wall*2]);

  #union() {
    translate([-TeeWidth(receiverTee)/2 - wall - 0.1,0,TeeCenter(receiverTee)])
    rotate([0,90,0])
    cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeWidth(receiverTee) + wall*2 + 0.2, $fn=30);

    translate([0,0,-0.1])
    cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeHeight(receiverTee) - TeeOuterDiameter(receiverTee)/2 + 0.1, $fn=30);
  }

  translate([-TeeRimDiameter(receiverTee)/2 - wall -1, - 0.1,TeeCenter(receiverTee) - TeeRimDiameter(receiverTee)/2 - wall -1])
  #cube([1,1,1]);

  translate([TeeRimDiameter(receiverTee)/2 + wall, - 0.1,TeeCenter(receiverTee) - TeeRimDiameter(receiverTee)/2 - wall -1])
  #cube([1,1,1]);

  %Tee(TeeThreeQuarterInch);
}