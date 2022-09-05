use <../Vitamins/Pipe.scad>;
include <../AR15 Grip LowerMount.scad>;

wall = TeeWidth(receiverTee)/2 - TeeRimDiameter(receiverTee)/2 - TeeRimWidth(receiverTee);

scale([25.4, 25.4, 25.4])
union() {
  translate([0,0,TeeRimWidth(receiverTee)])
  rotate([0,180,0])
  %Tee(TeeThreeQuarterInch);


  difference() {
    union() {

      // Rim Wall
      color("LightBlue")
      cylinder(r=TeeRimDiameter(receiverTee)/2 + wall, h=TeeRimWidth(receiverTee));

      // AR15 Grip
      translate([TeeWidth(receiverTee)/2,0,TeeRimWidth(receiverTee)])
      rotate([180,0,180])
      ar15_grip(mount_height=TeeRimWidth(receiverTee),mount_length=TeeWidth(receiverTee)/2 - TeeRimDiameter(receiverTee)/2);
    }

    // Tee Rim
    translate([0,0,-0.1])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee) + 0.2);
  }
}
