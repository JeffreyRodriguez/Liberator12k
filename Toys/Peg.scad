include <../Vitamins/Rod.scad>;
include <../Vitamins/Pipe.scad>;
include <../Components.scad>;


base_thickness = grip_height;
base_thickness = RodDiameter(RodOneEighthInch)*2; // For testing

column_height = 0.95;

overall_height = column_height + base_thickness;

module peg_pivot(voffset=1/4, hoffset=0, pivotRod=RodOneEighthInch, pivotRodClearance=RodClearanceSnug) {
  difference() {
    children();
  
    translate([hoffset,0,voffset])
    rotate([90,0,0])
    Rod(rod=pivotRod, clearance=pivotRodClearance, center=true);
  }
}

module peg_slot(length=TeeInnerDiameter(receiverTee) + 0.02, width=0.255, height=3) {
  difference() {
    children();
    
    cube([length, width, height], center=true);
  }
}

module peg(column_height=0.95, tee=receiverTee) {
  union() {
    translate([0,0,base_thickness])
    cylinder(r=TeeInnerDiameter(tee)/2, h=column_height);

    intersection() {
      translate([-TeeRimDiameter(tee)/2,-TeeInnerDiameter(tee)/2,0])
      cube([TeeRimDiameter(tee),TeeInnerDiameter(tee),base_thickness]);
      
      cylinder(r=TeeRimRadius(tee) * 0.99, h=2);
    }
  }
}

scale([25.4, 25.4, 25.4]) {
  peg_pivot(voffset=RodRadius(RodOneEighthInch)*3, hoffset=1/4)
  peg_pivot(voffset=TeeCenter(receiverTee) - 18/32 + base_thickness)
  peg_slot(length=3)
  peg();
}