AngleStockWidth                   = 1;
AngleStockThickness               = 2;
AngleStockTrough                  = 3; // Thickness across the "elbow" of the angle
AngleStockWidthClearanceSnug      = 4;
AngleStockWidthClearanceLoose     = 5;
AngleStockThicknessClearanceSnug  = 6;
AngleStockThicknessClearanceLoose = 7;
AngleStockHeight                  = 8;

// .747
// .744
// .745
//.740


//.749
//.75
AngleStockThreeQuartersByOneEighthInch = [
  [AngleStockWidth,                   0.771],
  [AngleStockThickness,               0.13],
  [AngleStockTrough,                  0.235],
  [AngleStockWidthClearanceSnug,      0.008],
  [AngleStockWidthClearanceLoose,     0.015],
  [AngleStockThicknessClearanceSnug,  0.007],
  [AngleStockThicknessClearanceLoose, 0.008],
  [AngleStockHeight,                  0.574]
];

3_4_angle_stock_width                     = 3/4;
3_4_angle_stock_thickness                 = 0.13;
3_4_angle_stock_trough                    = 0.235;
3_4_angle_stock_height                    = 0.574;
3_4_angle_stock_width_clearance           = 0.008;
3_4_angle_stock_width_clearance_loose     = 0.008;
3_4_angle_stock_thickness_clearance       = 0.005;
3_4_angle_stock_thickness_clearance_loose = 0.007;

// trough is a percentage: 0.0-1.0
module AngleStock(stock=AngleStockThreeQuartersByOneEighthInch, trough=.5, thicknessClearance=AngleStockThicknessClearanceLoose, widthClearance=AngleStockWidthClearanceLoose, length=1) {

  // A percentage of the inner-side length (width - thickness)
  clearThicknessOffset = thicknessClearance != undef ? lookup(thicknessClearance, stock) : 0;
  clearWidthOffset     = widthClearance     != undef ? lookup(widthClearance, stock)     : 0;
  troughOffset         = (trough * (lookup(AngleStockWidth, stock) - lookup(AngleStockThickness, stock))) + lookup(AngleStockThickness, stock);

  linear_extrude(height=length)
  polygon(points=[[0,0],
                  [lookup(AngleStockWidth, stock)+clearWidthOffset,0],                                                         // X-POS Outer Corner
                  [lookup(AngleStockWidth, stock)+clearWidthOffset,lookup(AngleStockThickness, stock)+clearThicknessOffset],   // X-POS Inner Corner
                  [troughOffset,lookup(AngleStockThickness, stock)+clearThicknessOffset],                                      // X-POS Trough
                  [lookup(AngleStockThickness, stock)+clearThicknessOffset,troughOffset],                                      // Y-POS Trough
                  [lookup(AngleStockThickness, stock)+clearThicknessOffset,lookup(AngleStockWidth, stock)+clearWidthOffset],   // Y-POS Inner Corner
                  [0,lookup(AngleStockWidth, stock)+clearWidthOffset],                                                         // Y-POS Outer Corner
          ],
          paths=[[0,1,2,3,4,5,6]]);
}


//#AngleStock();

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
