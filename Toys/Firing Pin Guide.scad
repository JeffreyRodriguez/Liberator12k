include <../Vitamins/Rod.scad>;
include <../Vitamins/Pipe.scad>;

module firing_pin_guide(od=TeeInnerDiameter(receiverTee), minor_height = 1/4, major_height = 1/2) {

  // 1/8" Rod on 1/4" Rod
  difference() {
    union() {
      cylinder(r=od/2, h=major_height + minor_height, $fn=20);

      translate([-TeeRimDiameter(receiverTee)/2,-TeeInnerDiameter(receiverTee)/2,-1/4])
      *cube([TeeRimDiameter(receiverTee),TeeInnerDiameter(receiverTee),1/4]);
    }

    translate([0,0,-0.5])
    Rod(rod=RodOneEighthInch, length=minor_height + 1, clearance=RodClearanceLoose);

    translate([0,0,minor_height])
    #cylinder(r=0.4/2, h=major_height + 0.1, $fn=20);
  }
}

scale([25.4, 25.4, 25.4])
firing_pin_guide();