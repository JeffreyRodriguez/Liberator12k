include <Components.scad>;
use <Vitamins/Pipe.scad>;
use <Vitamins/Rod.scad>;

module striker_guide_center(wall = 1/8, overlap=1/4, side_overlap = 3/8, pin = 1/8, stockPipe=stockPipe) {
  difference() {
    union() {
      translate([0,0,overlap])
      *%Tee(TeeThreeQuarterInch);

      // Center Rim
      cylinder(r=TeeRimDiameter(receiverTee)/2 + wall, h=TeeRimWidth(receiverTee)+overlap);

      // Center Block
      translate([0,-TeeInnerDiameter(receiverTee)/2,0])
      cube([TeeWidth(receiverTee)/2 + overlap,TeeInnerDiameter(receiverTee),TeeRimWidth(receiverTee)+overlap]);

      // Side Block
      translate([TeeWidth(receiverTee)/2 - TeeRimWidth(receiverTee),-TeeInnerDiameter(receiverTee)/2,0])
      cube([TeeRimWidth(receiverTee) +side_overlap,TeeInnerDiameter(receiverTee),overlap + TeeCenter(receiverTee) - (TeeInnerDiameter(receiverTee)/2)]);
    }

    // Cutaway View
    translate([-5,0,-5])
    *cube([10,10,10]);

    // Center Rim Hole
    translate([0,0,overlap])
    cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeCenter(receiverTee));

    // Pipe Hole
    translate([0,0,-0.1])
    cylinder(r=PipeOuterRadius(stockPipe, PipeClearanceLoose), h=TeeRimWidth(receiverTee) + overlap + 0.3);

    // Side Rim
    translate([(TeeWidth(receiverTee)/2)-TeeRimWidth(receiverTee) -0.1,0,TeeCenter(receiverTee)+overlap])
    rotate([0,90,0])
    union() {
      cylinder(r=TeeRimDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee) +0.1);
      cylinder(r=TeeInnerDiameter(receiverTee)/2, h=TeeRimWidth(receiverTee)+side_overlap+0.2);
    }

    // Tee Body
    translate([-TeeWidth(receiverTee)/2,0,TeeCenter(receiverTee) + overlap])
    rotate([0,90,0])
    cylinder(r=TeeOuterDiameter(receiverTee)/2, h=TeeWidth(receiverTee)-TeeRimWidth(receiverTee) + 0.1);

    // Center Pin
    translate([TeeRimDiameter(receiverTee)/2 + overlap,TeeInnerDiameter(receiverTee)/2 +0.1,overlap])
    rotate([90,0,0])
    #1_8_rod(length=TeeInnerDiameter(receiverTee) + 0.2);

    // Center Pin Track
    translate([TeeRimDiameter(receiverTee)/2 + overlap - pin,0,-0.1])
    cylinder(r=pin, h=overlap + pin + 0.1);

    // Side/Center Rope Track
    translate([TeeRimDiameter(receiverTee)/2 + 0.01,-pin,overlap + pin + 0.01])
    rotate([0,53,0])
    cube([pin*3.4,pin*2,2]);

    // Side Tip Rope Track
    translate([TeeWidth(receiverTee)/2, -pin,TeeCenter(receiverTee) -(TeeInnerDiameter(receiverTee)/2) +overlap - pin])
    cube([side_overlap + 0.1, pin*2,1]);

    // Side Pin
    translate([TeeWidth(receiverTee)/2 + side_overlap - pin,
               TeeInnerDiameter(receiverTee)/2 +0.1,
               TeeCenter(receiverTee) - (TeeRimDiameter(receiverTee) - TeeInnerDiameter(receiverTee))/2])
    rotate([90,0,0])
    #1_8_rod(length=TeeInnerDiameter(receiverTee) + 0.2);
  }
}

scale([25.4, 25.4, 25.4])
striker_guide_center();
