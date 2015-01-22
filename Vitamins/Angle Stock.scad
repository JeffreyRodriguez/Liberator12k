3_4_angle_stock_width                     = 3/4;
3_4_angle_stock_thickness                 = 0.13;
3_4_angle_stock_trough                    = 0.235; // Thickness across the "elbow" of the angle
3_4_angle_stock_height                    = 0.574;
3_4_angle_stock_width_clearance           = 0.008;
3_4_angle_stock_width_clearance_loose     = 0.008;
3_4_angle_stock_thickness_clearance       = 0.005;
3_4_angle_stock_thickness_clearance_loose = 0.007;

module 3_4_angle_stock(length=1, cutter=false, loose=false) {
  width_clearance     = loose ? 3_4_angle_stock_width_clearance_loose     : 3_4_angle_stock_width_clearance;
  thickness_clearance = loose ? 3_4_angle_stock_thickness_clearance_loose : 3_4_angle_stock_thickness_clearance;

  union() {
    if (cutter) {
      translate([-width_clearance,-thickness_clearance,0])
      cube([3_4_angle_stock_width     + width_clearance*2,
            3_4_angle_stock_thickness + thickness_clearance*2,
            length]);

      translate([-width_clearance,-thickness_clearance,0])
      cube([3_4_angle_stock_thickness + thickness_clearance*2,
            3_4_angle_stock_width     + width_clearance*2,
            length]);

      translate([3_4_angle_stock_thickness/2, 3_4_angle_stock_thickness/2, 0])
      difference() {
        cube([3_4_angle_stock_trough + thickness_clearance/2,
              3_4_angle_stock_trough + thickness_clearance/2,
              length]);

        translate([3_4_angle_stock_trough + thickness_clearance/2,
                   thickness_clearance/2,
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
