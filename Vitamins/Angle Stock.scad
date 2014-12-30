3_4_angle_stock_width           = 3/4;
3_4_angle_stock_thickness       = 0.13;
3_4_angle_stock_trough          = 0.23; // Thickness across the "elbow" of the angle
3_4_angle_stock_height          = 0.574;
3_4_angle_stock_clearance       = 0.01;
3_4_angle_stock_clearance_loose = 0.02;

module 3_4_angle_stock(length=1, cutter=false) {
  union() {
    if (cutter) {
      translate([-3_4_angle_stock_clearance/2,-3_4_angle_stock_clearance/2,0])
      cube([3_4_angle_stock_width     + 3_4_angle_stock_clearance,
            3_4_angle_stock_thickness + 3_4_angle_stock_clearance,
            length]);

      translate([-3_4_angle_stock_clearance/2,-3_4_angle_stock_clearance/2,0])
      cube([3_4_angle_stock_thickness + 3_4_angle_stock_clearance,
            3_4_angle_stock_width     + 3_4_angle_stock_clearance,
            length]);

      translate([3_4_angle_stock_thickness/2, 3_4_angle_stock_thickness/2, 0])
      difference() {
        cube([3_4_angle_stock_trough + 3_4_angle_stock_clearance/2,
              3_4_angle_stock_trough + 3_4_angle_stock_clearance/2,
              length]);

        translate([3_4_angle_stock_trough + 3_4_angle_stock_clearance/2,
                   3_4_angle_stock_clearance/2,
                   -0.1])
        rotate([0,0,45])
        cube([3_4_angle_stock_trough*sqrt(2),
              3_4_angle_stock_trough*sqrt(2),
              length + 0.2]);
      }

    } else {
      cube([3_4_angle_stock_width,3_4_angle_stock_thickness,length]);
      cube([3_4_angle_stock_thickness,3_4_angle_stock_width,length]);

      translate([3_4_angle_stock_thickness, 3_4_angle_stock_thickness, 0])
      difference() {
        cube([3_4_angle_stock_trough, 3_4_angle_stock_trough,length]);

        translate([3_4_angle_stock_trough,0,-0.1])
        rotate([0,0,45])
        cube([3_4_angle_stock_trough*sqrt(2), 3_4_angle_stock_trough*sqrt(2),length + 0.2]);
      }
    }
  };
}
