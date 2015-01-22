include <../Components.scad>;

scale([25.4, 25.4, 25.4])
difference() {
  translate([-1/8, -1/8,0])
  cube([1,1,1/2]);


    // 3/4" Angle Stock
    translate([0,0,-0.1])
    #3_4_angle_stock(
      length=length + 4.2,
      cutter=true,
      loose=loose);

  #translate([0,0,-0.1]) {
    translate([0,0,0])
    1_8_rod(cutter=true, length=1);
  }
}