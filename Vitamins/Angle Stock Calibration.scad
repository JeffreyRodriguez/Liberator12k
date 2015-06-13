include <Angle Stock.scad>;

// Print with 100% infill
module AngleStockCalibration(stock = AngleStockThreeQuartersByOneEighthInch,
                             wall  = 1/4,
                             height=1) {
  
  width = lookup(AngleStockWidth, stock);

  difference() {
    cube([width*1.5 + wall*2,width + wall*2,height]);

    // Tight
    translate([wall, wall, -0.1])
    AngleStock(stock=AngleStockThreeQuartersByOneEighthInch,
               thicknessClearance=AngleStockThicknessClearanceSnug,
               widthClearance=AngleStockWidthClearanceSnug,
               length=height*2);

    // Loose
    translate([width*1.5 + wall, width + wall, -0.1])
    rotate([0,0,180])
    AngleStock(stock=AngleStockThreeQuartersByOneEighthInch,
               thicknessClearance=AngleStockThicknessClearanceLoose,
               widthClearance=AngleStockWidthClearanceLoose,
               length=height*2);
  }
}
  
scale([25.4, 25.4, 25.4]) {
  AngleStockCalibration();
}
