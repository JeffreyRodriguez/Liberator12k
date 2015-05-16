include <Angle Stock.scad>;

stock = AngleStockThreeQuartersByOneEighthInch;
wall = 1/8;

scale([25.4, 25.4, 25.4]) {

  difference() {
    cube([1.4,1.2,1/2]);

    // Tight
    translate([1/8, 1/8, -0.1])
    AngleStock(stock=AngleStockThreeQuartersByOneEighthInch,
               thicknessClearance=AngleStockThicknessClearanceSnug,
               widthClearance=AngleStockWidthClearanceSnug);

    // Loose
    translate([10/8, 1, -0.1])
    rotate([0,0,180])
    AngleStock(stock=AngleStockThreeQuartersByOneEighthInch,
               thicknessClearance=AngleStockThicknessClearanceLoose,
               widthClearance=AngleStockWidthClearanceLoose);
  }
}
