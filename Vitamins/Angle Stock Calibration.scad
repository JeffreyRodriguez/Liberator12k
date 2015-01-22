include <Angle Stock.scad>;

scale([25.4, 25.4, 25.4]) {

  difference() {
    cube([1.3,1,1/2]);
    
    // Cut out the middle to save materials
    translate([6/16,.35,-0.1])
    cube([8/16, 1/4, 1]);

    // Tight
    translate([1/8, 1/8, -0.1])
    3_4_angle_stock(length=1, cutter=true);

    // Loose
    translate([9/8, 7/8, -0.1])
    rotate([0,0,180])
    3_4_angle_stock(length=1, cutter=true, loose=true);
  }
}
